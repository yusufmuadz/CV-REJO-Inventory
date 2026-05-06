import 'package:cv_rejo/features/detail_order/data/models/customer_model.dart';
import 'package:cv_rejo/features/list_order/data/models/courier_model.dart';
import 'package:cv_rejo/features/list_order/data/models/date_model.dart';

import '../../data/models/assistant_model.dart';
import '../../data/models/driver_model.dart';
import '../../data/models/item_order_model.dart';

class DetailOrderEntity {
  final String invoice;
  final String orderNo;
  final Courier courier;
  final CustomerModel customer;
  final DateModel date;
  final AssistantModel? assistant;
  final DriverModel? driver;
  final List<ItemOrderModel>? orderDetails;

  const DetailOrderEntity({
    required this.invoice,
    required this.orderNo,
    required this.courier,
    required this.customer,
    required this.date,
    this.assistant,
    this.driver,
    this.orderDetails,
  });

  factory DetailOrderEntity.fromJson(Map<String, dynamic> json) {
    return DetailOrderEntity(
      invoice: json['invoice'] ?? '-',
      orderNo: json['order_no'] ?? '-',
      courier: Courier.fromJson(json['courier']),
      customer: CustomerModel.fromJson(json['customer']),
      date: DateModel.fromJson(json['date']),
      assistant: json['assistant'] != null ? AssistantModel.fromJson(json['assistant']) : null,
      driver: json['driver'] != null ? DriverModel.fromJson(json['driver']) : null,
      orderDetails: json['order_details'] != null
          ? List<ItemOrderModel>.from(
              json['order_details'].map((x) => ItemOrderModel.fromJson(x)),
            )
          : null,
    );
  }

  DetailOrderEntity copyWith({
    String? invoice,
    String? orderNo,
    Courier? courier,
    CustomerModel? customer,
    DateModel? date,
    AssistantModel? assistant,
    DriverModel? driver,
    List<ItemOrderModel>? orderDetails,
  }) {
    return DetailOrderEntity(
      invoice: invoice ?? this.invoice,
      orderNo: orderNo ?? this.orderNo,
      courier: courier ?? this.courier,
      customer: customer ?? this.customer,
      date: date ?? this.date,
      assistant: assistant ?? this.assistant,
      driver: driver ?? this.driver,
      orderDetails: orderDetails ?? this.orderDetails,
    );
  }
}
