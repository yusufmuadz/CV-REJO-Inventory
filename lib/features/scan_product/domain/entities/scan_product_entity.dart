
class ProductEntity {
  final String invoice;
  final String barcode;
  final String itemName;
  final String qty;

  const ProductEntity({
    required this.invoice,
    required this.barcode,
    required this.itemName,
    required this.qty,
  });

  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      invoice: json['invoice'] ?? '-',
      barcode: json['barcode'] ?? '-',
      itemName: json['item_name'] ?? '-',
      qty: json['qty'] ?? '-',
    );
  }
}
