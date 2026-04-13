import '../../domain/entities/etoken_entity.dart';

class ETokenModel extends ETokenEntity {
  const ETokenModel({
    required super.secretKey,
    required super.phoneNumber,
    required super.deviceId,
  });

  factory ETokenModel.fromJson(Map<String, dynamic> json) {
    return ETokenModel(
      secretKey: json['secretKey'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      deviceId: json['deviceId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'secretKey': secretKey,
      'phoneNumber': phoneNumber,
      'deviceId': deviceId,
    };
  }
}
