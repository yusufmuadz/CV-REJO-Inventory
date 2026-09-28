import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/text_styles.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_app_bar/app_bar_widget.dart';
import '../widgets/home_bbm/bbm_input_sheet.dart';

class HomeBbmWidget extends StatelessWidget {
  final HomeController homeController;

  const HomeBbmWidget({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    final controller = homeController.homeBbmController;

    return Column(
      children: [
        AppBarWidget().content(
          title: 'Isi BBM',
          controller: homeController,
          onTap: () {
            // homeController.dialogService.showComingSoonSnackbar();
            BbmInputSheet.show(
              homeController: homeController,
              isPreviewMode: false,
            );
          },
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (controller.listBbm.isEmpty) {
            return Expanded(
              child: const Center(child: Text('Belum ada data isi BBM')),
            );
          }

          return Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final item = controller.listBbm[index];

                return InkWell(
                  onTap: () => BbmInputSheet.show(
                    isPreviewMode: true,
                    date: DateFormat('dd MMMM yyyy, HH:mm').format(item.date),
                    desc: item.desc,
                    filesFront: item.mediaFilesFront,
                    filesAwalSegel: item.mediaFilesAwalSegel,
                    filesDispenserAwalPengisian:
                        item.mediaFilesDispenserAwalPengisian,
                    filesPengisianTangkiFull:
                        item.mediaFilesPengisianTangkiFull,
                    filesDispenserAkhirPengisian:
                        item.mediaFilesDispenserAkhirPengisian,
                    filesSegelBaru: item.mediaFilesSegelBaru,
                    filesNota: item.mediaFilesNota,
                    homeController: homeController,
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
                          '${item.rit} - ${item.routeRit}',
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
              itemCount: controller.listBbm.length,
            ),
          );
        }),
      ],
    );
  }
}
