import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/text_styles.dart';
import '../../../../shared/custom/custom_search_field.dart';
import '../controllers/home_controller.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/home_dialog/home_dialog.dart';

class TakeItOrderView extends StatelessWidget {
  final HomeController controller;

  const TakeItOrderView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final ritController = controller.homeRITController;

    return Column(
      children: [
        AppBarWidget().content(
          title: 'Ambil Pesanan',
          onTap: () =>
              controller.dialogService.showErrorSnackbar('Coming soon'),
          // HomeDialog.popupInputTakeIt(
          //   isPreviewMode: false,
          //   controller: controller,
          // ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 42,
          margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: CustomSearchField(
            placeholder: 'Cari pesanan...',
            searchController: controller.searchController,
            prefixInsets: EdgeInsetsGeometry.fromLTRB(10, 0, 5, 0),
            onSubmitted: (value) {
              controller.onRefreshTransaction();
            },
            onSuffixTap: () {
              controller.searchController.clear();
            },
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: const Color(0xFFD7C3B4)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Obx(() {
          if (ritController.listTakeItTransaction.isEmpty) {
            return Expanded(
              child: const Center(child: Text('Belum ada data ambil RIT')),
            );
          }

          return Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final item = ritController.listTakeItTransaction[index];

                return InkWell(
                  onTap: () => HomeDialog.popupInputTakeIt(
                    isPreviewMode: true,
                    date: DateFormat('dd MMMM yyyy, HH:mm').format(item.date),
                    desc: item.desc,
                    files: item.mediaFileList,
                    controller: controller,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 1,
                        color: const Color(0xFFD7C3B4),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title ?? '',
                          style: TextStyles.basicTextStyle(
                            fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF151C27),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${DateFormat('dd MMMM yyyy').format(item.date)} • ${DateFormat('HH:mm').format(item.date)}',
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF524439),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'SELESAI',
                                style: GoogleFonts.hankenGrotesk(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  color: Color(0xFF15803D),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: Color(0xFF857467),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: ritController.listTakeItTransaction.length,
            ),
          );
        }),
      ],
    );
  }
}
