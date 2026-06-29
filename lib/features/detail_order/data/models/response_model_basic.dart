class ResponseModelBasic {
  final bool? status;
  final String? message;
  final String? error;

  ResponseModelBasic({this.status, this.message, this.error});

  factory ResponseModelBasic.fromMap(Map<String, dynamic> json) =>
      ResponseModelBasic(
        status: json["status"],
        message: json["message"],
        error: json["error"] != null ? json["error"]["details"] : null,
      );
}
