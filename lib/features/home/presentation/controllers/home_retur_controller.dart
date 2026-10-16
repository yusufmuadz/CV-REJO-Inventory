import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../rit_information/domain/entities/item_order_retur_entity.dart';
import '../../../rit_information/domain/params/post_save_retur_param.dart';
import '../../../rit_information/domain/usecases/rit_usecase.dart';

class HomeReturController extends GetxController {
  final RitUseCase ritUseCase;

  HomeReturController({required this.ritUseCase});

  final isLoadingRetur = false.obs;

  final dialogService = Get.find<DialogService>();

  final itemPoAddRetur = <ItemOrderReturEntity>[].obs;

  final nameCustomerController = TextEditingController();
  final nameMarketController = TextEditingController();
  final marketAddressController = TextEditingController();
  final descReturController = TextEditingController();
  final mediaFileListRetur = <XFile>[].obs;

  final formKey = GlobalKey<FormState>();
  final formKeyItem = GlobalKey<FormState>();

  @override
  void onClose() {
    nameCustomerController.dispose();
    nameMarketController.dispose();
    marketAddressController.dispose();
    descReturController.dispose();

    super.onClose();
  }

  void addItemRetur({
    int? index,
    bool isRetur = false,
    ItemOrderReturEntity? item,
    required TextEditingController nameProductController,
    required TextEditingController qtyReturProductController,
    required TextEditingController descProductController,
    required RxList<XFile> mediaFileListItemRetur,
  }) {
    if (isRetur) {
      if (qtyReturProductController.text.isEmpty ||
          mediaFileListItemRetur.isEmpty) {
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
          mediaFileList: mediaFileListItemRetur,
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
        jumlahItem: item?.jumlahItem ?? qtyReturProductController.text,
        inputQtyItem: qtyReturProductController.text,
        hargaJual: item?.hargaJual ?? '0',
        satuanItem: item?.satuanItem ?? '0',
        diskonTotal: item?.diskonTotal ?? '0',
        hargaSatuan: item?.hargaSatuan ?? '0',
        grandTotal: item?.grandTotal ?? '0',
        description: descProductController.text,
        mediaFileList: mediaFileListItemRetur,
      ),
    );
  }

  Future<void> addRetur() async {
    try {
      if (isLoadingRetur.value) return;

      if (_getEmtpyPostRetur() != null) {
        Future.delayed(const Duration(milliseconds: 50), () {
          dialogService.showErrorSnackbar(
            title: 'Gagal!',
            _getEmtpyPostRetur() ?? 'Silakan lengkapi data terlebih dahulu!',
          );
        });
        return;
      }

      isLoadingRetur.value = true;

      debugPrint('List Item: ${itemPoAddRetur.first.inputQtyItem}');

      final result = await ritUseCase.callPostSaveRetur(
        ParamsPostSaveRetur(
          invoice: '',
          isTidakTerkait: true,
          customerName: nameCustomerController.text,
          marketName: nameMarketController.text,
          marketAddress: marketAddressController.text,
          description: descReturController.text,
          itemOrderList: itemPoAddRetur,
          mediaFileList: mediaFileListRetur,
        ),
      );

      switch (result) {
        case Success(:final data):
          debugPrint('Data Save Order: $data');
          dialogService.showDialogBox(
            title: 'Success',
            description: 'Berhasil Menyimpan Data',
            barrierDismissible: false,
            onPressed: () {
              nameCustomerController.clear();
              nameMarketController.clear();
              marketAddressController.clear();
              descReturController.clear();
              mediaFileListRetur.clear();
              itemPoAddRetur.clear();

              if (Get.isBottomSheetOpen == true) Get.back();
            },
          );

        case ErrorResult(:final message):
          if (Get.isBottomSheetOpen == true) Get.back();
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      if (Get.isBottomSheetOpen == true) Get.back();
      dialogService.showError('Failed', '$e');
    } finally {
      isLoadingRetur.value = false;
    }
  }

  String? _getEmtpyPostRetur() {
    if (nameMarketController.text.isEmpty) {
      return 'Silakan masukkan nama Toko/Tempat terlebih dahulu!';
    } else if (marketAddressController.text.isEmpty) {
      return 'Silakan masukkan alamat Toko/Tempat terlebih dahulu!';
    } else if (descReturController.text.isEmpty) {
      return 'Silakan masukkan alasan retur terlebih dahulu!';
    } else if (mediaFileListRetur.isEmpty) {
      return 'Silakan masukkan foto terlebih dahulu!';
    } else if (itemPoAddRetur.isEmpty) {
      return 'Silakan masukkan item terlebih dahulu!';
    }

    return null;
  }
}
