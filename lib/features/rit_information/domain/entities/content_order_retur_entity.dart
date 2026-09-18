import 'item_order_retur_entity.dart';

class ContentOrderReturEntity {
  final String idTransaction;
  final String dateTransaction;
  final String rit;
  final String dateRit;
  final String customerName;
  final String grandTotal;
  final List<ItemOrderReturEntity> itemOrder;

  ContentOrderReturEntity({
    required this.idTransaction,
    required this.dateTransaction,
    required this.rit,
    required this.dateRit,
    required this.customerName,
    required this.grandTotal,
    required this.itemOrder,
  });

  factory ContentOrderReturEntity.fromJson(Map<String, dynamic> json) {
    return ContentOrderReturEntity(
      idTransaction: json['idtransaksi'],
      dateTransaction: json['tanggal_transaksi'],
      rit: json['rit'] ?? '-',
      dateRit: json['tanggal_rit'] ?? '-',
      customerName: json['nama_customer'] ?? '-',
      grandTotal: json['grand_total'] ?? '-',
      itemOrder: json['detail_barang'] == null || json['detail_barang'].isEmpty
          ? []
          : (json['detail_barang'] as List)
                .map((e) => ItemOrderReturEntity.fromJson(e))
                .toList(),
    );
  }
}
