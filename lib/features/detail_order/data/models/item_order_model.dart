import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ItemOrderModel {
  final String item;
  late final String qty;
  final String barcode;
  final StatusItem pic;
  final StatusItem checker1;
  final StatusOrder checker2;
  final StatusOrder driver;
  bool isChecked;
  String? note;
  RxList<XFile>? mediaFileList;

  ItemOrderModel({
    required this.item,
    required this.qty,
    required this.barcode,
    required this.pic,
    required this.checker1,
    required this.checker2,
    required this.driver,
    this.isChecked = false,
    this.note = '',
    this.mediaFileList,
  });

  factory ItemOrderModel.fromJson(Map<String, dynamic> json) {
    return ItemOrderModel(
      item: json['item'] ?? '-',
      qty: json['qty'] ?? '-',
      barcode: json['barcode'],
      pic: StatusItem.fromJson(json['pic']),
      checker1: StatusItem.fromJson(json['checker1']),
      checker2: StatusOrder.fromJson(json['checker2']),
      driver: StatusOrder.fromJson(json['driver']),
    );
  }

  ItemOrderModel copyWith({
    String? item,
    String? qty,
    String? barcode,
    StatusItem? pic,
    StatusItem? checker1,
    StatusOrder? checker2,
    StatusOrder? driver,
    bool? isChecked,
    String? note,
    RxList<XFile>? mediaFileList,
  }) {
    return ItemOrderModel(
      item: item ?? this.item,
      qty: qty ?? this.qty,
      barcode: barcode ?? this.barcode,
      pic: pic ?? this.pic,
      checker1: checker1 ?? this.checker1,
      checker2: checker2 ?? this.checker2,
      driver: driver ?? this.driver,
      isChecked: isChecked ?? this.isChecked,
      note: note ?? this.note,
      mediaFileList: mediaFileList ?? this.mediaFileList,
    );
  }
}

class StatusItem {
  final String? status;
  String? qty;

  StatusItem({this.status, this.qty});

  factory StatusItem.fromJson(Map<String, dynamic> json) {
    return StatusItem(status: json['status'], qty: json['qty'] ?? '0');
  }
}

class StatusOrder {
  final String? status;

  StatusOrder({this.status});

  factory StatusOrder.fromJson(Map<String, dynamic> json) {
    return StatusOrder(status: json['status']);
  }
}
