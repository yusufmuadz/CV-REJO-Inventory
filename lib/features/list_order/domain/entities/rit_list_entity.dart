class RitListEntity {
  final String city; // Harunya ID/nomor RIT
  final String totalPO;
  final String tanggalRit;
  final String color;
  final String poPendingDelivery;
  final String poDoneDelivery;

  RitListEntity({
    required this.city,
    required this.totalPO,
    required this.tanggalRit,
    required this.color,
    required this.poPendingDelivery,
    required this.poDoneDelivery,
  });

  factory RitListEntity.fromJson(Map<String, dynamic> json) {
    return RitListEntity(
      city: json['city'] ?? '-',
      totalPO: json['total_po'] ?? '-',
      tanggalRit: json['tanggal_rit'] ?? '-',
      color: json['color'] ?? '-',
      poPendingDelivery: json['po_pending_delivery'] ?? '-',
      poDoneDelivery: json['po_done_delivery'] ?? '-',
    );
  }
}
