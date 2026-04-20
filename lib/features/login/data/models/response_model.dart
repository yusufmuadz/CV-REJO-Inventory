import 'package:cv_rejo/features/login/data/models/user_model.dart';
import 'package:cv_rejo/features/login/domain/entities/user_entity.dart';

class ResponseModelLoginSuccess {
  final int? statusCode;
  final String? message;
  final String? errors;
  final UserModel? userModel;

  ResponseModelLoginSuccess({
    this.statusCode,
    this.message,
    this.errors,
    this.userModel,
  });

  factory ResponseModelLoginSuccess.fromMap(Map<String, dynamic> json) =>
      ResponseModelLoginSuccess(
        statusCode: json["code"],
        message: json["message"],
        errors: json["errors"] == null ? null : json["errors"]['details'],
        userModel: json["data"] == null
            ? null
            : UserModel.fromJson(json["data"]),
      );

  UserEntity toEntity() => UserEntity(
    userId: userModel?.userId ?? '',
    nama: userModel?.nama ?? '',
    username: userModel?.username ?? '',
    jabatan: userModel?.jabatan ?? '',
    notelp: userModel?.notelp ?? '',
    alamat: userModel?.alamat ?? '',
    token: userModel?.token,
  );
}
