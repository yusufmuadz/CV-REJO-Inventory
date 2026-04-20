
import '../../domain/entities/list_order_entity.dart';

class ResponseModelGetTransactionAll {
  final bool? status;
  final String? message;
  final Data? data;

  ResponseModelGetTransactionAll({this.status, this.message, this.data});

  factory ResponseModelGetTransactionAll.fromMap(Map<String, dynamic> json) =>
      ResponseModelGetTransactionAll(
        status: json["status"],
        message: json["message"],
        data: Data.fromMap(json),
      );
}

class Data {
  List<OrderEntity>? transaction;

  Data({this.transaction});

  Data copyWith({List<OrderEntity>? transaction}) =>
      Data(transaction: transaction ?? this.transaction);

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    transaction: json["data"]['content'] == null || json["data"]['content'].isEmpty
        ? []
        : (json["data"]['content'] as List)
            .map((e) => OrderEntity.fromJson(e))
            .toList(),
  );

  List<OrderEntity> toEntity() {
    if (transaction == null) {
      return [];
    }
    return transaction!;
  }
}
