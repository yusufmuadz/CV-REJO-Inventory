import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../detail_order/presentation/controllers/detail_order_controller.dart';
import '../../domain/entities/item_product_entity.dart';
import '../../domain/params/post_product_param.dart';
import '../../domain/params/scan_product_param.dart';
import '../../domain/usecases/scan_product_usecase.dart';
import '../widgets/dialog_scan_product/input_qty_dialog.dart';
import '../widgets/dialog_scan_product/permission_scan_dialog.dart';

class ScanProductController extends GetxController with WidgetsBindingObserver {
  final ScanProductUseCase scanProductUseCase;

  ScanProductController({required this.scanProductUseCase});

  final isLoading = false.obs;
  final isLoadingSearch = false.obs;
  final isLoadingProduct = false.obs;
  final dialogService = Get.find<DialogService>();
  final detailOrderController = Get.find<DetailOrderController>();
  final noInvoice = ''.obs;

  final isMaxFailureChecker = false.obs;

  final messageProduct = ''.obs;
  final statusPostProduct = false.obs;

  final searchResults = <ItemProductEntity>[].obs;
  final searchController = TextEditingController();

  final mediaFileList = <XFile>[].obs;
  final ImagePicker picker = ImagePicker();

  StreamSubscription<Object?>? _subscription;
  final isScanner = false.obs;
  final isLightOn = false.obs;
  final controllerScanner = MobileScannerController(
    autoStart: false,
    formats: const [
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
      BarcodeFormat.code128,
    ],
    // detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    // ✅ Optimasi resolusi untuk speed
    cameraResolution: const Size(1280, 720),
  );

  final isSelect = false.obs;

  void _handleBarcode(BarcodeCapture barcode) {
    final code = barcode.barcodes.firstOrNull?.rawValue;
    if (code == null) return;

    if (code.isNotEmpty) {
      stopScanner();

      getProduct(code);
    }
  }

  Future<void> getProduct(String barcode) async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final result = await scanProductUseCase.call(
        ParamsGetProduct(
          barcode: barcode,
          invoice: noInvoice.value,
          role: AppRole.current!.name.toLowerCase(),
        ),
      );

      switch (result) {
        case Success(:final data):
          debugPrint('Data Product: $data');
          // product.value = data;
          openInputQtyDialog(
            itemName: data.itemName,
            barcodeValue: barcode,
            controller: this,
          );

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          dialogService.showError(
            'Failed',
            message,
            onPressed: () {
              Get.back();
              startScanner();
            },
          );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getItemProduct() async {
    if ((isLoading.value || isLoadingSearch.value) &&
        searchController.text.isEmpty) {
      return;
    }

    isLoadingSearch.value = true;

    try {
      final result = await scanProductUseCase.callGetItem(
        searchController.text,
      );

      switch (result) {
        case Success(:final data):
          debugPrint('Data Item Product: $data');
          searchResults.value = data;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          dialogService.showError('Failed', message);
      }
    } finally {
      isLoadingSearch.value = false;
    }
  }

  Future<void> errorProductScanner() async {
    dialogService.showErrorSnackbar(
      title: 'Gagal!',
      'Gagal menambahkan produk, silahkan coba lagi',
    );
  }

  Future<void> addProduct({
    required String barcode,
    required String quantity,
  }) async {
    if (isLoadingProduct.value || mediaFileList.isEmpty) return;
    isLoadingProduct.value = true;

    try {
      final result = await scanProductUseCase.callPostItem(
        ParamsPostProduct(
          role: AppRole.current!.name.toLowerCase(),
          barcode: barcode,
          invoice: noInvoice.value,
          qty: quantity,
          images: mediaFileList,
        ),
      );

      switch (result) {
        case Success(:final data):
          debugPrint('Data Item Product: $data');
          messageProduct.value = 'Berhasil Menambahkan Produk';
          statusPostProduct.value = true;

        case ErrorResult(:final message, :final isMaxFailure):
          messageProduct.value = message;
          statusPostProduct.value = false;
          isMaxFailureChecker.value = isMaxFailure ?? false;
      }
    } finally {
      isLoadingProduct.value = false;
    }
  }

  void onTapHubungiAdmin() async {
    await canLaunchUrl(Uri.parse(ApiEndpoints.hubungiAdmin))
        ? launchUrl(
            Uri.parse(ApiEndpoints.hubungiAdmin),
            mode: LaunchMode.externalApplication,
          )
        : debugPrint("Can't open WhatsApp");
  }

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

  //////// ====== BARCODE SCANNER ====== ////////

  Future<void> _checkAndStartScanner() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      startScanner();
    } else if (status.isDenied || status.isRestricted) {
      // Minta izin sekali lagi
      final result = await Permission.camera.request();
      if (result.isGranted) {
        startScanner();
      } else {
        showPermissionScanDialog(
          isPermanentlyDenied: result.isPermanentlyDenied,
          onConfirm: () => confirmPermission,
        );
      }
    } else if (status.isPermanentlyDenied) {
      // Izin ditolak permanen → arahkan ke Settings
      // _showPermissionDialog(isPermanentlyDenied: true);
      showPermissionScanDialog(
        isPermanentlyDenied: true,
        onConfirm: () => confirmPermission,
      );
    }
  }

  void startScanner() {
    debugPrint('Start Scanner');
    debugPrint(
      'Scanner Permission: ${controllerScanner.value.hasCameraPermission}',
    );
    debugPrint('Bool Scanner: ${isScanner.value}');
    if (!isScanner.value || !controllerScanner.value.isRunning) {
      _subscription = controllerScanner.barcodes.listen(_handleBarcode);
      unawaited(controllerScanner.start());
      isScanner.value = true;
    }
  }

  void stopScanner() {
    if (isScanner.value || controllerScanner.value.isRunning) {
      unawaited(_subscription?.cancel());
      _subscription = null;
      unawaited(controllerScanner.stop());
      isScanner.value = false;
      debugPrint('Bool Scanner Stop: ${isScanner.value}');
    }
  }

  void toggleFlashLight() {
    // Cek apakah device mendukung senter
    if (controllerScanner.value.torchState == TorchState.unavailable) return;
    controllerScanner.toggleTorch();
    isLightOn.value = !isLightOn.value;
    debugPrint('Light Is: ${isLightOn.value}');
  }

  void confirmPermission({required bool isPermanentlyDenied}) {
    Get.back(); // Tutup dialog dulu
    if (isPermanentlyDenied) {
      openAppSettings(); // 🎯 Arahkan ke Settings app
    } else {
      _checkAndStartScanner(); // 🔄 Coba request lagi
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);
    _checkAndStartScanner();

    final args = Get.arguments;
    if (args != null) {
      noInvoice.value = args['invoice'] ?? '';
    }
  }

  @override
  void onClose() {
    stopScanner();
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    unawaited(controllerScanner.dispose());
    isLoading.value = false;
    if (controllerScanner.value.torchState == TorchState.on) {
      controllerScanner.toggleTorch();
    }
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controllerScanner.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        debugPrint('Error kenapa: $state');
        return;
      case AppLifecycleState.resumed:
        startScanner();
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controllerScanner.stop());
    }
  }
}
