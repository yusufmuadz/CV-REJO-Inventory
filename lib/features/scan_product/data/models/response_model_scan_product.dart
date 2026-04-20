import '../../domain/entities/scan_product_entity.dart';

class ResponseModelScanProduct {
  final bool? status;
  final String? message;
  final String? error;
  final Data? data;

  ResponseModelScanProduct({this.status, this.message, this.error, this.data});

  factory ResponseModelScanProduct.fromMap(Map<String, dynamic> json) =>
      ResponseModelScanProduct(
        status: json["status"],
        message: json["message"],
        error: json["error"] == null ? null : json["error"]['details'],
        data: Data.fromMap(json),
      );
}

class Data {
  ProductEntity? product;

  Data({this.product});

  Data copyWith({ProductEntity? product}) =>
      Data(product: product ?? this.product);

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    product: json["data"] == null
        ? ProductEntity(invoice: '', barcode: '', itemName: '', qty: '')
        : ProductEntity(
            invoice: json["data"]["invoice"] ?? '',
            barcode: json["data"]["barcode"] ?? '',
            itemName: json["data"]["item_name"] ?? '',
            qty: json["data"]["qty"] ?? '',
          ),
  );

  ProductEntity? toEntity() {
    if (product == null) {
      return ProductEntity(invoice: '', barcode: '', itemName: '', qty: '');
    }
    return product!;
  }
}
