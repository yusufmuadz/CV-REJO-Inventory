class TakeItOrderEntity {
  final bool status;
  final String message;

  TakeItOrderEntity({required this.status, required this.message});

  factory TakeItOrderEntity.fromJson(Map<String, dynamic> json) {
    return TakeItOrderEntity(status: json['status'], message: json['message']);
  }
}
