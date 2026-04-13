import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/etoken_repository.dart';

class GenerateEToken implements UseCase<String, GenerateETokenParams> {
  final ETokenRepository repository;

  GenerateEToken(this.repository);

  @override
  Future<Either<Failure, String>> call(GenerateETokenParams params) async {
    return await repository.generateEToken(
      password: params.password,
    );
  }
}

class GenerateETokenParams extends Equatable {
  final String password;

  const GenerateETokenParams({
    required this.password,
  });

  @override
  List<Object> get props => [password];
}
