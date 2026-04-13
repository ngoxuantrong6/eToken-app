import 'package:equatable/equatable.dart';

abstract class ETokenState extends Equatable {
  const ETokenState();

  @override
  List<Object> get props => [];
}

class ETokenInitial extends ETokenState {}

class ETokenLoading extends ETokenState {}

class ETokenRegisterSuccess extends ETokenState {
  final String secretKey;

  const ETokenRegisterSuccess({required this.secretKey});

  @override
  List<Object> get props => [secretKey];
}

class ETokenGenerateSuccess extends ETokenState {
  final String tokenCode;

  const ETokenGenerateSuccess({required this.tokenCode});

  @override
  List<Object> get props => [tokenCode];
}

class ETokenError extends ETokenState {
  final String message;

  const ETokenError({required this.message});

  @override
  List<Object> get props => [message];
}
