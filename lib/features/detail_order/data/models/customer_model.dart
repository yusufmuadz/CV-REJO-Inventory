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
    return CustomerModel(
      username: json['username'] ?? '-',
      name: json['name'] ?? '-',
      phone: json['phone'] ?? '-',
      district: json['district'] ?? '-',
      address: json['address'] ?? '-',
      dropAddress: json['drop_address'] ?? '-',
      latitude: json['lat'] ?? '-',
      longitude: json['lng'] ?? '-',
    );
  }
}
