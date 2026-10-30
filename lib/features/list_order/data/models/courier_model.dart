class Courier {
  final String service;
  final String waybillNumber;

  Courier({required this.service, required this.waybillNumber});

  factory Courier.fromJson(Map<String, dynamic> json) {
    String getData({required String value}) {
      String? data = json[value];

      if (json['content'] != null) {
        data ??= json['content'][value];
      }

      return data ?? '-';
    }

    return Courier(
      service: getData(value: 'service'),
      waybillNumber: getData(value: 'waybill_number'),
    );
  }
}
