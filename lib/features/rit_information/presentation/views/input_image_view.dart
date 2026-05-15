import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        _buildContentImage(
          title: 'kendaraan',
          mediaFileList: controller.mediaFileList,
        ),
        const SizedBox(height: 20),
        _buildContentImage(
          title: 'KM kendaraan',
          mediaFileList: controller.mediaFileListKM,
        ),
        const SizedBox(height: 20),
        const Text(
          'Masukkan KM kendaraan',
          style: TextStyle(
            color: Color(0xFF171717),
            fontSize: 15,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 0,
            letterSpacing: 0.48,
          ),
        ),
        const SizedBox(height: 6),
        SharedTextField(
          controller: controller.kmController,
          keyboardType: TextInputType.number,
          labelText: '',
          prefixIcon: null,
          validator: (String? p1) {
            if (p1 == null || p1.isEmpty) {
              return 'Masukkan KM Kendaraan';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildContentImage(
          title: 'Tangki Bahan Bakar dan Foto Segel',
          mediaFileList: controller.mediaFileListTangki,
        ),
        const SizedBox(height: 20),
        _buildContentImage(
          title: 'Surat Jalan, Foto Invoice, Foto Sangu',
          mediaFileList: controller.mediaFileListSJ,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildContentImage({
    required String title,
    required RxList<XFile> mediaFileList,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unggah Foto $title',
          style: TextStyle(
            color: Color(0xFF171717),
            fontSize: 15,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 0,
            letterSpacing: 0.48,
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          '*Upload minimal 1 foto',
          style: TextStyle(
            color: Colors.red,
            fontSize: 10,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
          ),
        ),
        Obx(
          () => Visibility(
            visible: mediaFileList.isNotEmpty,
            child: Container(
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
          ),
        ),
        const SizedBox(height: 5),
        Obx(
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
                        onTap: () =>
                            controller.removeImage(index, mediaFileList),
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
                  child: InkWell(
                    onTap: () => controller.selectImage(
                      ImageSource.camera,
                      mediaFileList,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.grey[200],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}
