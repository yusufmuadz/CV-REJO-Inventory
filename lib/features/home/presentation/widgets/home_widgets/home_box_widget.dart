import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../routes/app_pages.dart';
import '../../controllers/home_controller.dart';
import 'home_card_widget.dart';

class HomeBoxWidget extends StatelessWidget {
  final HomeController controller;
  const HomeBoxWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final transController = controller.homeTransactionsController;

    return Obx(
      () => Row(
        children: [
          Expanded(
            child: HomeCardWidget(
              icon: Icons.inventory_2_outlined,
              title: 'Total\nPesanan',
              subtitle: 'Sedang Berjalan',
              value: transController.totalOrder.value,
              iconColor: const Color(0xFF15803D),
              bgIconColor: const Color(0xFFDCFCE7),
              onTap: () {
                controller.routeTo();
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: HomeCardWidget(
              isPast: true,
              icon: CupertinoIcons.cube_box,
              title: 'Total\nPesanan',
              subtitle: 'Pesanan Lampau',
              value: 0,
              iconColor: const Color(0xFFC2410C),
              bgIconColor: const Color(0xFFFFEDD5),
              onTap: () {
                controller.routeTo(ritToday: false);
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: HomeCardWidget(
              icon: Icons.history_rounded,
              title: 'History\nPesanan',
              subtitle: 'Telah dikerjakan',
              value: transController.totalOrderHistory.value,
              iconColor: const Color(0xFF1D4ED8),
              bgIconColor: const Color(0xFFDBEAFE),
              onTap: () {
                Get.toNamed(Routes.LIST_HISTORY_ORDER);
              },
            ),
          ),
        ],
      ),
    );
  }
}
