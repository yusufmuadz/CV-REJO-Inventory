class VersionEntity {
  final String? version;

  const VersionEntity({this.version});

  factory VersionEntity.fromJson(Map<String, dynamic> json) {
    return VersionEntity(version: json['latest_version'] ?? '-');
  }
}
