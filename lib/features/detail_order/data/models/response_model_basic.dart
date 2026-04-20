class ResponseModelBasic {
  final bool? status;
  final String? message;

  ResponseModelBasic({this.status, this.message});

  factory ResponseModelBasic.fromMap(Map<String, dynamic> json) =>
      ResponseModelBasic(status: json["status"], message: json["message"]);
}
