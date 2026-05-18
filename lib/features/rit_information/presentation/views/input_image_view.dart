import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/text_field/textfield_shared.dart';
import '../controllers/rit_controller.dart';

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

  Widget _buildTitle({required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unggah Foto $title',
          style: GoogleFonts.hankenGrotesk(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.48,
          ),
        ),
        Text(
          '*Upload minimal 1 foto',
          style: GoogleFonts.hankenGrotesk(
            color: Colors.red,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildImage({required RxList<XFile> mediaFileList}) {
    return InkWell(
      onTap: () => controller.selectImage(ImageSource.camera, mediaFileList),
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
    required String title,
    required RxList<XFile> mediaFileList,
  }) {
    return _buildBoxStyle(
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: mediaFileList.isNotEmpty,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [
                    Expanded(child: _buildTitle(title: title)),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(top: 10),
                      child: InkWell(
                        onTap: () => controller.clearAllImages(mediaFileList),
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
              visible: mediaFileList.isNotEmpty,
              child: _buildContentImage(
                mediaFileList: mediaFileList,
                title: title,
              ),
            ),
            Visibility(
              visible: mediaFileList.isEmpty,
              child: Row(
                children: [
                  _buildImage(mediaFileList: mediaFileList),
                  const SizedBox(width: 10),
                  Expanded(child: _buildTitle(title: title)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentImage({
    required String title,
    required RxList<XFile> mediaFileList,
  }) {
    return Obx(
      () => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: mediaFileList.length + 1,
        itemBuilder: (context, index) {
          if (index < mediaFileList.length) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.file(
                      File(mediaFileList[index].path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => controller.removeImage(index, mediaFileList),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (mediaFileList.length < 2) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: _buildImage(mediaFileList: mediaFileList),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
