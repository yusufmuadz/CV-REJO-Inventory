import 'package:cv_rejo/features/detail_order/data/models/assistant_model.dart';
import 'package:cv_rejo/features/detail_order/data/models/customer_model.dart';
import 'package:cv_rejo/features/detail_order/domain/entities/detail_order_entity.dart';
import 'package:cv_rejo/features/list_order/data/models/courier_model.dart';
import 'package:cv_rejo/features/list_order/data/models/date_model.dart';

import 'driver_model.dart';
import 'item_order_model.dart';

class ResponseModelDetailOrder {
  final bool? status;
  final String? message;
  final Data? data;

  ResponseModelDetailOrder({this.status, this.message, this.data});

  factory ResponseModelDetailOrder.fromMap(Map<String, dynamic> json) =>
      ResponseModelDetailOrder(
        status: json["status"],
        message: json["message"],
        data: Data.fromMap(json),
      );
}

class Data {
  DetailOrderEntity? detailOrder;

  Data({this.detailOrder});

  Data copyWith({DetailOrderEntity? detailOrder}) =>
      Data(detailOrder: detailOrder ?? this.detailOrder);

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    detailOrder: json["data"] == null
        ? DetailOrderEntity(
            invoice: '',
            orderNo: '',
            suratJalan: '',
            courier: Courier(service: '', waybillNumber: ''),
            customer: CustomerModel(
              username: '',
              name: '',
              district: '',
              latitude: '',
              longitude: '',
              address: '',
            ),
            date: DateModel(transaction: '', delivery: ''),
          )
        : DetailOrderEntity.fromJson(json['data']),
  );

  DetailOrderEntity toEntity() {
    if (detailOrder == null) {
      return DetailOrderEntity(
        invoice: '',
        orderNo: '',
        suratJalan: '',
        courier: Courier(service: '', waybillNumber: ''),
        customer: CustomerModel(
          username: '',
          name: '',
          district: '',
          latitude: '',
          longitude: '',
          address: '',
        ),
        date: DateModel(transaction: '', delivery: ''),
      );
    }
    return detailOrder!;
  }
}
