class CustomerModel {
  final String username;
  final String name;
  final String district;
  final String latitude;
  final String longitude;

  CustomerModel({
    required this.username,
    required this.name,
    required this.district,
    required this.latitude,
    required this.longitude,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      username: json['username'] ?? '-',
      name: json['name'] ?? '-',
      district: json['district'] ?? '-',
      latitude: json['lat'] ?? '-',
      longitude: json['lng'] ?? '-',
    );
  }
}
