import '../../../../features/login/domain/entities/user_entity.dart';

class ResponseModelGetUserLogin {
  final bool? status;
  final String? message;
  final Data? data;

  ResponseModelGetUserLogin({this.status, this.message, this.data});

  factory ResponseModelGetUserLogin.fromMap(Map<String, dynamic> json) =>
      ResponseModelGetUserLogin(
        status: json["status"],
        message: json["message"],
        data: Data.fromMap(json),
      );
}

class Data {
  final UserEntity? entity;

  Data({this.entity});

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    entity: json["data"] == null ? null : UserEntity.fromJson(json["data"]),
  );

  UserEntity toEntity() {
    return entity ??
        UserEntity(
          userId: '',
          nama: '',
          username: '',
          jabatan: '',
          notelp: '',
          alamat: '',
        );
  }
}
