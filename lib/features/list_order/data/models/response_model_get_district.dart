import '../../domain/entities/district_entity.dart';

class ResponseModelGetDistrict {
  final bool? status;
  final String? message;
  final Data? data;

  ResponseModelGetDistrict({this.status, this.message, this.data});

  factory ResponseModelGetDistrict.fromMap(Map<String, dynamic> json) =>
      ResponseModelGetDistrict(
        status: json["status"],
        message: json["message"],
        data: Data.fromMap(json),
      );
}

class Data {
  List<DistrictEntity>? transaction;

  Data({this.transaction});

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    transaction: json["data"] == null
        ? []
        : List<DistrictEntity>.from(
            json["data"]['content'].map((x) => DistrictEntity.fromJson(x)),
          ),
  );

  List<DistrictEntity> toEntity() {
    return transaction!;
  }
}
