class TransportationEntity {
  final String? id;
  final String? namaKendaraan;
  final String? penggunaan;
  final String? status;

  const TransportationEntity({
    this.id,
    this.namaKendaraan,
    this.penggunaan,
    this.status,
  });

  factory TransportationEntity.fromJson(Map<String, dynamic> json) {
    return TransportationEntity(
      id: json['id'] ?? '-',
      namaKendaraan: json['nama_kendaraan'] ?? '-',
      penggunaan: json['penggunaan'] ?? '-',
      status: json['status_aktif'] ?? '-',
    );
  }
}
