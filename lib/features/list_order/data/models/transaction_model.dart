import '../../../home/domain/entities/transaction_entity.dart';
import 'courier_model.dart';
import 'date_model.dart';
import 'status_model.dart';

class TransactionModel extends TransactionEntity {
  final String invoice;
  final String orderNo;
  final String customer;
  final DateModel date;
  final Courier courier;
  final Status picking;
  final Status packing;
  final Status sealing;
  final Status delivery;

  TransactionModel({
    required this.invoice,
    required this.orderNo,
    required this.customer,
    required this.date,
    required this.courier,
    required this.picking,
    required this.packing,
    required this.sealing,
    required this.delivery,
    required super.totalRow,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      invoice: json['invoice'],
      orderNo: json['order_no'],
      customer: json['customer'],
      date: DateModel.fromJson(json['date']),
      courier: Courier.fromJson(json['courier']),
      picking: Status.fromJson(json['picking']),
      packing: Status.fromJson(json['packing']),
      sealing: Status.fromJson(json['sealing']),
      delivery: Status.fromJson(json['delivery']),
      totalRow: json['total_row'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "invoice": invoice,
      "order_no": orderNo,
      "customer": customer,
      "date": date,
      "courier": courier,
      "picking": picking,
      "packing": packing,
      "sealing": sealing,
      "delivery": delivery,
      "total_row": totalRow,
    };
  }

  TransactionEntity toEntity() => TransactionEntity(totalRow: totalRow);
}
