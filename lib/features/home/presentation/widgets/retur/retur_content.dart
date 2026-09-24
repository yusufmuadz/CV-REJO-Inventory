import 'package:cv_rejo/shared/popup/shared_header_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/custom/custom_button.dart';
import '../../controllers/home_retur_controller.dart';
import 'retur_form.dart';

class ReturContent extends StatelessWidget {
  final HomeReturController controller;

  const ReturContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 22, 15, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SharedHeaderPopup(title: 'Masukkan Informasi Retur'),
          Container(
            height: 1,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10),
            color: Colors.grey.shade100,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 13),
                  ReturForm(controller: controller),
                ],
              ),
            ),
          ),
          // const Spacer(),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: CustomButton.basicButton(
              title: 'Simpan',
              color: const Color(0xFF2ED471),
              onPressed: () {
                if (!controller.formKey.currentState!.validate()) {
                  return;
                }

                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }
}
