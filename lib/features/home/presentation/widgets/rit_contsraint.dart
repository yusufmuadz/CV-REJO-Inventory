import 'package:cv_rejo/features/home/presentation/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../shared/custom/custom_button.dart';
import '../../../../shared/custom/custom_search_field.dart';
import '../../../../shared/text_field/textfield_shared.dart';
import '../../../../utils/thousand_formatter.dart';
import '../../../rit_information/presentation/widgets/custom_image.dart';
import 'app_bar_widget.dart';

class RitConstraint extends StatelessWidget {
  final HomeController controller;

  const RitConstraint({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBarWidget().content(
          title: 'Kendala',
          onTap: () {
            _popupAddConstraint(isPreviewMode: false);
          },
        ),
        const SizedBox(height: 10),
        Container(
          height: 42,
          margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: CustomSearchField(
            placeholder: 'Cari kendala...',
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
          if (controller.ritConstraints.isEmpty) {
            return Expanded(
              child: const Center(child: Text('Belum ada kendala')),
            );
          }
          return Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final item = controller.ritConstraints[index];

                return InkWell(
                  onTap: () => _popupAddConstraint(
                    isPreviewMode: true,
                    title: item.title,
                    nominal: item.nominal,
                    date: DateFormat('dd MMMM yyyy, HH:mm').format(item.date),
                    desc: item.desc,
                    files: item.mediaFileList,
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: GoogleFonts.hankenGrotesk(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF151C27),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              item.nominal.isEmpty
                                  ? 'Rp0'
                                  : 'Rp${formatNumber(int.parse(item.nominal))}',
                              style: GoogleFonts.hankenGrotesk(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF151C27),
                              ),
                            ),
                          ],
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
              itemCount: controller.ritConstraints.length,
            ),
          );
        }),
      ],
    );
  }

  _popupAddConstraint({
    String? title,
    String? nominal,
    String? date,
    String? desc,
    List<XFile>? files,
    required isPreviewMode,
  }) {
    final titleProductController = TextEditingController(text: title);
    final nominalProductController = TextEditingController(text: nominal);
    final descProductController = TextEditingController(text: desc);
    final mediaFileList = <XFile>[].obs;

    if (files != null && files.isNotEmpty) {
      mediaFileList.value = mediaFileList;
    }

    date ??= DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.now());

    Get.bottomSheet(
      SizedBox(
        height: Get.height * 0.9,
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
                        'Tambah Kendala Perjalanan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.back(),
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
                  child: Column(
                    children: [
                      _buildTitleField(
                        isReadOnly: true,
                        title: 'Tanggal laporan',
                        controller: TextEditingController(text: date),
                      ),
                      const SizedBox(height: 15),
                      _buildTitleField(
                        isReadOnly: isPreviewMode,
                        title: 'Kendala',
                        controller: titleProductController,
                      ),
                      const SizedBox(height: 15),
                      _buildTitleField(
                        isReadOnly: isPreviewMode,
                        title: 'Nominal',
                        controller: nominalProductController,
                      ),
                      const SizedBox(height: 15),
                      _buildTitleField(
                        isDesc: true,
                        isReadOnly: isPreviewMode,
                        title: 'Keterangan',
                        controller: descProductController,
                      ),
                      const SizedBox(height: 15),
                      CustomImage().buildContentImage(
                        title: 'Bukti Kendala',
                        readOnly: isPreviewMode,
                        mediaFileList: mediaFileList,
                      ),
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
                        title: isPreviewMode ? 'Kembali' : 'Batal',
                        textColor: isPreviewMode
                            ? Colors.red
                            : const Color(0xFF8A5012),
                        minimumSize: Size.fromHeight(48),
                        side: BorderSide(
                          color: isPreviewMode
                              ? Colors.red
                              : const Color(0xFF8A5012),
                          width: 1,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                    Visibility(
                      visible: !isPreviewMode,
                      child: Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 12),
                          child: CustomButton.basicButton(
                            title: 'Simpan',
                            minimumSize: Size.fromHeight(48),
                            color: const Color(0xFF0056D2),
                            onPressed: () {
                              controller.addConstraint(
                                title: titleProductController.text,
                                nominal: nominalProductController.text,
                                date: DateTime.now(),
                                status: 'SELESAI',
                                description: descProductController.text,
                                mediaFileList: mediaFileList,
                              );
                              Get.back();
                            },
                          ),
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

  Widget _buildTitleField({
    required bool isReadOnly,
    required String title,
    required TextEditingController controller,
    bool? isDesc = false,
  }) {
    String titleField = '$title*';
    String hintText = 'Masukkan $title';
    TextInputType? keyboardType;
    Color fillColor = Colors.white70;
    List<TextInputFormatter>? inputFormatters;

    if (title == 'Nominal') {
      keyboardType = TextInputType.number;
      inputFormatters = [ThousandsSeparatorInputFormatter()];
    }

    if (isReadOnly) {
      fillColor = const Color(0xFFf0f3ff);
    }

    if (isDesc == true) {
      titleField = title;
      hintText = 'Masukkan keterangan kendala (opsional)';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleField,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.38,
          ),
        ),
        const SizedBox(height: 5),
        SharedTextField(
          isDense: isDesc,
          readOnly: isReadOnly,
          maxLines: isDesc == true ? 4 : null,
          fillColor: fillColor,
          controller: controller,
          hintText: hintText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          contentPadding: isDesc == true ? const EdgeInsets.all(12) : null,
          validator: isDesc == true
              ? null
              : (String? p1) {
                  if (p1 == null || p1.isEmpty) {
                    return 'Masukkan $title terlebih dahulu';
                  }
                  return null;
                },
        ),
      ],
    );
  }
}
