class CustomerModel {
  final String username;
  final String name;
  final String district;

  CustomerModel({required this.username, required this.name, required this.district});

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      username: json['username'] ?? '-',
      name: json['name'] ?? '-',
      district: json['district'] ?? '-',
    );
  }
}
