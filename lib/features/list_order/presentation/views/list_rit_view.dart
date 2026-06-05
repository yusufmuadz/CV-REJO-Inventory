import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../utils/loading_custom.dart';
import '../../../home/presentation/sample/app_colors.dart';
import '../../domain/entities/rit_list_entity.dart';
import '../controllers/list_order_controller.dart';

class ListRitView extends StatelessWidget {
  final ListOrderController controller;
  const ListRitView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount:
            controller.listRit.length +
            (controller.loadState.value == LoadState.loadingMore ||
                    controller.loadState.value == LoadState.error ||
                    controller.loadState.value == LoadState.noMore
                ? 1
                : 0),
        (context, index) {
          if (index == controller.listRit.length) {
            return _buildBottomIndicator(
              controller.loadState.value,
              controller.retryFetch,
            );
          }

          return _buildOrder(index: index);
        },
      ),
    );
  }

  Widget _buildOrder({required int index}) {
    RitListEntity ritOrder = controller.listRit[index];

    return Obx(() {
      final isSelected =
          controller.isSelected.value == ritOrder.city &&
          controller.tanggalRit.value == ritOrder.tanggalRit;

      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
        child: InkWell(
          onTap: () => controller.takeItOrder(
            rit: ritOrder.city,
            clrRit: ritOrder.color,
            tglRit: ritOrder.tanggalRit,
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                width: isSelected ? 2 : 1,
                color: isSelected
                    ? const Color(0x4617ACF1)
                    : Colors.grey.shade100,
              ),
              color: Color(
                int.parse('0xFF${ritOrder.color.replaceAll('#', '')}'),
              ),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'RIT - ${ritOrder.city}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${ritOrder.totalPO} ${AppRole.isDriver ? 'SJ' : 'PO'}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  DateFormat(
                    'dd MMMM yyyy',
                  ).format(DateTime.parse(ritOrder.tanggalRit)),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBottomIndicator(LoadState state, VoidCallback onRetry) {
    switch (state) {
      case LoadState.loadingMore:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: LoadingView(),
        );

      case LoadState.noMore:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text(
              '✨ Tidak ada data lagi',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        );

      case LoadState.error:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Coba Lagi'),
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
