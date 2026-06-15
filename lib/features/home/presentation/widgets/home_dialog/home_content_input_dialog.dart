import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/middlewares/app_role.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../shared/custom/custom_button.dart';
import '../../../../../shared/text_field/textfield_shared.dart';
import '../../../../../utils/thousand_formatter.dart';
import '../../../../rit_information/presentation/widgets/custom_image.dart';
import '../../../domain/entities/take_it_transaction_entity.dart';

class HomeContentInputDialog extends StatelessWidget {
  final bool? isTakeIt;
  final bool isPreviewMode;
  final String? date;
  final TextEditingController? titleProductController;
  final TextEditingController? nominalProductController;
  final TextEditingController descProductController;
  final RxList<XFile> mediaFileList;
  final Function()? onPressedSave;
  final List<TakeItTransactionEntity>? takeItTransactionListRIT;

  String? selectedValueTakeItRIT;

  HomeContentInputDialog({
    super.key,
    required this.isPreviewMode,
    required this.descProductController,
    required this.mediaFileList,
    this.titleProductController,
    this.nominalProductController,
    this.takeItTransactionListRIT,
    this.selectedValueTakeItRIT,
    this.onPressedSave,
    this.isTakeIt,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    String titleInput = 'Kendala Perjalanan';
    String titleImage = 'Bukti Kendala';

    if (isTakeIt == true) {
      titleInput = 'Ambil RIT';
      titleImage = 'Bukti Pengambilan (Opsional)';
    }

    return SizedBox(
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
                      titleInput,
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

                    //// ====== CONTENT INPUT ISIAN ATAU DROPDOWN ====== ////
                    _buildContent(),
                    const SizedBox(height: 15),
                    _buildTitleField(
                      isDesc: true,
                      isReadOnly: isPreviewMode,
                      title: 'Keterangan',
                      controller: descProductController,
                    ),
                    const SizedBox(height: 15),
                    CustomImage().buildContentImage(
                      title: titleImage,
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
                          onPressed: onPressedSave ?? () => Get.back(),
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
    );
  }

  Widget _buildContent() {
    if (isTakeIt == true) {
      String? valueRIT;

      if (AppRole.isDriver && takeItTransactionListRIT != null) {
        valueRIT =
            selectedValueTakeItRIT ?? takeItTransactionListRIT!.first.value;
      }

      return _buildDropdown(
        title: 'Pilih RIT*',
        description: 'RIT',
        selectedValue: valueRIT,
        items:
            takeItTransactionListRIT?.map<DropdownMenuItem<String>>((item) {
              return _buildMenuItem(item: item.value);
            }).toList() ??
            [],
        onChanged: (value) {
          selectedValueTakeItRIT = value.toString();
        },
      );
    }

    return Column(
      children: [
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
      ],
    );
  }

  Widget _buildDropdown({
    required String title,
    required String description,
    required List<DropdownMenuItem<String>> items,
    Function(Object?)? onChanged,
    String? selectedValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.basicTextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.38,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(7),
          ),
          child: DropdownButton(
            isDense: true,
            isExpanded: true,
            hint: Text(
              'Pilih $description',
              style: TextStyles.basicTextStyle(
                fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                color: const Color(0xFF9FA2B4),
                fontSize: 15,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.38,
              ),
            ),
            icon: const Icon(Icons.arrow_drop_down),
            underline: Container(),
            padding: EdgeInsets.zero,
            value: selectedValue,
            items: items,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  DropdownMenuItem<String> _buildMenuItem({required String item}) {
    return DropdownMenuItem(
      value: item,
      child: Text(
        item.capitalizeFirst ?? '-',
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTitleField({
    required bool isReadOnly,
    required String title,
    TextEditingController? controller,
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
      if (isTakeIt == true) {
        hintText = 'Masukkan keterangan (wajib)';
      } else {
        titleField = title;
        hintText = 'Masukkan keterangan kendala (opsional)';
      }
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
          controller: controller ?? TextEditingController(),
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
