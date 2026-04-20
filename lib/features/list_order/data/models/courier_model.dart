class Courier {
  final String service;
  final String waybillNumber;

  Courier({
    required this.service,
    required this.waybillNumber,
  });

  factory Courier.fromJson(Map<String, dynamic> json) {
    return Courier(
      service: json['service'] ?? '-',
      waybillNumber: json['waybill_number'] ?? '-',
    );
  }
}