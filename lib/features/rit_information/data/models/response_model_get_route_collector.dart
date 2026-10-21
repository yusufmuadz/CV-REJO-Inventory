import '../../domain/entities/route_collector_entity.dart';

class ResponseModelGetRouteCollector {
  final bool? status;
  final String? message;
  final Data? data;

  ResponseModelGetRouteCollector({this.status, this.message, this.data});

  factory ResponseModelGetRouteCollector.fromMap(Map<String, dynamic> json) =>
      ResponseModelGetRouteCollector(
        status: json["status"],
        message: json["message"],
        data: Data.fromMap(json),
      );
}

class Data {
  List<RouteCollectorEntity>? transaction;

  Data({this.transaction});

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    transaction: json["data"] == null
        ? []
        : List<RouteCollectorEntity>.from(
            json["data"]['content'].map(
              (x) => RouteCollectorEntity.fromJson(x),
            ),
          ),
  );

  List<RouteCollectorEntity> toEntity() {
    return transaction!;
  }
}
