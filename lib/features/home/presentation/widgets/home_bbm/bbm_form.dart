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
  late final RxList<XFile> mediaFileListFront;
  late final RxList<XFile> mediaFilesAwalSegel;
  late final RxList<XFile> mediaFilesDispenserAwalPengisian;
  late final RxList<XFile> mediaFilesPengisianTangkiFull;
  late final RxList<XFile> mediaFilesDispenserAkhirPengisian;
  late final RxList<XFile> mediaFilesSegelBaru;
  late final RxList<XFile> mediaFilesNota;

  late bool isPreviewMode;

  HomeController get homeController => widget.homeController;
  HomeBbmController get controller => widget.homeController.homeBbmController;

  RxString get date => controller.date;

  TextEditingController get isiAwalController => controller.isiAwalController;
  TextEditingController get inputNopolController =>
      controller.inputNopolController;
  TextEditingController get descController => controller.descController;

  @override
  initState() {
    super.initState();

    date.value =
        widget.date ?? DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.now());

    mediaFileListFront = <XFile>[].obs;
    mediaFilesAwalSegel = <XFile>[].obs;
    mediaFilesDispenserAwalPengisian = <XFile>[].obs;
    mediaFilesPengisianTangkiFull = <XFile>[].obs;
    mediaFilesDispenserAkhirPengisian = <XFile>[].obs;
    mediaFilesSegelBaru = <XFile>[].obs;
    mediaFilesNota = <XFile>[].obs;

    isPreviewMode = widget.isPreviewMode;

    if (widget.isPreviewMode) {
      isiAwalController.text = widget.isiAwal ?? '';
      inputNopolController.text = widget.inputNopol ?? '';
      descController.text = widget.desc ?? '';

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
    isiAwalController.dispose();
    inputNopolController.dispose();
    descController.dispose();

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
            isReadOnly: isPreviewMode,
            title: 'Isi Awal',
            controller: isiAwalController,
          ),
          const SizedBox(height: 15),
          _buildTitleField(
            isReadOnly: isPreviewMode,
            title: 'Nomor Polisi / Nopol',
            controller: inputNopolController,
          ),
          const SizedBox(height: 15),
          CustomImage().buildContentImage(
            title: 'Depan',
            readOnly: isPreviewMode,
            isPreview: isPreviewMode,
            mediaFileList: mediaFileListFront,
          ),
          const SizedBox(height: 15),
          CustomImage().buildContentImage(
            title: 'Awal Segel',
            readOnly: isPreviewMode,
            isPreview: isPreviewMode,
            mediaFileList: mediaFilesAwalSegel,
          ),
          const SizedBox(height: 15),
          CustomImage().buildContentImage(
            title: 'Dispenser Awal Pengisian',
            readOnly: isPreviewMode,
            isPreview: isPreviewMode,
            mediaFileList: mediaFilesDispenserAwalPengisian,
          ),
          const SizedBox(height: 15),
          CustomImage().buildContentImage(
            title: 'Pengisian Tangki Full',
            readOnly: isPreviewMode,
            isPreview: isPreviewMode,
            mediaFileList: mediaFilesPengisianTangkiFull,
          ),
          const SizedBox(height: 15),
          CustomImage().buildContentImage(
            title: 'Dispenser Akhir Pengisian',
            readOnly: isPreviewMode,
            isPreview: isPreviewMode,
            mediaFileList: mediaFilesDispenserAkhirPengisian,
          ),
          const SizedBox(height: 15),
          CustomImage().buildContentImage(
            title: 'Segel Baru',
            readOnly: isPreviewMode,
            isPreview: isPreviewMode,
            mediaFileList: mediaFilesSegelBaru,
          ),
          const SizedBox(height: 15),
          CustomImage().buildContentImage(
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
  }) {
    String titleField = '$title*';
    String hintText = 'Masukkan $title';
    TextInputType? keyboardType;
    Color fillColor = Colors.white70;
    List<TextInputFormatter>? inputFormatters;

    if (title == 'Nominal') {
      keyboardType = TextInputType.number;
      inputFormatters = [ThousandsSeparatorInputFormatter()];
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
                validator: isReadOnly || isDesc == true
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
