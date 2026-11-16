import '../../../../features/login/domain/entities/user_entity.dart';

class ResponseModelLogin {
  final bool? status;
  final String? message;
  final String? error;
  final Data? data;

  ResponseModelLogin({this.status, this.message, this.error, this.data});

  factory ResponseModelLogin.fromMap(Map<String, dynamic> json) =>
      ResponseModelLogin(
        status: json["status"],
        message: json["message"],
        error: json["error"] != null ? json["error"]['details'] : null,
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
          userId: '-',
          nama: '-',
          username: '-',
          jabatan: '-',
          notelp: '-',
          alamat: '-',
        );
  }
}
