import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_service.dart';
import '../models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login({required String username, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<AuthModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await apiService.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData['status'] == 'success') {
          return AuthModel.fromJson(responseData);
        } else {
          final message =
              responseData['message']?.toString() ?? 'Đăng nhập thất bại';
          throw ServerException(message: message);
        }
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      final message =
          (e.response?.data as Map?)?['message']?.toString() ??
          'Đăng nhập thất bại';
      throw ServerException(message: message);
    } catch (_) {
      throw ServerException();
    }
  }
}
