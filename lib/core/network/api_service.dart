import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  late final Dio _dio;
  final SharedPreferences sharedPreferences;

  ApiService({required this.sharedPreferences}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api-internal.dev.kienlongbank.co/kbiz/core/api/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'X-Client-Type': 'MOBILE',
          'X-App-Platform': 'mobile',
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Inject token
          final token = sharedPreferences.getString('ACCESS_TOKEN');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // Inject dynamic device & app headers
          await _injectDeviceHeaders(options.headers);

          // Generate cURL for debugging
          try {
            var curl = "curl -X '${options.method}' '${options.uri}'";
            options.headers.forEach((key, value) {
              curl += " -H '$key: $value'";
            });
            if (options.data != null) {
              if (options.data is Map || options.data is List) {
                final data = jsonEncode(options.data);
                curl += " -d '$data'";
              } else if (options.data is String) {
                curl += " -d '${options.data}'";
              }
            }
            print('--- cURL START ---');
            log(curl);
            print('--- cURL END ---');
          } catch (e) {
            print('Could not generate cURL: $e');
          }

          return handler.next(options);
        },
      ),
    );
  }

  /// Reads real device info and app version then adds them as headers.
  Future<void> _injectDeviceHeaders(Map<String, dynamic> headers) async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final packageInfo = await PackageInfo.fromPlatform();

      if (Platform.isAndroid) {
        final android = await deviceInfo.androidInfo;
        headers['X-Device-Id'] = android.id;
        headers['X-Device-Model'] = android.model;
        headers['X-Device-Manufacturer'] = android.manufacturer;
        headers['X-OS-Version'] = android.version.release;
      } else if (Platform.isIOS) {
        final ios = await deviceInfo.iosInfo;
        headers['X-Device-Id'] = ios.identifierForVendor ?? '';
        headers['X-Device-Model'] = ios.model;
        headers['X-Device-Manufacturer'] = 'Apple';
        headers['X-OS-Version'] = ios.systemVersion;
      }

      headers['X-App-Version'] = packageInfo.version;
    } catch (e) {
      log('Could not read device/app info: $e');
    }
  }

  // Get raw Dio instance
  Dio get dio => _dio;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get(path, queryParameters: queryParameters, options: options);
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
