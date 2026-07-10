import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:camera/camera.dart';

import '../../../../core/services/location_service.dart';
import '../../../../routes/app_pages.dart';
import '../../../../shared/images/camera_screen.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../../utils/loading_custom.dart';
import '../../../detail_order/data/models/item_order_model.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../../../list_order/domain/entities/rit_list_entity.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../../../list_order/presentation/bindings/list_order_binding.dart';
import '../../../list_order/presentation/controllers/list_order_controller.dart';
import '../../domain/params/post_rit_param.dart';
import '../../domain/params/trouble_rit_param.dart';
import '../../domain/usecases/rit_usecase.dart';
import 'enums/enum_rit.dart';
import 'enums/enum_trouble.dart';

class RitController extends GetxController {
  final RitUseCase ritUseCase;

  RitController({required this.ritUseCase});

  final isLoading = false.obs;
  final isLoadingReason = false.obs;
  final loadState = LoadState.initial.obs;
  final dialogService = Get.find<DialogService>();
  final locationService = LocationService();
  final noInvoice = ''.obs;
  final routeFrom = ''.obs;
  final isFirstOpen = true.obs;

  final currentPage = 1.obs;
  final orders = <OrderEntity>[].obs;
  final isDistrictSelected = ''
      .obs; // DIUBAH JADI RIT DULU NANTI JIKA ADA PERUBAHAN DISINI BUAT JADI KOTA LAGI
  final colorRit = ''.obs;
  final tanggalRit = ''.obs;
  final isRitToday = false.obs;
  final isAcceptRIT = false.obs;

  final buttonRIT = EnumButtonRIT.acceptRIT.obs;
  // final changeSequencePO = ButtonSequenceState.selectChange.obs;

  final isTakeOff = false.obs;
  final isAccept = false.obs;
  final isSave = false.obs;
  final isArriveInput = false.obs;
  final isArrive = false.obs;

  final kmController = TextEditingController();
  final reasonController = TextEditingController();

  final mediaFileList = <XFile>[].obs;
  final mediaFileListKM = <XFile>[].obs;
  final mediaFileListTangki = <XFile>[].obs;
  final mediaFileListSJ = <XFile>[].obs;
  final mediaFileListInvoice = <XFile>[].obs;
  final mediaFileListTransportMoney = <XFile>[].obs;
  final mediaFileReason = <XFile>[].obs;

  final mediaFileFrontTransport = Rx<XFile>(XFile(''));
  final mediaFileBackTransport = Rx<XFile>(XFile(''));
  final mediaFileRightTransport = Rx<XFile>(XFile(''));
  final mediaFileLeftTransport = Rx<XFile>(XFile(''));

  final mediaFileListRetur = <XFile>[].obs;
  final mediaFileListAddRetur = <XFile>[].obs;

  final mediaFileRecipientInvoice = <XFile>[].obs;
  final mediaFileRecipientMoney = <XFile>[].obs;
  final mediaFileRecipientMoneyRit = <XFile>[].obs;

  final selectedPoRetur = ''.obs;
  final selectedInfoRetur = 'Terkait'.obs;
  final infoReturList = ['Terkait', 'Tidak Terkait'].obs;

  final selectedAllItem = false.obs;
  final itemPO = <ItemOrderModel>[].obs;
  final itemPoAddRetur = <ItemOrderModel>[].obs;

  final recipientName = TextEditingController();

  final pageIndex = 0.obs;
  late PageController pageController;

  late final ListOrderController listOrderController;

  // late ScrollController scrollController;

  @override
  void onReady() {
    super.onReady();
    pageController = PageController(initialPage: pageIndex.value);
    final args = Get.arguments;
    if (args != null) {
      noInvoice.value = args['invoice'] ?? '';
      isDistrictSelected.value = args['city'] ?? '';
      colorRit.value = args['colorRit'] ?? '';
      tanggalRit.value = args['tanggalRit'] ?? '';
      routeFrom.value = args['routeFrom'] ?? '';
      isRitToday.value = args['isRitToday'] ?? false;
    }

    // final isAccepted = GetStorage().read('isAcceptRIT') ?? false;

    // if (isAccepted) {
    //   buttonRIT.value = EnumButtonRIT.buttonTakeOff;
    // } else {
    final getButtonRIT = GetStorage().read('buttonRIT');

    buttonRIT.value = getButtonRIT ?? EnumButtonRIT.acceptRIT;
    // }

    _getOrder();
  }

  @override
  void onClose() {
    pageController.dispose();
    isLoading.value = false;
    isLoadingReason.value = false;
    loadState.value = LoadState.idle;

    // registerScroll();
    debugPrint('On Close');
    super.onClose();
  }

  void onRefreshTransaction() {
    _getOrder(isRefresh: true);
  }

  void retryFetch() => _getOrder(isRefresh: loadState.value == LoadState.error);

  Future<void> acceptRit() async {
    GetStorage().write('city', isDistrictSelected.value);
    GetStorage().write('colorRit', colorRit.value);
    GetStorage().write('tanggalRit', tanggalRit.value);
    GetStorage().write('isRitToday', isRitToday.value);
    isAcceptRIT.value = true;

    buttonRIT.value = EnumButtonRIT.buttonTakeOff;

    GetStorage().write('buttonRIT', buttonRIT.value);
    // buttonRIT.value = EnumButtonRIT.buttonChangePO;
    // isAccept.value = !isAccept.value;
  }

  void selectAll() {
    selectedAllItem.value = !selectedAllItem.value;

    for (var i = 0; i < itemPO.length; i++) {
      itemPO[i] = itemPO[i].copyWith(isChecked: selectedAllItem.value);
    }
  }

  void selectedItem(int index) async {
    if (index != -1) {
      final order = itemPO[index];

      bool result = !order.isChecked;

      final updatedOrder = order.copyWith(isChecked: result);

      final updateList = List<ItemOrderModel>.from(itemPO);
      updateList[index] = updatedOrder;

      itemPO.value = updateList;
      selectedAllItem.value = itemPO.every((e) => e.isChecked);
    }
  }

  Future<void> saveOrder() async {
    if (isLoading.value) return;

    if (_checkEmptyInputDriver()) {
      dialogService.showErrorSnackbar(
        title: 'Gagal!',
        'Silakan lengkapi data terlebih dahulu!',
      );
      return;
    }

    isLoading.value = true;

    try {
      final result = await ritUseCase.call(
        ParamsRit(
          rit: isDistrictSelected.value,
          km: kmController.text,
          kmImage: mediaFileListKM[0],
          tankTruckImage: mediaFileListTangki[0],
          frontTruckImage: mediaFileRightTransport.value,
          rightTruckImage: mediaFileRightTransport.value,
          backTruckImage: mediaFileBackTransport.value,
          leftTruckImage: mediaFileLeftTransport.value,
          // overAllTruckImage: mediaFileList[0],
          travelDocImage: mediaFileListSJ[0],
          pocketImage: mediaFileListTransportMoney[0],
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
              mediaFileList.clear();
              mediaFileListKM.clear();
              mediaFileListTangki.clear();
              mediaFileListSJ.clear();
              mediaFileListTransportMoney.clear();
              mediaFileFrontTransport.value = XFile('');
              mediaFileRightTransport.value = XFile('');
              mediaFileBackTransport.value = XFile('');
              mediaFileLeftTransport.value = XFile('');
              kmController.clear();

              buttonRIT.value = EnumButtonRIT.buttonArriveRIT;
              if (Get.isDialogOpen == true) Get.back();

              pageIndex.value = 0;
              pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              GetStorage().write('buttonRIT', buttonRIT.value);
            },
          );

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', '$e');
    } finally {
      isLoading.value = false;
    }
  }

  bool _checkEmptyInputDriver() {
    final isTranportation =
        mediaFileFrontTransport.value.path.isEmpty ||
        mediaFileRightTransport.value.path.isEmpty ||
        mediaFileBackTransport.value.path.isEmpty ||
        mediaFileLeftTransport.value.path.isEmpty;

    return isTranportation ||
        mediaFileListKM.isEmpty ||
        mediaFileListTangki.isEmpty ||
        mediaFileListSJ.isEmpty ||
        mediaFileListTransportMoney.isEmpty ||
        kmController.text.isEmpty;
  }

  Future<void> cancelRIT() async {
    if (isLoading.value) return;

    if (mediaFileReason.isEmpty) {
      dialogService.showErrorSnackbar(
        title: 'Gagal!',
        'Masukkan foto terlebih dahulu!',
      );
      return;
    }
    isLoading.value = true;

    try {
      final position = await locationService.getLatestLocationLightweight();

      final lat = position.latitude.toString();
      final long = position.longitude.toString();

      final result = await ritUseCase.postCancelRIT(
        ParamsTroubleRIT(
          noRIT: isDistrictSelected.value,
          tanggalRIT: tanggalRit.value,
          troubleRIT: EnumTroubleRIT.tolak,
          lat: lat,
          long: long,
          desc: reasonController.text,
          images: mediaFileReason,
        ),
      );

      switch (result) {
        case Success(:final data):
          debugPrint('Data Item Product: $data');
          if (Get.isDialogOpen == true) Get.back();
          buttonRIT.value = EnumButtonRIT.cancelRIT;
          dialogService.showSuccessSnackbar('Berhasil Menolak RIT');

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', '$e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _getOrder({bool isRefresh = false}) async {
    try {
      loadState.value = (isRefresh || currentPage.value == 1)
          ? LoadState.initial
          : LoadState.loadingMore;

      if (isRefresh) {
        orders.clear();
        currentPage.value = 1;
      }

      final result = await ritUseCase.callGetOrders(
        ParamsGetTransaction(
          limit: '10',
          page: '$currentPage',
          filter: 'all',
          // sort: sortByNew.value ? 'newest' : 'oldest',
          district: isDistrictSelected.value,
          dateRit: tanggalRit.value,
        ),
      );

      switch (result) {
        case Success(:final data):
          debugPrint('Data Order: ${data.length}');
          if (data.isEmpty) {
            if (isRefresh && currentPage.value == 1) {
              loadState.value = LoadState.idle;
            } else {
              loadState.value = LoadState.noMore;
            }
            return;
          }
          orders.addAll(data);
          loadState.value = LoadState.idle;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          loadState.value = LoadState.error;
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      loadState.value = LoadState.error;
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', 'Error Get Data');
    } finally {
      // loadState.value = LoadState.idle;
      // isLoading.value = false;
    }
  }

  void changeRit(RitListEntity item) {
    isDistrictSelected.value = item.city;
    colorRit.value = item.color;
    tanggalRit.value = item.tanggalRit;

    GetStorage().write('city', item.city);
    GetStorage().write('colorRit', item.color);
    GetStorage().write('tanggalRit', item.tanggalRit);

    _getOrder(isRefresh: true);

    Get.back();
  }

  void registerListController() {
    if (!Get.isRegistered<ListOrderController>()) {
      ListOrderBinding().dependencies();
      listOrderController = Get.find<ListOrderController>();
      debugPrint('Register List Order Controller');
    } else {
      listOrderController = Get.find<ListOrderController>();
      debugPrint('Get List Order Controller');
    }
  }

  void reorderOrders(int oldIndex, int newIndex) {
    // 1. Sesuaikan index (quirk bawaan Flutter)
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    // 2. Pindahkan item di dalam list
    final item = orders.removeAt(oldIndex);
    orders.insert(newIndex, item);

    // 3. (Opsional) Jika Anda menggunakan GetBuilder, Anda bisa memanggil update()
    // TAPI baca "Catatan Penting" di bawah agar animasi tidak rusak!
    // update(['orders']);

    // 4. (Opsional) Panggil API untuk menyimpan urutan baru ke server
    // _saveNewOrderToServer();
  }

  bool emptyPath(XFile file) {
    if (file.path.isNotEmpty && mediaFileList.contains(file) == false) {
      return true;
    }
    return false;
  }

  void saveImageTransportation() async {
    try {
      if (mediaFileFrontTransport.value.path.isEmpty ||
          mediaFileBackTransport.value.path.isEmpty ||
          mediaFileLeftTransport.value.path.isEmpty ||
          mediaFileRightTransport.value.path.isEmpty) {
        dialogService.showErrorSnackbar(title: 'Gagal!', 'Masukkan semua foto');
        return;
      }
      // isLoading.value = true;
      if (emptyPath(mediaFileFrontTransport.value)) {
        mediaFileList.add(mediaFileFrontTransport.value);
      }

      if (emptyPath(mediaFileBackTransport.value)) {
        mediaFileList.add(mediaFileBackTransport.value);
      }

      if (emptyPath(mediaFileLeftTransport.value)) {
        mediaFileList.add(mediaFileLeftTransport.value);
      }

      if (emptyPath(mediaFileRightTransport.value)) {
        mediaFileList.add(mediaFileRightTransport.value);
      }

      Get.back();
      dialogService.showSuccessSnackbar('Berhasil Menyimpan Foto');
    } catch (e) {
      debugPrint('$e');
    }
  }

  void removeImage(
    int index,
    Rx<XFile>? file,
    RxList<XFile> files,
    bool isTransportation,
  ) {
    if (file != null) {
      files.remove(file.value);
      file.value = XFile('');
      update();
      return;
    }

    if (index >= 0 && index < files.length) {
      files.removeAt(index);

      if (isTransportation) {
        if (emptyPath(mediaFileFrontTransport.value)) {
          mediaFileFrontTransport.value = XFile('');
        }

        if (emptyPath(mediaFileBackTransport.value)) {
          mediaFileBackTransport.value = XFile('');
        }

        if (emptyPath(mediaFileLeftTransport.value)) {
          mediaFileLeftTransport.value = XFile('');
        }

        if (emptyPath(mediaFileRightTransport.value)) {
          mediaFileRightTransport.value = XFile('');
        }
      }
      update(); // Memperbarui state setelah gambar dihapus
    }
  }

  void clearAllImages(files, isTransportation) {
    if (isTransportation) {
      mediaFileFrontTransport.value = XFile('');
      mediaFileBackTransport.value = XFile('');
      mediaFileLeftTransport.value = XFile('');
      mediaFileRightTransport.value = XFile('');
    }
    files.clear();
    update(); // Memperbarui state setelah semua gambar dan teks dihapus
  }

  void addSampleItem() {
    itemPO.add(
      ItemOrderModel(
        item: 'Item Testing ${itemPO.length + 1}',
        qty: '1',
        barcode: '',
        pic: StatusItem(),
        checker1: StatusItem(),
        checker2: StatusOrder(),
        driver: StatusOrder(),
        statusFinishScan: false,
        statusArrive: false,
        statusUnload: false,
        statusConfirmDelivery: false,
        isChecked: false,
      ),
    );
  }

  void onWidgetScroll(ScrollController activeController) {
    if (!activeController.hasClients) return;

    final currentPixels = activeController.position.pixels;
    final maxScroll = activeController.position.maxScrollExtent;

    // DEBUG: Pantau angka ini di console saat Anda melakukan scroll
    // debugPrint('Pixels: $currentPixels / Max: $maxScroll');

    final canLoad = loadState.value == LoadState.idle;

    // Jika canLoad bernilai false, pagination tidak akan berjalan.
    // Pastikan setelah _getOrder() selesai, loadState.value dikembalikan ke LoadState.idle
    if (canLoad && currentPixels >= maxScroll - 200) {
      debugPrint('=== MEMANGGIL HALAMAN BERIKUTNYA ===');
      currentPage.value++;
      _getOrder();
    }
  }
}
