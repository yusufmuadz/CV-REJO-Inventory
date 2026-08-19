import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:camera/camera.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../core/services/contact_service.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../../routes/app_pages.dart';
import '../../../../shared/images/camera_screen.dart';
import '../../../../utils/maps_utils.dart';
import '../../../list_order/data/models/courier_model.dart';
import '../../../list_order/data/models/date_model.dart';
import '../../../list_order/domain/params/take_it_param.dart';
import '../../../scan_product/domain/params/post_product_param.dart';
import '../../data/models/customer_model.dart';
import '../../data/models/item_order_model.dart';
import '../../domain/entities/detail_order_entity.dart';
import '../../domain/params/add_assistant_param.dart';
import '../../domain/usecases/detail_order_usecase.dart';
import '../widgets/dialog/input_product_dialog.dart';
import 'add_product_order_controller.dart';
import 'get_detail_order_controller.dart';

class DetailOrderController extends GetxController {
  final DetailOrderUseCase detailOrderUseCase;

  DetailOrderController({required this.detailOrderUseCase});

  final isLoading = false.obs;
  final isLoadingAssistant = false.obs;
  final isLoadingProduct = false.obs;
  final dialogService = Get.find<DialogService>();
  final noInvoice = ''.obs;
  final routeFrom = ''.obs;
  final takeItOrder = false.obs;
  final statusPO = ''.obs;

  final isFromHistory = false.obs;

  final statusChecker2 = ''.obs;
  final statusLoader = ''.obs;
  final statusDriver = ''.obs;

  final doneByPO = ''.obs;

  final isSelect = false.obs;
  final isTakeIt = false.obs;
  final isTakeToTheRoad = false.obs;

  final messageProduct = ''.obs;
  final statusPostProduct = false.obs;

  final isCheckedAll = false.obs;

  final reasonController = TextEditingController();

  final driverSelected = ''.obs;
  final assistantSelected = ''.obs;
  final selectTransportation = ''.obs;
  final nopolTransportation = ''.obs;

  late final GetDetailOrderController getDetailOrderController;
  late final AddProductOrderController addProductOrderController;

  final orderDetail = DetailOrderEntity(
    invoice: '',
    orderNo: '',
    suratJalan: '',
    courier: Courier(service: '', waybillNumber: ''),
    customer: CustomerModel(
      username: '',
      name: '',
      phone: '',
      district: '',
      latitude: '',
      longitude: '',
      address: '',
      dropAddress: '',
    ),
    date: DateModel(transaction: '', delivery: ''),
  ).obs;

  @override
  void onInit() {
    super.onInit();
    getDetailOrderController = Get.find<GetDetailOrderController>();
    addProductOrderController = Get.find<AddProductOrderController>();

    final args = Get.arguments;
    if (args != null) {
      noInvoice.value = args['invoice'] ?? '';
      routeFrom.value = args['routeFrom'] ?? '';
      takeItOrder.value = args['take_it_order'] ?? false;
      statusChecker2.value = args['status_checker2'] ?? '';
      statusLoader.value = args['status_loader'] ?? '';
      statusDriver.value = args['status_driver'] ?? '';
      statusPO.value = args['status_po'] ?? '';
      doneByPO.value = args['done_by_po'] ?? '-';
      // statusDriver.value = 'completed';

      if (AppRole.isDriver) {
        if (statusDriver.value == 'ongoing') {
          isSelect.value = true;
        } else if (statusDriver.value == 'completed') {
          final getIsTakeToTheRoad = GetStorage().read('isTakeToTheRoad');

          isTakeToTheRoad.value = getIsTakeToTheRoad ?? false;
        }
      }

      if (routeFrom.value == 'listHistoryOrder') {
        isFromHistory.value = true;
      }

      // debugPrint('No Invoice : ${noInvoice.value}');
      // debugPrint('Route From : ${routeFrom.value}');
      // debugPrint('Take It Order : ${takeItOrder.value}');
      // debugPrint('Status Checker 2 : ${statusChecker2.value}');
      // debugPrint('Status Loader : ${statusLoader.value}');
    }
  }

  @override
  void onReady() {
    super.onReady();
    _getDetailOrder();
  }

  @override
  void onClose() {
    super.onClose();
    isLoading.value = false;
  }

  void onRefreshDetailOrder() {
    _getDetailOrder();
  }

  Future<void> _getDetailOrder() async {
    getDetailOrderController.getDetailOrder();
  }

  void selectedProduct(int index) async {
    if (index != -1) {
      final order = orderDetail.value.orderDetails![index];

      if (order.isChecked) return;

      // mediaFileList.clear();

      bool result = false;

      if (!order.isChecked) {
        result =
            await openInputFieldDialog(
              index: index,
              itemName: order.item,
              qty: order.qty,
              detailController: this,
              barcodeValue: order.barcode,
            ) ??
            false;
      }

      final updatedOrder = order.copyWith(isChecked: result);

      final updateList = List<ItemOrderModel>.from(
        orderDetail.value.orderDetails!,
      );
      updateList[index] = updatedOrder;

      orderDetail.value = orderDetail.value.copyWith(orderDetails: updateList);
    } else {
      if (orderDetail.value.orderDetails == null || Get.isDialogOpen == true) {
        return;
      }

      await openInputListProductDialog(
        controller: this,
        orderDetails: orderDetail.value.orderDetails!,
      );
    }
  }

  void startingPO() async {
    if (isLoading.value) return;

    isLoading.value = true;

    final result = await detailOrderUseCase.callTakeItTransaction(
      ParamsTakeIt(
        role: AppRole.current!.name.toLowerCase(),
        statusChecker2: statusChecker2.value,
        invoice: noInvoice.value,
      ),
    );

    try {
      switch (result) {
        case Success(:final data):
          if (data.status && data.message.isEmpty) {
            GetStorage().write('noInvoice', noInvoice.value);
            if (AppRole.isChecker2) {
              GetStorage().write('status_checker2', statusChecker2.value);
            }

            isSelect.value = !isSelect.value;
            statusPO.value = 'ongoing';
            dialogService.showSuccessSnackbar('Berhasil Memulai PO');
          } else {
            if (Get.isDialogOpen == true) Get.back();
            isLoading.value = false;
            List<String> daftarKata = data.message.split('.');
            bool lockPO = false;

            if (daftarKata.isNotEmpty && daftarKata.contains('LockPO')) {
              lockPO = true;
            }

            dialogService.showError(
              'Failed',
              data.message.replaceAll('LockPO', ''),
              singleButton: !lockPO,
              onPressed2: () => ContactService.onTapHubungiAdmin(),
            );
          }
        // debugPrint('Data Take It Order: ${data.length}');
        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          isLoading.value = false;

          dialogService.showError('Failed', message);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', 'Error Get Data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> takeItTransactionDriver() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      debugPrint('No Invoice: ${noInvoice.value}');
      final result = await detailOrderUseCase.callTakeItTransactionDriver(
        ParamsAddAssistant(invoice: noInvoice.value),
      );

      switch (result) {
        case Success(:final data):
          if (data.status) {
            isSelect.value = !isSelect.value;
            statusDriver.value = 'ongoing';
            dialogService.showSuccessSnackbar('Berhasil Mengambil Transaksi');
          } else {
            if (Get.isDialogOpen == true) Get.back();
            dialogService.showError('Failed', data.message);
          }

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          // loadState.value = LoadState.error;
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      debugPrint('Error Mengambil Transaksi: $e');
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', '$e');
    } finally {
      isLoading.value = false;
    }
  }

  //////// ====== COPY PHONE NUMBER ====== ////////

  Future<void> copyToClipboard({required String phone}) async {
    await Clipboard.setData(ClipboardData(text: phone));

    if (Get.isDialogOpen == true) Get.back();
    dialogService.showSuccessSnackbar('Berhasil Menyalin Nomor Telepon');
  }

  //////// ====== LAUNCH MAPS ====== ////////

  void onTapMaps() async {
    final customer = orderDetail.value.customer;

    final latitude = customer.latitude;
    final longitude = customer.longitude;
    final address = customer.address;
    final dropAddress = customer.dropAddress;

    MapsUtils.openMaps(
      latitude: latitude,
      longitude: longitude,
      address: address,
      dropAddress: dropAddress,
      dialogService: dialogService,
    );
  }

  void onBack() {
    if (takeItOrder.value) {
      Get.back();
      // Get.offAllNamed(Routes.HOME);
      return;
    }

    if (AppRole.isDriver && isTakeToTheRoad.value) {
      dialogService.showConfirmation(
        title: 'Batalkan Keberangkatan',
        confirmText: 'Ya',
        cancelText: 'Tidak',
        description: 'Apakah anda ingin membatalkan keberangkatan sekarang?',
        onConfirm: () {
          GetStorage().remove('isTakeToTheRoad');
          GetStorage().remove('noInvoice');

          if (AppRole.isDriver && routeFrom.value == 'home') {
            final rit = GetStorage().read('city') ?? '';
            final colorRit = GetStorage().read('colorRit') ?? '';
            final dateRit = GetStorage().read('tanggalRit') ?? '';
            final isRitToday = GetStorage().read('isRitToday') ?? false;

            Get.offAllNamed(
              Routes.RIT_INFORMATION,
              arguments: {
                'city': rit.value,
                'colorRit': colorRit.value,
                'tanggalRit': dateRit.value,
                'routeFrom': 'endingOrder',
                'isRitToday': isRitToday.value,
              },
            );
            return;
          }

          Get.back();
          Get.back();
        },
      );
      return;
    }
    Get.back();
  }
}
