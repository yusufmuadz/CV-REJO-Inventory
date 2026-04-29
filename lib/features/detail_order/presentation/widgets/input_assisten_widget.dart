import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/middlewares/app_role.dart';
import '../controllers/detail_order_controller.dart';

class InputAssistenWidget extends StatelessWidget {
  final DetailOrderController controller;

  const InputAssistenWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView(
        children: [
          _buildTitle(title: 'Nama Driver'),
          const SizedBox(height: 5),
          _buildDropdown(
            title: 'Driver',
            selectedValue: controller.driverSelected.value.isEmpty
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
            selectedValue: controller.assistantSelected.value.isEmpty
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
      ),
    );
  }

  Widget _buildTransportation() {
    if (AppRole.isChecker2) {
      return _buildDropdown(
        title: 'Kendaraan',
        selectedValue: controller.selectTransportation.value.isEmpty
            ? controller.transportations.first.jenisKendaraan ?? '-'
            : controller.selectTransportation.value,
        items: controller.transportations.map<DropdownMenuItem<String>>((item) {
          return _buildMenuItem(item: item.jenisKendaraan ?? '-');
        }).toList(),
        onChanged: (value) {
          controller.selectTransportation.value = value.toString();
        },
      );
    }

    return _buildDropdown(
      title: 'Kendaraan',
      selectedValue: controller.selectTransportation.value.isEmpty
          ? controller.transportations.first.namaKendaraan ?? '-'
          : controller.selectTransportation.value,
      items: controller.transportations.map<DropdownMenuItem<String>>((item) {
        return _buildMenuItem(item: item.namaKendaraan ?? '-');
      }).toList(),
      onChanged: (value) {
        controller.selectTransportation.value = value.toString();
      },
    );
  }

  Widget _buildTitle({required String title, double? size = 15}) {
    return Text(
      title,
      style: TextStyle(fontSize: size, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildDropdown({
    required String title,
    required List<DropdownMenuItem<String>> items,
    required String selectedValue,
    Function(Object?)? onChanged,
  }) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(7),
      ),
      child: DropdownButton(
        isDense: true,
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
}
