class CollectorStatusProcessModel {
  bool? statusArrive;
  final bool? statusBerangkat;
  final bool? statusBayar;
  final bool? statusPulang;

  CollectorStatusProcessModel({
    this.statusArrive,
    this.statusBerangkat,
    this.statusBayar,
    this.statusPulang,
  });

  factory CollectorStatusProcessModel.fromJson(Map<String, dynamic> json) {
    bool getData({required String value}) {
      bool? data = json[value];

      if (json['content'] != null) {
        data ??= json['content'][value];
      }

      return data ?? false;
    }

    return CollectorStatusProcessModel(
      statusArrive: getData(value: 'status_arrive'),
      statusBerangkat: getData(value: 'status_berangkat'),
      statusBayar: getData(value: 'status_bayar'),
      statusPulang: getData(value: 'status_pulang'),
    );
  }
}
