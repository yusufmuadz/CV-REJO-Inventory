import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/dialog_service.dart';
import '../../../rit_information/domain/entities/item_order_retur_entity.dart';
import '../../../rit_information/domain/usecases/rit_usecase.dart';

class HomeReturController extends GetxController {
  final RitUseCase ritUseCase;

  HomeReturController({required this.ritUseCase});

  final isLoadingRetur = false.obs;

  final dialogService = Get.find<DialogService>();

  final itemPoAddRetur = <ItemOrderReturEntity>[].obs;

  final formKey = GlobalKey<FormState>();
  final formKeyItem = GlobalKey<FormState>();

  void addItemRetur({
    int? index,
    bool isRetur = false,
    ItemOrderReturEntity? item,
    required TextEditingController nameProductController,
    required TextEditingController qtyReturProductController,
    required TextEditingController descProductController,
    required RxList<XFile> mediaFileListRetur,
  }) {
    if (isRetur) {
      if (qtyReturProductController.text.isEmpty ||
          mediaFileListRetur.isEmpty) {
        Future.delayed(const Duration(milliseconds: 50), () {
          dialogService.showErrorSnackbar(
            title: 'Gagal!',
            'Silakan lengkapi data terlebih dahulu!',
          );
        });
        return;
      }

      if (index != null) {
        final order = itemPoAddRetur[index];

        final updateOrder = order.copyWith(
          inputQtyItem: qtyReturProductController.text,
          description: descProductController.text,
          mediaFileList: mediaFileListRetur,
        );

        itemPoAddRetur[index] = updateOrder;
        // selectedItem(index);
      }
      return;
    }
    itemPoAddRetur.add(
      ItemOrderReturEntity(
        idTransactionDetail: item?.idTransactionDetail ?? '',
        idItem: item?.idItem ?? '',
        name: nameProductController.text,
        jumlahItem: '0',
        inputQtyItem: qtyReturProductController.text,
        hargaJual: item?.hargaJual ?? '0',
        satuanItem: item?.satuanItem ?? '0',
        diskonTotal: item?.diskonTotal ?? '0',
        hargaSatuan: item?.hargaSatuan ?? '0',
        grandTotal: item?.grandTotal ?? '0',
        description: descProductController.text,
        mediaFileList: mediaFileListRetur,
      ),
    );
  }
}
