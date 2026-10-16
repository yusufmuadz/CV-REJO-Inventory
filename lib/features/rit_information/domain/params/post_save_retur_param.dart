import 'package:camera/camera.dart';
import 'package:get/get.dart';

import '../entities/item_order_retur_entity.dart';

class ParamsPostSaveRetur {
  final bool? isTidakTerkait;
  final String invoice;
  final String description;
  final String? customerName;
  final String? marketName;
  final String? marketAddress;
  final RxList<XFile> mediaFileList;
  final List<ItemOrderReturEntity> itemOrderList;

  ParamsPostSaveRetur({
    required this.invoice,
    required this.description,
    required this.mediaFileList,
    required this.itemOrderList,
    this.isTidakTerkait = false,
    this.customerName,
    this.marketName,
    this.marketAddress,
  });
}
