class DriverModel {
  final String? idKendaraan;
  final String? idDriver;
  final String? idKenek;
  final String? namaKendaraan;
  final String? namaDriver;
  final String? namaKenek;

  DriverModel({
    required this.idKendaraan,
    required this.idDriver,
    required this.idKenek,
    required this.namaKendaraan,
    required this.namaDriver,
    required this.namaKenek,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      idKendaraan: json['idmobil'] ?? '-',
      idDriver: json['iddriver'] ?? '-',
      idKenek: json['idkenek'] ?? '-',
      namaKendaraan: json['nama_kendaraan'] ?? '-',
      namaDriver: json['nama_driver'] ?? '-',
      namaKenek: json['nama_kenek'] ?? '-',
    );
  }
}
