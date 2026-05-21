import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../shared/custom/custom_button.dart';
import '../../../../shared/text_field/textfield_shared.dart';
import '../../../../utils/loading_custom.dart';
import '../controllers/rit_controller.dart';
import 'custom_image.dart';

class RitDialog {
  void inputReason({int? maxImage, required RitController controller}) {
    Get.bottomSheet(
      SizedBox(
        height: Get.height * 0.6,
        child: Obx(() {
          if (controller.isLoadingReason.value) {
            return const LoadingView();
          }

          return Padding(
            padding: EdgeInsets.fromLTRB(15, 22, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Masukkan Alasan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: controller.reasonController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.all(12),
                    hint: const Text('Masukkan alasan pending...'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomImage().buildTitle(title: 'Alasan'),
                const SizedBox(height: 10),
                CustomImage().contentImage(
                  maxImage: maxImage,
                  mediaFileList: controller.mediaFileReason,
                  controller: controller,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton.basicButton(
                    title: 'Kirim',
                    color: const Color(0xFF2ED471),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  void inputRetur({required RitController controller}) {
    Get.bottomSheet(
      SizedBox(
        height: Get.height * 0.95,
        child: Obx(() {
          if (controller.isLoadingReason.value) {
            return const LoadingView();
          }

          return Padding(
            padding: EdgeInsets.fromLTRB(15, 22, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 35),
                    Expanded(
                      child: Text(
                        'Masukkan Informasi Retur',
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
                const SizedBox(height: 23),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDropdown(
                          title: 'Status Retur',
                          hint: 'Pilih Info Retur',
                          selected: controller.selectedInfoRetur.value,
                          onChanged: (value) {
                            controller.selectedInfoRetur.value = value ?? '';
                          },
                          items: controller.infoReturList
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: GoogleFonts.hankenGrotesk(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.50,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 10),
                        _buildRetur(
                          status: controller.selectedInfoRetur.value,
                          controller: controller,
                        ),
                      ],
                    ),
                  ),
                ),
                // const Spacer(),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton.basicButton(
                    title: 'Simpan',
                    color: const Color(0xFF2ED471),
                    onPressed: () {
                      controller.addSampleItem();
                      // Get.back();
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  void inputProductRetur() {
    final nameProductController = TextEditingController();
    final qtyProductController = TextEditingController();
    final descProductController = TextEditingController();

    Get.bottomSheet(
      SizedBox(
        height: Get.height * 0.65,
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 22, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 35),
                  Expanded(
                    child: Text(
                      'Tambah Barang Retur',
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
              const SizedBox(height: 23),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama Barang *',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.38,
                          ),
                        ),
                        const SizedBox(height: 5),
                        SharedTextField(
                          controller: nameProductController,
                          hintText: 'Masukkan nama barang',
                          validator: (String? p1) {
                            if (p1 == null || p1.isEmpty) {
                              return 'Masukkan nama barang terlebih dahulu';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Qty(Jumlah)*',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.38,
                          ),
                        ),
                        const SizedBox(height: 5),
                        SharedTextField(
                          controller: qtyProductController,
                          keyboardType: TextInputType.number,
                          hintText: '0',
                          validator: (String? p1) {
                            if (p1 == null || p1.isEmpty) {
                              return 'Masukkan qty barang terlebih dahulu';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
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

  Widget _buildDropdown({
    required String title,
    required String hint,
    String? selected,
    required Function(String?)? onChanged,
    required List<DropdownMenuItem<String>>? items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.38,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFf4f4f5)),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: selected,
            hint: Text(
              hint,
              style: GoogleFonts.hankenGrotesk(
                color: Colors.grey.shade500,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.50,
              ),
            ),
            underline: Container(),
            items: items,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  _buildRetur({required String status, required RitController controller}) {
    // if (status != 'Terkait') {
    //   return SizedBox.shrink();
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: status == 'Terkait',
          child: Container(
            margin: const EdgeInsets.only(top: 5, bottom: 15),
            child: _buildDropdown(
              title: 'Pilih PO',
              hint: 'Pilih Nomor PO',
              selected: controller.selectedPoRetur.value.isEmpty
                  ? null
                  : controller.selectedPoRetur.value,
              onChanged: (value) {
                controller.selectedPoRetur.value = value ?? '';
              },
              items: controller.orders
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item.orderNo,
                      child: Text(
                        item.orderNo,
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        Visibility(
          visible: status == 'Terkait',
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: CustomImage().buildContentImage(
              title: 'Barang Retur',
              controller: controller,
              mediaFileList: controller.mediaFileListRetur,
            ),
          ),
        ),
        Visibility(
          visible: controller.itemPO.isNotEmpty,
          child: Text(
            'Pilih Barang Retur',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.38,
            ),
          ),
        ),
        Visibility(
          visible: controller.itemPO.isNotEmpty || status == 'Tidak Terkait',
          child: Container(
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Color(0xFFD7C3B4)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Container(
                  height: 47,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xFFD7C3B4)),
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      topLeft: Radius.circular(12),
                    ),
                    color: Color(0xFFF0F3FF),
                  ),
                  child: _buildTitleIconList(
                    isRelated: status == 'Terkait',
                    valueCheckbox: controller.selectedAllItem.value,
                    onChanged: (value) {
                      controller.selectAll();
                    },
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.itemPO.length,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => const Divider(
                    thickness: 1,
                    height: 20,
                    color: Color(0xFFD7C3B4),
                  ),
                  itemBuilder: (context, index) {
                    final item = controller.itemPO[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _buildTitleIconList(
                        isRelated: status == 'Terkait',
                        title: item.item,
                        isIcon: false,
                        number: '${index + 1}',
                        valueCheckbox: item.isChecked,
                        onChanged: (value) {
                          controller.selectedItem(index);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleIconList({
    required bool isRelated,
    bool isIcon = true,
    String? title,
    String? number,
    bool? valueCheckbox,
    Function(bool?)? onChanged,
  }) {
    String resultTitle = 'PILIH SEMUA';

    if (!isRelated) {
      resultTitle = 'TAMBAH BARANG';
    }

    if (title != null) {
      resultTitle = title;
    }
    return Row(
      children: [
        Visibility(
          visible: isIcon,
          child: const SizedBox(
            width: 30,
            child: Icon(
              Icons.checklist_rounded,
              size: 24,
              color: Color(0xFF857467),
            ),
          ),
        ),
        Visibility(
          visible: !isIcon,
          child: SizedBox(
            width: 30,
            child: Text(
              '$number',
              textAlign: TextAlign.center,
              style: GoogleFonts.hankenGrotesk(
                color: const Color(0xFF857467),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.48,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            resultTitle,
            style: GoogleFonts.hankenGrotesk(
              color: const Color(0xFF524439),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.48,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Visibility(
          visible: !isRelated && isIcon,
          child: InkWell(
            onTap: () => inputProductRetur(),
            child: const Icon(
              Icons.add_circle_outline_outlined,
              size: 28,
              color: Color(0xFFd68f4d),
            ),
          ),
        ),
        Visibility(
          visible: !isRelated && title != null && !isIcon,
          child: InkWell(
            onTap: () {},
            child: const Icon(
              Ionicons.close_circle_outline,
              size: 28,
              color: Colors.redAccent,
            ),
          ),
        ),
        Visibility(
          visible: isRelated,
          child: Checkbox(
            value: valueCheckbox,
            onChanged: onChanged,
            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
        ),
      ],
    );
  }
}
