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
import '../../domain/params/get_rit_param.dart';
import '../../domain/params/get_transaction_param.dart';
import '../../domain/params/take_it_param.dart';
import '../../domain/usecases/list_order_usecase.dart';

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
  final scrollController = ScrollController();
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

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      debugPrint('Route From: ${args['routeFrom']}');
      isRouteFrom.value = args['routeFrom'] ?? '';
      isDistrictSelected.value = args['city'] ?? '';
      colorRit.value = args['colorRit'] ?? '';
      tanggalRit.value = args['tanggalRit'] ?? '';
      isRitToday.value = args['isRitToday'] ?? false;
      final page = args['page'] ?? 0;

      // if (tanggalRit.isEmpty) {
      //   tanggalRit.value = DateTime.now().toString();
      // }

      debugPrint('DATE RIT : ${tanggalRit.value}');

      if (AppRole.isDriver) {
        pageIndex.value = page;
      } else {
        if (isDistrictSelected.value.isNotEmpty) {
          pageIndex.value = 1;
        }
      }
    }
    scrollController.addListener(_onScroll);
  }

  @override
  void onReady() {
    super.onReady();
    if (pageIndex.value == 0) {
      debugPrint('List RIT');
      getRit();
    } else {
      debugPrint('List Order');
      _getOrder();
    }
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
    isLoading.value = false;
    loadState.value = LoadState.idle;
  }

  void onRefreshTransaction() {
    currentPage.value = 1;

    if (pageIndex.value == 0) {
      listRit.clear();
      getRit();
    } else {
      orders.clear();
      _getOrder(isRefresh: true);
    }
  }

  void onRefreshAssistant() {
    getAssisten();
  }

  void retryFetch() => _getOrder(isRefresh: loadState.value == LoadState.error);

  void onResetSort() {
    currentPage.value = 1;
    hasmore.value = true;
    orders.clear();
    sortByNew.value = true;
    isStatusSelected.value = '';
    isDistrictSelected.value = '';
    _getOrder();
  }

  void _onScroll() {
    final canLoad = loadState.value == LoadState.idle;

    if (canLoad &&
        scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
      // Panggil fungsi untuk memuat lebih banyak data
      // if (hasmore.value && !isLoading.value) {
      currentPage.value++;
      _getOrder();
      // }
    }
  }

  void onSelected(String id) {
    final index = orders.indexWhere((order) => order.invoice == id);
    if (index != -1) {
      isSelected.value = id;
    }
  }

  void onSelectedRit(int index) {
    if (!isSelection.value && !AppRole.isDriver) return;

    if (index != -1) {
      isSelected.value = listRit[index].city;
      colorRit.value = listRit[index].color;
      tanggalRit.value = listRit[index].tanggalRit;
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
    GetStorage().write('city', rit);
    GetStorage().write('colorRit', clrRit);
    GetStorage().write('tanggalRit', tglRit);
    GetStorage().write('isRitToday', isRitToday.value);
    if (AppRole.isDriver) {
      Get.offNamed(
        Routes.RIT_INFORMATION,
        arguments: {
          'invoice': '',
          'city': rit,
          'colorRit': clrRit,
          'tanggalRit': tglRit,
          'routeFrom': 'listOrder',
        },
      );
      pageIndex.value = 0;
      isSelection.value = true;
      isDistrictSelected.value = '';
      colorRit.value = '';
      tanggalRit.value = '';
    } else {
      searchController.text = '';
      sortByNew.value = true;
      isStatusSelected.value = 'All';
      isDistrictSelected.value = rit;
      tanggalRit.value = tglRit;
      orders.clear();
      _getOrder();
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
      if (listUser.isEmpty) {
        getAssisten();
      }

      final resultAddAssistant = await AssistantDialog.inputAsisten(this);

      if (!resultAddAssistant) return;

      if (rit.isEmpty || clrRit.isEmpty || tglRit.isEmpty) {
        rit = isSelected.value;
        clrRit = colorRit.value;
        tglRit = tanggalRit.value;
      }

      takeItRIT(rit: rit, clrRit: clrRit, tglRit: tglRit);
      return;
    }

    // isLoading.value = true;

    // final index = orders.indexWhere((order) => order.invoice == invoicePO);

    // final result = await listOrderUseCase.callTakeItTransaction(
    //   ParamsTakeIt(
    //     role: AppRole.current!.name.toLowerCase(),
    //     statusChecker2: orders[index].checker2?.status ?? '',
    //     invoice: invoicePO,
    //   ),
    // );

    // try {
    //   switch (result) {
    //     case Success(:final data):
    //       if (data.status && data.message.isEmpty) {
    //         GetStorage().write('noInvoice', isSelected.value);
    //         if (AppRole.isChecker2) {
    //           GetStorage().write(
    //             'status_checker2',
    //             orders[index].checker2?.status ?? '',
    //           );
    //         }
    //         Get.offNamed(
    //           Routes.DETAIL_ORDER,
    //           arguments: {
    //             'invoice': invoicePO,
    //             'routeFrom': 'listOrder',
    //             'take_it_order': true,
    //             'status_checker2': orders[index].checker2?.status ?? '',
    //           },
    //         );
    //       } else {
    //         if (Get.isDialogOpen == true) Get.back();
    //         loadState.value = LoadState.error;
    //         isLoading.value = false;
    //         List<String> daftarKata = data.message.split('.');
    //         bool lockPO = false;

    //         if (daftarKata.isNotEmpty && daftarKata.contains('LockPO')) {
    //           lockPO = true;
    //         }

    //         dialogService.showError(
    //           'Failed',
    //           data.message.replaceAll('LockPO', ''),
    //           singleButton: !lockPO,
    //           onPressed2: () => onTapHubungiAdmin(),
    //         );
    //       }
    //     // debugPrint('Data Take It Order: ${data.length}');
    //     case ErrorResult(:final message):
    //       if (Get.isDialogOpen == true) Get.back();
    //       loadState.value = LoadState.error;
    //       isLoading.value = false;

    //       dialogService.showError('Failed', message);
    //   }
    // } catch (e) {
    //   if (Get.isDialogOpen == true) Get.back();
    //   dialogService.showError('Failed', 'Error Get Data');
    // } finally {
    //   isLoading.value = false;
    // }
  }

  Future<void> _getOrder({bool isRefresh = false}) async {
    try {
      loadState.value = (isRefresh || currentPage.value == 1)
          ? LoadState.initial
          : LoadState.loadingMore;

      if (isRefresh) {
        if (pageIndex.value == 0) {
          listRit.clear();
        } else {
          orders.clear();
        }

        currentPage.value = 1;
      }

      final result = await listOrderUseCase.call(
        ParamsGetTransaction(
          limit: '10',
          page: '$currentPage',
          q: searchController.text,
          sort: sortByNew.value ? 'newest' : 'oldest',
          filter: isStatusSelected.value.toLowerCase(),
          district: isDistrictSelected.value.toLowerCase(),
          dateRit: tanggalRit.value,
          pastRit: !isRitToday.value,
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
      isLoading.value = false;
    }
  }

  Future<void> getRit() async {
    if (isLoading.value) return;
    isLoading.value = true;

    final result = await listOrderUseCase.callGetRit(
      ParamGetRIT(
        isPastRit: !isRitToday.value,
        date: pastRitDateSelected.value,
      ),
    );

    try {
      switch (result) {
        case Success(:final data):
          listRit.value = data;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          loadState.value = LoadState.error;
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', 'Error Get Data');
    } finally {
      isLoading.value = false;
      loadState.value = LoadState.idle;
    }

    debugPrint('List RIT: ${isLoading.value}');
    debugPrint('List RIT: ${loadState.value}');
  }

  void onTapHubungiAdmin() async {
    await canLaunchUrl(Uri.parse(ApiEndpoints.hubungiAdmin))
        ? launchUrl(
            Uri.parse(ApiEndpoints.hubungiAdmin),
            mode: LaunchMode.externalApplication,
          )
        : debugPrint("Can't open WhatsApp");
  }

  Future<void> getAssisten() async {
    if (isLoadingAssistant.value) return;
    isLoadingAssistant.value = true;

    try {
      final result = await Future.wait([
        listOrderUseCase.callUsers(),
        if (!AppRole.isChecker2) listOrderUseCase.callTransportations(),
        if (AppRole.isChecker2) listOrderUseCase.callLoaderTransportations(),
      ]);

      final usersResult = result[0];
      final transportationsResult = result[1];

      switch (usersResult) {
        case Success(:final data):
          // debugPrint('Data Detail Order Users: $data');
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
      final loader = transportations.firstWhereOrNull(
        (element) => element.namaKendaraan == selectTransportation.value,
      );
      final driver = listUser.firstWhereOrNull(
        (element) => element.nama == driverSelected.value,
      );
      final kenek = listUser.firstWhereOrNull(
        (element) => element.nama == assistantSelected.value,
      );

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
}
