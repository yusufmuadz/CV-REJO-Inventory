import 'package:get/get.dart';

import '../../data/models/courier_model.dart';
import '../../data/models/date_model.dart';
import '../../data/models/status_model.dart';

class OrderEntity {
  final String invoice;
  final String orderNo;
  final String customer;
  final String district;
  final DateModel date;
  String? suratJalan;
  Courier? courier;
  Status? pic;
  Status? checker1;
  Status? checker2;
  Status? loader;
  Status? driver;
  String? address;
  String? noTelp;
  String? maps;
  String? lat;
  String? long;
  final String? route;
  RxInt number = 0.obs;
  bool isSelected;

  OrderEntity({
    required this.invoice,
    required this.orderNo,
    required this.customer,
    required this.date,
    required this.district,
    this.suratJalan,
    this.courier,
    this.pic,
    this.checker1,
    this.checker2,
    this.loader,
    this.driver,
    this.address,
    this.noTelp,
    this.maps,
    this.lat,
    this.long,
    this.route,
    required this.number,
    this.isSelected = false,
  });

  factory OrderEntity.fromJson(Map<String, dynamic> json) {
    return OrderEntity(
      invoice: json['invoice'],
      orderNo: json['order_no'],
      suratJalan: json['surat_jalan'] ?? '-',
      customer: json['customer'] ?? '-',
      district: json['district'] ?? '-',
      date: json['dates'] != null
          ? DateModel.fromJson(json['dates'])
          : json['date'] != null
          ? DateModel.fromJson(json['date'])
          : DateModel(transaction: '', delivery: ''),
      courier: json['courier'] == null
          ? null
          : Courier.fromJson(json['courier']),
      pic: json['pic'] == null ? null : Status.fromJson(json['pic']),
      checker1: json['checker1'] == null
          ? null
          : Status.fromJson(json['checker1']),
      checker2: json['checker2'] == null
          ? null
          : Status.fromJson(json['checker2']),
      loader: json['loader'] == null ? null : Status.fromJson(json['loader']),
      driver: json['driver'] == null ? null : Status.fromJson(json['driver']),
      address: json['drop_address'] ?? '-',
      noTelp: json['phone'] ?? '-',
      route: json['route'] ?? json['router'] ?? '-',
      maps: json['maps'] ?? '-',
      isSelected: json['isSelected'] ?? false,
      number: 0.obs,
    );
  }
}
