import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../utils/loading_custom.dart';
import '../../domain/entities/rit_list_entity.dart';
import '../controllers/list_order_controller.dart';

class ListRitView extends StatelessWidget {
  final ListOrderController controller;
  const ListRitView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isPlusOne =
        controller.loadState.value != LoadState.initial &&
        controller.loadState.value != LoadState.idle;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: controller.listRit.length + (isPlusOne ? 1 : 0),
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
    bool showBottom = index + 1 == controller.listRit.length;
    String totalOnProgressPO = '0';
    String pendingPoRITCheck2 = ritOrder.poPendingCheck2;
    final colorRIT = int.parse('0xFF${ritOrder.color.replaceAll('#', '')}');

    if (AppRole.isPIC) {
      totalOnProgressPO = ritOrder.poPendingPic;
    } else if (AppRole.isChecker1) {
      totalOnProgressPO = ritOrder.poPendingCheck1;
    } else if (AppRole.isChecker2) {
      if (pendingPoRITCheck2 != '0') {
        totalOnProgressPO = ritOrder.poPendingCheck2;
      } else {
        totalOnProgressPO = ritOrder.poPendingLoader;
      }
    } else if (AppRole.isDriver) {
      totalOnProgressPO = ritOrder.poPendingDelivery;
    }

    return Obx(() {
      bool isSelected =
          controller.isSelected.value == ritOrder.city &&
          controller.tanggalRit.value == ritOrder.tanggalRit;

      return Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
        margin: showBottom ? const EdgeInsets.only(bottom: 16) : null,
        child: InkWell(
          onTap: () =>
              controller.onSelectedRit(index, pendingPoRIT: pendingPoRITCheck2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: controller.isSelection.value,
                child: Container(
                  margin: const EdgeInsets.only(top: 10, right: 10),
                  child: Container(
                    height: 20,
                    width: 20,
                    padding: isSelected ? const EdgeInsets.all(2) : null,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: Colors.blue),
                    ),
                    child: isSelected
                        ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1, color: Color(colorRIT)),
                      bottom: BorderSide(width: 1, color: Color(colorRIT)),
                      right: BorderSide(width: 1, color: Color(colorRIT)),
                      left: BorderSide(width: 7, color: Color(colorRIT)),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected ? Colors.grey.shade200 : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRowContent(
                        title: 'NOMOR RIT',
                        value: 'Tanggal',
                        color: const Color(0xFF524439),
                        fontWeightTitle: FontWeight.w600,
                      ),
                      const SizedBox(height: 3),
                      _buildRowContent(
                        title: 'RIT - ${ritOrder.city}',
                        value: DateFormat(
                          'dd MMMM yyyy',
                        ).format(DateTime.parse(ritOrder.tanggalRit)),
                        color: const Color(0xFF151C27),
                        fontWeightTitle: FontWeight.bold,
                        fontWeightValue: FontWeight.w500,
                      ),
                      const Divider(
                        thickness: 1,
                        height: 24,
                        color: Color(0xFFE7EEFE),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 18,
                            color: const Color(0xFF8A5012),
                          ),
                          const SizedBox(width: 5),
                          RichText(
                            text: TextSpan(
                              text: '${ritOrder.totalPO} ',
                              style: TextStyles.basicTextStyle(
                                fontSize: 16,
                                fontFamily:
                                    GoogleFonts.hankenGrotesk().fontFamily,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF151C27),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Total PO',
                                  style: TextStyles.basicTextStyle(
                                    fontSize: 16,
                                    fontFamily:
                                        GoogleFonts.hankenGrotesk().fontFamily,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF524439),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            CupertinoIcons.cube_box,
                            size: 18,
                            color: const Color(0xFFD68F4D),
                          ),
                          const SizedBox(width: 5),
                          RichText(
                            text: TextSpan(
                              text: '$totalOnProgressPO ',
                              style: TextStyles.basicTextStyle(
                                fontSize: 16,
                                fontFamily:
                                    GoogleFonts.hankenGrotesk().fontFamily,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF151C27),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'PO Berjalan',
                                  style: TextStyles.basicTextStyle(
                                    fontSize: 16,
                                    fontFamily:
                                        GoogleFonts.hankenGrotesk().fontFamily,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF524439),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(height: 10),
                      // Row(
                      //   children: [
                      //     const Icon(
                      //       Icons.location_on_outlined,
                      //       size: 18,
                      //       color: Color(0xFF8A5012),
                      //     ),
                      //     const SizedBox(width: 5),
                      //     Text(
                      //       'Malang, Jogja, Semarang',
                      //       style: TextStyles.basicTextStyle(
                      //         fontSize: 16,
                      //         fontFamily:
                      //             GoogleFonts.hankenGrotesk().fontFamily,
                      //         fontWeight: FontWeight.w400,
                      //         color: const Color(0xFF524439),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildRowContent({
    required String title,
    required String value,
    required Color color,
    required FontWeight fontWeightTitle,
    FontWeight fontWeightValue = FontWeight.w400,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.basicTextStyle(
              fontSize: 16,
              fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
              fontWeight: fontWeightTitle,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: fontWeightValue,
            color: color,
          ),
        ),
      ],
    );
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
