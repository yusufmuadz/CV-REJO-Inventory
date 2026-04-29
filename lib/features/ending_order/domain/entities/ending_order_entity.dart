
class EndingOrderEntity {
  final List<dynamic>? list;

  const EndingOrderEntity({
    this.list,
  });

  factory EndingOrderEntity.fromJson(Map<String, dynamic> json) {
    return EndingOrderEntity(
      list: [],
    );
  }
}
