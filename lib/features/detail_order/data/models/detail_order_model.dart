import '../../../list_order/data/models/courier_model.dart';
import '../../../list_order/data/models/date_model.dart';
import '../../domain/entities/detail_order_entity.dart';
import 'item_order_model.dart';

class DetailOrderModel extends DetailOrderEntity {
  const DetailOrderModel({
    required super.invoice,
    required super.orderNo,
    required super.customer,
    required super.courier,
    required super.date,
    super.orderDetails,
  });

  factory DetailOrderModel.fromJson(Map<String, dynamic> json) {
    return DetailOrderModel(
      invoice: json['invoice'] ?? '',
      orderNo: json['order_no'] ?? '',
      customer: json['customer'] ?? '',
      courier: Courier.fromJson(json['courier']),
      date: DateModel.fromJson(json['date']),
      orderDetails: json['order_details'] != null
          ? List<ItemOrderModel>.from(
              json['order_details'].map((x) => ItemOrderModel.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "invoice": invoice,
      "order_no": orderNo,
      "customer": customer,
      "courier": courier,
      "date": date,
      "order_details": orderDetails,
    };
  }
}
