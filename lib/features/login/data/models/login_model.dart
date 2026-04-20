
import '../../domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {
  const LoginModel({
    required super.id,
    required super.refreshToken,
    required super.email,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "access_token": id,
      "refresh_token": refreshToken,
      "email": email,
    };
  }
}