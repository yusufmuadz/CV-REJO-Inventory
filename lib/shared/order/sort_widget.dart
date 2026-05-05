import 'package:cv_rejo/features/list_order_history/presentation/controllers/list_history_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/loading_custom.dart';
import '../custom/custom_button.dart';

class SortWidget extends StatelessWidget {
  final ListHistoryOrderController controller;

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
      child: Obx(() {
        if (controller.isLoadingSort.value) {
          return const Center(child: LoadingView());
        }

        return Column(
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
                  Wrap(
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
                  // Jika List Order Bukan HISTORY
                  // const SizedBox(height: 15.0),
                  // _buildTitle(title: 'Status Pengerjaan'),
                  // Wrap(
                  //   spacing: 10.0,
                  //   runSpacing: 0.0,
                  //   children: controller.status
                  //       .map<Widget>(
                  //         (status) => _buildSortingOption(
                  //           label: status['name'] as String,
                  //           isSelected:
                  //               controller.isStatusSelected.value ==
                  //               status['name'],
                  //           onSelected: (bool p1) {
                  //             if (controller.isStatusSelected.value ==
                  //                     status['name'] &&
                  //                 status['isSelected'] == true) {
                  //               status['isSelected'] = false;
                  //               controller.isStatusSelected.value = '';
                  //               return;
                  //             }

                  //             status['isSelected'] = p1;

                  //             controller.isStatusSelected.value = status['name']
                  //                 .toString();
                  //             controller.status.refresh();
                  //           },
                  //         ),
                  //       )
                  //       .toList(),
                  // ),
                  const SizedBox(height: 15.0),
                  _buildTitle(title: 'Kabupaten/Kota'),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 0.0,
                    children: controller.listDistrict
                        .map(
                          (district) => _buildSortingOption(
                            label: district.kabupaten as String,
                            isSelected:
                                controller.isDistrictSelected.value ==
                                district.kabupaten,
                            onSelected: (bool p1) {
                              controller.isDistrictSelected.value = district
                                  .kabupaten
                                  .toString();
                              controller.listDistrict.refresh();
                            },
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 3.0),
            CustomButton.doubleButton(
              title1: 'Reset',
              title2: 'Terapkan',
              color1: Colors.redAccent.shade200,
              color2: const Color(0xFFd6993a),
              shadowColor: Colors.transparent,
              minimumSize: const Size(double.infinity, 45),
              onPressed1: () {
                // Apply filter and sorting
                controller.onResetSort();
                Get.back();
              },
              onPressed2: () {
                // Apply filter and sorting
                controller.onRefreshTransaction();
                Get.back();
              },
            ),
          ],
        );
      }),
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
