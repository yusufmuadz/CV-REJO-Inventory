import 'package:cv_rejo/features/scan_product/domain/entities/item_product_entity.dart';

class ResponseModelGetItemProduct {
  final bool? status;
  final String? message;
  final String? error;
  final Data? data;

  ResponseModelGetItemProduct({this.status, this.message, this.error, this.data});

  factory ResponseModelGetItemProduct.fromMap(Map<String, dynamic> json) =>
      ResponseModelGetItemProduct(
        status: json["status"],
        message: json["message"],
        error: json["error"] == null ? null : json["error"]['message'],
        data: Data.fromMap(json),
      );
}

class Data {
  List<ItemProductEntity>? products;

  Data({this.products});

  Data copyWith({List<ItemProductEntity>? products}) =>
      Data(products: products ?? this.products);

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    products: json["data"] == null
        ? []
        : List<ItemProductEntity>.from(
            json["data"]['content'].map((x) => ItemProductEntity.fromJson(x)),
          ),
  );

  List<ItemProductEntity> toEntity() {
    if (products == null) {
      return [];
    }
    return products!;
  }
}
