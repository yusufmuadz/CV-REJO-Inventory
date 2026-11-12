import '../../../domain/entities/app/version_entity.dart';

class ResponseModelAppVersion {
  final bool? status;
  final String? message;
  final Data? data;

  ResponseModelAppVersion({this.status, this.message, this.data});

  factory ResponseModelAppVersion.fromMap(Map<String, dynamic> json) =>
      ResponseModelAppVersion(
        status: json["status"],
        message: json["message"],
        data: Data.fromMap(json),
      );
}

class Data {
  final VersionEntity? entity;

  Data({this.entity});

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    entity: json["data"] == null ? null : VersionEntity.fromJson(json["data"]),
  );

  VersionEntity toEntity() {
    return entity ?? VersionEntity();
  }
}
