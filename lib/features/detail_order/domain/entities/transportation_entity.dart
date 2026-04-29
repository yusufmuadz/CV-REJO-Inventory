class TransportationEntity {
  final String? id;
  final String? idDeliveryMobil;
  final String? namaKendaraan;
  final String? jenisKendaraan;
  final String? maxKoli;
  final String? maxTonase;
  final String? penggunaan;
  final String? status;

  const TransportationEntity({
    this.id,
    this.idDeliveryMobil,
    this.namaKendaraan,
    this.jenisKendaraan,
    this.maxKoli,
    this.maxTonase,
    this.penggunaan,
    this.status,
  });

  factory TransportationEntity.fromJson(Map<String, dynamic> json) {
    return TransportationEntity(
      id: json['id'] ?? '-',
      namaKendaraan: json['nama_kendaraan'] ?? '-',
      penggunaan: json['penggunaan'] ?? '-',
      status: json['status_aktif'] ?? '-',
      idDeliveryMobil: json['iddelivery_mobil'] ?? '-', // BUAT ROLE LOADER
      jenisKendaraan: json['jenis_kendaraan'] ?? '-', // BUAT ROLE LOADER
      maxKoli: json['max_koli'] ?? '-', // BUAT ROLE LOADER
      maxTonase: json['max_tonase'] ?? '-', // BUAT ROLE LOADER
    );
  }
}
