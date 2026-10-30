class CustomerModel {
  final String username;
  final String name;
  final String phone;
  final String district;
  final String address;
  final String dropAddress;
  final String latitude;
  final String longitude;

  CustomerModel({
    required this.username,
    required this.name,
    required this.phone,
    required this.district,
    required this.address,
    required this.dropAddress,
    required this.latitude,
    required this.longitude,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    String getData({required String value}) {
      String? data = json[value];

      if (json['content'] != null) {
        data ??= json['content'][value];
      }

      return data ?? '-';
    }

    return CustomerModel(
      username: getData(value: 'username'),
      name: getData(value: 'name'),
      phone: getData(value: 'phone'),
      district: getData(value: 'district'),
      address: getData(value: 'address'),
      dropAddress: getData(value: 'drop_address'),
      latitude: getData(value: 'lat'),
      longitude: getData(value: 'long'),
    );
  }
}
