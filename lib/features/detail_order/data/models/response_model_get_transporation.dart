import '../../domain/entities/transportation_entity.dart';

class ResponseModelGetTransportation {
  final bool? status;
  final String? message;
  final Data? data;

  ResponseModelGetTransportation({this.status, this.message, this.data});

  factory ResponseModelGetTransportation.fromMap(Map<String, dynamic> json) =>
      ResponseModelGetTransportation(
        status: json["status"],
        message: json["message"],
        data: Data.fromMap(json),
      );
}

class Data {
  final List<TransportationEntity>? transportations;

  Data({this.transportations});

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    transportations: json["data"] == null
        ? []
        : List<TransportationEntity>.from(
            json["data"]['content'].map(
              (x) => TransportationEntity.fromJson(x),
            ),
          ),
  );

  List<TransportationEntity> toEntity() {
    return transportations ?? [];
  }
}
