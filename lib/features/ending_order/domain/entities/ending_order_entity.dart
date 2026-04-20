
class EndingOrderEntity {
  final String invoice;
  final String orderNo;

  const EndingOrderEntity({
    required this.invoice,
    required this.orderNo,
  });

  factory EndingOrderEntity.fromJson(Map<String, dynamic> json) {
    return EndingOrderEntity(
      invoice: json['invoice'] ?? '-',
      orderNo: json['order_no'] ?? '-',
    );
  }
}
