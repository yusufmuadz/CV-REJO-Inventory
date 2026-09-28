import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/custom/custom_button.dart';
import '../../../../../shared/popup/shared_header_popup.dart';
import '../../../domain/entities/bbm_entity.dart';
import '../../controllers/home_controller.dart';
import 'bbm_form.dart';

class BbmContent extends StatelessWidget {
  final HomeController homeController;
  final bool? isPreviewMode;

  final String? isiAwal;
  final String? inputNopol;
  final String? date;
  final String? desc;
  final String? rit;
  final String? routeRit;

  final List<XFile>? filesFront;
  final List<XFile>? filesAwalSegel;
  final List<XFile>? filesDispenserAwalPengisian;
  final List<XFile>? filesPengisianTangkiFull;
  final List<XFile>? filesDispenserAkhirPengisian;
  final List<XFile>? filesSegelBaru;
  final List<XFile>? filesNota;

  const BbmContent({
    super.key,
    required this.homeController,
    this.isPreviewMode,
    this.isiAwal,
    this.inputNopol,
    this.date,
    this.desc,
    this.rit,
    this.routeRit,
    this.filesFront,
    this.filesAwalSegel,
    this.filesDispenserAwalPengisian,
    this.filesPengisianTangkiFull,
    this.filesDispenserAkhirPengisian,
    this.filesSegelBaru,
    this.filesNota,
  });

  @override
  Widget build(BuildContext context) {
    final controller = homeController.homeBbmController;

    return Padding(
      padding: EdgeInsets.fromLTRB(15, 22, 15, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SharedHeaderPopup(title: 'Masukkan Informasi BBM'),
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
                  BbmForm(
                    homeController: homeController,
                    isPreviewMode: isPreviewMode ?? false,
                  ),
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
                final dateFormat = DateFormat(
                  'dd MMMM yyyy, HH:mm',
                ).parse(controller.date.value);

                controller.addBbm(
                  BbmEntitity(
                    isiAwal: controller.isiAwalController.text,
                    inputNopol: controller.inputNopolController.text,
                    date: dateFormat,
                    desc: controller.descController.text,
                    rit: homeController.rit.value,
                    routeRit: homeController.routeRit.value,
                    mediaFilesFront: controller.mediaFileListFront.toList(),
                    mediaFilesAwalSegel: controller.mediaFilesAwalSegel
                        .toList(),
                    mediaFilesDispenserAwalPengisian: controller
                        .mediaFilesDispenserAwalPengisian
                        .toList(),
                    mediaFilesPengisianTangkiFull: controller
                        .mediaFilesPengisianTangkiFull
                        .toList(),
                    mediaFilesDispenserAkhirPengisian: controller
                        .mediaFilesDispenserAkhirPengisian
                        .toList(),
                    mediaFilesSegelBaru: controller.mediaFilesSegelBaru
                        .toList(),
                    mediaFilesNota: controller.mediaFilesNota.toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
