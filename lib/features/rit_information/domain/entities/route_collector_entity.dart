class RouteCollectorEntity {
  final String noRoute; // Harunya ID/nomor RIT
  final String notaRoute;
  final String jumlahTransaksi;

  RouteCollectorEntity({
    required this.noRoute,
    required this.notaRoute,
    required this.jumlahTransaksi,
  });

  factory RouteCollectorEntity.fromJson(Map<String, dynamic> json) {
    return RouteCollectorEntity(
      noRoute: json['no_rute'] ?? '-',
      notaRoute: json['nota_rute'] ?? '-',
      jumlahTransaksi: json['jumlah_transaksi'] ?? '-',
    );
  }
}
