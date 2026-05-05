import 'package:cv_rejo/features/home/presentation/controllers/home_controller.dart';
import 'package:cv_rejo/features/list_order/data/models/date_model.dart';
import 'package:cv_rejo/features/list_order/domain/entities/list_order_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import 'app_colors.dart';
import 'home_card_sample.dart';

class HomeViewNewSample extends GetView<HomeController> {
  const HomeViewNewSample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMint,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              // const SizedBox(height: 24),

              // // Stats Cards
              _buildStatsSection(),
              const SizedBox(height: 24),

              // // Orders Section
              // _buildOrdersSection(),
              // const SizedBox(height: 20),

              // // Info Banner
              // _buildInfoBanner(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Image.asset(
          Assets.images.bgPickingMan.path,
          width: double.infinity,
          fit: BoxFit.fitWidth,
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
                  const Text(
                    'Hi, Andi 👋',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Semangat picking hari ini!',
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
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryGreen),
        );
      }

      return Container(
        padding: const EdgeInsets.all(16),
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
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: StatCard(
                    icon: Icons.receipt_long_outlined,
                    title: 'History\nPesanan',
                    subtitle: 'Telah dikerjakan',
                    value: 100,
                    iconColor: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Orders Section
            _buildOrdersSection(),
          ],
        ),
      );
    });
  }

  Widget _buildOrdersSection() {
    return Container(
      height: 200,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pesanan Dikerjakan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              // TextButton(
              //   onPressed: () {
              //     // Navigate to all orders
              //   },
              //   style: TextButton.styleFrom(padding: EdgeInsets.zero),
              //   child: const Text(
              //     'Lihat semua',
              //     style: TextStyle(
              //       color: AppColors.primaryGreen,
              //       fontSize: 12,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 12),
          // Obx(() {
          //   if (controller.isLoading.value) {
          //     return const SizedBox(
          //       height: 150,
          //       child: Center(
          //         child: CircularProgressIndicator(
          //           color: AppColors.primaryGreen,
          //         ),
          //       ),
          //     );
          //   }

          //   return
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) => OrderItem(
                index: index,
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
          //     // .map((order)
          //     // .toList(),
          //   );
          // }),
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
