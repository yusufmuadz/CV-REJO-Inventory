import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../shared/custom/custom_button.dart';
import '../../../../shared/custom/custom_card_list.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../controllers/rit_controller.dart';
import '../widgets/box_rit.dart';

class RitView extends StatelessWidget {
  final RitController controller;
  const RitView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
          child: BoxRit(
            rit: controller.isDistrictSelected.value,
            dateRit: controller.tanggalRit.value,
            onPressed: () => _openChangeRit(),
          ),
        ),
        Divider(thickness: 1, height: 1, color: Colors.grey.shade100),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildEmptyOrder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Tidak ada pesanan'),
        const SizedBox(height: 10),
        SizedBox(
          child: CustomButton.basicButton(
            title: 'Muat Ulang',
            color: const Color(0x954D7BF1),
            onPressed: () => controller.onRefreshTransaction(),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (controller.orders.isEmpty) {
      return _buildEmptyOrder();
    }

    return RefreshIndicator(
      onRefresh: () async => controller.onRefreshTransaction(),
      child: ListView.separated(
        itemCount: controller.orders.length,
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(16, 15, 16, 16),
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) => _buildOrder(index: index),
      ),
    );
  }

  Widget _buildOrder({required int index}) {
    OrderEntity transaction = controller.orders[index];

    return CustomCardList(
      onTap: () {
        Get.toNamed(
          Routes.DETAIL_ORDER,
          arguments: {
            'invoice': transaction.invoice,
            'status_driver': transaction.driver?.status ?? '',
          },
        );
      },
      showSelection: false,
      isSelected: '',
      onCheckboxChanged: () {},
      transaction: transaction,
      color: controller.colorRit.value.replaceAll('#', ''),
    );
  }

  _openChangeRit() {
    controller.dialogService.defaultDialog(
      height: 0.5,
      title: 'RIT',
      singleButton: true,
      titleButton1: 'Kembali',
      titlePadding: const EdgeInsets.all(10),
      insetPadding: const EdgeInsets.all(20),
      contentPadding: const EdgeInsets.all(5),
      content: ListView.separated(
        itemCount: controller.listOrderController.listRit.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = controller.listOrderController.listRit[index];

          return InkWell(
            onTap: () => controller.changeRit(item),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: BoxRit(
                rit: item.city,
                dateRit: item.tanggalRit,
                colorBox: const Color.fromARGB(255, 197, 221, 245),
              ),
            ),
          );
        },
      ),
    );
  }
}
