import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/loading_custom.dart';
import '../../../list_order/data/models/courier_model.dart';
import '../../../list_order/data/models/date_model.dart';
import '../../../list_order/data/models/status_model.dart';
import '../../../list_order/domain/entities/invoice_entity.dart';
import '../../../list_order/presentation/controllers/enums/button_inv_enum.dart';

class HomeCollectorController extends GetxController {
  final isGetLoading = false.obs;
  final getLoadState = LoadState.initial.obs;

  final buttonINV = EnumButtonInv.acceptINV.obs;

  final isSelectedRoute = ''.obs;
  final dateRoute = ''.obs;

  final searchInvController = TextEditingController();

  final recipientName = TextEditingController();
  final kmController = TextEditingController();

  final mediaFileList = <XFile>[].obs;
  final mediaFileListKM = <XFile>[].obs;
  final mediaFileListTangki = <XFile>[].obs;
  final mediaFileListSJ = <XFile>[].obs;
  final mediaFileListTransportMoney = <XFile>[].obs;
  final mediaFileRecipientMoneyRit = <XFile>[].obs;
  final mediaFileRecipientBox = <XFile>[].obs;

  final mediaFileFrontTransport = Rx<XFile>(XFile(''));
  final mediaFileBackTransport = Rx<XFile>(XFile(''));
  final mediaFileRightTransport = Rx<XFile>(XFile(''));
  final mediaFileLeftTransport = Rx<XFile>(XFile(''));

  void retryFetch() =>
      getOrder(isRefresh: getLoadState.value == LoadState.error);

  Future<void> getOrder({
    bool isRefresh = false,
    bool isDetail = false,
    String? dateRIT,
    String? noRIT,
  }) async {
    try {
      if (isRefresh) {
        // if (masterController.pageIndex.value == 0 && !isDetail) {
        //   // listCtrl.orders.clear();
        // }
      }

      // final result = await listOrderUseCase.call(
      //   ParamsGetTransaction(
      //     limit: '10',
      //     page: isDetail
      //         ? '${listCtrl.currentPageDetail.value}'
      //         : '${listCtrl.currentPage.value}',
      //     q: listCtrl.searchController.text,
      //     sort: listCtrl.sortByNew.value ? 'newest' : 'oldest',
      //     filter: listCtrl.isStatusSelected.value.toLowerCase(),
      //     district: noRIT ?? listCtrl.isDistrictSelected.value.toLowerCase(),
      //     dateRit: dateRIT ?? listCtrl.tanggalRit.value,
      //     pastRit: !listCtrl.isRitToday.value,
      //   ),
      // );

      // switch (result) {
      //   case Success(:final data):
      //     debugPrint('Data Order: ${data.length}');
      //     if (data.isEmpty) {
      //       if (isRefresh && listCtrl.currentPage.value == 1) {
      //         listCtrl.loadState.value = LoadState.idle;
      //       } else {
      //         if (isDetail) {
      //           listCtrl.loadStateDetailPO.value = LoadState.noMore;
      //         } else {
      //           listCtrl.loadState.value = LoadState.noMore;
      //         }
      //       }
      //       return;
      //     }

      //     final filterData = data.where((element) {
      //       bool result = true;

      //       // if (AppRole.isChecker2 &&
      //       //     element.checker2?.status == 'completed' &&
      //       //     element.loader?.status == 'available') {
      //       //   result = false;
      //       // }

      //       return result;
      //     }).toList();

      //     listCtrl.orders.addAll(filterData);

      //     debugPrint('isDetail: $isDetail');

      //     if (isDetail) {
      //       debugPrint('Data Order: ${listCtrl.orders.length}');
      //       listCtrl.loadStateDetailPO.value = LoadState.idle;
      //       // if (listCtrl.orders.isNotEmpty) {
      //       //   DetailRITDialog().showDetailRIT(controller: listCtrl);
      //       // }
      //     } else {
      //       listCtrl.loadState.value = LoadState.idle;
      //     }

      //   case ErrorResult(:final message):
      //     if (Get.isDialogOpen == true) Get.back();
      //     listCtrl.loadState.value = LoadState.error;
      //     listCtrl.dialogService.showError('Failed', message);
      // }
    } catch (e) {
      // listCtrl.loadState.value = LoadState.error;
      // if (Get.isDialogOpen == true) Get.back();
      // listCtrl.dialogService.showError('Failed', 'Error Get Data');
    } finally {
      // listCtrl.isLoading.value = false;
    }
  }

  void onSelectedInv(int index) {
    debugPrint('index: $index');
    if (index != -1) {
      final invEntity = listInv[index];

      bool result = !invEntity.isChecked;

      final updatedInv = invEntity.copyWith(isChecked: result);

      final updateList = List<InvoiceEntity>.from(listInv);
      updateList[index] = updatedInv;

      listInv.value = updateList;
      // selectedAllItem.value = listInv.every((e) => e.isChecked);
    } else {
      isSelectedRoute.value = '';
      dateRoute.value = '';
    }
  }

  final listInv = <InvoiceEntity>[
    InvoiceEntity(
      invoice: '01SL00000000001',
      orderNo: 'PO/0000/0001',
      customer: 'TESTING DUMMY CUSTOMER',
      district: 'PARANGKUSUMO',
      suratJalan: 'SJ/0000/0001',
      address:
          'Jl. Raya Pantai Parangkusumo, Parangkusumo, Kec. Parangkusumo, Kota Surabaya, Jawa Timur 60254',
      noTelp: '081234567890',
      maps: '-',
      lat: '-',
      long: '-',
      jenisArmada: 'INTERNAL',
      route: 'PANTAI PARANGKUSUMO',
      isSelected: false,
      isChecked: false,
      date: DateModel(transaction: '2026-10-05', delivery: ''),
      courier: Courier(service: '', waybillNumber: ''),
      pic: Status(
        status: 'ongoing',
        date: '2026-10-05',
        desc: '',
        by: '',
        scanDriver: false,
      ),
      checker1: Status(
        status: 'ongoing',
        date: '2026-10-05',
        desc: '',
        by: '',
        scanDriver: false,
      ),
      checker2: Status(
        status: 'ongoing',
        date: '2026-10-05',
        desc: '',
        by: '',
        scanDriver: false,
      ),
      loader: Status(
        status: 'ongoing',
        date: '2026-10-05',
        desc: '',
        by: '',
        scanDriver: false,
      ),
      driver: Status(
        status: 'ongoing',
        date: '2026-10-05',
        desc: '',
        by: '',
        scanDriver: false,
      ),
    ),
    InvoiceEntity(
      invoice: '01SL00000000002',
      orderNo: 'PO/0000/0002',
      customer: 'TESTING DUMMY',
      district: 'PARANGTRITIS',
      suratJalan: 'SJ/0000/0002',
      address: 'JALANJALAN',
      noTelp: '081234567890',
      maps: '-',
      lat: '-',
      long: '-',
      jenisArmada: 'INTERNAL',
      route: 'PANTAI PARANGTRITIS',
      isSelected: false,
      isChecked: false,
      date: DateModel(transaction: '2026-10-05', delivery: ''),
      courier: Courier(service: '', waybillNumber: ''),
      pic: Status(
        status: 'ongoing',
        date: '2026-10-05',
        desc: '',
        by: '',
        scanDriver: false,
      ),
      checker1: Status(
        status: 'ongoing',
        date: '2026-10-05',
        desc: '',
        by: '',
        scanDriver: false,
      ),
      checker2: Status(
        status: 'ongoing',
        date: '2026-10-05',
        desc: '',
        by: '',
        scanDriver: false,
      ),
      loader: Status(
        status: 'ongoing',
        date: '2026-10-05',
        desc: '',
        by: '',
        scanDriver: false,
      ),
      driver: Status(
        status: 'ongoing',
        date: '2026-10-05',
        desc: '',
        by: '',
        scanDriver: false,
      ),
    ),
    InvoiceEntity(
      invoice: '01SL00000000003',
      orderNo: 'PO/0000/0003',
      customer: 'DUMMY CUSTOMER',
      district: 'GOA CINA',
      suratJalan: 'SJ/0000/0003',
      address:
          'Jl. Goa Cina, Parangkusumo, Kec. Parangkusumo, Kota Surabaya, Jawa Timur 60254',
      noTelp: '081234567890',
      maps: '-',
      lat: '-',
      long: '-',
      jenisArmada: 'INTERNAL',
      route: 'GOA CINA',
      isSelected: false,
      isChecked: false,
      date: DateModel(transaction: '2026-10-05', delivery: ''),
      courier: Courier(service: '', waybillNumber: ''),
      pic: Status(
        status: 'ongoing',
        date: '2026-10-05',
        desc: '',
        by: '',
        scanDriver: false,
      ),
      checker1: Status(
        status: 'ongoing',
        date: '2026-10-05',
        desc: '',
        by: '',
        scanDriver: false,
      ),
      checker2: Status(
        status: 'ongoing',
        date: '2026-10-05',
        desc: '',
        by: '',
        scanDriver: false,
      ),
      loader: Status(
        status: 'ongoing',
        date: '2026-10-05',
        desc: '',
        by: '',
        scanDriver: false,
      ),
      driver: Status(
        status: 'ongoing',
        date: '2026-10-05',
        desc: '',
        by: '',
        scanDriver: false,
      ),
    ),
  ].obs;
}
