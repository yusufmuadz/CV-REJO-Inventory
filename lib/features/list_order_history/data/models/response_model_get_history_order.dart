import '../../../list_order/domain/entities/list_order_entity.dart';

class ResponseModelHistoryOrderAll {
  final bool? status;
  final String? message;
  final Data? data;

  ResponseModelHistoryOrderAll({this.status, this.message, this.data});

  factory ResponseModelHistoryOrderAll.fromMap(Map<String, dynamic> json) =>
      ResponseModelHistoryOrderAll(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null && json["data"].runtimeType == List
            ? json["data"].map((e) => OrderEntity.fromJson(e)).toList()
            : Data.fromMap(json),
      );
}

class Data {
  List<OrderEntity>? transactions;

  Data({this.transactions});

  Data copyWith({List<OrderEntity>? transactions}) =>
      Data(transactions: transactions ?? this.transactions);

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    transactions: json["data"] == null || json["data"].isEmpty
        ? []
        : json["data"]['content'] == null || json["data"]['content'].isEmpty
        ? []
        : (json["data"]['content'] as List)
              .map((e) => OrderEntity.fromJson(e))
              .toList(),
  );

  List<OrderEntity> toEntity() {
    if (transactions == null) {
      return [];
    }
    return transactions!;
  }
}
