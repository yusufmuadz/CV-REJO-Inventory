import 'package:cv_rejo/features/home/presentation/widgets/retur/retur_item_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_retur_controller.dart';
import 'retur_item_dialog.dart';

class ReturItemList extends StatelessWidget {
  final HomeReturController controller;

  const ReturItemList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                child: ReturItemHeader(
                  isRelated: false,
                  isCheckbox: false,
                  valueCheckbox: false,
                  controller: controller,
                  onChanged: (value) {
                    // controller.selectAll();
                  },
                ),
              ),
              Obx(
                () => ListView.separated(
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
                          ReturItemDialog.show(
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
                        child: ReturItemHeader(
                          isRelated: false,
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
