import 'package:cv_rejo/features/detail_order/data/models/customer_model.dart';
import 'package:cv_rejo/features/list_order/data/models/courier_model.dart';
import 'package:cv_rejo/features/list_order/data/models/date_model.dart';

import '../../data/models/assistant_model.dart';
import '../../data/models/item_order_model.dart';

class DetailOrderEntity {
  final String invoice;
  final String orderNo;
  final Courier courier;
  final CustomerModel customer;
  final DateModel date;
  final AssistantModel? assistant;
  final List<ItemOrderModel>? orderDetails;

  const DetailOrderEntity({
    required this.invoice,
    required this.orderNo,
    required this.courier,
    required this.customer,
    required this.date,
    this.assistant,
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
      orderDetails: json['order_details'] != null
          ? List<ItemOrderModel>.from(
              json['order_details'].map((x) => ItemOrderModel.fromJson(x)),
            )
          : null,
    );
  }
}
