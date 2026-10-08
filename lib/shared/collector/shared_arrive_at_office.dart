import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../shared/text_field/textfield_shared.dart';
import '../../../../shared/images/custom_image.dart';
import 'content_image_widget.dart';

class SharedArriveAtOffice extends StatelessWidget {
  final bool isDriverCollector;
  final TextEditingController recipientName;
  final TextEditingController kmController;

  final RxList<XFile> mediaFileList;
  final RxList<XFile> mediaFileListKM;
  final RxList<XFile> mediaFileListTangki;
  final RxList<XFile> mediaFileListSJ;
  final RxList<XFile> mediaFileListTransportMoney;
  final RxList<XFile> mediaFileRecipientMoneyRit;
  final RxList<XFile> mediaFileRecipientBox;

  final Rx<XFile> mediaFileFrontTransport;
  final Rx<XFile> mediaFileBackTransport;
  final Rx<XFile> mediaFileLeftTransport;
  final Rx<XFile> mediaFileRightTransport;

  const SharedArriveAtOffice({
    super.key,
    this.isDriverCollector = false,
    required this.recipientName,
    required this.kmController,
    required this.mediaFileList,
    required this.mediaFileListKM,
    required this.mediaFileListTangki,
    required this.mediaFileListSJ,
    required this.mediaFileListTransportMoney,
    required this.mediaFileRecipientMoneyRit,
    required this.mediaFileRecipientBox,
    required this.mediaFileFrontTransport,
    required this.mediaFileBackTransport,
    required this.mediaFileLeftTransport,
    required this.mediaFileRightTransport,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Masukkan Nama Penerima Berkas*',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.38,
            ),
          ),
          const SizedBox(height: 10),
          SharedTextField(
            controller: recipientName,
            hintText: 'Masukkan nama penerima*',
            validator: (String? p1) {
              if (p1 == null || p1.isEmpty) {
                return 'Masukkan nama penerima terlebih dahulu';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          ContentSharedImageWidget().buildContentImageArrive(
            title: 'KM kendaraan',
            mediaFileList: mediaFileListKM,
            mediaFileFrontTransport: mediaFileFrontTransport,
            mediaFileBackTransport: mediaFileBackTransport,
            mediaFileLeftTransport: mediaFileLeftTransport,
            mediaFileRightTransport: mediaFileRightTransport,
          ),
          const SizedBox(height: 10),
          ContentSharedImageWidget().buildInputKM(kmController: kmController),
          const SizedBox(height: 10),
          ContentSharedImageWidget().buildContentImageArrive(
            title: 'kendaraan',
            isTransportation: true,
            maxImage: 4,
            mediaFileList: mediaFileList,
            mediaFileFrontTransport: mediaFileFrontTransport,
            mediaFileBackTransport: mediaFileBackTransport,
            mediaFileLeftTransport: mediaFileLeftTransport,
            mediaFileRightTransport: mediaFileRightTransport,
          ),
          Visibility(
            visible: AppRole.isDriver && !isDriverCollector,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              child: ContentSharedImageWidget().buildContentImageArrive(
                title: 'Tangki Bahan Bakar dan Foto Segel',
                mediaFileList: mediaFileListTangki,
              ),
            ),
          ),
          const SizedBox(height: 10),
          CustomImage().buildContentImage(
            title: 'Invoice/Surat Jalan',
            mediaFileList: mediaFileListSJ,
          ),
          const SizedBox(height: 10),
          CustomImage().buildContentImage(
            title: 'Bukti Transfer/Uang Cash Pembayaran',
            mediaFileList: mediaFileListTransportMoney,
          ),
          Visibility(
            visible: AppRole.isDriver && !isDriverCollector,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              child: CustomImage().buildContentImage(
                title: 'Penggunaan Uang Perjalanan',
                mediaFileList: mediaFileRecipientMoneyRit,
              ),
            ),
          ),
          const SizedBox(height: 10),
          CustomImage().buildContentImage(
            title: 'Kotak Berkas',
            mediaFileList: mediaFileRecipientBox,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
