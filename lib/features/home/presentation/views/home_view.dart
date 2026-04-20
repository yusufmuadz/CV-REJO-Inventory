import 'package:cv_rejo/features/home/presentation/widgets/home_box_widget.dart';
import 'package:cv_rejo/features/home/presentation/widgets/home_total_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../utils/loading_custom.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_chart_widget.dart';
import '../widgets/home_header_widget.dart';

class HomeView extends StatelessWidget {
  final HomeController controller;

  const HomeView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const LoadingView();
      } else {
        return RefreshIndicator(
          edgeOffset: 40.0,
          onRefresh: () async => controller.onRefreshTransaction(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
            children: [
              HomeHeaderWidget(controller: controller),
              const SizedBox(height: 20),
              HomeBoxWidget(controller: controller,),
              const SizedBox(height: 35),
              HomeTotalWidget(controller: controller),
              const SizedBox(height: 20),
              HomeChartWidget(),
            ],
          ),
        );
      }
    });
  }
}
