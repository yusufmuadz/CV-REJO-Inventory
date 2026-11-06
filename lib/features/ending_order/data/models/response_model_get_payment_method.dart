import '../../domain/entities/payment_method_entity.dart';

class ResponseModelGetPaymentMethod {
  final bool? status;
  final String? message;
  final Data? data;

  ResponseModelGetPaymentMethod({this.status, this.message, this.data});

  factory ResponseModelGetPaymentMethod.fromMap(Map<String, dynamic> json) =>
      ResponseModelGetPaymentMethod(
        status: json["status"],
        message: json["message"],
        data: Data.fromMap(json),
      );
}

class Data {
  List<PaymentMethodEntity>? paymentMethod;

  Data({this.paymentMethod});

  Data copyWith({List<PaymentMethodEntity>? paymentMethod}) =>
      Data(paymentMethod: paymentMethod ?? this.paymentMethod);

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    paymentMethod: json["data"] == null
        ? []
        : List<PaymentMethodEntity>.from(
            json['data']['content'].map((x) => PaymentMethodEntity.fromJson(x)),
          ),
  );

  List<PaymentMethodEntity> toEntity() {
    return paymentMethod ?? [];
  }
}
