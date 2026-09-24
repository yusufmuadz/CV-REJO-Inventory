import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../rit_information/domain/entities/item_order_retur_entity.dart';
import '../../controllers/home_retur_controller.dart';
import 'retur_item_form.dart';

class ReturItemDialog extends StatelessWidget {
  final HomeReturController controller;

  final int? index;

  final bool isPreview;

  final String? name;
  final String? qty;
  final String? qtyInput;
  final String? desc;

  final ItemOrderReturEntity? item;

  final RxList<XFile>? mediaFileListPreview;

  const ReturItemDialog({
    super.key,
    required this.controller,
    this.index,
    this.name,
    this.qty,
    this.qtyInput,
    this.desc,
    this.item,
    this.isPreview = false,
    this.mediaFileListPreview,
  });

  static void show({
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
    Get.dialog(
      ReturItemDialog(
        controller: controller,
        index: index,
        name: name,
        qty: qty,
        qtyInput: qtyInput,
        desc: desc,
        isPreview: isPreview,
        item: item,
        mediaFileListPreview: mediaFileListPreview,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      
        child: SizedBox(
          height: Get.height * 0.9,
          child: ReturItemForm(
            controller: controller,
            index: index,
            name: name,
            qty: qty,
            qtyInput: qtyInput,
            desc: desc,
            isPreview: isPreview,
            item: item,
            mediaFileListPreview: mediaFileListPreview,
          )
        ),
      ),
    );
  }
}
