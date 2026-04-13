import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/etoken_entity.dart';

abstract class ETokenRepository {
  Future<Either<Failure, ETokenEntity>> registerEToken({
    required String password,
    required String deviceName,
    required String deviceId,
    required String deviceType,
    required String accountName,
  });

  Future<Either<Failure, String>> generateEToken({
    required String password,
  });
}
