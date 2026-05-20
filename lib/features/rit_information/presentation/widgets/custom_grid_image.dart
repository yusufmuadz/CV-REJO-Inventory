import 'dart:io';

import 'package:cv_rejo/features/rit_information/presentation/widgets/custom_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/rit_controller.dart';

class CustomGridImage extends StatelessWidget {
  final int maxImage;
  final bool isTransportation;
  final Function()? onTap;
  final RxList<XFile> mediaFileList;
  final RitController controller;

  const CustomGridImage({
    super.key,
    required this.maxImage,
    required this.mediaFileList,
    required this.controller,
    this.isTransportation = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: mediaFileList.length + (isTransportation ? 0 : 1),
        itemBuilder: (context, index) {
          if (index < mediaFileList.length) {
            return CustomImage().displayImage(
              path: mediaFileList[index].path,
              isTransportation: isTransportation,
              onTap: () => controller.removeImage(index, null, mediaFileList, isTransportation),
            );
          } else if (mediaFileList.length < maxImage) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: _buildImage(
                mediaFileList: mediaFileList,
                isTransportation: isTransportation,
                onTap: onTap,
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildImage({
    required RxList<XFile> mediaFileList,
    bool isTransportation = false,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: isTransportation
          ? onTap
          : () =>
                controller.selectImage(ImageSource.camera, null, mediaFileList),
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
}
