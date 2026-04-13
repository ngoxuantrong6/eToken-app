import '../../domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.accessToken,
    required super.username,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final user = data['user'] as Map<String, dynamic>? ?? {};
    return AuthModel(
      accessToken: data['accessToken'] ?? data['token'] ?? '',
      username: user['username'] ?? data['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'username': username,
      };
}
