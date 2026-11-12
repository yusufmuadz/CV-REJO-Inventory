class RitListEntity {
  final String city; // Harunya ID/nomor RIT
  final String totalPO;
  final String tanggalRit;
  final String color;
  final String poPendingPic;
  final String poDonePic;
  final String poPendingCheck1;
  final String poDoneCheck1;
  final String poPendingCheck2;
  final String poDoneCheck2;
  final String poPendingLoader;
  final String poDoneLoader;
  final String poPendingDelivery;
  final String poDoneDelivery;
  final String? driverName;
  final String? statusArmada;
  final String? nopolArmada;
  final String? namaArmada;
  final bool? ritBerangkat;
  final bool? ritPulang;
  final List<String> route;
  final List<String> pengurut;

  RitListEntity({
    required this.city,
    required this.totalPO,
    required this.tanggalRit,
    required this.color,
    required this.poPendingPic,
    required this.poDonePic,
    required this.poPendingCheck1,
    required this.poDoneCheck1,
    required this.poPendingCheck2,
    required this.poDoneCheck2,
    required this.poPendingLoader,
    required this.poDoneLoader,
    required this.poPendingDelivery,
    required this.poDoneDelivery,
    required this.route,
    required this.pengurut,
    this.driverName,
    this.statusArmada,
    this.namaArmada,
    this.nopolArmada,
    this.ritBerangkat,
    this.ritPulang,
  });

  factory RitListEntity.fromJson(Map<String, dynamic> json) {
    final isExternal =
        json['status_armada']?.toString().toLowerCase() == 'external';

    return RitListEntity(
      city: json['city'] ?? '-',
      totalPO: json['total_po'] ?? '-',
      tanggalRit: json['tanggal_rit'] ?? '-',
      color: json['color'] ?? '-',
      poPendingPic: json['po_pending_pic'] ?? '-',
      poDonePic: json['po_done_pic'] ?? '-',
      poPendingCheck1: json['po_pending_check1'] ?? '-',
      poDoneCheck1: json['po_done_check1'] ?? '-',
      poPendingCheck2: json['po_pending_check2'] ?? '-',
      poDoneCheck2: json['po_done_check2'] ?? '-',
      poPendingLoader: json['po_pending_loader'] ?? '-',
      poDoneLoader: json['po_done_loader'] ?? '-',
      poPendingDelivery: json['po_pending_delivery'] ?? '-',
      poDoneDelivery: json['po_done_delivery'] ?? '-',
      driverName: isExternal
          ? json['driver_external'] ?? '-'
          : json['driver_assigned'] ?? '-',
      statusArmada: json['status_armada'] ?? '-',
      namaArmada: json['truck_nama'] ?? '-',
      nopolArmada: isExternal
          ? json['mobil_external'] ?? '-'
          : json['truck_assigned'] ?? '-',
      ritBerangkat: json['rit_berangkat'] ?? false,
      ritPulang: json['rit_pulang'] ?? false,
      route: json['rute'] != null
          ? List<String>.from(json['rute'])
          : List<String>.from(['-']), // json['rute'],
      pengurut: json['pengurut'] != null
          ? List<String>.from(json['pengurut'])
          : List<String>.from(['-']),
    );
  }
}
