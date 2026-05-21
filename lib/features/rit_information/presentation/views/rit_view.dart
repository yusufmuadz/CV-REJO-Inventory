import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../shared/custom/custom_card_list.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../controllers/rit_controller.dart';
import '../widgets/box_rit.dart';

class RitView extends StatelessWidget {
  final RitController controller;
  const RitView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          BoxRit(controller: controller),
          Divider(thickness: 1, height: 30, color: Colors.grey.shade100),
          Expanded(child: _buildContent()),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmptyOrder() {
    return const Center(child: Text('Tidak ada pesanan'));
  }

  Widget _buildContent() {
    if (controller.orders.isEmpty) {
      return _buildEmptyOrder();
    }

    return ListView.separated(
      itemCount: controller.orders.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _buildOrder(index: index),
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
}
