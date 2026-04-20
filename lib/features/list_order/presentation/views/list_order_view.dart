import 'package:cv_rejo/features/list_order/domain/entities/list_order_entity.dart';
import 'package:cv_rejo/features/list_order/presentation/widgets/sort_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../shared/custom/custom_card_list.dart';
import '../../../../utils/loading_custom.dart';
import '../controllers/list_order_controller.dart';

class ListOrderView extends GetView<ListOrderController> {
  const ListOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Pesanan'),
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
          edgeOffset: 65.0,
          onRefresh: () async {
            controller.onRefreshTransaction();
          },
          child: Column(
            children: [
              Container(
                height: 42,
                margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CupertinoSearchTextField(
                  placeholder: 'Cari...',
                  placeholderStyle: const TextStyle(
                    color: Color(0xFF7C7C7C),
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 0.39,
                  ),
                  prefixInsets: EdgeInsetsGeometry.fromLTRB(10, 0, 5, 0),
                  controller: controller.searchController,
                  onSubmitted: (value) {
                    controller.onRefreshTransaction();
                  },
                  onSuffixTap: () {
                    controller.searchController.clear();
                    controller.onRefreshTransaction();
                  },
                  // onTap: () {
                  //   controller.isSearching.value = true;
                  // },
                ),
              ),
              const SizedBox(height: 10),
              Divider(thickness: 1, height: 8, color: Colors.grey[100]),
              Expanded(child: _buildContent()),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.orders.isEmpty) {
          return const SizedBox.shrink();
        }
        return _buildButtonStyle(child: _buildButton());
      }),
    );
  }

  Widget _buildButton() {
    if (controller.isSelection.value) {
      return _buildButtonSelect();
    }
    return _buildBasicButton(
      title: 'Pilih Pesanan',
      color: const Color(0xFFd5914d),
      onPressed: () {
        debugPrint('Pilih Pesanan');
        controller.isSelection.value = !controller.isSelection.value;
      },
    );
  }

  Widget _buildButtonSelect() {
    return Row(
      children: [
        Expanded(
          child: _buildBasicButton(
            title: 'Batal',
            color: Colors.redAccent,
            onPressed: () {
              debugPrint('Batal');
              controller.cancelSelection();
              controller.isSelection.value = !controller.isSelection.value;
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildBasicButton(
            title: 'Ambil Pesanan',
            color: const Color(0xFFc7a16d),
            onPressed: () => controller.takeItOrder(),
          ),
        ),
      ],
    );
  }

  Widget _buildBasicButton({
    required String title,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(title),
    );
  }

  Widget _buildButtonStyle({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: child,
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
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        OrderEntity transaction = controller.orders[index];
        return Obx(
          () => CustomCardList(
            onTap: () {
              if (controller.userModel.value.jabatan == 'picking' &&
                  controller.isSelection.value) {
                controller.onSelected(transaction.invoice);
              }
              // Navigate to detail transaksi screen with invoice number
              // Get.toNamed(Routes.DETAIL_TRANSAKSI,
              //     arguments: transaction.invoice);
            },
            idTransaksi: transaction.orderNo,
            noResi: transaction.courier?.waybillNumber ?? '-',
            noPesanan: transaction.invoice,
            kurir: transaction.courier?.service ?? '-',
            customer: transaction.customer,
            tanggalTransaksi: transaction.date.transaction,
            tanggalDelivery: transaction.date.delivery,
            showSelection: controller.isSelection.value,
            isSelected: controller.isSelected.value,
            onCheckboxChanged: () => controller.onSelected(transaction.invoice),
          ),
        );
      },
    );
  }
}
