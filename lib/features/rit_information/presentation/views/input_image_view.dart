import 'package:flutter/material.dart';

import '../../../../core/middlewares/app_role.dart';
import '../controllers/rit_controller.dart';
import '../widgets/arrive_image_widget.dart';

class InputImageView extends StatelessWidget {
  final RitController controller;
  const InputImageView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ArriveImageWidget().buildContentImageArrive(
          title: 'kendaraan',
          isTransportation: true,
          maxImage: 4,
          mediaFileList: controller.mediaFileList,
          controller: controller,
        ),
        const SizedBox(height: 10),
        ArriveImageWidget().buildContentImageArrive(
          title: 'KM kendaraan',
          mediaFileList: controller.mediaFileListKM,
          controller: controller,
        ),

        const SizedBox(height: 10),
        ArriveImageWidget().buildInputKM(controller: controller),
        const SizedBox(height: 10),
        _buildImage(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildImage() {
    if (AppRole.isCollector) {
      return ArriveImageWidget().buildContentImageArrive(
        title: 'Surat/dokumen yang dibawa',
        mediaFileList: controller.mediaFileListInvoice,
        controller: controller,
      );
    }

    return Column(
      children: [
        ArriveImageWidget().buildContentImageArrive(
          title: 'Tangki Bahan Bakar dan Foto Segel',
          mediaFileList: controller.mediaFileListTangki,
          controller: controller,
        ),
        const SizedBox(height: 10),
        ArriveImageWidget().buildContentImageArrive(
          title: 'Surat Jalan',
          mediaFileList: controller.mediaFileListSJ,
          controller: controller,
        ),
        const SizedBox(height: 10),
        ArriveImageWidget().buildContentImageArrive(
          title: 'Sangu',
          mediaFileList: controller.mediaFileListTransportMoney,
          controller: controller,
        ),
      ],
    );
  }
}
