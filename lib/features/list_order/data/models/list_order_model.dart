import 'package:get/get.dart';

import '../../domain/entities/list_order_entity.dart';
import 'courier_model.dart';
import 'date_model.dart';
import 'status_model.dart';

class ListOrderModel extends OrderEntity {
  ListOrderModel({
    required super.invoice,
    required super.orderNo,
    required super.customer,
    required super.district,
    required super.date,
    required super.courier,
    required super.pic,
    required super.checker1,
    required super.checker2,
    required super.driver,
    required super.isSelected,
    required super.number,
  });

  factory ListOrderModel.fromJson(Map<String, dynamic> json) {
    return ListOrderModel(
      invoice: json['invoice'] ?? '',
      orderNo: json['order_no'] ?? '',
      customer: json['customer'] ?? '',
      district: json['district'] ?? '',
      date: DateModel.fromJson(json['date']),
      courier: Courier.fromJson(json['courier']),
      pic: Status.fromJson(json['pic']),
      checker1: Status.fromJson(json['checker1']),
      checker2: Status.fromJson(json['checker2']),
      driver: Status.fromJson(json['driver']),
      isSelected: json['isSelected'] ?? false,
      number: json['number'] ?? 0.obs,
    );
  }
}
