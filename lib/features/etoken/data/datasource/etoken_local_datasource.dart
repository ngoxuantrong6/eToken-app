import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/etoken_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class ETokenLocalDataSource {
  Future<void> cacheEToken(ETokenModel eTokenToCache);
  Future<ETokenModel> getLastEToken();
  Future<void> cachePassword(String password);
  Future<String> getPassword();
}

const cachedETokenKey = 'CACHED_ETOKEN';
const cachedPasswordKey = 'CACHED_PASSWORD';

class ETokenLocalDataSourceImpl implements ETokenLocalDataSource {
  final SharedPreferences sharedPreferences;

  ETokenLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheEToken(ETokenModel eTokenToCache) {
    return sharedPreferences.setString(
      cachedETokenKey,
      json.encode(eTokenToCache.toJson()),
    );
  }

  @override
  Future<ETokenModel> getLastEToken() {
    final jsonString = sharedPreferences.getString(cachedETokenKey);
    if (jsonString != null) {
      return Future.value(ETokenModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cachePassword(String password) {
    return sharedPreferences.setString(cachedPasswordKey, password);
  }

  @override
  Future<String> getPassword() {
    final password = sharedPreferences.getString(cachedPasswordKey);
    if (password != null) {
      return Future.value(password);
    } else {
      throw CacheException();
    }
  }
}
