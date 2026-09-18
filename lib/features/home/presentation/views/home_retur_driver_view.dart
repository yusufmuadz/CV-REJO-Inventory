import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/theme/text_styles.dart';
import '../../../../shared/custom/custom_button.dart';
import '../../../../shared/images/custom_image.dart';
import '../../../../shared/text_field/textfield_shared.dart';
import '../../../../utils/loading_custom.dart';
import '../../../rit_information/domain/entities/item_order_retur_entity.dart';
import '../../../rit_information/presentation/widgets/rit_dialog.dart';
import '../controllers/home_controller.dart';
import '../controllers/home_retur_controller.dart';
import '../widgets/home_app_bar/app_bar_widget.dart';

class HomeReturDriverView extends StatelessWidget {
  final HomeController homeController;

  const HomeReturDriverView({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    final controller = homeController.homeReturController;

    return Column(
      children: [
        AppBarWidget().content(
          title: 'Retur Tidak Terkait',
          onTap: () {
            _buildInputRetur(controller: controller);
          },
        ),
      ],
    );
  }

  void _buildInputRetur({required HomeReturController controller}) {
    Get.bottomSheet(
      enableDrag: false,
      SizedBox(
        height: Get.height * 0.85,
        child: Obx(() {
          if (controller.isLoadingRetur.value) {
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
                Container(
                  height: 1,
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10),
                  color: Colors.grey.shade100,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 13),
                        _buildRetur(controller: controller),
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
                      // if (homeController.selectedInfoRetur.value == 'Terkait') {
                      //   homeController.savePostRetur();
                      //   return;
                      // }
                      // controller.addSampleItem();
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

  Widget _buildRetur({required HomeReturController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Barang Retur',
          style: TextStyles.basicTextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.38,
          ),
        ),
        Container(
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
                  isCheckbox: false,
                  valueCheckbox: false,
                  controller: controller,
                  onChanged: (value) {
                    // controller.selectAll();
                  },
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                itemCount: controller.itemPoAddRetur.length,
                padding: const EdgeInsets.symmetric(vertical: 10),
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const Divider(
                  thickness: 1,
                  height: 20,
                  color: Color(0xFFD7C3B4),
                ),
                itemBuilder: (context, index) {
                  final item = controller.itemPoAddRetur[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        _inputProductRetur(
                          index: index,
                          isPreview: true,
                          controller: controller,
                          name: item.name,
                          qty: item.jumlahItem,
                          qtyInput: item.inputQtyItem,
                          desc: item.description,
                          mediaFileListPreview: item.mediaFileList,
                        );
                      },
                      child: _buildTitleIconList(
                        title: item.name,
                        isIcon: false,
                        index: index,
                        number: '${index + 1}',
                        controller: controller,
                        valueCheckbox: item.isChecked,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _inputProductRetur({
    required HomeReturController controller,
    int? index,
    String? name,
    String? qty,
    String? qtyInput,
    String? desc,
    bool isPreview = false,
    ItemOrderReturEntity? item,
    RxList<XFile>? mediaFileListPreview,
  }) {
    final nameProductController = TextEditingController(text: name);
    final qtyProductController = TextEditingController(text: qty);
    final qtyReturProductController = TextEditingController(text: qtyInput);
    final descProductController = TextEditingController(text: desc);
    final mediaFileList = <XFile>[].obs;

    if (isPreview) {
      mediaFileList.value = mediaFileListPreview ?? [];
    }

    bool isEdit = false;
    bool isPreviewMode = isPreview;

    Get.dialog(
      Align(
        alignment: Alignment.bottomCenter,
        child: StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Material(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),

              child: Container(
                height: Get.height * 0.9,
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
                    Container(
                      height: 1,
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.grey.shade100,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 13),
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
                                    hintText: '0',
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton.basicOutlinedButton(
                            title: isPreviewMode && !isEdit
                                ? 'Edit'
                                : 'Batal',
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
                                final order =
                                    controller.itemPoAddRetur[index];
                    
                                final updateOrder = order.copyWith(
                                  name: nameProductController.text,
                                  jumlahItem: qtyProductController.text,
                                  description: descProductController.text,
                                  mediaFileList: mediaFileList,
                                );
                    
                                controller.itemPoAddRetur[index] =
                                    updateOrder;
                              } else {
                                controller.addItemRetur(
                                  index: index,
                                  item: item,
                                  nameProductController:
                                      nameProductController,
                                  qtyReturProductController:
                                      qtyReturProductController,
                                  descProductController:
                                      descProductController,
                                  mediaFileListRetur: mediaFileList,
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
      ),
    );
  }

  Widget _buildTitleIconList({
    bool isIcon = true,
    bool isCheckbox = true,
    int? index,
    String? title,
    String? number,
    bool? valueCheckbox,
    Function(bool?)? onChanged,
    required HomeReturController controller,
  }) {
    String resultTitle = 'TAMBAH BARANG';

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
          visible: isIcon && !isCheckbox,
          child: InkWell(
            onTap: () {
              _inputProductRetur(controller: controller);
            },
            child: const Icon(
              Icons.add_circle_outline_outlined,
              size: 28,
              color: Color(0xFFd68f4d),
            ),
          ),
        ),
        Visibility(
          visible: isCheckbox && !isIcon,
          child: InkWell(
            onTap: () {
              debugPrint('index $index');

              controller.itemPoAddRetur.removeAt(index ?? 0);
            },
            child: const Icon(
              Ionicons.close_circle_outline,
              size: 28,
              color: Colors.redAccent,
            ),
          ),
        ),
      ],
    );
  }
}
