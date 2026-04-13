import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String accessToken;
  final String username;

  const AuthEntity({
    required this.accessToken,
    required this.username,
  });

  @override
  List<Object> get props => [accessToken, username];
}
