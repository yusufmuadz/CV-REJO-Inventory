import '../../../login/domain/entities/user_entity.dart';

class ResponseModelGetUser {
  final bool? status;
  final String? message;
  final Data? data;

  ResponseModelGetUser({this.status, this.message, this.data});

  factory ResponseModelGetUser.fromMap(Map<String, dynamic> json) =>
      ResponseModelGetUser(
        status: json["status"],
        message: json["message"],
        data: Data.fromMap(json),
      );
}

class Data {
  final List<UserEntity>? users;

  Data({this.users});

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    users: json["data"] == null
        ? []
        : List<UserEntity>.from(
            json["data"].map((x) => UserEntity.fromJson(x)),
          ),
  );

  List<UserEntity> toEntity() {
    return users ?? [];
  }
}
