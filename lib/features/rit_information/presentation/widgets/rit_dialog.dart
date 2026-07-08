import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../shared/custom/custom_button.dart';
import '../../../../shared/text_field/textfield_shared.dart';
import '../../../../utils/loading_custom.dart';
import '../../../detail_order/data/models/item_order_model.dart';
import '../controllers/rit_controller.dart';
import '../../../../shared/images/custom_image.dart';
import '../controllers/enums/enum_rit.dart';

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
                    hint: const Text('Masukkan alasan tolak...'),
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
                      controller.buttonRIT.value = EnumButtonRIT.cancelRIT;
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

  void inputProductRetur({
    required RitController controller,
    int? index,
    String? name,
    String? qty,
    String? desc,
    bool isPreview = false,
    RxList<XFile>? mediaFileListPreview,
  }) {
    final nameProductController = TextEditingController(text: name);
    final qtyProductController = TextEditingController(text: qty);
    final descProductController = TextEditingController(text: desc);
    final mediaFileList = <XFile>[].obs;

    if (isPreview) {
      mediaFileList.value = mediaFileListPreview ?? [];
    }

    bool isEdit = false;
    bool isPreviewMode = isPreview;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, StateSetter setState) {
          return SizedBox(
            height: Get.height * 0.75,
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
                        child: Text(
                          'Nama Barang *',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.38,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 100,
                        child: Text(
                          'Qty(Jumlah)*',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.38,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SharedTextField(
                          readOnly: isPreviewMode && !isEdit,
                          controller: nameProductController,
                          hintText: 'Masukkan nama barang',
                          validator: (String? p1) {
                            if (p1 == null || p1.isEmpty) {
                              return 'Masukkan nama barang terlebih dahulu';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 100,
                        child: SharedTextField(
                          readOnly: isPreviewMode && !isEdit,
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Keterangan',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.38,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    readOnly: isPreviewMode && !isEdit,
                    controller: descProductController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.all(12),
                      hint: Text(
                        'Masukkan alasan retur (opsional)',
                        style: GoogleFonts.hankenGrotesk(
                          color: Color(0xFF9FA2B4),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.48,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  CustomImage().buildContentImage(
                    readOnly: isPreviewMode && !isEdit,
                    title: 'Barang Retur',
                    mediaFileList: mediaFileList,
                  ),
                  const Spacer(),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton.basicOutlinedButton(
                          title: isPreviewMode && !isEdit ? 'Edit' : 'Batal',
                          textColor: isPreviewMode && !isEdit
                              ? Colors.red
                              : const Color(0xFF8A5012),
                          minimumSize: Size.fromHeight(48),
                          side: BorderSide(
                            color: isPreviewMode && !isEdit
                                ? Colors.red
                                : const Color(0xFF8A5012),
                            width: 1,
                          ),
                          onPressed: () {
                            if (isPreviewMode && !isEdit) {
                              setState(() {
                                isPreviewMode = false;
                                isEdit = true;
                              });
                            } else {
                              Get.back();
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: CustomButton.basicButton(
                          title: 'Simpan',
                          minimumSize: Size.fromHeight(48),
                          color: const Color(0xFF0056D2),
                          onPressed: () {
                            if (!isPreviewMode && isEdit && index != null) {
                              final order = controller.itemPoAddRetur[index];

                              final updateOrder = order.copyWith(
                                item: nameProductController.text,
                                qty: qtyProductController.text,
                                note: descProductController.text,
                                mediaFileList: mediaFileList,
                              );

                              controller.itemPoAddRetur[index] = updateOrder;
                            } else {
                              controller.itemPoAddRetur.add(
                                ItemOrderModel(
                                  item: nameProductController.text,
                                  qty: qtyProductController.text,
                                  barcode: '',
                                  pic: StatusItem(),
                                  checker1: StatusItem(),
                                  checker2: StatusOrder(),
                                  driver: StatusOrder(),
                                  statusFinishScan: false,
                                  statusArrive: false,
                                  statusUnload: false,
                                  statusConfirmDelivery: false,
                                  note: descProductController.text,
                                  mediaFileList: mediaFileList,
                                ),
                              );
                            }
                            Get.back();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
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
                    controller: controller,
                    valueCheckbox: controller.selectedAllItem.value,
                    onChanged: (value) {
                      controller.selectAll();
                    },
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: status == 'Terkait'
                      ? controller.itemPO.length
                      : controller.itemPoAddRetur.length,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => const Divider(
                    thickness: 1,
                    height: 20,
                    color: Color(0xFFD7C3B4),
                  ),
                  itemBuilder: (context, index) {
                    final item = status == 'Terkait'
                        ? controller.itemPO[index]
                        : controller.itemPoAddRetur[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                        onTap: () => inputProductRetur(
                          index: index,
                          isPreview: true,
                          controller: controller,
                          name: item.item,
                          qty: item.qty,
                          desc: item.note,
                          mediaFileListPreview: item.mediaFileList,
                        ),
                        child: _buildTitleIconList(
                          isRelated: status == 'Terkait',
                          title: item.item,
                          isIcon: false,
                          index: index,
                          number: '${index + 1}',
                          controller: controller,
                          valueCheckbox: item.isChecked,
                          onChanged: (value) {
                            controller.selectedItem(index);
                          },
                        ),
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
    int? index,
    String? title,
    String? number,
    bool? valueCheckbox,
    Function(bool?)? onChanged,
    required RitController controller,
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
            onTap: () => inputProductRetur(controller: controller),
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
            onTap: () {
              controller.itemPoAddRetur.removeAt(index ?? 0);
            },
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
