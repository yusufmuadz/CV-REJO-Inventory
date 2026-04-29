import '../../data/models/courier_model.dart';
import '../../data/models/date_model.dart';
import '../../data/models/status_model.dart';

class OrderEntity {
  final String invoice;
  final String orderNo;
  final String customer;
  final DateModel date;
  Courier? courier;
  Status? pic;
  Status? checker1;
  Status? checker2;
  Status? driver;
  bool isSelected;

  OrderEntity({
    required this.invoice,
    required this.orderNo,
    required this.customer,
    required this.date,
    this.courier,
    this.pic,
    this.checker1,
    this.checker2,
    this.driver,
    this.isSelected = false,
  });

  factory OrderEntity.fromJson(Map<String, dynamic> json) {
    return OrderEntity(
      invoice: json['invoice'],
      orderNo: json['order_no'],
      customer: json['customer'],
      date: json['dates'] != null ? DateModel.fromJson(json['dates']) : json['date'] != null ? DateModel.fromJson(json['date']) : DateModel(transaction: '', delivery: ''),
      courier: json['courier'] == null ? null : Courier.fromJson(json['courier']),
      pic: json['pic'] == null ? null : Status.fromJson(json['pic']),
      checker1: json['checker1'] == null ? null : Status.fromJson(json['checker1']),
      checker2: json['checker2'] == null ? null : Status.fromJson(json['checker2']),
      driver: json['driver'] == null ? null : Status.fromJson(json['driver']),
      isSelected: json['isSelected'] ?? false,
    );
  }

  OrderEntity copyWith({
    String? invoice,
    String? orderNo,
    String? customer,
    DateModel? date,
    Courier? courier,
    Status? picking,
    Status? packing,
    Status? sealing,
    Status? delivery,
    bool? isSelected,
  }) {
    return OrderEntity(
      invoice: invoice ?? this.invoice,
      orderNo: orderNo ?? this.orderNo,
      customer: customer ?? this.customer,
      date: date ?? this.date,
      courier: courier ?? this.courier,
      pic: picking ?? this.pic,
      checker1: packing ?? this.checker1,
      checker2: sealing ?? this.checker2,
      driver: delivery ?? this.driver,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
