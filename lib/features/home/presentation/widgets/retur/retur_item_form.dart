import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../shared/custom/custom_button.dart';
import '../../../../../shared/images/custom_image.dart';
import '../../../../../shared/popup/shared_header_popup.dart';
import '../../../../../shared/text_field/textfield_shared.dart';
import '../../controllers/home_retur_controller.dart';
import '../../../../rit_information/domain/entities/item_order_retur_entity.dart';

class ReturItemForm extends StatefulWidget {
  final HomeReturController controller;

  final int? index;

  final bool isRelated;
  final bool isPreview;

  final String? name;
  final String? qty;
  final String? qtyInput;
  final String? desc;

  final ItemOrderReturEntity? item;

  final RxList<XFile>? mediaFileListPreview;

  const ReturItemForm({
    super.key,
    required this.controller,
    this.index,
    this.name,
    this.qty,
    this.qtyInput,
    this.desc,
    this.item,
    this.isRelated = false,
    this.isPreview = false,
    this.mediaFileListPreview,
  });

  @override
  State<ReturItemForm> createState() => _ReturItemFormState();
}

class _ReturItemFormState extends State<ReturItemForm> {
  late final TextEditingController nameProductController;
  late final TextEditingController qtyProductController;
  late final TextEditingController qtyReturProductController;
  late final TextEditingController descProductController;
  late final RxList<XFile> mediaFileList;

  late bool isPreviewMode;

  bool isEdit = false;

  HomeReturController get controller => widget.controller;

  @override
  void initState() {
    super.initState();

    nameProductController = TextEditingController(text: widget.name);
    qtyProductController = TextEditingController(text: widget.qty);
    qtyReturProductController = TextEditingController(text: widget.qtyInput);
    descProductController = TextEditingController(text: widget.desc);

    mediaFileList = <XFile>[].obs;
    isPreviewMode = widget.isPreview;

    if (widget.isPreview) {
      mediaFileList.value = widget.mediaFileListPreview?.toList() ?? [];
    }
  }

  @override
  void dispose() {
    nameProductController.dispose();
    qtyProductController.dispose();
    qtyReturProductController.dispose();
    descProductController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 22, 15, 10),
      child: Form(
        key: controller.formKeyItem,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SharedHeaderPopup(title: 'Tambah Barang Retur'),
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
                    _buildProductNameAndQty(),
                    _buildInputQtyRetur(),
                    const SizedBox(height: 15),
                    _buildLabel(title: 'Keterangan'),
                    const SizedBox(height: 5),
                    SharedTextField(
                      isDense: true,
                      readOnly: isPreviewMode && !isEdit,
                      controller: descProductController,
                      maxLines: 4,
                      hintText: 'Masukkan alasan retur (opsional)',
                      contentPadding: const EdgeInsets.all(12),
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
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel({required String title}) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.38,
      ),
    );
  }

  Widget _buildButton() {
    return Row(
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
              if (!controller.formKeyItem.currentState!.validate() ||
                  mediaFileList.isEmpty) {
                return;
              }
              if (!isPreviewMode && isEdit && widget.index != null) {
                final order = controller.itemPoAddRetur[widget.index!];

                final updateOrder = order.copyWith(
                  name: nameProductController.text,
                  jumlahItem: qtyProductController.text,
                  description: descProductController.text,
                  mediaFileList: mediaFileList,
                );

                controller.itemPoAddRetur[widget.index!] = updateOrder;
              } else {
                controller.addItemRetur(
                  index: widget.index,
                  item: widget.item,
                  nameProductController: nameProductController,
                  qtyReturProductController: qtyReturProductController,
                  descProductController: descProductController,
                  mediaFileListRetur: mediaFileList,
                );
              }
              Get.back();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInputQtyRetur() {
    return Visibility(
      visible: widget.isRelated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          _buildLabel(title: 'Qty(Retur)*'),
          const SizedBox(height: 5),
          SharedTextField(
            readOnly: isPreviewMode && !isEdit,
            controller: qtyReturProductController,
            keyboardType: TextInputType.number,
            hintText: '0',
            validator: (String? p1) {
              if (p1 == null || p1.isEmpty) {
                return 'Masukkan jumlah barang retur terlebih dahulu';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductNameAndQty() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildLabel(title: 'Nama Barang *')),
            const SizedBox(width: 10),
            SizedBox(width: 100, child: _buildLabel(title: 'Qty(Jumlah)*')),
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
      ],
    );
  }
}
