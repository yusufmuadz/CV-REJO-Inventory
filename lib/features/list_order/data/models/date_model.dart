class DateModel {
  final String transaction;
  final String delivery;

  DateModel({required this.transaction, required this.delivery});

  factory DateModel.fromJson(Map<String, dynamic> json) {
    return DateModel(
      transaction: json['transaction'].replaceAll('-', ' ') ?? '-',
      delivery: json['delivery'].replaceAll('-', ' ') ?? '-',
    );
  }
}
