import 'dart:typed_data';
import 'package:base32/base32.dart';
import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/etoken_entity.dart';
import '../../domain/repositories/etoken_repository.dart';
import '../datasource/etoken_local_datasource.dart';
import '../datasource/etoken_remote_datasource.dart';

class ETokenRepositoryImpl implements ETokenRepository {
  final ETokenRemoteDataSource remoteDataSource;
  final ETokenLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ETokenRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ETokenEntity>> registerEToken({
    required String password,
    required String deviceName,
    required String deviceId,
    required String deviceType,
    required String accountName,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEToken = await remoteDataSource.registerEToken(
          password: password,
          deviceName: deviceName,
          deviceId: deviceId,
          deviceType: deviceType,
          accountName: accountName,
        );
        await localDataSource.cacheEToken(remoteEToken);
        await localDataSource.cachePassword(password);
        return Right(remoteEToken);
      } on ServerException {
        return const Left(ServerFailure('Server exception occurred'));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> generateEToken({
    required String password,
  }) async {
    try {
      final cachedPassword = await localDataSource.getPassword();
      if (password != cachedPassword) {
        return const Left(CacheFailure('Mật khẩu eToken không chính xác'));
      }

      final localEToken = await localDataSource.getLastEToken();
      
      // Bước 1 — Tính counter (time step)
      final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final counter = currentTime ~/ 30;

      // Bước 2 — Decode secret (Base32 → bytes)
      final keyBytes = base32.decode(localEToken.secretKey);

      // Bước 3 — HMAC-SHA1
      final counterBytes = Uint8List(8);
      var tempCounter = counter;
      for (int i = 7; i >= 0; i--) {
        counterBytes[i] = tempCounter & 0xff;
        tempCounter >>= 8;
      }

      final hmac = Hmac(sha1, keyBytes);
      final digest = hmac.convert(counterBytes);
      final hash = digest.bytes;

      // Bước 4 — Dynamic Truncation
      final offset = hash[19] & 0x0f;
      final binary = ((hash[offset] & 0x7f) << 24) |
          ((hash[offset + 1] & 0xff) << 16) |
          ((hash[offset + 2] & 0xff) << 8) |
          (hash[offset + 3] & 0xff);

      // Bước 5 — Lấy 6 chữ số
      final otp = binary % 1000000;
      final code = otp.toString().padLeft(6, '0');

      return Right(code);
    } on CacheException {
      return const Left(CacheFailure('Local eToken not found'));
    }
  }
}
