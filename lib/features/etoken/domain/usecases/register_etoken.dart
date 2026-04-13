import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/etoken_entity.dart';
import '../repositories/etoken_repository.dart';

class RegisterEToken implements UseCase<ETokenEntity, RegisterETokenParams> {
  final ETokenRepository repository;

  RegisterEToken(this.repository);

  @override
  Future<Either<Failure, ETokenEntity>> call(RegisterETokenParams params) async {
    return await repository.registerEToken(
      password: params.password,
      deviceName: params.deviceName,
      deviceId: params.deviceId,
      deviceType: params.deviceType,
      accountName: params.accountName,
    );
  }
}

class RegisterETokenParams extends Equatable {
  final String password;
  final String deviceName;
  final String deviceId;
  final String deviceType;
  final String accountName;

  const RegisterETokenParams({
    required this.password,
    required this.deviceName,
    required this.deviceId,
    required this.deviceType,
    required this.accountName,
  });

  @override
  List<Object> get props => [password, deviceName, deviceId, deviceType, accountName];
}
