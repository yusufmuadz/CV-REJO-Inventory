import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.token,
    required super.refreshToken,
    required super.email,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      token: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "access_token": token,
      "refresh_token": refreshToken,
      "email": email,
    };
  }
}
