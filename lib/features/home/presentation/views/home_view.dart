import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/loading_custom.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_widgets/home_header_widget.dart';
import '../widgets/home_widgets/home_transactions_in_progress.dart';

class HomeView extends StatelessWidget {
  final HomeController controller;

  const HomeView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          HomeHeaderWidget(controller: controller),

          // Stats Cards
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const LoadingView();
              }

              return HomeTransactionsInProgress(controller: controller);
            }),
          ),
        ],
      ),
    );
  }
}
