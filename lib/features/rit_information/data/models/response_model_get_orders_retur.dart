import '../../domain/entities/content_order_retur_entity.dart';

class ResponseModelGetOrdersRetur {
  final bool? status;
  final String? message;
  final Data? data;

  ResponseModelGetOrdersRetur({this.status, this.message, this.data});

  factory ResponseModelGetOrdersRetur.fromMap(Map<String, dynamic> json) =>
      ResponseModelGetOrdersRetur(
        status: json["status"],
        message: json["message"],
        data: Data.fromMap(json),
      );
}

class Data {
  List<ContentOrderReturEntity>? orders;

  Data({this.orders});

  Data copyWith({List<ContentOrderReturEntity>? orders}) =>
      Data(orders: orders ?? this.orders);

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    orders: json["data"]['content'] == null || json["data"]['content'].isEmpty
        ? []
        : (json["data"]['content'] as List)
              .map((e) => ContentOrderReturEntity.fromJson(e))
              .toList(),
  );

  List<ContentOrderReturEntity> toEntity() {
    if (orders == null) {
      return [];
    }
    return orders!;
  }
}
