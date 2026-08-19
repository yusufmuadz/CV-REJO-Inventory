import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/middlewares/app_role.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../shared/images/custom_image.dart';
import '../../../../../shared/text_field/textfield_shared.dart';
import '../../../../list_order/presentation/controllers/list_order_controller.dart';

class InputAssistenWidget extends StatelessWidget {
  final ListOrderController controller;

  const InputAssistenWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        child: Column(
          children: [
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

  Widget _buildContent() {
    if (AppRole.isChecker2 &&
        controller.statusTransportationSelected.value == 'External') {
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
              controller: controller.extNopolTransporation,
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
              controller: controller.extNopolTransporation,
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
              controller.driverSelected.value.isEmpty ||
                  controller.driverSelected.value == '-'
              ? controller.listUser.first.nama
              : controller.driverSelected.value,
          items: controller.listUser.map<DropdownMenuItem<String>>((item) {
            return _buildMenuItem(item: item.nama);
          }).toList(),
          onChanged: (value) {
            controller.driverSelected.value = value.toString();
          },
        ),
        const SizedBox(height: 23),
        _buildTitle(title: 'Nama Kenek'),
        const SizedBox(height: 5),
        _buildDropdown(
          title: 'Asisten',
          selectedValue:
              controller.assistantSelected.value.isEmpty ||
                  controller.assistantSelected.value == '-'
              ? controller.listUser.first.nama
              : controller.assistantSelected.value,
          items: controller.listUser.map<DropdownMenuItem<String>>((item) {
            return _buildMenuItem(item: item.nama);
          }).toList(),
          onChanged: (value) {
            controller.assistantSelected.value = value.toString();
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
              onPressed: () => controller.onRefreshAssistant(),
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
      ],
    );
  }

  Widget _buildTransportation() {
    if (AppRole.isChecker2) {
      return _buildDropdown(
        title: 'Kendaraan',
        isNotTransportation: false,
        selectedValue:
            controller.selectTransportation.value.isEmpty ||
                controller.selectTransportation.value == '-'
            ? controller.transportations.first.jenisKendaraan ?? '-'
            : controller.selectTransportation.value,
        items: controller.transportations.map<DropdownMenuItem<String>>((item) {
          return _buildMenuItemTransportation(
            item: item.jenisKendaraan ?? '-',
            plat: item.idDeliveryMobil ?? '-',
          );
        }).toList(),
        onChanged: (value) {
          controller.selectTransportation.value = value.toString();
          if (value.toString() != '-') {
            final transportation = controller.transportations;
            final index = transportation.indexWhere(
              (element) => element.jenisKendaraan == value.toString(),
            );
            controller.nopolTransportation.value =
                transportation[index].idDeliveryMobil ?? '-';
          }
        },
      );
    }

    return _buildDropdown(
      title: 'Kendaraan',
      isNotTransportation: false,
      selectedValue: controller.selectTransportation.value.isEmpty
          ? controller.transportations.first.namaKendaraan ?? '-'
          : controller.selectTransportation.value,
      items: controller.transportations.map<DropdownMenuItem<String>>((item) {
        if (AppRole.isPIC) {
          return _buildMenuItem(item: item.namaKendaraan ?? '-');
        }
        return _buildMenuItemTransportation(
          item: item.namaKendaraan ?? '-',
          plat: item.idDeliveryMobil ?? '-',
        );
      }).toList(),
      onChanged: (value) {
        controller.selectTransportation.value = value.toString();
      },
    );
  }

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
            'H 1028 KX',
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

  Widget _buildSelectStatusTransportation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(title: 'Pilih Status Armada'),
        const SizedBox(height: 5),
        _buildDropdown(
          title: 'Status Armada',
          selectedValue: controller.statusTransportationSelected.value,
          items: controller.statusTransportations.map<DropdownMenuItem<String>>(
            (item) {
              return _buildMenuItem(item: item);
            },
          ).toList(),
          onChanged: (value) {
            if (value.toString() == 'External') {
              controller.dialogService.showComingSoonSnackbar();
              return;
            }
            controller.statusTransportationSelected.value = value.toString();
          },
        ),
        const SizedBox(height: 23),
      ],
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
            controller.nopolTransportation.value.isEmpty
                ? controller.transportations.first.idDeliveryMobil ?? '-'
                : controller.nopolTransportation.value,
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
