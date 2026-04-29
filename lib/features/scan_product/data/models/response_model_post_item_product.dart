import 'package:cv_rejo/features/scan_product/domain/entities/error_post_entity.dart';

import '../../domain/entities/post_item_product_entity.dart';

class ResponseModelPostItemProduct {
  final bool? status;
  final String? message;
  final ErrorPostItemProductEntity? error;
  final Data? data;

  ResponseModelPostItemProduct({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  factory ResponseModelPostItemProduct.fromMap(Map<String, dynamic> json) =>
      ResponseModelPostItemProduct(
        status: json["status"],
        message: json["message"],
        error: json["error"] == null ? null : ErrorPostItemProductEntity.fromJson(json["error"]),
        data: Data.fromMap(json),
      );
}

class Data {
  PostItemProductEntity? product;

  Data({this.product});

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    product: json["data"] == null
        ? PostItemProductEntity()
        : PostItemProductEntity.fromJson(json["data"]),
  );

  PostItemProductEntity? toEntity() {
    if (product == null) {
      return PostItemProductEntity();
    }
    return product!;
  }
}
