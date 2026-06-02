import 'package:cv_rejo/features/home/presentation/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/custom/custom_search_field.dart';
import '../../../../shared/text_field/textfield_shared.dart';
import '../../../rit_information/presentation/widgets/custom_image.dart';

class RitConstraint extends StatelessWidget {
  final HomeController controller;

  const RitConstraint({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 90,
          padding: EdgeInsets.all(16),
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 3,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kendala',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  color: Color(0xFF151C27),
                ),
              ),
              InkWell(
                onTap: () {
                  _popupAddTrouble();
                },
                child: Icon(
                  Icons.add_circle_outline,
                  size: 27,
                  color: Color(0xFF151C27),
                ),
              ),
            ],
          ),
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
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: const Color(0xFFD7C3B4)),
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
                            'Beli Bensin',
                            style: GoogleFonts.hankenGrotesk(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF151C27),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Rp150.000',
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
                      '29 Mei 2025 • 10:30',
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
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: controller.ritConstraints.length,
          ),
        ),
      ],
    );
  }

  _popupAddTrouble({
    String? title,
    String? nominal,
    String? date,
    String? desc,
    RxList<XFile>? files,
  }) {
    final titleProductController = TextEditingController(text: title);
    final nominalProductController = TextEditingController(text: nominal);
    final descProductController = TextEditingController(text: desc);
    final mediaFileList = <XFile>[].obs;

    if (files != null) {
      mediaFileList.value = mediaFileList;
    }

    Get.bottomSheet(
      SizedBox(
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
              const SizedBox(height: 23),
              Text(
                'Kendala *',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.38,
                ),
              ),
              const SizedBox(height: 5),
              SharedTextField(
                controller: titleProductController,
                hintText: 'Masukkan kendala',
                validator: (String? p1) {
                  if (p1 == null || p1.isEmpty) {
                    return 'Masukkan kendala terlebih dahulu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              Text(
                'Nominal *',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.38,
                ),
              ),
              const SizedBox(height: 5),
              SharedTextField(
                controller: nominalProductController,
                hintText: 'Masukkan nominal',
                validator: (String? p1) {
                  if (p1 == null || p1.isEmpty) {
                    return 'Masukkan nominal terlebih dahulu';
                  }
                  return null;
                },
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
                controller: descProductController,
                maxLines: 4,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.all(12),
                  hint: Text(
                    'Masukkan keterangan kendala (opsional)',
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
              // CustomImage().buildContentImage(
              //   title: 'Bukti Kendala',
              //   controller: controller,
              //   mediaFileList: mediaFileList,
              // ),
              // const Spacer(),
              // const SizedBox(height: 15),
              // Row(
              //   children: [
              //     Expanded(
              //       child: CustomButton.basicOutlinedButton(
              //         title: isPreviewMode && !isEdit ? 'Edit' : 'Batal',
              //         textColor: isPreviewMode && !isEdit
              //             ? Colors.red
              //             : const Color(0xFF8A5012),
              //         minimumSize: Size.fromHeight(48),
              //         side: BorderSide(
              //           color: isPreviewMode && !isEdit
              //               ? Colors.red
              //               : const Color(0xFF8A5012),
              //           width: 1,
              //         ),
              //         onPressed: () {
              //           if (isPreviewMode && !isEdit) {
              //             setState(() {
              //               isPreviewMode = false;
              //               isEdit = true;
              //             });
              //           } else {
              //             Get.back();
              //           }
              //         },
              //       ),
              //     ),
              //     SizedBox(width: 12),
              //     Expanded(
              //       child: CustomButton.basicButton(
              //         title: 'Simpan',
              //         minimumSize: Size.fromHeight(48),
              //         color: const Color(0xFF0056D2),
              //         onPressed: () {
              //           if (!isPreviewMode && isEdit && index != null) {
              //             final order = controller.itemPoAddRetur[index];

              //             final updateOrder = order.copyWith(
              //               item: nameProductController.text,
              //               qty: qtyProductController.text,
              //               note: descProductController.text,
              //               mediaFileList: mediaFileList,
              //             );

              //             controller.itemPoAddRetur[index] = updateOrder;
              //           } else {
              //             controller.itemPoAddRetur.add(
              //               ItemOrderModel(
              //                 item: nameProductController.text,
              //                 qty: qtyProductController.text,
              //                 barcode: '',
              //                 pic: StatusItem(),
              //                 checker1: StatusItem(),
              //                 checker2: StatusOrder(),
              //                 driver: StatusOrder(),
              //                 note: descProductController.text,
              //                 mediaFileList: mediaFileList,
              //               ),
              //             );
              //           }
              //           Get.back();
              //         },
              //       ),
              //     ),
              //   ],
              // ),
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
}
