// lib/core/widgets/stat_card.dart
import 'package:cv_rejo/features/list_order/domain/entities/list_order_entity.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int value;
  final Color iconColor;
  final Function() onTap;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundMint,
          borderRadius: BorderRadius.circular(16),
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
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: iconColor),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                height: 1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textLight,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final int index;
  final bool? showStatus;
  final OrderEntity order;

  const OrderItem({
    super.key,
    required this.index,
    required this.order,
    this.showStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        // color: AppColors.cardBackground,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
          bottom: index == 0
              ? BorderSide(color: Colors.grey.withOpacity(0.1), width: 1)
              : BorderSide.none,
          right: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
          left: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
        ),
        borderRadius: BorderRadius.only(
          topRight: index == 0 ? Radius.circular(12) : Radius.zero,
          topLeft: index == 0 ? Radius.circular(12) : Radius.zero,
          bottomRight: index == 0 ? Radius.circular(12) : Radius.zero,
          bottomLeft: index == 0 ? Radius.circular(12) : Radius.zero,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.invoice,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    text: order.date.transaction, // Lokasi :
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      // TextSpan(
                      //   text: 'Semarang',
                      //   style: const TextStyle(
                      //     fontSize: 10,
                      //     color: AppColors.textSecondary,
                      //     fontWeight: FontWeight.w400,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '50 Item',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Visibility(
                visible: showStatus ?? false,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: order.pic?.status == 'Sedang Proses'
                        ? AppColors.statusGreenBg
                        : AppColors.statusOrangeBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.pic?.status ?? '-',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: order.pic?.status == 'Sedang Proses'
                          ? AppColors.statusGreen
                          : AppColors.statusOrange,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          const Icon(Icons.chevron_right, color: AppColors.textLight, size: 20),
        ],
      ),
    );
  }
}
