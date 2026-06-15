// lib/core/widgets/stat_card.dart
import 'package:cv_rejo/features/list_order/domain/entities/list_order_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../shared/box/box_status.dart';
import '../../../../../core/theme/app_colors.dart';

class HomeCardWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int value;
  final Color iconColor;
  final Color bgIconColor;
  final bool isPast;
  final Function() onTap;

  const HomeCardWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.iconColor,
    required this.bgIconColor,
    required this.onTap,
    this.isPast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: const Color(0xFFD7C3B4)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: bgIconColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: iconColor),
            ),
            const SizedBox(height: 7),
            Text(
              title,
              style: TextStyles.basicTextStyle(
                fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                fontSize: 11,
                color: const Color(0xFF524439),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              isPast ? '-' : value.toString(),
              style: TextStyles.basicTextStyle(
                fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: iconColor,
                height: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF524439),
                fontWeight: FontWeight.w500,
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
  final int length;
  final bool? showStatus;
  final OrderEntity order;

  const OrderItem({
    super.key,
    required this.index,
    required this.length,
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
          bottom: index == length - 1
              ? BorderSide(color: Colors.grey.withOpacity(0.1), width: 1)
              : BorderSide.none,
          right: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
          left: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
        ),
        borderRadius: BorderRadius.only(
          topRight: index == 0 ? Radius.circular(12) : Radius.zero,
          topLeft: index == 0 ? Radius.circular(12) : Radius.zero,
          bottomRight: index == length - 1 ? Radius.circular(12) : Radius.zero,
          bottomLeft: index == length - 1 ? Radius.circular(12) : Radius.zero,
        ),
      ),
      child: InkWell(
        onTap: () {
          Get.toNamed(
            Routes.DETAIL_ORDER,
            arguments: {
              'invoice': order.invoice,
              'routeFrom': 'listOrder',
              'status_checker2': order.checker2?.status,
            },
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.orderNo,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  RichText(
                    text: TextSpan(
                      text: 'Lokasi : ',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: order.district,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
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
                      color: BoxStatus.buildColor(
                        statusPIC: order.pic?.status ?? '',
                        statusChecker1: order.checker1?.status ?? '',
                        statusChecker2: order.checker2?.status ?? '',
                        statusDriver: order.driver?.status ?? '',
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      BoxStatus.buildText(
                        statusPIC: order.pic?.status ?? '',
                        statusChecker1: order.checker1?.status ?? '',
                        statusChecker2: order.checker2?.status ?? '',
                        statusDriver: order.driver?.status ?? '',
                      ),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
