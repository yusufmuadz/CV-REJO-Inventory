import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/middlewares/app_role.dart';
import '../../core/theme/text_styles.dart';
import '../../features/detail_order/domain/entities/transportation_entity.dart';
import '../../features/login/domain/entities/user_entity.dart';
import '../images/custom_image.dart';
import '../text_field/textfield_shared.dart';

class SharedInputDriver extends StatelessWidget {
  final bool? isDetail;
  final String noRIT;
  final RxString statusTransportationSelected;
  final RxList<String> statusTransportations;

  final RxString driverSelected;
  final RxString assistantSelected;
  final RxString nopolTransportation;

  final RxString selectTransportation;

  final TextEditingController? extNopolTransporation;
  final TextEditingController? extDriverName;
  final TextEditingController? extDriverPhone;
  final RxList<XFile>? mediaFileList;

  final RxList<UserEntity> listUser;
  final RxList<TransportationEntity> transportations;

  final Function() onRefreshAssistant;

  const SharedInputDriver({
    super.key,
    this.isDetail,
    this.extNopolTransporation,
    this.extDriverName,
    this.extDriverPhone,
    this.mediaFileList,
    required this.noRIT,
    required this.statusTransportationSelected,
    required this.statusTransportations,
    required this.driverSelected,
    required this.assistantSelected,
    required this.nopolTransportation,
    required this.selectTransportation,
    required this.listUser,
    required this.transportations,
    required this.onRefreshAssistant,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(
        () => Column(
          children: [
            _buildNoRIT(),
            const SizedBox(height: 23),
            Visibility(
              visible: AppRole.isChecker2,
              child: _buildSelectStatusTransportation(),
            ),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  // PILIH STATUS ARMADA
  Widget _buildSelectStatusTransportation() {
    if (isDetail == true) {
      statusTransportationSelected.value = 'Internal';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(title: 'Pilih Status Armada'),
        const SizedBox(height: 5),
        _buildDropdown(
          title: 'Status Armada',
          selectedValue: statusTransportationSelected.value,
          items: statusTransportations.map<DropdownMenuItem<String>>((item) {
            return _buildMenuItem(item: item);
          }).toList(),
          onChanged: isDetail == true
              ? null
              : (value) {
                  statusTransportationSelected.value = value.toString();
                },
        ),
        const SizedBox(height: 23),
      ],
    );
  }

  // BUILD CONTENT
  Widget _buildContent() {
    if (AppRole.isChecker2 &&
        statusTransportationSelected.value == 'External') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '*Masukkan informasi pengirim per-PO diakhir proses',
            textAlign: TextAlign.center,
            style: TextStyles.basicTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: Colors.red,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            '*Jika ada perubahan dari External ke Internal, silakan hubungi Admin untuk informasi lebih lanjut',
            textAlign: TextAlign.center,
            style: TextStyles.basicTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: Colors.red,
            ),
          ),
        ],
      );
    }

    if (AppRole.isChecker2 && statusTransportationSelected.value == 'null') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(title: 'Masukkan Nopol*', color: Color(0xFF1F2937)),
          const SizedBox(height: 5),
          Container(
            height: 40,
            margin: const EdgeInsets.only(top: 2),
            child: SharedTextField(
              radius: 8,
              controller: extNopolTransporation!,
              hintText: 'Nopol Kendaraan',
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              textStyle: TextStyles.basicTextStyle(
                height: 1.5,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
                fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildTitle(title: 'Nama Driver*', color: Color(0xFF1F2937)),
          const SizedBox(height: 5),
          Container(
            height: 40,
            margin: const EdgeInsets.only(top: 2),
            child: SharedTextField(
              radius: 8,
              controller: extDriverName!,
              hintText: 'Masukkan Nama Driver',
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              textStyle: TextStyles.basicTextStyle(
                height: 1.5,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
                fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
              ),
            ),
          ),
          const SizedBox(height: 20),
          CustomImage().buildContentImage(
            title: 'Muatan/Semua barang',
            mediaFileList: <XFile>[].obs,
          ),
          const SizedBox(height: 10),
          CustomImage().buildContentImage(
            title: 'Kendaraan',
            mediaFileList: <XFile>[].obs,
          ),
          const SizedBox(height: 10),
          CustomImage().buildContentImage(
            title: 'Surat Jalan/Invoice',
            mediaFileList: <XFile>[].obs,
          ),
          const SizedBox(height: 10),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(title: 'Nama Driver'),
        const SizedBox(height: 5),
        _buildDropdown(
          title: 'Driver',
          selectedValue:
              driverSelected.value.isEmpty || driverSelected.value == '-'
              ? listUser.first.nama
              : driverSelected.value,
          items: listUser.map<DropdownMenuItem<String>>((item) {
            return _buildMenuItem(item: item.nama);
          }).toList(),
          onChanged: (value) {
            driverSelected.value = value.toString();
          },
        ),
        const SizedBox(height: 23),
        _buildTitle(title: 'Kendaraan'),
        const SizedBox(height: 5),
        _buildTransportation(),
        Visibility(
          visible: AppRole.isChecker2,
          child: _buildNopolTransportation(),
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Center(
            child: IconButton(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              onPressed: () => onRefreshAssistant(),
              icon: const Icon(Icons.refresh, color: Colors.blue),
            ),
          ),
        ),
        Center(
          child: Text(
            'Refresh untuk melihat data terbaru',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTransportation() {
    if (AppRole.isChecker2) {
      return _buildDropdown(
        title: 'Kendaraan',
        isNotTransportation: false,
        selectedValue:
            selectTransportation.value.isEmpty ||
                selectTransportation.value == '-'
            ? transportations.first.jenisKendaraan ?? '-'
            : selectTransportation.value,
        items: transportations.map<DropdownMenuItem<String>>((item) {
          return _buildMenuItemTransportation(
            item: item.jenisKendaraan ?? '-',
            plat: item.idDeliveryMobil ?? '-',
          );
        }).toList(),
        onChanged: (value) {
          selectTransportation.value = value.toString();
          if (value.toString() != '-') {
            final transportation = transportations;
            final index = transportation.indexWhere(
              (element) => element.jenisKendaraan == value.toString(),
            );
            nopolTransportation.value =
                transportation[index].idDeliveryMobil ?? '-';
          }
        },
      );
    }

    return _buildDropdown(
      title: 'Kendaraan',
      isNotTransportation: false,
      selectedValue: selectTransportation.value.isEmpty
          ? transportations.first.namaKendaraan ?? '-'
          : selectTransportation.value,
      items: transportations.map<DropdownMenuItem<String>>((item) {
        if (AppRole.isPIC) {
          return _buildMenuItem(item: item.namaKendaraan ?? '-');
        }
        return _buildMenuItemTransportation(
          item: item.namaKendaraan ?? '-',
          plat: item.idDeliveryMobil ?? '-',
        );
      }).toList(),
      onChanged: (value) {
        selectTransportation.value = value.toString();
      },
    );
  }

  // WIDGET
  Widget _buildTitle({required String title, double? size = 15, Color? color}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }

  Widget _buildDropdown({
    required String title,
    required List<DropdownMenuItem<String>> items,
    required String selectedValue,
    Function(Object?)? onChanged,
    bool? isNotTransportation = true,
  }) {
    return Container(
      height: isNotTransportation == true ? 45 : 50,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(7),
      ),
      child: DropdownButton(
        isDense: isNotTransportation ?? true,
        isExpanded: true,
        hint: Text('Pilih $title'),
        icon: const Icon(Icons.arrow_drop_down),
        underline: Container(),
        padding: EdgeInsets.zero,
        value: selectedValue.isEmpty ? items.first : selectedValue,
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  DropdownMenuItem<String> _buildMenuItem({required String item}) {
    return DropdownMenuItem(
      value: item,
      child: Text(
        item.capitalizeFirst ?? '-',
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  DropdownMenuItem<String> _buildMenuItemTransportation({
    required String item,
    required String plat,
  }) {
    return DropdownMenuItem(
      value: item,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.capitalizeFirst ?? '-',
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            plat,
            style: const TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoRIT() {
    return Container(
      height: 45,
      padding: EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        'RIT - $noRIT',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildNopolTransportation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 23),
        _buildTitle(title: 'Nopol Kendaraan'),
        const SizedBox(height: 5),
        Container(
          height: 45,
          padding: EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            nopolTransportation.value.isEmpty
                ? transportations.first.idDeliveryMobil ?? '-'
                : nopolTransportation.value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 178, 155, 155),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'No. Polisi Kendaraan otomatis terisi saat memilih kendaraan*',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
