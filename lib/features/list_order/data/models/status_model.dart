class Status {
  final String? status;
  final String? date;
  final String? desc;
  final bool? scanDriver;
  final bool? arriveDriver;
  final dynamic by;

  Status({
    required this.status,
    required this.date,
    required this.desc,
    required this.by,
    required this.scanDriver,
    this.arriveDriver,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      status: json['status'],
      date: json['date'],
      desc: json['desc'],
      by: json['by'],
      scanDriver: json['statusscandriver'],
      arriveDriver: json['statusacceptedbycustomer'],
    );
  }
}
