
class ResponseModelTakeItTransaction {
  final bool? status;
  final String? message;
  final String? error;

  ResponseModelTakeItTransaction({this.status, this.message, this.error});

  factory ResponseModelTakeItTransaction.fromMap(Map<String, dynamic> json) =>
      ResponseModelTakeItTransaction(
        status: json["status"],
        message: json["message"],
        error: json["error"] != null ? json["error"]['details'] : null,
      );
}
