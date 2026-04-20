class CustomerModel {
  final String username;
  final String name;

  CustomerModel({
    required this.username,
    required this.name,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      username: json['username'] ?? '-',
      name: json['name'] ?? '-',
    );
  }
}
