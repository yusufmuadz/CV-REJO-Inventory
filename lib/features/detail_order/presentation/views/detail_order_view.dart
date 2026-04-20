import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../utils/loading_custom.dart';
import '../controllers/detail_order_controller.dart';
import '../widgets/content_detail_order_widget.dart';

class DetailOrderView extends GetView<DetailOrderController> {
  const DetailOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        elevation: 1,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingView();
        }
        return RefreshIndicator(
          onRefresh: () async {
            controller.onRefreshDetailOrder();
          },
          child: ContentDetailOrderWidget(controller: controller),
        );
      }),
      bottomNavigationBar: Obx(() {
        if ((controller.orderDetail.value.orderDetails?.isEmpty ?? true) ||
            controller.routeFrom.value == 'listHistoryOrder' ||
            controller.isLoading.value) {
          return const SizedBox.shrink();
        }
        return _buildButtonStyle(child: _buildButton());
      }),
    );
  }

  Widget _buildButton() {
    if (controller.isSelect.value) {
      return _buildButtonSelect();
    }
    return _buildBasicButton(
      title: 'Mulai',
      color: const Color(0xFF2ED471),
      onPressed: () {
        if (controller.listUser.isEmpty) {
          controller.getAssisten();
        }
        _inputAsisten();
      },
    );
  }

  Widget _buildButtonSelect() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: _buildBasicButton(
            title: 'Scan Produk',
            color: const Color(0xFFFF51BD),
            onPressed: () {
              Get.toNamed(
                Routes.SCAN_PRODUCT,
                arguments: {'invoice': controller.noInvoice.value},
              );
            },
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildBasicButton(
                title: 'Pending',
                color: Colors.redAccent,
                onPressed: () => _inputReason(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildBasicButton(
                title: 'Lanjut',
                color: const Color(0xFF255BF0),
                onPressed: () {
                  Get.toNamed(
                    Routes.ENDING_ORDER,
                    arguments: {'invoice': controller.noInvoice.value},
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBasicButton({
    required String title,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(title),
    );
  }

  Widget _buildButtonStyle({required Widget child}) {
    return Container(
      height: !controller.isSelect.value ? null : Get.height * 0.155,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }

  void _inputReason() {
    Get.bottomSheet(
      SizedBox(
        height: Get.height * 0.45,
        child: Obx(() {
          if (controller.isLoadingAssistant.value) {
            return const LoadingView();
          }

          return Padding(
            padding: EdgeInsets.fromLTRB(15, 22, 15, 10),
            child: Column(
              children: [
                _buildTitle(title: 'Masukkan Alasan', size: 18),
                const SizedBox(height: 15),
                TextField(
                  // controller: controller.reasonController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.all(12),
                    hint: const Text('Masukkan alasan pending...'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: _buildBasicButton(
                    title: 'Kirim',
                    color: const Color(0xFF2ED471),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  void _inputAsisten() {
    Get.defaultDialog(
      radius: 10,
      title: 'Masukkan Asisten',
      titlePadding: const EdgeInsets.only(top: 20),
      titleStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      contentPadding: EdgeInsets.fromLTRB(15, 22, 15, 10),
      content: SizedBox(
        height: Get.height * 0.45,
        child: Obx(() {
          if (controller.isLoadingAssistant.value) {
            return const LoadingView();
          }

          return ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(title: 'Nama Driver'),
              const SizedBox(height: 5),
              _buildDropdown(
                title: 'Driver',
                selectedValue: controller.driverSelected.value.isEmpty
                    ? controller.listUser.first.username
                    : controller.driverSelected.value,
                items: controller.listUser.map<DropdownMenuItem<String>>((
                  item,
                ) {
                  return _buildMenuItem(item: item.username);
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
                    ? controller.listUser.first.username
                    : controller.assistantSelected.value,
                items: controller.listUser.map<DropdownMenuItem<String>>((
                  item,
                ) {
                  return _buildMenuItem(item: item.username);
                }).toList(),
                onChanged: (value) {
                  controller.assistantSelected.value = value.toString();
                },
              ),
              const SizedBox(height: 23),
              _buildTitle(title: 'Kendaraan'),
              const SizedBox(height: 5),
              _buildDropdown(
                title: 'Kendaraan',
                selectedValue: controller.selectTransportation.value.isEmpty
                    ? controller.transportations.first.namaKendaraan ?? '-'
                    : controller.selectTransportation.value,
                items: controller.transportations.map<DropdownMenuItem<String>>(
                  (item) {
                    return _buildMenuItem(item: item.namaKendaraan ?? '-');
                  },
                ).toList(),
                onChanged: (value) {
                  controller.selectTransportation.value = value.toString();
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: IconButton(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  onPressed: () => controller.onRefreshAssistant(),
                  icon: const Icon(Icons.refresh, color: Colors.blue),
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
        }),
      ),
      confirm: SizedBox(
        height: 45,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFc7a16d),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Batal'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  controller.addAssistant();
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF2ED471),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
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
    required Function(Object?) onChanged,
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
