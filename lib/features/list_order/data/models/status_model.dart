class Status {
  final String? status;
  final String? date;
  final String? desc;
  final dynamic by;

  Status({
    required this.status,
    required this.date,
    required this.desc,
    required this.by,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      status: json['status'],
      date: json['date'],
      desc: json['desc'],
      by: json['by'],
    );
  }
}