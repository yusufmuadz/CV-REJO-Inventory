import 'package:flutter/material.dart';

import '../controllers/rit_controller.dart';

class InfoRit extends StatelessWidget {
  final RitController controller;
  const InfoRit({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitleBody(
          title: 'Informasi RIT',
          icon: Icons.assignment_outlined,
          colorIcon: const Color(0xFF165be3),
          colorCircle: const Color(0xFFdaeafc),
        ),
        const SizedBox(height: 16),
        // _buildInfoText(title: 'ID RIT', value: 'RIT-0813892-001'),
        // _buildInfoText(title: 'Tanggal', value: '31 Januari 2023'),
        _buildInfoText(title: 'Driver', value: 'John Doe'),
        _buildInfoText(title: 'Kenek', value: 'John Doe 2'),
        _buildInfoText(title: 'Kendaraan', value: 'Truck'),
        _buildInfoText(title: 'No. Pol', value: 'B 1234 AB', hideLine: true),
        Divider(thickness: 1, height: 30, color: Colors.grey.shade100),
        _buildTitleBody(
          title: 'Ringkasan Pesanan',
          icon: Icons.date_range_outlined,
          colorIcon: const Color(0xFF3a9c4f),
          colorCircle: const Color(0xFFecf8ee),
        ),
        const SizedBox(height: 16),
        _buildInfoText(title: 'Total PO', value: '50'),
        _buildInfoText(title: 'Total Item', value: '100'),
        Divider(thickness: 1, height: 30, color: Colors.grey.shade100),
        Row(
          children: [
            Container(
              height: 26,
              width: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFf5eafd),
              ),
              child: Icon(
                Icons.list_alt_outlined,
                color: const Color(0xFF684ca8),
                size: 15,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Daftar PO(50)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {},
              child: Text(
                'Lihat Semua',
                style: _textStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.45,
                  color: const Color(0xFF165be3),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitleBody({
    required String title,
    required IconData icon,
    required Color colorCircle,
    required Color colorIcon,
  }) {
    return Row(
      children: [
        Container(
          height: 26,
          width: 26,
          decoration: BoxDecoration(shape: BoxShape.circle, color: colorCircle),
          child: Icon(icon, color: colorIcon, size: 15),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoText({
    required String title,
    required String value,
    bool? hideLine = false,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: _textStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF4d5461),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: _textStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        Visibility(
          visible: !hideLine!,
          child: Divider(thickness: 1, height: 20, color: Colors.grey.shade100),
        ),
      ],
    );
  }

  TextStyle _textStyle({
    double fontSize = 13,
    FontWeight fontWeight = FontWeight.w400,
    double? height,
    double? letterSpacing,
    Color color = const Color(0xFF171717),
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: 'Inter',
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}
