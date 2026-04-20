class BasicEntity {
  final bool status;
  final String message;

  BasicEntity({required this.status, required this.message});

  factory BasicEntity.fromJson(Map<String, dynamic> json) {
    return BasicEntity(status: json['status'], message: json['message']);
  }
}
