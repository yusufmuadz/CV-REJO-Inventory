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
  String? jenisArmada;
  String? urutan;
  final String? idDetail;
  final String? route;
  final String? idPiutang;
  final String? totalPiutang;
  final String? sisaPiutang;
  final String? tanggalTransaksi;
  RxInt number = 0.obs;
  bool isSelected;
  bool isChecked;

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
    this.jenisArmada,
    this.urutan,
    this.idDetail,
    this.idPiutang,
    this.totalPiutang,
    this.sisaPiutang,
    this.tanggalTransaksi,
    required this.number,
    this.isSelected = false,
    this.isChecked = false,
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
      jenisArmada: json['jenis_armada'] ?? '-',
      idDetail: json['id_detail'] ?? '-',
      idPiutang: json['id_piutang'] ?? '-',
      totalPiutang: json['total_piutang'] ?? '-',
      sisaPiutang: json['sisa_piutang'] ?? '-',
      tanggalTransaksi: json['tanggal_transaksi'],
      isSelected: json['isSelected'] ?? false,
      urutan: json['urutan'],
      number: 0.obs,
    );
  }

  OrderEntity copyWith({
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
    String? idDetail,
    String? route,
    String? idPiutang,
    String? totalPiutang,
    String? sisaPiutang,
    String? tanggalTransaksi,
    bool? isChecked,
    bool? isSelected,
    RxInt? number,
  }) {
    return OrderEntity(
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
      idDetail: idDetail ?? this.idDetail,
      route: route ?? this.route,
      idPiutang: idPiutang ?? this.idPiutang,
      totalPiutang: totalPiutang ?? this.totalPiutang,
      sisaPiutang: sisaPiutang ?? this.sisaPiutang,
      tanggalTransaksi: tanggalTransaksi ?? this.tanggalTransaksi,
      isChecked: isChecked ?? this.isChecked,
      isSelected: isSelected ?? this.isSelected,
      number: number ?? this.number,
    );
  }
}
