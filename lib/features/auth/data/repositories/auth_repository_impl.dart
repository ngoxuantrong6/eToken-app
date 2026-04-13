import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, AuthEntity>> login({
    required String username,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(ServerFailure('Không có kết nối mạng'));
    }
    try {
      final model = await remoteDataSource.login(
        username: username,
        password: password,
      );
      // Save token locally
      await sharedPreferences.setString('ACCESS_TOKEN', model.accessToken);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
