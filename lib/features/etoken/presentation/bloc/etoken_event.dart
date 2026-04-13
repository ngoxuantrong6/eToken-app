import 'package:equatable/equatable.dart';

abstract class ETokenEvent extends Equatable {
  const ETokenEvent();

  @override
  List<Object> get props => [];
}

class RegisterETokenEvent extends ETokenEvent {
  final String password;
  final String deviceName;
  final String deviceId;
  final String deviceType;
  final String accountName;

  const RegisterETokenEvent({
    required this.password,
    required this.deviceName,
    required this.deviceId,
    required this.deviceType,
    required this.accountName,
  });

  @override
  List<Object> get props =>
      [password, deviceName, deviceId, deviceType, accountName];
}

class GenerateETokenEvent extends ETokenEvent {
  final String password;

  const GenerateETokenEvent({required this.password});

  @override
  List<Object> get props => [password];
}
