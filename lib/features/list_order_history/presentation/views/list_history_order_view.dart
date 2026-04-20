import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../shared/custom/custom_card_list.dart';
import '../../../../shared/order/sort_widget.dart';
import '../../../../utils/loading_custom.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../controllers/list_history_order_controller.dart';

class ListHistoryOrderView extends GetView<ListHistoryOrderController> {
  const ListHistoryOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List History Pesanan'),
        elevation: 1,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Untuk Android
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light, // Untuk iOS
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              Get.bottomSheet(
                SortWidget(controller: controller),
                isScrollControlled: true,
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingView();
        }
        return RefreshIndicator(
          onRefresh: () async {
            controller.onRefreshTransaction();
          },
          child: _buildContent(),
        );
      }),
    );
  }

  Widget _buildContent() {
    if (controller.orders.isEmpty) {
      return SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: Get.height - kToolbarHeight,
          child: const Center(child: Text('Tidak ada pesanan')),
        ),
      );
    }
    return ListView.separated(
      controller: controller.scrollController,
      itemCount: controller.orders.length,
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        OrderEntity transaction = controller.orders[index];
        return CustomCardList(
          onTap: () {
            // Navigate to detail transaksi screen with invoice number
            // Get.toNamed(Routes.DETAIL_TRANSAKSI,
            //     arguments: transaction.invoice);
            Get.toNamed(
              Routes.DETAIL_ORDER,
              arguments: {'invoice': transaction.invoice, 'routeFrom': 'listHistoryOrder'},
            );
          },
          idTransaksi: transaction.orderNo,
          noResi: transaction.courier?.waybillNumber ?? '',
          noPesanan: transaction.invoice,
          kurir: transaction.courier?.service ?? '',
          customer: transaction.customer,
          tanggalTransaksi: transaction.date.transaction,
          tanggalDelivery: transaction.date.delivery,
          isSelected: '',
          showSelection: false,
        );
      },
    );
  }
}
