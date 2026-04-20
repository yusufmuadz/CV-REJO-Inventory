import '../../domain/entities/ending_order_entity.dart';

class ResponseModelEndingOrder {
  final bool? status;
  final String? message;
  final Data? data;

  ResponseModelEndingOrder({this.status, this.message, this.data});

  factory ResponseModelEndingOrder.fromMap(Map<String, dynamic> json) =>
      ResponseModelEndingOrder(
        status: json["status"],
        message: json["message"],
        data: Data.fromMap(json),
      );
}

class Data {
  EndingOrderEntity? detailOrder;

  Data({this.detailOrder});

  Data copyWith({EndingOrderEntity? detailOrder}) =>
      Data(detailOrder: detailOrder ?? this.detailOrder);

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    detailOrder: json["data"] == null
        ? EndingOrderEntity(invoice: '', orderNo: '')
        : EndingOrderEntity(
            invoice: json["data"]["invoice"] ?? '',
            orderNo: json["data"]["order_no"] ?? '',
          ),
  );

  EndingOrderEntity toEntity() {
    if (detailOrder == null) {
      return EndingOrderEntity(invoice: '', orderNo: '');
    }
    return detailOrder!;
  }
}
