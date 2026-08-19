import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../shared/box/box_status.dart';
import '../../../../shared/custom/custom_button.dart';
import '../../../../utils/loading_custom.dart';
import '../../../list_order/domain/entities/rit_list_entity.dart';
import '../controllers/home_controller.dart';
import '../controllers/home_tracking_driver_controller.dart';
import '../widgets/home_app_bar/app_bar_widget.dart';

class HomeTrackingDriverView extends StatelessWidget {
  final HomeController homeController;

  const HomeTrackingDriverView({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    final controller = homeController.homeTrackingDriverController;

    return Column(
      children: [
        AppBarWidget().content(
          title: 'Tracking Driver',
          icon: Ionicons.options_outline,
          onTap: () {
            controller.dialogService.showComingSoonSnackbar();
            // _popupFilter();
          },
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
            color: const Color.fromARGB(154, 255, 255, 255),
            child: Obx(
              () => RefreshIndicator(
                onRefresh: () async {
                  if (controller.isLoading.value) return;
                  controller.onRefreshTransaction();
                },
                child: CustomScrollView(
                  controller: controller.scrollerController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [_buildContent(controller)],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(HomeTrackingDriverController ctrlr) {
    if (ctrlr.isLoading.value) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: LoadingView(),
      );
    }

    if (ctrlr.listRit.isEmpty) {
      return _buildEmpty();
    }
    return _buildList(ctrlr: ctrlr);
  }

  Widget _buildEmpty() {
    String message = 'Tidak ada pesanan';

    // if (controller.pageIndex.value == 0) {
    //   message = 'Tidak ada RIT';
    // }

    return SliverFillRemaining(
      hasScrollBody: false, // Mencegah stretching konten
      child: Center(child: Text(message)),
    );
  }

  Widget _buildList({required HomeTrackingDriverController ctrlr}) {
    final isPlusOne =
        ctrlr.loadState.value != LoadState.initial &&
        ctrlr.loadState.value != LoadState.idle;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: ctrlr.listRit.length + (isPlusOne ? 1 : 0),
        (context, index) {
          if (index == ctrlr.listRit.length) {
            return _buildBottomIndicator(
              ctrlr.loadState.value,
              ctrlr.retryFetch,
            );
          }

          final ritOrder = ctrlr.listRit[index];

          return _buildOrder(controller: ctrlr, ritOrder: ritOrder);
        },
      ),
    );
  }

  Widget _buildOrder({
    required HomeTrackingDriverController controller,
    required RitListEntity ritOrder,
  }) {
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

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          controller.dialogService.showComingSoonSnackbar();
        },
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
              const Divider(thickness: 1, height: 24, color: Color(0xFFE7EEFE)),
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
                        fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF151C27),
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Total PO',
                          style: TextStyles.basicTextStyle(
                            fontSize: 16,
                            fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
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
                        fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF151C27),
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'PO Berjalan',
                          style: TextStyles.basicTextStyle(
                            fontSize: 16,
                            fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF524439),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: Color(0xFF8A5012),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      ritOrder.route.isEmpty ? '-' : ritOrder.route.join(', '),
                      style: TextStyles.basicTextStyle(
                        fontSize: 16,
                        fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF524439),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: BoxStatus.buildColor(
                        // statusPIC: transaction.pic?.status ?? '',
                        // statusChecker1: transaction.checker1?.status ?? '',
                        // statusChecker2: transaction.checker2?.status ?? '',
                        // statusDriver: transaction.driver?.status ?? '',
                        // statusScanDriver:
                        //     transaction.driver?.scanDriver ?? false,
                        // statusArriveDriver:
                        //     transaction.driver?.arriveDriver ?? false,
                      ),
                    ),
                    child: Text(
                      BoxStatus.buildText(
                        // statusPIC: transaction.pic?.status ?? '',
                        // statusChecker1: transaction.checker1?.status ?? '',
                        // statusChecker2: transaction.checker2?.status ?? '',
                        // statusDriver: transaction.driver?.status ?? '',
                        // statusScanDriver:
                        //     transaction.driver?.scanDriver ?? false,
                        // statusArriveDriver:
                        //     transaction.driver?.arriveDriver ?? false,
                      ),
                      style: TextStyles.basicTextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

  _popupFilter() {
    Get.bottomSheet(
      isDismissible: false,
      enableDrag: false,
      SizedBox(
        height: Get.height * 0.5,
        child: Padding(
          padding: EdgeInsets.only(top: 22, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10.0),
                child: Row(
                  children: [
                    const SizedBox(width: 35),
                    Expanded(
                      child: Text(
                        'Filter',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFF3F4F6),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: const Color(0xFF4B5563),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 5, thickness: 1, color: Color(0xFFE2E8F8)),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16, 13, 16, 16),
                  child: Column(children: [
                      ],
                    ),
                ),
              ),
              const Divider(height: 2, thickness: 1, color: Color(0xFFE2E8F8)),
              // const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12.0, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton.basicOutlinedButton(
                        title: 'Batal',
                        textColor: const Color(0xFF8A5012),
                        minimumSize: Size.fromHeight(48),
                        side: BorderSide(
                          color: const Color(0xFF8A5012),
                          width: 1,
                        ),
                        onPressed: () {
                          // if (ritController.isLoading.value) return;
                          Get.back();
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 12),
                        child: CustomButton.basicButton(
                          title: 'Simpan',
                          minimumSize: Size.fromHeight(48),
                          color: const Color(0xFF0056D2),
                          onPressed: () {
                            // if (ritController.isLoading.value) return;
                            Get.back();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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

      // case LoadState.error:
      //   return Padding(
      //     padding: const EdgeInsets.symmetric(vertical: 16),
      //     child: Center(
      //       child: ElevatedButton.icon(
      //         onPressed: onRetry,
      //         icon: const Icon(Icons.refresh, size: 18),
      //         label: const Text('Coba Lagi'),
      //       ),
      //     ),
      //   );

      default:
        return const SizedBox.shrink();
    }
  }
}
