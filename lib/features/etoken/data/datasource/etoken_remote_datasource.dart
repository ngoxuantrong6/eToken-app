import 'package:dio/dio.dart';
import '../../../../core/network/api_service.dart';
import '../models/etoken_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class ETokenRemoteDataSource {
  Future<ETokenModel> registerEToken({
    required String password,
    required String deviceName,
    required String deviceId,
    required String deviceType,
    required String accountName,
  });
}

class ETokenRemoteDataSourceImpl implements ETokenRemoteDataSource {
  final ApiService apiService;

  ETokenRemoteDataSourceImpl({required this.apiService});

  @override
  Future<ETokenModel> registerEToken({
    required String password,
    required String deviceName,
    required String deviceId,
    required String deviceType,
    required String accountName,
  }) async {
    try {
      final response = await apiService.post(
        '/etoken/enroll',
        data: {
          "deviceName": deviceName,
          "deviceType": deviceType,
          "platform": "iOS 17.2",
        },
        options: Options(headers: {"deviceId": deviceId}),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final data = response.data['data'];
        return ETokenModel(
          secretKey: data['secret'] ?? '',
          phoneNumber: data['smsSentTo'] ?? '',
          deviceId: data['deviceId'] ?? deviceId,
        );
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
