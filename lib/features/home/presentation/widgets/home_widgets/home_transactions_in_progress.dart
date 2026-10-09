import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/middlewares/app_role.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../routes/app_pages.dart';
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
              Visibility(
                visible: AppRole.isPIC || AppRole.isDriver,
                child: Container(
                  height: 45,
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color(0xFFD7C3B4),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () => controller.routeToSortingPO(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            border: Border.all(
                              width: 1,
                              color: const Color(0xFFD1FAE5),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.sync,
                            size: 20,
                            color: const Color(0xFF485461),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Urutkan',
                          style: TextStyles.basicTextStyle(
                            fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                            fontSize: 13,
                            color: const Color(0xFF524439),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
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
  }

  Widget _buildOrdersSection() {
    final transController = controller.homeTransactionsController;

    String label = 'Pesanan Dikerjakan';
    String message = 'Tidak ada pesanan';

    if (AppRole.isCollector) {
      label = 'Invoice Hari Ini';
      message = 'Tidak ada invoice';
    }

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
          Text(
            label,
            style: TextStyles.basicTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.roboto().fontFamily,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Visibility(
            visible: transController.orders.isEmpty,
            child: Expanded(child: Center(child: Text(message))),
          ),
          Visibility(
            visible: transController.orders.isNotEmpty,
            child: Expanded(
              child: ListView.builder(
                itemCount: transController.orders.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  OrderEntity transaction = transController.orders[index];

                  return OrderItem(
                    index: index,
                    showStatus: true,
                    order: transaction,
                    length: transController.orders.length,
                    onTap: () => controller.dialogService.showErrorSnackbar(
                      'Coming Soon',
                    ),
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
