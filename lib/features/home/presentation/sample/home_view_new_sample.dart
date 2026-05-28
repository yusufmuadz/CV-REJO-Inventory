import 'package:cv_rejo/features/home/presentation/controllers/home_controller.dart';
import 'package:cv_rejo/features/home/presentation/widgets/rit_contsraint.dart';
import 'package:cv_rejo/features/list_order/data/models/date_model.dart';
import 'package:cv_rejo/features/list_order/domain/entities/list_order_entity.dart';
import 'package:cv_rejo/features/list_order/presentation/views/list_order_page.dart';
import 'package:cv_rejo/features/profile/presentation/views/profile_view.dart';
import 'package:cv_rejo/shared/custom/custom_button.dart';
import 'package:cv_rejo/utils/loading_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../routes/app_pages.dart';
import 'app_colors.dart';
import 'home_card_sample.dart';

class HomeViewNewSample extends GetView<HomeController> {
  const HomeViewNewSample({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppRole.isDriver
            ? Color(0xFFf5f0fa)
            : AppColors.backgroundMint,
        body: Stack(children: [_buildPage()]),
        bottomNavigationBar: Obx(
          () => CustomButton.bottomBarIcon(controller: controller),
        ),
      ),
    );
  }

  Widget _buildPage() {
    return PageView(
      controller: controller.pageControllerSample,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildHome(),
        // ListOrderPage(),
        Container(),
        RitConstraint(),
        ProfileView(controller: controller),
      ],
    );
  }

  Widget _buildHome() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),

          // Stats Cards
          Expanded(child: _buildStatsSection()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Image.asset(
          AppRole.isDriver
              ? Assets.images.bgDriver.path
              : Assets.images.bgPickingMan.path,
          width: double.infinity,
          fit: BoxFit.fitWidth,
          // color: Colors.black,
        ),
        Positioned(
          top: 0.0,
          bottom: 0.0,
          left: 20.0,
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, ${AppRole.name!.capitalize} 👋',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Semangat ${AppRole.current!.name.capitalizeFirst} hari ini!',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const LoadingView();
      }

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, -10), // changes position of shadow
            ),
          ],
        ),
        child: RefreshIndicator(
          onRefresh: () async => controller.onRefreshTransaction(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.shopping_bag_outlined,
                        title: 'Total\nPesanan',
                        subtitle: 'Sedang Berjalan',
                        value: controller.totalOrder.value,
                        iconColor: AppColors.primaryGreen,
                        onTap: () => controller.routeTo(),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: StatCard(
                        icon: Icons.receipt_long_outlined,
                        title: 'History\nPesanan',
                        subtitle: 'Telah dikerjakan',
                        value: controller.totalOrderHistory.value,
                        iconColor: AppColors.primaryGreen,
                        onTap: () {
                          Get.toNamed(Routes.LIST_HISTORY_ORDER);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Orders Section
                _buildOrdersSection(),
                const SizedBox(height: 20),

                // // Info Banner
                // _buildInfoBanner(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildOrdersSection() {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pesanan Dikerjakan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: 1,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) => OrderItem(
                index: index,
                showStatus: true,
                order: OrderEntity(
                  invoice: 'PO/2000/000${index + 1}',
                  orderNo: '${index + 1}',
                  customer: 'Halo',
                  district: 'Jakarta',
                  date: DateModel(transaction: '', delivery: ''),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.bannerGreen, AppColors.bannerGreenDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pastikan picking sesuai dengan list pesanan ya!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Akurasi adalah kunci kepuasan pelanggan.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
