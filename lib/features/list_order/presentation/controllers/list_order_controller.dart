import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/loading_custom.dart';
import '../../domain/entities/district_entity.dart';
import '../../domain/entities/list_order_entity.dart';
import '../../domain/entities/rit_list_entity.dart';
import '../../domain/params/get_transaction_param.dart';
import '../../domain/params/take_it_param.dart';
import '../../domain/usecases/list_order_usecase.dart';

class ListOrderController extends GetxController {
  final ListOrderUseCase listOrderUseCase;

  ListOrderController({required this.listOrderUseCase});

  final isLoading = false.obs;
  final isLoadingSort = false.obs;
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

  final listDistrict = <DistrictEntity>[].obs;
  final listRit = <RitListEntity>[].obs;

  final colorRit = ''.obs;
  final tanggalRit = ''.obs;

  final sortByNew = true.obs;

  final loadState = LoadState.initial.obs;

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
      if (isDistrictSelected.value.isNotEmpty) {
        pageIndex.value = 1;
        // pageController.jumpToPage(1);
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
      // final order = orders[index];
      // final updatedOrder = order.copyWith(isSelected: !order.isSelected);
      // orders[index] = updatedOrder;
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
  }

  void takeItOrder({
    String rit = '',
    String clrRit = '',
    String tglRit = '',
  }) async {
    if (isLoading.value) return;

    if ((pageIndex.value == 1 && isSelected.value.isEmpty) &&
        !AppRole.isDriver) {
      dialogService.showError('Error', 'Pilih pesanan terlebih dahulu');
      return;
    }

    if (pageIndex.value == 0) {
      pageIndex.value = 1;
      isSelection.value = false;
      isDistrictSelected.value = rit;
      GetStorage().write('city', rit);
      GetStorage().write('colorRit', clrRit);
      GetStorage().write('tanggalRit', tglRit);
      if (AppRole.isDriver) {
        Get.offNamed(
          Routes.RIT_INFORMATION,
          arguments: {
            'invoice': '',
            'city': isSelected.value,
            'colorRit': clrRit,
            'tanggalRit': tglRit,
            'routeFrom': 'listOrder',
          },
        );
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
      return;
    }

    isLoading.value = true;

    final index = orders.indexWhere(
      (order) => order.invoice == isSelected.value,
    );

    final result = await listOrderUseCase.callTakeItTransaction(
      ParamsTakeIt(
        role: AppRole.current!.name.toLowerCase(),
        statusChecker2: orders[index].checker2?.status ?? '',
        invoice: isSelected.value,
      ),
    );

    try {
      switch (result) {
        case Success(:final data):
          if (data.status && data.message.isEmpty) {
            GetStorage().write('noInvoice', isSelected.value);
            if (AppRole.isChecker2) {
              GetStorage().write(
                'status_checker2',
                orders[index].checker2?.status ?? '',
              );
            }
            Get.offNamed(
              Routes.DETAIL_ORDER,
              arguments: {
                'invoice': isSelected.value,
                'routeFrom': 'listOrder',
                'take_it_order': true,
                'status_checker2': orders[index].checker2?.status ?? '',
              },
            );
          } else {
            if (Get.isDialogOpen == true) Get.back();
            dialogService.showError('Failed', data.message);
          }
        // debugPrint('Data Take It Order: ${data.length}');
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
    }
  }

  Future<void> _getOrder({bool isRefresh = false}) async {
    try {
      loadState.value = (isRefresh || currentPage.value == 1)
          ? LoadState.initial
          : LoadState.loadingMore;

      final result = await listOrderUseCase.call(
        ParamsGetTransaction(
          limit: '10',
          page: '$currentPage',
          q: searchController.text,
          sort: sortByNew.value ? 'newest' : 'oldest',
          filter: isStatusSelected.value.toLowerCase(),
          district: isDistrictSelected.value.toLowerCase(),
          dateRit: tanggalRit.value,
          // DateFormat(
          //   'yyyy-MM-dd',
          // ).format(DateTime.parse(tanggalRit.value)),
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

    final result = await listOrderUseCase.callGetRit('');

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
}
