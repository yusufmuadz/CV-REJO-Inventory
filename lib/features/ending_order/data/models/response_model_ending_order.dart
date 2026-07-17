class ResponseModelEndingOrder {
  final bool? status;
  final String? message;
  final String? error;

  ResponseModelEndingOrder({this.status, this.message, this.error});

  factory ResponseModelEndingOrder.fromMap(Map<String, dynamic> json) =>
      ResponseModelEndingOrder(
        status: json["status"],
        message: json["message"],
        error: json["error"] != null ? json["error"]['details'] : null,
      );
}
