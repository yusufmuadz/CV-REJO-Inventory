class RitListEntity {
  final String city; // Harunya ID/nomor RIT
  final String totalPO;
  final String tanggalRit;

  RitListEntity({required this.city, required this.totalPO, required this.tanggalRit});

  factory RitListEntity.fromJson(Map<String, dynamic> json) {
    return RitListEntity(
      city: json['city'] ?? '-',
      totalPO: json['total_po'] ?? '-',
      tanggalRit: json['tanggal_rit'] ?? '-',
    );
  }
}
