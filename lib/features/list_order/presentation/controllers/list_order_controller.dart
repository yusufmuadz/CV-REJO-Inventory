import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/loading_custom.dart';
import '../../../detail_order/domain/entities/transportation_entity.dart';
import '../../../detail_order/domain/params/add_assistant_param.dart';
import '../../../detail_order/presentation/widgets/dialog/assistant_dialog.dart';
import '../../../login/domain/entities/user_entity.dart';
import '../../domain/entities/district_entity.dart';
import '../../domain/entities/list_order_entity.dart';
import '../../domain/entities/rit_list_entity.dart';
import '../../domain/usecases/list_order_usecase.dart';
import 'get_data_list_controller.dart';

class ListOrderController extends GetxController {
  final ListOrderUseCase listOrderUseCase;

  ListOrderController({required this.listOrderUseCase});

  final isLoading = false.obs;
  final isLoadingSort = false.obs;
  final isLoadingAssistant = false.obs;
  final isLoadingReason = false.obs;
  final isRouteFrom = ''.obs;
  final dialogService = Get.find<DialogService>();

  final orders = <OrderEntity>[].obs;
  final currentPage = 1.obs;
  final pageIndex = 0.obs;
  final hasmore = true.obs;
  final searchController = TextEditingController();
  final pageController = PageController(initialPage: 0);

  final isSelection = false.obs;
  final isSelected = ''.obs;
  final isStatusSelected = 'All'.obs;
  final isDistrictSelected = ''
      .obs; // DIUBAH JADI RIT DULU NANTI JIKA ADA PERUBAHAN DISINI BUAT JADI KOTA LAGI
  final listSelected = <dynamic>[].obs;

  final isRitToday = false.obs;
  final pastRitDateSelected = DateTime.now().toString().obs;

  final listDistrict = <DistrictEntity>[].obs;
  final listRit = <RitListEntity>[].obs;

  final colorRit = ''.obs;
  final tanggalRit = ''.obs;
  final totalPendingPoRITCheck2 = '0'.obs;

  final reasonPendingRITController = TextEditingController();
  final mediaFileReasonPendingRIT = <XFile>[].obs;

  final sortByNew = true.obs;

  final loadState = LoadState.initial.obs;

  final driverSelected = ''.obs;
  final assistantSelected = ''.obs;
  final selectTransportation = ''.obs;
  final statusTransportationSelected = 'Internal'.obs;
  final nopolTransportation = ''.obs;

  final listUser = <UserEntity>[].obs;
  final transportations = <TransportationEntity>[].obs;
  final statusTransportations = ['Internal', 'External'].obs;

  final status = [
    {'id': '0', 'name': 'All', 'isSelected': true},
    {'id': '1', 'name': 'Available', 'isSelected': false},
    {'id': '2', 'name': 'Ongoing', 'isSelected': false},
  ].obs;

  late final GetDataListController getDataListController;

  @override
  void onInit() {
    super.onInit();
    getDataListController = Get.find<GetDataListController>();

    final args = Get.arguments;
    if (args != null) {
      isRouteFrom.value = args['routeFrom'] ?? '';
      isDistrictSelected.value = args['city'] ?? '';
      colorRit.value = args['colorRit'] ?? '';
      tanggalRit.value = args['tanggalRit'] ?? '';
      isRitToday.value = args['isRitToday'] ?? false;

      debugPrint('DATE RIT : ${tanggalRit.value}');

      if (isDistrictSelected.value.isNotEmpty) {
        pageIndex.value = 1;
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    if (pageIndex.value == 0) {
      debugPrint('List RIT');
      getDataListController.getRit();
    } else {
      debugPrint('List Order');
      getDataListController.getOrder();
    }
  }

  @override
  void onClose() {
    super.onClose();
    isLoading.value = false;
    loadState.value = LoadState.idle;
  }

  void onRefreshTransaction() {
    currentPage.value = 1;

    if (pageIndex.value == 0) {
      listRit.clear();
      getDataListController.getRit();
    } else {
      orders.clear();
      getDataListController.getOrder(isRefresh: true);
    }
  }

  void onRefreshAssistant() {
    getDataListController.getAssisten();
  }

  void retryFetch() => getDataListController.getOrder(isRefresh: loadState.value == LoadState.error);

  void onResetSort() {
    currentPage.value = 1;
    hasmore.value = true;
    orders.clear();
    sortByNew.value = true;
    isStatusSelected.value = '';
    isDistrictSelected.value = '';
    getDataListController.getOrder();
  }

  void onWidgetScroll(ScrollController activeController) {
    if (pageIndex.value == 0) return;
    if (!activeController.hasClients) return;

    final currentPixels = activeController.position.pixels;
    final maxScroll = activeController.position.maxScrollExtent;

    // Hanya trigger ambil data jika status sedang idle (tidak sedang loading)
    final canLoad = loadState.value == LoadState.idle;

    if (canLoad && currentPixels >= maxScroll - 200) {
      currentPage.value++;
      getDataListController.getOrder(); // Fungsi ambil data pagination Anda
    }
  }

  void onSelectedPO(String id) {
    final index = orders.indexWhere((order) => order.invoice == id);
    if (index != -1) {
      isSelected.value = id;
    }
  }

  void onSelectedRit(int index, {required String pendingPoRIT}) {
    if (!isSelection.value && !AppRole.isDriver) return;

    if (index != -1) {
      isSelected.value = listRit[index].city;
      colorRit.value = listRit[index].color;
      tanggalRit.value = listRit[index].tanggalRit;
      totalPendingPoRITCheck2.value = pendingPoRIT;
    }

    if (AppRole.isDriver) {
      takeItOrder();
      return;
    }
  }

  void cancelSelection() {
    isSelected.value = '';
    isSelection.value = !isSelection.value;
    colorRit.value = '';
    tanggalRit.value = '';
  }

  void takeItRIT({String rit = '', String clrRit = '', String tglRit = ''}) {
    pageIndex.value = 1;
    isSelection.value = false;
    isDistrictSelected.value = rit;
    colorRit.value = clrRit;
    tanggalRit.value = tglRit;

    if (AppRole.isDriver) {
      Get.toNamed(
        Routes.RIT_INFORMATION,
        arguments: {
          'invoice': '',
          'city': rit,
          'colorRit': clrRit,
          'tanggalRit': tglRit,
          'routeFrom': 'listOrder',
          'isRitToday': isRitToday.value,
        },
      );
    } else {
      GetStorage().write('city', rit);
      GetStorage().write('colorRit', clrRit);
      GetStorage().write('tanggalRit', tglRit);
      GetStorage().write('isRitToday', isRitToday.value);
      searchController.text = '';
      sortByNew.value = true;
      isStatusSelected.value = 'All';
      isDistrictSelected.value = rit;
      tanggalRit.value = tglRit;
      orders.clear();
      getDataListController.getOrder();
    }
    isSelected.value = '';
    // listRit.clear();
  }

  void takeItOrder({
    String rit = '',
    String clrRit = '',
    String tglRit = '',
    String invoicePO = '',
  }) async {
    if (isLoading.value) return;

    if (pageIndex.value == 0 && isSelected.value.isEmpty) {
      dialogService.showError('Error', 'Pilih RIT terlebih dahulu');
      return;
    }

    if (pageIndex.value == 0) {
      if (AppRole.isPIC ||
          (AppRole.isChecker2 && totalPendingPoRITCheck2.value == '0')) {
        if (listUser.isEmpty) {
          getDataListController.getAssisten();
        }

        final resultAddAssistant = await AssistantDialog.inputAsisten(this);

        if (!resultAddAssistant) return;
      } else if (!AppRole.isDriver) {
        final resultTakRIT = await takeRIT();
        if (!resultTakRIT) return;
      }

      if (rit.isEmpty || clrRit.isEmpty || tglRit.isEmpty) {
        rit = isSelected.value;
        clrRit = colorRit.value;
        tglRit = tanggalRit.value;
      }

      takeItRIT(rit: rit, clrRit: clrRit, tglRit: tglRit);
      return;
    }
  }

  Future<bool> takeRIT({
    String rit = '',
    String clrRit = '',
    String tglRit = '',
    bool isRitDate = false,
  }) async {
    if (isLoading.value) return false;
    isLoading.value = true;

    try {
      final dateRIT = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.parse(tanggalRit.value));

      bool isCheck2 =
          AppRole.isChecker2 && totalPendingPoRITCheck2.value != '0';

      final result = await listOrderUseCase.callPostAssistant(
        ParamsAddAssistant(
          district: isSelected.value,
          dateRIT: dateRIT,
          isChecker2: isCheck2,
        ),
      );

      switch (result) {
        case Success(:final data):
          if (data.status) {
            // takeItOrder();
            // isSelect.value = !isSelect.value;
            debugPrint('Success Add Assistant: ${data.message}');
            return true;
          } else {
            if (Get.isDialogOpen == true) Get.back();
            dialogService.showError('Failed', data.message);
            return false;
          }

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          // loadState.value = LoadState.error;
          dialogService.showError('Failed', message);
          return false;
      }
    } catch (e) {
      debugPrint('Error Add Assistant: $e');
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', '$e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addAssistant() async {
    if (isLoadingAssistant.value) return false;
    isLoadingAssistant.value = true;

    debugPrint('Driver: ${driverSelected.value}');
    debugPrint('Asisten: ${assistantSelected.value}');
    debugPrint('Kendaraan: ${selectTransportation.value}');
    debugPrint('Nopol: ${nopolTransportation.value}');

    // debugPrint('Kendaraan: ${loader}');
    // debugPrint('Driver: ${driver}');
    // debugPrint('Asisten: ${kenek}');

    try {
      final loader = transportations.firstWhereOrNull((element) {
        bool result = false;
        String kendaraan = element.namaKendaraan ?? '';

        if (AppRole.isChecker2) {
          kendaraan = element.jenisKendaraan ?? '';
        }

        if (kendaraan == selectTransportation.value) {
          result = true;
        }
        return result;
      });
      final driver = listUser.firstWhereOrNull(
        (element) => element.nama == driverSelected.value,
      );
      final kenek = listUser.firstWhereOrNull(
        (element) => element.nama == assistantSelected.value,
      );

      debugPrint('ID Kendaraan: ${loader}');
      // debugPrint('ID Forklift: ${loader.id}');

      final idKendaraan = AppRole.isChecker2
          ? loader!.idDeliveryMobil
          : loader!.id;

      final dateRIT = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.parse(tanggalRit.value));

      final result = await listOrderUseCase.callPostAssistant(
        ParamsAddAssistant(
          district: isSelected.value,
          idKendaraan: idKendaraan,
          idDriver: driver!.userId,
          idKenek: kenek!.userId,
          dateRIT: dateRIT,
        ),
      );

      switch (result) {
        case Success(:final data):
          if (data.status) {
            // takeItOrder();
            // isSelect.value = !isSelect.value;
            debugPrint('Success Add Assistant: ${data.message}');
            return true;
          } else {
            if (Get.isDialogOpen == true) Get.back();
            dialogService.showError('Failed', data.message);
            return false;
          }

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          // loadState.value = LoadState.error;
          dialogService.showError('Failed', message);
          return false;
      }
    } catch (e) {
      debugPrint('Error Add Assistant: $e');
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', '$e');
      return false;
    } finally {
      isLoadingAssistant.value = false;
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

  void changeRIT() {
    if (listRit.isEmpty) {
      getDataListController.getRit();
    }
    pageIndex.value = 0;
  }
}
