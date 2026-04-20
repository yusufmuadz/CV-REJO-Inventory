import 'package:cv_rejo/features/home/domain/entities/transaction_entity.dart';

class ResponseModelGetTransaction {
  final bool? status;
  final String? message;
  final Data? data;

  ResponseModelGetTransaction({this.status, this.message, this.data});

  factory ResponseModelGetTransaction.fromMap(Map<String, dynamic> json) =>
      ResponseModelGetTransaction(
        status: json["status"],
        message: json["message"],
        data: Data.fromMap(json),
      );
}

class Data {
  TransactionEntity? transaction;

  Data({this.transaction});

  Data copyWith({TransactionEntity? transaction}) =>
      Data(transaction: transaction ?? this.transaction);

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    transaction: json["data"] == null
        ? TransactionEntity(totalRow: 0)
        : TransactionEntity(totalRow: json["data"]['total_row']),
  );

  TransactionEntity toEntity() {
    if (transaction == null) {
      return TransactionEntity(totalRow: 0);
    }
    return transaction!;
  }
}
