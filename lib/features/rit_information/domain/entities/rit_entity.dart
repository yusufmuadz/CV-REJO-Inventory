
class RitEntity {
  final List<dynamic>? list;

  const RitEntity({
    this.list,
  });

  factory RitEntity.fromJson(Map<String, dynamic> json) {
    return RitEntity(
      list: [],
    );
  }
}
