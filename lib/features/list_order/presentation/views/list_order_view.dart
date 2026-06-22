import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../routes/app_pages.dart';
import '../../../../shared/custom/custom_card_list.dart';
import '../../../../shared/custom/custom_search_field.dart';
import '../../../../utils/loading_custom.dart';
import '../../domain/entities/list_order_entity.dart';
import '../controllers/list_order_controller.dart';
import 'list_rit_view.dart';

class ListOrderView extends StatelessWidget {
  final ListOrderController controller;
  const ListOrderView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible:
              !controller.isRitToday.value && controller.pageIndex.value == 0,
          child: InkWell(
            onTap: () async {
              DateTime initialDate = DateTime.now();

              if (controller.pastRitDateSelected.isNotEmpty) {
                initialDate = DateTime.parse(
                  controller.pastRitDateSelected.value,
                );
              }

              final selectedDate = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now().add(const Duration(days: 360)),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(),
                    child: child!,
                  );
                },
              );

              if (selectedDate != null) {
                controller.pastRitDateSelected.value = selectedDate.toString();
                controller.onRefreshTransaction();
              }
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 2),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE2E8F8)),
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFF0F3FF),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: const Color(0xFF524439),
                  ),
                  const SizedBox(width: 6),
                  Obx(
                    () => Visibility(
                      visible: controller.pastRitDateSelected.isNotEmpty,
                      child: Text(
                        DateFormat('dd MMM yyyy').format(
                          DateTime.parse(controller.pastRitDateSelected.value),
                        ),
                        style: TextStyles.basicTextStyle(
                          fontSize: 16,
                          fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF151C27),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Ubah Tanggal',
                    style: TextStyles.basicTextStyle(
                      fontSize: 16,
                      fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF8A5012),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.edit_calendar_outlined,
                    size: 18,
                    color: Color(0xFF8A5012),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: !AppRole.isPIC && controller.pageIndex.value == 1,
          child: Container(
            height: 42,
            margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: CustomSearchField(
              placeholder: 'Cari ID pesanan...',
              searchController: controller.searchController,
              prefixInsets: EdgeInsetsGeometry.fromLTRB(10, 0, 5, 0),
              onSubmitted: (value) {
                controller.onRefreshTransaction();
              },
              onSuffixTap: () {
                controller.searchController.clear();
                controller.onRefreshTransaction();
              },
            ),
          ),
        ),
        Visibility(
          visible: !AppRole.isPIC && controller.pageIndex.value == 1,
          child: const SizedBox(height: 10),
        ),
        Visibility(
          visible: !AppRole.isPIC && controller.pageIndex.value == 1,
          child: Divider(thickness: 1, height: 8, color: Colors.grey[100]),
        ),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildEmptyOrder() {
    String message = 'Tidak ada pesanan';

    if (controller.pageIndex.value == 0) {
      message = 'Tidak ada RIT';
    }

    return SliverFillRemaining(
      hasScrollBody: false, // Mencegah stretching konten
      child: Center(child: Text(message)),
    );
  }

  // Widget _buildContent() {
  //   return Obx(
  //     () => CustomScrollView(
  //       controller: controller.scrollController,
  //       physics: const AlwaysScrollableScrollPhysics(),
  //       slivers: [
  //         if ((controller.orders.isEmpty && controller.pageIndex.value == 1) ||
  //             (controller.listRit.isEmpty && controller.pageIndex.value == 0))
  //           _buildEmptyOrder()
  //         else if (controller.pageIndex.value == 0)
  //           ListRitView(controller: controller)
  //         else
  //           SliverList(
  //             delegate: SliverChildBuilderDelegate(
  //               childCount:
  //                   controller.orders.length +
  //                   (controller.loadState.value == LoadState.loadingMore ||
  //                           controller.loadState.value == LoadState.error ||
  //                           controller.loadState.value == LoadState.noMore
  //                       ? 1
  //                       : 0),
  //               (context, index) {
  //                 if (index == controller.orders.length) {
  //                   return _buildBottomIndicator(
  //                     controller.loadState.value,
  //                     controller.retryFetch,
  //                   );
  //                 }

  //                 return _buildOrder(index: index);
  //               },
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildContent() {
    // 1. Buat ScrollController lokal agar fresh setiap kali widget dibangun
    final localScrollController = ScrollController();

    return PrimaryScrollController(
      controller: localScrollController,
      child: Builder(
        builder: (context) {
          // 2. Pasang listener langsung ke localScrollController untuk mendeteksi scroll
          localScrollController.removeListener(
            () {},
          ); // Bersihkan listener lama jika terjadi re-render
          localScrollController.addListener(() {
            // Kirim instance scroll aktif ke fungsi di GetX Controller Anda
            controller.onWidgetScroll(localScrollController);
          });

          return Obx(
            () => CustomScrollView(
              // 3. Pasang localScrollController ke CustomScrollView Anda
              controller: localScrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if ((controller.orders.isEmpty &&
                        controller.pageIndex.value == 1) ||
                    (controller.listRit.isEmpty &&
                        controller.pageIndex.value == 0))
                  _buildEmptyOrder()
                else if (controller.pageIndex.value == 0)
                  ListRitView(controller: controller)
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount:
                          controller.orders.length +
                          (controller.loadState.value ==
                                      LoadState.loadingMore ||
                                  controller.loadState.value ==
                                      LoadState.error ||
                                  controller.loadState.value == LoadState.noMore
                              ? 1
                              : 0),
                      (context, index) {
                        if (index == controller.orders.length) {
                          return _buildBottomIndicator(
                            controller.loadState.value,
                            controller.retryFetch,
                          );
                        }

                        return _buildOrder(index: index);
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrder({required int index}) {
    OrderEntity transaction = controller.orders[index];

    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
        child: CustomCardList(
          onTap: () {
            String statusPO = transaction.pic?.status ?? '';

            if (AppRole.isChecker1) {
              statusPO = transaction.checker1?.status ?? '';
            } else if (AppRole.isChecker2) {
              if (transaction.checker2?.status != 'completed') {
                statusPO = transaction.checker2?.status ?? '';
              } else {
                statusPO = transaction.loader?.status ?? '';
              }
            } else if (AppRole.isDriver) {
              statusPO = transaction.driver?.status ?? '';
            }

            if (AppRole.isDriver) {
              Get.toNamed(
                Routes.DETAIL_ORDER,
                arguments: {'invoice': transaction.invoice},
              );
              return;
            }

            Get.toNamed(
              Routes.DETAIL_ORDER,
              arguments: {
                'invoice': transaction.invoice,
                'routeFrom': 'listOrder',
                'take_it_order': true,
                'status_checker2': transaction.checker2?.status ?? '',
                'status_po': statusPO,
              },
            );

            // controller.takeItOrder(invoicePO: transaction.invoice);

            // if (controller.isSelection.value) {
            //   controller.onSelected(transaction.invoice);
            // }
          },
          showSelection: controller.isSelection.value,
          isSelected: controller.isSelected.value,
          onCheckboxChanged: () => controller.onSelected(transaction.invoice),
          transaction: transaction,
          color: controller.colorRit.value.replaceAll('#', ''),
        ),
      ),
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
