
class ResponseModelTakeItTransaction {
  final bool? status;
  final String? message;

  ResponseModelTakeItTransaction({this.status, this.message});

  factory ResponseModelTakeItTransaction.fromMap(Map<String, dynamic> json) =>
      ResponseModelTakeItTransaction(
        status: json["status"],
        message: json["message"],
      );
}
