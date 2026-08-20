import 'package:camera/camera.dart';
import 'package:get/get.dart';

class ItemOrderModel {
  final String item;
  late final String qty;
  final String barcode;
  final StatusItem pic;
  final StatusItem checker1;
  final StatusOrder checker2;
  final StatusOrder loader;
  final StatusOrder driver;
  final bool statusChecker2;
  final bool statusDriver;
  final bool statusFinishScan;
  final bool statusArrive;
  final bool statusUnload;
  final bool statusConfirmDelivery;
  final String? color;
  bool isChecked;
  String? note;
  final String? locationRack;
  RxList<XFile>? mediaFileList;
  bool isLoading;
  bool hasError;

  ItemOrderModel({
    required this.item,
    required this.qty,
    required this.barcode,
    required this.pic,
    required this.checker1,
    required this.checker2,
    required this.loader,
    required this.driver,
    required this.statusFinishScan,
    required this.statusArrive,
    required this.statusUnload,
    required this.statusConfirmDelivery,
    this.color = '-',
    this.statusChecker2 = false,
    this.statusDriver = false,
    this.isChecked = false,
    this.note = '',
    this.locationRack,
    this.mediaFileList,
    this.isLoading = false,
    this.hasError = false,
  });

  factory ItemOrderModel.fromJson(Map<String, dynamic> json) {
    return ItemOrderModel(
      item: json['item'] ?? '-',
      qty: json['qty'] ?? '-',
      barcode: json['barcode'],
      pic: StatusItem.fromJson(json['pic']),
      checker1: StatusItem.fromJson(json['checker1']),
      checker2: StatusOrder.fromJson(json['checker2']),
      loader: StatusOrder.fromJson(json['loader']),
      driver: StatusOrder.fromJson(json['driver']),
      statusChecker2: json['status_checker2'] ?? false,
      statusDriver: json['status_deliveryscan'] ?? false,
      statusFinishScan: json['status_finishscan'] ?? false,
      statusArrive: json['status_arrive'] ?? false,
      statusUnload: json['status_unload'] ?? false,
      statusConfirmDelivery: json['status_confirmdelivery'] ?? false,
      locationRack: json['lokasi'] ?? '-',
      color: json['warna'] ?? '-',
    );
  }

  ItemOrderModel copyWith({
    String? item,
    String? qty,
    String? barcode,
    StatusItem? pic,
    StatusItem? checker1,
    StatusOrder? checker2,
    StatusOrder? loader,
    StatusOrder? driver,
    bool? statusChecker2,
    bool? statusDriver,
    bool? statusFinishScan,
    bool? statusArrive,
    bool? statusUnload,
    bool? statusConfirmDelivery,
    bool? isChecked,
    String? note,
    String? locationRack,
    String? color,
    RxList<XFile>? mediaFileList,
  }) {
    return ItemOrderModel(
      item: item ?? this.item,
      qty: qty ?? this.qty,
      barcode: barcode ?? this.barcode,
      pic: pic ?? this.pic,
      checker1: checker1 ?? this.checker1,
      checker2: checker2 ?? this.checker2,
      loader: loader ?? this.loader,
      driver: driver ?? this.driver,
      statusChecker2: statusChecker2 ?? this.statusChecker2,
      statusDriver: statusDriver ?? this.statusDriver,
      statusFinishScan: statusFinishScan ?? this.statusFinishScan,
      statusArrive: statusArrive ?? this.statusArrive,
      statusUnload: statusUnload ?? this.statusUnload,
      statusConfirmDelivery:
          statusConfirmDelivery ?? this.statusConfirmDelivery,
      isChecked: isChecked ?? this.isChecked,
      note: note ?? this.note,
      color: color ?? this.color,
      locationRack: locationRack ?? this.locationRack,
      mediaFileList: mediaFileList ?? this.mediaFileList,
    );
  }
}

class StatusItem {
  final String? status;
  final String? qty;
  final List<dynamic>? images;

  StatusItem({this.status, this.qty, this.images});

  factory StatusItem.fromJson(Map<String, dynamic> json) {
    return StatusItem(
      status: json['status'],
      qty: json['qty'] ?? '0',
      images: json['foto'] is List
          ? List<dynamic>.from(json['foto'])
          : json['foto'],
    );
  }
}

class StatusOrder {
  final String? status;
  final List<dynamic>? images;

  StatusOrder({this.status, this.images});

  factory StatusOrder.fromJson(Map<String, dynamic> json) {
    return StatusOrder(
      status: json['status'],
      images: json['foto'] is List
          ? List<dynamic>.from(json['foto'])
          : json['foto'],
    );
  }
}
