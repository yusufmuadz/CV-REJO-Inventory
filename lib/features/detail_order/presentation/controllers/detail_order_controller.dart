import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
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

  final isSelect = false.obs;
  final isTakeIt = false.obs;
  final isTakeToTheRoad = false.obs;

  final messageProduct = ''.obs;
  final statusPostProduct = false.obs;

  final isChecked = false.obs;

  final reasonController = TextEditingController();

  final picker = ImagePicker();
  final mediaFileList = <XFile>[].obs;

  final driverSelected = ''.obs;
  final assistantSelected = ''.obs;
  final selectTransportation = ''.obs;
  final nopolTransportation = ''.obs;

  final orderDetail = DetailOrderEntity(
    invoice: '',
    orderNo: '',
    suratJalan: '',
    courier: Courier(service: '', waybillNumber: ''),
    customer: CustomerModel(
      username: '',
      name: '',
      district: '',
      latitude: '',
      longitude: '',
    ),
    date: DateModel(transaction: '', delivery: ''),
  ).obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      noInvoice.value = args['invoice'] ?? '';
      routeFrom.value = args['routeFrom'] ?? '';
      takeItOrder.value = args['take_it_order'] ?? false;
      statusChecker2.value = args['status_checker2'] ?? '';
      statusLoader.value = args['status_loader'] ?? '';
      statusDriver.value = args['status_driver'] ?? '';
      statusPO.value = args['status_po'] ?? '';
      // statusDriver.value = 'completed';

      if (AppRole.isDriver && statusDriver.value == 'ongoing') {
        isSelect.value = true;
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

  void selectedProduct(int index) async {
    if (index != -1) {
      final order = orderDetail.value.orderDetails![index];

      if (order.isChecked) return;

      mediaFileList.clear();

      bool result = false;

      if (!order.isChecked) {
        result =
            await openInputFieldDialog(
              itemName: order.item,
              qty: order.qty,
              controller: this,
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
      if (orderDetail.value.orderDetails == null) return;

      final result =
          await openInputListProductDialog(
            itemName: '',
            qty: '',
            controller: this,
            barcodeValue: '',
          ) ??
          false;

      // for (var element in orderDetail.value.orderDetails!) {
      //   element.isChecked = result;
      // }
    }
  }

  Future<void> _getDetailOrder() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      // final result = await detailOrderUseCase.call('01SL20260600005');
      final result = await detailOrderUseCase.call(noInvoice.value);

      switch (result) {
        case Success(:final data):
          debugPrint('Data Detail Order: $data');
          orderDetail.value = data;

          driverSelected.value = data.assistant?.namaDriver ?? '';
          assistantSelected.value = data.assistant?.namaKenek ?? '';
          selectTransportation.value = data.assistant?.namaKendaraan ?? '';

          if (!AppRole.isDriver) {
            bool check =
                data.assistant!.namaDriver != '-' &&
                data.assistant!.namaDriver != '-' &&
                data.assistant!.namaKendaraan != '-';

            if (AppRole.isChecker2) {
              check =
                  data.driver!.namaDriver != '-' &&
                  data.driver!.namaDriver != '-' &&
                  data.driver!.namaKendaraan != '-';
              driverSelected.value = data.driver?.namaDriver ?? '';
              assistantSelected.value = data.driver?.namaKenek ?? '';
              selectTransportation.value = data.driver?.namaKendaraan ?? '';
              nopolTransportation.value = data.driver?.idKendaraan ?? '';
            }

            // debugPrint('Check Assistant: $check');
            // debugPrint('Check Driver: ${data.assistant?.namaDriver}');
            // debugPrint('Check Nama Kenek: ${data.assistant?.namaKenek}');
            // debugPrint('Check Nama Kendaraan: ${data.assistant?.namaKendaraan}');

            isSelect.value = check;
          }

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          // loadState.value = LoadState.error;
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', '$e');
    } finally {
      isLoading.value = false;
    }
  }

  void startingPO() async {
    if (isLoading.value) return;

    // if (pageIndex.value == 0 && isSelected.value.isEmpty) {
    //   dialogService.showError('Error', 'Pilih RIT terlebih dahulu');
    //   return;
    // }

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
              onPressed2: () => onTapHubungiAdmin(),
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

  Future<void> addProduct({
    required String barcode,
    required String quantity,
  }) async {
    if (isLoadingProduct.value) return;

    if (mediaFileList.isEmpty) {
      return;
    }

    isLoadingProduct.value = true;

    try {
      final result = await detailOrderUseCase.callPostItem(
        ParamsPostProduct(
          role: AppRole.current!.name.toLowerCase(),
          barcode: barcode,
          invoice: noInvoice.value,
          qty: quantity,
          statusChecker2: statusChecker2.value,
          images: mediaFileList,
        ),
      );

      switch (result) {
        case Success(:final data):
          debugPrint('Data Item Product: $data');
          // messageProduct.value = 'Berhasil Menambahkan Produk';
          // statusPostProduct.value = true;
          Get.back(result: true); // Tutup dialog
          dialogService.showSuccessSnackbar('Berhasil Menambahkan Produk');

        case ErrorResult(:final message):
          // loadState.value = LoadState.error;
          messageProduct.value = message;
          statusPostProduct.value = false;
      }
    } finally {
      isLoadingProduct.value = false;
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
    final latitude = orderDetail.value.customer.latitude;
    final longitude = orderDetail.value.customer.longitude;

    if (latitude.isNotEmpty && longitude.isNotEmpty) {
      dialogService.showErrorSnackbar(title: 'Gagal!', 'Koordinat Kosong');
      return;
    }
    final url = ApiEndpoints.maps(latitude.toString(), longitude.toString());

    await canLaunchUrlString(url)
        ? launchUrlString(url)
        : debugPrint("Can't open Terms and Conditions");
  }

  //////// ====== LAUNCH WHATSAPP ====== ////////

  void onTapHubungiAdmin() async {
    await canLaunchUrl(Uri.parse(ApiEndpoints.hubungiAdmin))
        ? launchUrl(
            Uri.parse(ApiEndpoints.hubungiAdmin),
            mode: LaunchMode.externalApplication,
          )
        : debugPrint("Can't open WhatsApp");
  }

  //////// ====== PICK IMAGE ====== ////////

  void selectImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(
        source: source, // Atau ImageSource.gallery untuk galeri
        maxWidth: 1080, // Batasi lebar maksimal Full HD
        maxHeight: 1920, // Batasi tinggi maksimal Full HD
        imageQuality: 70,
      );

      if (pickedFile != null) {
        mediaFileList.add(pickedFile);
        update(); // Memperbarui state untuk menampilkan gambar yang dipilih
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < mediaFileList.length) {
      mediaFileList.removeAt(index);
      update(); // Memperbarui state setelah gambar dihapus
    }
  }

  void clearAllImages() {
    mediaFileList.clear();
    update(); // Memperbarui state setelah semua gambar dan teks dihapus
  }
}
