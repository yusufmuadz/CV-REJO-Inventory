import 'package:flutter/material.dart';
import '../../../../list_order/domain/entities/list_order_entity.dart';
import '../../controllers/home_controller.dart';
import '../../../../../core/theme/app_colors.dart';
import 'home_card_widget.dart';
import 'home_box_widget.dart';

class HomeTransactionsInProgress extends StatelessWidget {
  final HomeController controller;

  const HomeTransactionsInProgress({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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
              // Total Section
              HomeBoxWidget(controller: controller),
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
}
