class ItemProductEntity {
  final String nama;
  final String barcode;
  final String iditem;

  ItemProductEntity({
    required this.nama,
    required this.barcode,
    required this.iditem,
  });

  factory ItemProductEntity.fromJson(Map<String, dynamic> json) {
    return ItemProductEntity(
      nama: json['nama'] ?? '-',
      barcode: json['barcode'] ?? '-',
      iditem: json['iditem'] ?? '-',
    );
  }
}
