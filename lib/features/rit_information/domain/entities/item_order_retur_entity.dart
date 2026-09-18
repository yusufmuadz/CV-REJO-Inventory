import 'package:camera/camera.dart';
import 'package:get/get.dart';

class ItemOrderReturEntity {
  final String idTransactionDetail;
  final String idItem;
  final String name;
  final String hargaJual;
  final String satuanItem;
  final String jumlahItem;
  final String? inputQtyItem;
  final String diskonTotal;
  final String hargaSatuan;
  final String grandTotal;
  final String? description;
  final RxList<XFile>? mediaFileList;
  bool isChecked;

  ItemOrderReturEntity({
    required this.idTransactionDetail,
    required this.idItem,
    required this.name,
    required this.hargaJual,
    required this.satuanItem,
    required this.jumlahItem,
    required this.diskonTotal,
    required this.hargaSatuan,
    required this.grandTotal,
    this.inputQtyItem,
    this.description,
    this.mediaFileList,
    this.isChecked = false,
  });

  factory ItemOrderReturEntity.fromJson(Map<String, dynamic> json) {
    return ItemOrderReturEntity(
      idTransactionDetail: json['idtransaksi_detail'],
      idItem: json['iditem'],
      name: json['nama'],
      hargaJual: json['harga_jual'],
      satuanItem: json['satuan_item'],
      jumlahItem: json['jumlah_item'],
      inputQtyItem: json['input_qty_item'],
      diskonTotal: json['diskon_total'],
      hargaSatuan: json['harga_satuan'].toString(),
      grandTotal: json['grand_total'],
      isChecked: json['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idtransaksi_detail': idTransactionDetail,
      'iditem': idItem,
      'jumlah_item': int.parse(inputQtyItem ?? '0'),
      'harga_satuan': int.parse(hargaSatuan),
      'alasan_perbarang': description,
      if (mediaFileList != null && mediaFileList!.isNotEmpty)
        'foto1': mediaFileList?[0].path ?? '',
      if (mediaFileList != null && mediaFileList!.length > 1)
        'foto2': mediaFileList?[1].path ?? '',
    };
  }

  ItemOrderReturEntity copyWith({
    String? idTransactionDetail,
    String? idItem,
    String? name,
    String? hargaJual,
    String? satuanItem,
    String? jumlahItem,
    String? inputQtyItem,
    String? diskonTotal,
    String? hargaSatuan,
    String? grandTotal,
    String? description,
    RxList<XFile>? mediaFileList,
    bool? isChecked,
  }) {
    return ItemOrderReturEntity(
      idTransactionDetail: idTransactionDetail ?? this.idTransactionDetail,
      idItem: idItem ?? this.idItem,
      name: name ?? this.name,
      hargaJual: hargaJual ?? this.hargaJual,
      satuanItem: satuanItem ?? this.satuanItem,
      jumlahItem: jumlahItem ?? this.jumlahItem,
      inputQtyItem: inputQtyItem ?? this.inputQtyItem,
      diskonTotal: diskonTotal ?? this.diskonTotal,
      hargaSatuan: hargaSatuan ?? this.hargaSatuan,
      grandTotal: grandTotal ?? this.grandTotal,
      description: description ?? this.description,
      mediaFileList: mediaFileList ?? this.mediaFileList,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
