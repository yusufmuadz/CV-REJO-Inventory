import 'package:get/get.dart';

import '../../data/models/courier_model.dart';
import '../../data/models/date_model.dart';
import '../../data/models/status_model.dart';

class InvoiceEntity {
  final String? invoice;
  final String? orderNo;
  final String? customer;
  final String? district;
  final DateModel? date;
  final String? suratJalan;
  final Courier? courier;
  final Status? pic;
  final Status? checker1;
  final Status? checker2;
  final Status? loader;
  final Status? driver;
  final String? address;
  final String? noTelp;
  final String? maps;
  final String? lat;
  final String? long;
  final String? jenisArmada;
  final String? route;
  bool isChecked;
  bool isSelected;

  InvoiceEntity({
    this.invoice,
    this.orderNo,
    this.customer,
    this.date,
    this.district,
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
    this.jenisArmada,
    this.isChecked = false,
    this.isSelected = false,
  });

  factory InvoiceEntity.fromJson(Map<String, dynamic> json) {
    return InvoiceEntity(
      invoice: json['invoice'] ?? '-',
      orderNo: json['order_no'] ?? '-',
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
      jenisArmada: json['jenis_armada'] ?? '-',
      isChecked: json['isChecked'] ?? false,
      isSelected: json['isSelected'] ?? false,
    );
  }

  InvoiceEntity copyWith({
    String? invoice,
    String? orderNo,
    String? customer,
    String? district,
    DateModel? date,
    String? suratJalan,
    Courier? courier,
    Status? pic,
    Status? checker1,
    Status? checker2,
    Status? loader,
    Status? driver,
    String? address,
    String? noTelp,
    String? maps,
    String? lat,
    String? long,
    String? jenisArmada,
    String? route,
    bool? isChecked,
    bool? isSelected,
  }) {
    return InvoiceEntity(
      invoice: invoice ?? this.invoice,
      orderNo: orderNo ?? this.orderNo,
      customer: customer ?? this.customer,
      district: district ?? this.district,
      date: date ?? this.date,
      suratJalan: suratJalan ?? this.suratJalan,
      courier: courier ?? this.courier,
      pic: pic ?? this.pic,
      checker1: checker1 ?? this.checker1,
      checker2: checker2 ?? this.checker2,
      loader: loader ?? this.loader,
      driver: driver ?? this.driver,
      address: address ?? this.address,
      noTelp: noTelp ?? this.noTelp,
      maps: maps ?? this.maps,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      jenisArmada: jenisArmada ?? this.jenisArmada,
      route: route ?? this.route,
      isChecked: isChecked ?? this.isChecked,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
