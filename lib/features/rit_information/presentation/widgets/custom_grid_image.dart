import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/rit_controller.dart';
import 'custom_image.dart';

class CustomGridImage extends StatelessWidget {
  final int maxImage;
  final int? plusLength;
  final Function()? onAdd;
  final Function(int) onRemove;
  final RxList<XFile> mediaFileList;

  const CustomGridImage({
    super.key,
    required this.maxImage,
    required this.mediaFileList,
    required this.onAdd,
    required this.onRemove,
    this.plusLength,
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
        itemCount: mediaFileList.length + (plusLength ?? 1),
        itemBuilder: (context, index) {
          if (index < mediaFileList.length) {
            return CustomImage().displayImage(
              path: mediaFileList[index].path,
              onTap: () => onRemove(index),
            );
          } else if (mediaFileList.length < maxImage) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: CustomImage().addImage(onTap: onAdd),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
