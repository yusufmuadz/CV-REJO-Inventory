import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SortWidget extends StatelessWidget {
  final dynamic controller;

  const SortWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.8,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              'Filter',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 13.0),
          Divider(color: Colors.grey.shade300, thickness: 1, height: 2),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 10.0),
              children: [
                _buildTitle(title: 'Urutkan berdasarkan'),
                Obx(
                  () => Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: [
                      _buildSortingOption(
                        label: 'Terbaru',
                        isSelected: controller.sortByNew.value,
                        onSelected: (bool p1) {
                          controller.sortByNew.value = true;
                        },
                      ),
                      _buildSortingOption(
                        label: 'Terlama',
                        isSelected: !controller.sortByNew.value,
                        onSelected: (bool p1) {
                          controller.sortByNew.value = false;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15.0),
                _buildTitle(title: 'Status Pengerjaan'),
                Obx(
                  () => Wrap(
                    spacing: 10.0,
                    runSpacing: 0.0,
                    children: controller.status
                        .map<Widget>(
                          (status) => _buildSortingOption(
                            label: status['name'] as String,
                            isSelected: status['isSelected'] as bool,
                            onSelected: (bool p1) {
                              status['isSelected'] = p1;

                              if (status['name'] == 'Semua') {
                                for (var element in controller.status) {
                                  element['isSelected'] = p1;
                                }
                              } else {
                                final allSelected = controller.status
                                    .where((e) => e['name'] != 'Semua')
                                    .every((s) => s['isSelected'] == true);

                                controller.status[0]['isSelected'] = false;
                                if (allSelected) {
                                  controller.status[0]['isSelected'] = true;
                                }
                              }
                              controller.status.refresh();
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 3.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFFd6993a),
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(double.infinity, 45),
            ),
            onPressed: () {
              // Apply filter and sorting
              // controller.getTransaksi();
              Get.back();
            },
            child: const Text(
              'Terapkan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle({required String title}) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildSortingOption({
    required String label,
    required bool isSelected,
    required Function(bool) onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: const Color(0xFFc7a16d),
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        fontSize: 13,
        color: isSelected ? Colors.white : Colors.black,
      ),
      shape: StadiumBorder(
        side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
