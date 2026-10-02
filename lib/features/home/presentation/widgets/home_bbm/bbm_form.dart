import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/images/custom_image.dart';
import '../../../../../shared/text_field/textfield_shared.dart';
import '../../../../../utils/thousand_formatter.dart';
import '../../controllers/home_bbm_controller.dart';
import '../../controllers/home_controller.dart';

class BbmForm extends StatefulWidget {
  final HomeController homeController;

  final bool isPreviewMode;

  final String? isiAwal;
  final String? inputNopol;
  final String? date;
  final String? desc;
  final String? nominal;
  final String? paymentMethod;
  final String? rit;
  final String? routeRit;

  final List<XFile>? filesFront;
  final List<XFile>? filesAwalSegel;
  final List<XFile>? filesDispenserAwalPengisian;
  final List<XFile>? filesPengisianTangkiFull;
  final List<XFile>? filesDispenserAkhirPengisian;
  final List<XFile>? filesSegelBaru;
  final List<XFile>? filesNota;

  const BbmForm({
    super.key,
    required this.homeController,
    required this.isPreviewMode,
    this.isiAwal,
    this.inputNopol,
    this.date,
    this.desc,
    this.nominal,
    this.paymentMethod,
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
  State<BbmForm> createState() => _BbmFormState();
}

class _BbmFormState extends State<BbmForm> {
  late bool isPreviewMode;

  HomeController get homeController => widget.homeController;
  HomeBbmController get controller => widget.homeController.homeBbmController;

  RxString get date => controller.date;

  TextEditingController get isiAwalController => controller.isiAwalController;
  TextEditingController get inputNopolController =>
      controller.inputNopolController;
  TextEditingController get descController => controller.descController;
  TextEditingController get nominalController => controller.nominalController;
  TextEditingController get paymentMethodController =>
      controller.paymentMethodController;

  RxList<XFile> get mediaFileListFront => controller.mediaFileListFront;
  RxList<XFile> get mediaFilesAwalSegel => controller.mediaFilesAwalSegel;
  RxList<XFile> get mediaFilesDispenserAwalPengisian =>
      controller.mediaFilesDispenserAwalPengisian;
  RxList<XFile> get mediaFilesPengisianTangkiFull =>
      controller.mediaFilesPengisianTangkiFull;
  RxList<XFile> get mediaFilesDispenserAkhirPengisian =>
      controller.mediaFilesDispenserAkhirPengisian;
  RxList<XFile> get mediaFilesSegelBaru => controller.mediaFilesSegelBaru;
  RxList<XFile> get mediaFilesNota => controller.mediaFilesNota;

  @override
  initState() {
    super.initState();

    date.value =
        widget.date ?? DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.now());

    isPreviewMode = widget.isPreviewMode;

    if (widget.isPreviewMode) {
      isiAwalController.text = widget.isiAwal ?? '';
      inputNopolController.text = widget.inputNopol ?? '';
      descController.text = widget.desc ?? '';
      nominalController.text = widget.nominal ?? '';
      paymentMethodController.text = widget.paymentMethod ?? '';

      if (widget.filesFront != null && widget.filesFront!.isNotEmpty) {
        mediaFileListFront.value = widget.filesFront!;
      }

      if (widget.filesAwalSegel != null && widget.filesAwalSegel!.isNotEmpty) {
        mediaFilesAwalSegel.value = widget.filesAwalSegel!;
      }

      if (widget.filesDispenserAwalPengisian != null &&
          widget.filesDispenserAwalPengisian!.isNotEmpty) {
        mediaFilesDispenserAwalPengisian.value =
            widget.filesDispenserAwalPengisian!;
      }

      if (widget.filesPengisianTangkiFull != null &&
          widget.filesPengisianTangkiFull!.isNotEmpty) {
        mediaFilesPengisianTangkiFull.value = widget.filesPengisianTangkiFull!;
      }

      if (widget.filesDispenserAkhirPengisian != null &&
          widget.filesDispenserAkhirPengisian!.isNotEmpty) {
        mediaFilesDispenserAkhirPengisian.value =
            widget.filesDispenserAkhirPengisian!;
      }

      if (widget.filesSegelBaru != null && widget.filesSegelBaru!.isNotEmpty) {
        mediaFilesSegelBaru.value = widget.filesSegelBaru!;
      }

      if (widget.filesNota != null && widget.filesNota!.isNotEmpty) {
        mediaFilesNota.value = widget.filesNota!;
      }
    }
  }

  @override
  dispose() {
    if (!isPreviewMode) {
      // controller.clearForm();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleField(
            isReadOnly: true,
            title: 'Tanggal laporan',
            controller: TextEditingController(text: date.value),
          ),
          const SizedBox(height: 15),
          _buildTitleField(
            isRit: true,
            isReadOnly: true,
            title: 'Nomor RIT',
            routeRit: widget.routeRit ?? widget.homeController.routeRit.value,
            controller: TextEditingController(
              text: widget.rit ?? widget.homeController.rit.value,
            ),
          ),
          const SizedBox(height: 15),
          _buildTitleField(
            isNumber: true,
            isReadOnly: isPreviewMode,
            title: 'Isi KM Awal',
            controller: isiAwalController,
          ),
          const SizedBox(height: 15),
          _buildTitleField(
            isReadOnly: isPreviewMode,
            title: 'Nomor Polisi / Nopol',
            controller: inputNopolController,
          ),
          const SizedBox(height: 15),
          _buildTitleField(
            isNumber: true,
            isReadOnly: isPreviewMode,
            title: 'Nominal',
            controller: nominalController,
          ),
          const SizedBox(height: 15),
          _buildTitleField(
            isReadOnly: isPreviewMode,
            title: 'Tipe Pembayaran',
            controller: paymentMethodController,
          ),
          const SizedBox(height: 15),
          CustomImage().buildContentImage(
            maxImage: 1,
            title: 'Depan',
            readOnly: isPreviewMode,
            isPreview: isPreviewMode,
            mediaFileList: mediaFileListFront,
          ),
          const SizedBox(height: 15),
          CustomImage().buildContentImage(
            maxImage: 1,
            title: 'Awal Segel',
            readOnly: isPreviewMode,
            isPreview: isPreviewMode,
            mediaFileList: mediaFilesAwalSegel,
          ),
          const SizedBox(height: 15),
          CustomImage().buildContentImage(
            maxImage: 1,
            title: 'Dispenser Awal Pengisian(angka:0)',
            readOnly: isPreviewMode,
            isPreview: isPreviewMode,
            mediaFileList: mediaFilesDispenserAwalPengisian,
          ),
          const SizedBox(height: 15),
          CustomImage().buildContentImage(
            maxImage: 1,
            title: 'Pengisian Tangki Full',
            readOnly: isPreviewMode,
            isPreview: isPreviewMode,
            mediaFileList: mediaFilesPengisianTangkiFull,
          ),
          const SizedBox(height: 15),
          CustomImage().buildContentImage(
            maxImage: 1,
            title: 'Dispenser Akhir Pengisian',
            readOnly: isPreviewMode,
            isPreview: isPreviewMode,
            mediaFileList: mediaFilesDispenserAkhirPengisian,
          ),
          const SizedBox(height: 15),
          CustomImage().buildContentImage(
            maxImage: 1,
            title: 'Segel Baru',
            readOnly: isPreviewMode,
            isPreview: isPreviewMode,
            mediaFileList: mediaFilesSegelBaru,
          ),
          const SizedBox(height: 15),
          CustomImage().buildContentImage(
            maxImage: 1,
            title: 'Nota',
            readOnly: isPreviewMode,
            isPreview: isPreviewMode,
            mediaFileList: mediaFilesNota,
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField({
    required bool isReadOnly,
    required String title,
    required TextEditingController controller,
    String? routeRit,
    bool? isDesc = false,
    bool? isRit = false,
    bool? isNumber = false,
    bool? isMandatory = false,
  }) {
    String titleField = '$title*';
    String hintText = 'Masukkan $title';
    TextInputType? keyboardType;
    Color fillColor = Colors.white70;
    List<TextInputFormatter>? inputFormatters;

    if (isNumber == true) {
      keyboardType = TextInputType.number;
      inputFormatters = [FilteringTextInputFormatter.digitsOnly];
    }

    if (isReadOnly) {
      fillColor = const Color(0xFFf0f3ff);
    }

    if (isDesc == true) {
      titleField = title;
      hintText = 'Masukkan keterangan kendala (opsional)';
    }

    if (isRit == true) {
      hintText = '-';
    }

    if (isMandatory == false) {
      titleField = title;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                titleField,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.38,
                ),
              ),
            ),
            Visibility(
              visible: isRit == true,
              child: Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Rute',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.38,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: SharedTextField(
                isDense: isDesc,
                readOnly: isReadOnly,
                maxLines: isDesc == true ? 4 : null,
                fillColor: fillColor,
                controller: controller,
                hintText: hintText,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                contentPadding: isDesc == true
                    ? const EdgeInsets.all(12)
                    : null,
                validator: isReadOnly || isDesc == true || isMandatory == false
                    ? null
                    : (String? p1) {
                        if (p1 == null || p1.isEmpty) {
                          return 'Masukkan $title terlebih dahulu';
                        }
                        return null;
                      },
              ),
            ),
            Visibility(
              visible: isRit == true,
              child: Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: SharedTextField(
                    isDense: false,
                    readOnly: true,
                    hintText: '-',
                    fillColor: fillColor,
                    controller: TextEditingController(text: routeRit ?? '-'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
