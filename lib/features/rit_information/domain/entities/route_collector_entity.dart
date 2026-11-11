class RouteCollectorEntity {
  final String noRoute; // Harunya ID/nomor RIT
  final String notaRoute;
  final String namaRoute;
  final String jumlahTransaksi;
  final String tanggalTransaksi;
  final String statusPenugasan;

  RouteCollectorEntity({
    required this.noRoute,
    required this.notaRoute,
    required this.namaRoute,
    required this.jumlahTransaksi,
    required this.tanggalTransaksi,
    required this.statusPenugasan,
  });

  factory RouteCollectorEntity.fromJson(Map<String, dynamic> json) {
    return RouteCollectorEntity(
      noRoute: json['no_rute'] ?? '-',
      notaRoute: json['nota_rute'] ?? '-',
      jumlahTransaksi: json['jumlah_transaksi'] ?? '-',
      namaRoute: json['nama_rute'] ?? '-',
      tanggalTransaksi: json['tanggal_penagihan'] ?? '-',
      statusPenugasan: json['status_penugasan'] ?? '-',
    );
  }
}
