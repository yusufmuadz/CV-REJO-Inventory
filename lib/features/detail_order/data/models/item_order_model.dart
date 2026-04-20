class ItemOrderModel {
  final String item;
  late final String qty;
  final String barcode;
  final StatusItem pic;
  final StatusItem checker1;
  final StatusOrder checker2;
  final StatusOrder driver;

  ItemOrderModel({
    required this.item,
    required this.qty,
    required this.barcode,
    required this.pic,
    required this.checker1,
    required this.checker2,
    required this.driver,
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
