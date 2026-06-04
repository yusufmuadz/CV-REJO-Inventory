import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../list_order/data/models/courier_model.dart';
import '../../../list_order/data/models/date_model.dart';
import '../../../login/domain/entities/user_entity.dart';
import '../../../scan_product/domain/params/post_product_param.dart';
import '../../data/models/customer_model.dart';
import '../../data/models/item_order_model.dart';
import '../../domain/entities/detail_order_entity.dart';
import '../../domain/entities/transportation_entity.dart';
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

  final statusChecker2 = ''.obs;
  final statusLoader = ''.obs;
  final statusDriver = ''.obs;

  final isSelect = false.obs;
  final isTakeIt = false.obs;
  final isTakeToTheRoad = false.obs;

  final messageProduct = ''.obs;
  final statusPostProduct = false.obs;

  final driverSelected = ''.obs;
  final assistantSelected = ''.obs;
  final selectTransportation = ''.obs;
  final statusTransportationSelected = 'Internal'.obs;
  final nopolTransportation = ''.obs;

  final isChecked = false.obs;

  final reasonController = TextEditingController();

  final listUser = <UserEntity>[].obs;
  final transportations = <TransportationEntity>[].obs;
  final statusTransportations = ['Internal', 'External'].obs;

  final picker = ImagePicker();
  final mediaFileList = <XFile>[].obs;

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
      // statusDriver.value = 'completed';

      if (AppRole.isDriver && statusDriver.value == 'ongoing') {
        isSelect.value = true;
      }
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

  void onRefreshAssistant() {
    getAssisten();
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
      dialogService.showError('Failed', 'Error Get Data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAssisten() async {
    if (isLoadingAssistant.value) return;
    isLoadingAssistant.value = true;

    try {
      final result = await Future.wait([
        detailOrderUseCase.callUsers(),
        if (!AppRole.isChecker2) detailOrderUseCase.callTransportations(),
        if (AppRole.isChecker2) detailOrderUseCase.callLoaderTransportations(),
      ]);

      final usersResult = result[0];
      final transportationsResult = result[1];

      switch (usersResult) {
        case Success(:final data):
          debugPrint('Data Detail Order Users: $data');
          listUser.value = data as List<UserEntity>;
          driverSelected.value = data.first.nama;
          assistantSelected.value = data.first.nama;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          // loadState.value = LoadState.error;
          dialogService.showError('Failed', message);
      }

      switch (transportationsResult) {
        case Success(:final data):
          debugPrint('Data Detail Order Transportations: $data');
          transportations.value = data as List<TransportationEntity>;

          if (data.first.namaKendaraan != null &&
              data.first.namaKendaraan != '-') {
            selectTransportation.value = data.first.namaKendaraan!;
          } else if (data.first.jenisKendaraan != null &&
              data.first.jenisKendaraan != '-') {
            selectTransportation.value = data.first.jenisKendaraan!;
          }

          nopolTransportation.value = data.first.idDeliveryMobil ?? '-';

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          // loadState.value = LoadState.error;
          dialogService.showError('Failed', message);
      }
    } finally {
      isLoadingAssistant.value = false;
    }
  }

  Future<void> addAssistant() async {
    if (isLoading.value) return;
    isLoading.value = true;

    debugPrint('Driver: ${driverSelected.value}');
    debugPrint('Asisten: ${assistantSelected.value}');
    debugPrint('Kendaraan: ${selectTransportation.value}');
    debugPrint('Nopol: ${nopolTransportation.value}');

    // debugPrint('Kendaraan: ${loader}');
    // debugPrint('Driver: ${driver}');
    // debugPrint('Asisten: ${kenek}');

    try {
      final loader = transportations.firstWhereOrNull(
        (element) => element.namaKendaraan == selectTransportation.value,
      );
      final driver = listUser.firstWhereOrNull(
        (element) => element.nama == driverSelected.value,
      );
      final kenek = listUser.firstWhereOrNull(
        (element) => element.nama == assistantSelected.value,
      );

      final result = await detailOrderUseCase.callPostAssistant(
        ParamsAddAssistant(
          invoice: noInvoice.value,
          idKendaraan: AppRole.isChecker2
              ? nopolTransportation.value
              : loader!.id,
          idDriver: driver!.userId,
          idKenek: kenek!.userId,
        ),
      );

      switch (result) {
        case Success(:final data):
          if (data.status) {
            isSelect.value = !isSelect.value;
            dialogService.showSuccessSnackbar('Berhasil Menambahkan Asisten');
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
      debugPrint('Error Add Assistant: $e');
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', '$e');
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
      final result = await detailOrderUseCase.callTakeItTransactionDriver(
        ParamsAddAssistant(invoice: noInvoice.value),
      );

      switch (result) {
        case Success(:final data):
          if (data.status) {
            isSelect.value = !isSelect.value;
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

  //////// ====== PICK IMAGE ====== ////////

  void selectImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(
        source: source, // Atau ImageSource.gallery untuk galeri
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
