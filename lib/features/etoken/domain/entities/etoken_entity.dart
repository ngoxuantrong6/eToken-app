import 'package:equatable/equatable.dart';

class ETokenEntity extends Equatable {
  final String secretKey;
  final String phoneNumber;
  final String deviceId;

  const ETokenEntity({
    required this.secretKey,
    required this.phoneNumber,
    required this.deviceId,
  });

  @override
  List<Object> get props => [secretKey, phoneNumber, deviceId];
}
