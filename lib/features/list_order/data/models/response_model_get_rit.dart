import '../../domain/entities/rit_list_entity.dart';

class ResponseModelGetRit {
  final bool? status;
  final String? message;
  final Data? data;

  ResponseModelGetRit({this.status, this.message, this.data});

  factory ResponseModelGetRit.fromMap(Map<String, dynamic> json) =>
      ResponseModelGetRit(
        status: json["status"],
        message: json["message"],
        data: Data.fromMap(json),
      );
}

class Data {
  List<RitListEntity>? transaction;

  Data({this.transaction});

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    transaction: json["data"] == null
        ? []
        : List<RitListEntity>.from(
            json["data"]['content'].map((x) => RitListEntity.fromJson(x)),
          ),
  );

  List<RitListEntity> toEntity() {
    return transaction!;
  }
}
