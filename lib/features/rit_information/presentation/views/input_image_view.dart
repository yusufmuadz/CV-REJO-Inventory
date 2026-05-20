import 'package:cv_rejo/shared/custom/custom_button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/text_field/textfield_shared.dart';
import '../controllers/rit_controller.dart';
import '../widgets/custom_image.dart';

class InputImageView extends StatelessWidget {
  final RitController controller;
  const InputImageView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildContentImageNew(
          title: 'kendaraan',
          isTransportation: true,
          maxImage: 4,
          mediaFileList: controller.mediaFileList,
        ),
        const SizedBox(height: 10),
        _buildContentImageNew(
          title: 'KM kendaraan',
          mediaFileList: controller.mediaFileListKM,
        ),

        const SizedBox(height: 10),
        _buildInputKM(),
        const SizedBox(height: 10),
        _buildContentImageNew(
          title: 'Tangki Bahan Bakar dan Foto Segel',
          mediaFileList: controller.mediaFileListTangki,
        ),
        const SizedBox(height: 10),
        _buildContentImageNew(
          title: 'Surat Jalan',
          mediaFileList: controller.mediaFileListSJ,
        ),
        const SizedBox(height: 10),
        _buildContentImageNew(
          title: 'Invoice',
          mediaFileList: controller.mediaFileListSJ,
        ),
        const SizedBox(height: 10),
        _buildContentImageNew(
          title: 'Sangu',
          mediaFileList: controller.mediaFileListSJ,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildBoxStyle({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFf4f4f5)),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildInputKM() {
    return _buildBoxStyle(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Masukkan KM kendaraan',
            style: GoogleFonts.hankenGrotesk(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.48,
            ),
          ),
          const SizedBox(height: 6),
          SharedTextField(
            controller: controller.kmController,
            keyboardType: TextInputType.number,
            hintText: 'Contoh: 12345',
            prefixIcon: Icon(Icons.speed, color: const Color(0xFFfa913c)),
            validator: (String? p1) {
              if (p1 == null || p1.isEmpty) {
                return 'Masukkan KM Kendaraan';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImage({
    required RxList<XFile> mediaFileList,
    Rx<XFile>? file,
    bool isTransportation = false,
  }) {
    return InkWell(
      onTap: () => isTransportation
          ? null
          : controller.selectImage(ImageSource.camera, file, mediaFileList),
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          color: const Color(0xFFffd8ab),
          strokeWidth: 1.5,
          padding: EdgeInsets.all(3),
          dashPattern: const [5, 3.5],
          strokeCap: StrokeCap.round,
          radius: const Radius.circular(10),
        ),
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFfffdfa),
          ),
          child: Center(
            child: Icon(
              Icons.camera_alt_outlined,
              color: const Color(0xFFfa913c),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentImageNew({
    int? maxImage,
    bool isPopup = false,
    bool isTransportation = false,
    int? indexImage,
    String pathImage = '',
    Rx<XFile>? file,
    required String title,
    required RxList<XFile> mediaFileList,
  }) {
    return _buildBoxStyle(
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: mediaFileList.isNotEmpty && !isPopup,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [
                    Expanded(child: CustomImage().buildTitle(title: title)),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(top: 10),
                      child: InkWell(
                        onTap: () => controller.clearAllImages(mediaFileList, isTransportation),
                        child: const Text(
                          'Hapus Semua',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: mediaFileList.isNotEmpty && !isPopup,
              child: CustomImage().contentImage(
                maxImage: maxImage,
                controller: controller,
                mediaFileList: mediaFileList,
                isTransportation: isTransportation,
                onTap: () => popUpUploadImageTransportation(),
              ),
            ),
            Visibility(
              visible: pathImage.isNotEmpty && isPopup,
              child: Row(
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: CustomImage().displayImage(
                      path: pathImage,
                      onTap: () => controller.removeImage(
                        indexImage ?? 0,
                        file,
                        mediaFileList,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: CustomImage().buildTitle(title: title)),
                ],
              ),
            ),
            Visibility(
              visible:
                  (mediaFileList.isEmpty && !isPopup) ||
                  (isPopup && pathImage.isEmpty),
              child: InkWell(
                onTap: () =>
                    isTransportation ? popUpUploadImageTransportation() : null,
                child: Row(
                  children: [
                    _buildImage(
                      file: file,
                      mediaFileList: mediaFileList,
                      isTransportation: isTransportation,
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: CustomImage().buildTitle(title: title)),
                    Visibility(
                      visible: isTransportation,
                      child: Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> popUpUploadImageTransportation() {
    return Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32),
          topLeft: Radius.circular(32),
        ),
      ),
      Obx(() {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const SizedBox(width: 40),
                  Expanded(
                    child: Text(
                      'Tambah Foto Kendaraan',
                      style: GoogleFonts.hankenGrotesk(
                        color: const Color(0xFF111827),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.48,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF3F4F6),
                      ),
                      child: Icon(Icons.close, color: const Color(0xFF4B5563)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFf0f6ff),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFDBEAFE),
                      ),
                      child: const Icon(
                        Icons.info_outlined,
                        size: 20,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Pastikan semua foto terlihat jelas dan tidak terpotong.',
                        style: GoogleFonts.hankenGrotesk(
                          color: const Color(0xFF1E40AF),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.48,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildContentImageNew(
                maxImage: 1,
                isPopup: true,
                file: controller.mediaFileFrontTransport,
                title: 'Depan Kendaraan',
                pathImage: controller.mediaFileFrontTransport.value.path,
                mediaFileList: controller.mediaFileList,
              ),
              const SizedBox(height: 10),
              _buildContentImageNew(
                maxImage: 1,
                isPopup: true,
                file: controller.mediaFileRightTransport,
                title: 'Kanan Kendaraan',
                pathImage: controller.mediaFileRightTransport.value.path,
                mediaFileList: controller.mediaFileList,
              ),
              const SizedBox(height: 10),
              _buildContentImageNew(
                maxImage: 1,
                isPopup: true,
                file: controller.mediaFileBackTransport,
                title: 'Belakang Kendaraan',
                pathImage: controller.mediaFileBackTransport.value.path,
                mediaFileList: controller.mediaFileList,
              ),
              const SizedBox(height: 10),
              _buildContentImageNew(
                maxImage: 1,
                isPopup: true,
                file: controller.mediaFileLeftTransport,
                title: 'Kiri Kendaraan',
                pathImage: controller.mediaFileLeftTransport.value.path,
                mediaFileList: controller.mediaFileList,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: Get.width,
                child: CustomButton.basicButton(
                  title: 'Simpan',
                  color: const Color(0xFFd68f4d),
                  onPressed: () => controller.saveImageTransportation(),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
