import 'package:cv_rejo/features/list_order_history/presentation/controllers/list_history_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/theme/text_styles.dart';
import '../../features/list_order/domain/entities/district_entity.dart';
import '../../utils/loading_custom.dart';
import '../custom/custom_button.dart';

class SortWidget extends StatelessWidget {
  final RxBool isLoading;
  final RxBool isSortBy;
  final RxString ritSelected;
  final RxString? dateRit;
  final RxList<DistrictEntity> listRIT;
  final Function() onReset;
  final Function() onApply;

  const SortWidget({
    super.key,
    required this.isLoading,
    required this.isSortBy,
    required this.ritSelected,
    required this.listRIT,
    required this.onReset,
    required this.onApply,
    this.dateRit,
  });

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
        if (isLoading.value) {
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
                  _buildDateTime(context: context),
                  _buildTitle(title: 'Urutkan berdasarkan'),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: [
                      _buildSortingOption(
                        label: 'Terbaru',
                        isSelected: isSortBy.value,
                        onSelected: (bool p1) {
                          isSortBy.value = true;
                        },
                      ),
                      _buildSortingOption(
                        label: 'Terlama',
                        isSelected: !isSortBy.value,
                        onSelected: (bool p1) {
                          isSortBy.value = false;
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
                  _buildTitle(title: 'RIT'),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 0.0,
                    children: listRIT
                        .map(
                          (district) => _buildSortingOption(
                            label: 'RIT-${district.kabupaten}',
                            isSelected: ritSelected.value == district.kabupaten,
                            onSelected: (bool p1) {
                              ritSelected.value = district.kabupaten.toString();
                              ritSelected.refresh();
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
              onPressed1: onReset,
              onPressed2: onApply,
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

  Widget _buildDateTime({required BuildContext context}) {
    return Visibility(
      visible: dateRit != null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: InkWell(
          onTap: () async {
            DateTime initialDate = DateTime.now();

            if (dateRit != null) {
              initialDate = DateTime.parse(dateRit!.value);
            }

            final selectedDate = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime(2000),
              lastDate: DateTime.now().add(const Duration(days: 360)),
              builder: (context, child) {
                return Theme(data: Theme.of(context).copyWith(), child: child!);
              },
            );

            if (selectedDate != null) {
              dateRit!.value = selectedDate.toString();
              // controller.onRefreshTransaction();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E8F8)),
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFF0F3FF),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: const Color(0xFF524439),
                ),
                const SizedBox(width: 6),
                Obx(
                  () => Visibility(
                    visible: dateRit!.isNotEmpty,
                    child: Text(
                      DateFormat(
                        'dd MMM yyyy',
                      ).format(DateTime.parse(dateRit!.value)),
                      style: TextStyles.basicTextStyle(
                        fontSize: 16,
                        fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF151C27),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Ubah Tanggal',
                  style: TextStyles.basicTextStyle(
                    fontSize: 16,
                    fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8A5012),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.edit_calendar_outlined,
                  size: 18,
                  color: Color(0xFF8A5012),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
