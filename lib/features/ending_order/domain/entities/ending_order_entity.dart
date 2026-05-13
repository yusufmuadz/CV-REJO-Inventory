
class EndingOrderEntity {
  final String? totalPO;
  final List<dynamic>? list;

  const EndingOrderEntity({
    this.totalPO,
    this.list,
  });

  factory EndingOrderEntity.fromJson(Map<String, dynamic> json) {
    return EndingOrderEntity(
      totalPO: json['totalPO'],
      list: [],
    );
  }
}
