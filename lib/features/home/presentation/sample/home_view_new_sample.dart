import 'package:cv_rejo/features/home/presentation/controllers/home_controller.dart';
import 'package:cv_rejo/features/home/presentation/widgets/rit_contsraint.dart';
import 'package:cv_rejo/features/list_order/data/models/date_model.dart';
import 'package:cv_rejo/features/list_order/domain/entities/list_order_entity.dart';
import 'package:cv_rejo/features/list_order/presentation/views/list_order_page.dart';
import 'package:cv_rejo/features/profile/presentation/views/profile_view.dart';
import 'package:cv_rejo/shared/custom/custom_button.dart';
import 'package:cv_rejo/utils/loading_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../routes/app_pages.dart';
import '../../../detail_order/presentation/bindings/detail_order_binding.dart';
import '../../../detail_order/presentation/controllers/detail_order_controller.dart';
import '../../../scan_product/presentation/bindings/scan_product_binding.dart';
import '../../../scan_product/presentation/controllers/scan_product_controller.dart';
import '../../../scan_product/presentation/widgets/dialog_scan_product/input_qty_dialog.dart';
import '../views/take_it_order_view.dart';
import 'app_colors.dart';
import 'home_card_sample.dart';

class HomeViewNewSample extends GetView<HomeController> {
  const HomeViewNewSample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppRole.isDriver || AppRole.isChecker1
          ? Color(0xFFf5f0fa)
          : AppColors.backgroundMint,
      body: _buildPage(),
      bottomNavigationBar: Obx(() {
        if (controller.isKeyboardOpen.value) return const SizedBox();
        return CustomButton.bottomBarIcon(controller: controller);
      }),
    );
  }

  Widget _buildPage() {
    return PageView(
      controller: controller.pageControllerSample,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildHome(),
        // ListOrderPage(),
        if (AppRole.isDriver) RitConstraint(controller: controller),
        if (AppRole.isDriver) TakeItOrderView(controller: controller),
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
    String imagePath = Assets.images.bgPickingMan.path;

    if (AppRole.isDriver) {
      imagePath = Assets.images.bgDriver.path;
    } else if (AppRole.isChecker1) {
      imagePath = Assets.images.bgPackingMan.path;
    }
    return Stack(
      children: [
        Image.asset(
          imagePath,
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
                        icon: Icons.inventory_2_outlined,
                        title: 'Total\nPesanan',
                        subtitle: 'Sedang Berjalan',
                        value: controller.totalOrder.value,
                        iconColor: const Color(0xFF15803D),
                        bgIconColor: const Color(0xFFDCFCE7),
                        onTap: () {
                          controller.routeTo();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: StatCard(
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
                      child: StatCard(
                        icon: Icons.history_rounded,
                        title: 'History\nPesanan',
                        subtitle: 'Telah dikerjakan',
                        value: controller.totalOrderHistory.value,
                        iconColor: const Color(0xFF1D4ED8),
                        bgIconColor: const Color(0xFFDBEAFE),
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
            blurRadius: 3,
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
          Visibility(
            visible: controller.orders.isEmpty,
            child: Expanded(
              child: const Center(child: Text('Tidak ada pesanan')),
            ),
          ),
          Visibility(
            visible: controller.orders.isNotEmpty,
            child: Expanded(
              child: ListView.builder(
                itemCount: controller.orders.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  OrderEntity transaction = controller.orders[index];

                  return OrderItem(
                    index: index,
                    showStatus: true,
                    order: transaction,
                    length: controller.orders.length,
                  );
                },
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
