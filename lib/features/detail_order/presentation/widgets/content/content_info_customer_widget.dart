import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/middlewares/app_role.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../controllers/detail_order_controller.dart';

class ContentInfoCustomerWidget extends StatelessWidget {
  final DetailOrderController controller;

  const ContentInfoCustomerWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final namePenerima = controller.orderDetail.value.customer.name;
    final phone = controller.orderDetail.value.customer.phone;
    final tanggalBatas = controller.orderDetail.value.date.delivery;
    final district = controller.orderDetail.value.customer.district;
    final address = controller.orderDetail.value.customer.address;
    final dropAddress = controller.orderDetail.value.customer.dropAddress;
    final isStatusDriver = controller.statusDriver.value == 'completed';
    final doneByPO = controller.doneByPO.value;
    final route = controller.orderDetail.value.route;

    final isDriver = AppRole.isDriver && isStatusDriver;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: controller.isFromHistory.value,
          child: _buildInfoContent(
            title: AppRole.isPIC ? 'Penanggung Jawab' : 'Rute',
            value: AppRole.isPIC ? doneByPO : route ?? '-',
            icon: AppRole.isPIC
                ? Icons.groups_outlined
                : Icons.directions_bus_outlined,
          ),
        ),
        _buildInfoContent(
          title: 'Nama Penerima',
          value: namePenerima,
          icon: Icons.person_outline,
        ),
        Visibility(
          visible: isDriver,
          child: _buildInfoContent(
            isPhone: true,
            title: 'Nomor Telepon',
            value: phone,
            icon: Icons.phone_outlined,
          ),
        ),
        _buildInfoContent(
          title: 'Tanggal Pesanan Masuk',
          value: tanggalBatas,
          icon: Icons.calendar_month_outlined,
        ),
        _buildInfoContent(
          title: 'KOTA/KABUPATEN',
          value: district,
          icon: Icons.location_on_outlined,
          mgBottom: 16,
        ),
        Visibility(
          visible: isDriver,
          child: _buildInfoContent(
            isAddress: true,
            title: 'Alamat Pengiriman',
            value: dropAddress,
            icon: Icons.apartment,
            mgBottom: 16,
          ),
        ),
        _buildInfoContent(
          title: 'Catatan',
          value: '-',
          icon: Icons.description_outlined,
          mgBottom: 0,
        ),
      ],
    );
  }

  Widget _buildIconStyle({required IconData icon}) {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFFDF2F8),
      ),
      child: Icon(icon, size: 20, color: const Color(0xFFEC4899)),
    );
  }

  Widget _buildInfoContent({
    required String title,
    required String value,
    required IconData icon,
    bool isPhone = false,
    bool isAddress = false,
    double mgBottom = 16,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: mgBottom),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIconStyle(icon: icon),
          const SizedBox(width: 15),
          Expanded(
            child: InkWell(
              onTap: () {
                if (isAddress) {
                  controller.onTapMaps();
                }
              },
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyles.basicTextStyle(
                            fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                            fontSize: 12,
                            color: const Color(0xFF857467),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          value.isNotEmpty ? value : '-',
                          style: TextStyles.basicTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            decoration: isAddress
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            fontStyle: isAddress ? FontStyle.italic : null,
                            decorationColor: isAddress
                                ? Colors.blueAccent
                                : null,
                            color: isAddress
                                ? Colors.blueAccent
                                : const Color(0xFF151C27),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isPhone,
                    child: InkWell(
                      onTap: () => controller.copyToClipboard(phone: value),
                      child: Icon(
                        Icons.copy,
                        size: 20,
                        color: const Color(0xFFEC4899),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isAddress,
                    child: Icon(
                      Icons.map_outlined,
                      size: 20,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
