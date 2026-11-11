class DriverStatusProcessModel {
  final bool? statusArrive;
  final bool? statusUnload;
  final bool? statusConfirm;
  final bool? statusPayment;

  DriverStatusProcessModel({
    this.statusArrive,
    this.statusUnload,
    this.statusConfirm,
    this.statusPayment,
  });

  factory DriverStatusProcessModel.fromJson(Map<String, dynamic> json) {
    bool getData({required String value}) {
      bool? data = json[value];

      if (json['content'] != null) {
        data ??= json['content'][value];
      }

      return data ?? false;
    }

    return DriverStatusProcessModel(
      statusArrive: getData(value: 'status_arrive'),
      statusUnload: getData(value: 'status_unload'),
      statusConfirm: getData(value: 'status_confirm'),
      statusPayment: getData(value: 'status_payment'),
    );
  }
}
