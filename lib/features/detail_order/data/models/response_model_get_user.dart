
import '../../../login/data/models/user_model.dart';

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
  final List<UserModel>? users;

  Data({this.users});

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    users: json["data"] == null
        ? []
        : List<UserModel>.from(json["data"].map((x) => UserModel.fromJson(x))),
  );

  List<UserModel> toEntity() {
    return users ?? [];
  }
}
