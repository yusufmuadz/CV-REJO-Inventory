class AssistantModel {
  final String? idLoader;
  final String? idDriver;
  final String? idKenek;
  final String? namaKendaraan;
  final String? namaDriver;
  final String? namaKenek;

  AssistantModel({
    required this.idLoader,
    required this.idDriver,
    required this.idKenek,
    required this.namaKendaraan,
    required this.namaDriver,
    required this.namaKenek,
  });

  factory AssistantModel.fromJson(Map<String, dynamic> json) {
    return AssistantModel(
      idLoader: json['idloader'] ?? '-',
      idDriver: json['iddriver'] ?? '-',
      idKenek: json['idkenek'] ?? '-',
      namaKendaraan: json['nama_kendaraan'] ?? '-',
      namaDriver: json['nama_driver'] ?? '-',
      namaKenek: json['nama_kenek'] ?? '-',
    );
  }
}
