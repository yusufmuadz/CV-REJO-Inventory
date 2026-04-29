class DistrictEntity {
  final String? kabupaten;

  DistrictEntity({this.kabupaten});

  factory DistrictEntity.fromJson(Map<String, dynamic> json) {
    return DistrictEntity(kabupaten: json['city'] ?? '');
  }
}
