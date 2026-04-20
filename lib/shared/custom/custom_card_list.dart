import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';

class CustomCardList extends StatelessWidget {
  final Function() onTap;
  final String idTransaksi;
  final String noResi;
  final String noPesanan;
  final String kurir;
  final String customer;
  final String tanggalTransaksi;
  final String tanggalDelivery;
  final bool showSelection;
  final String isSelected;
  final Function()? onCheckboxChanged;

  const CustomCardList({
    super.key,
    required this.onTap,
    required this.idTransaksi,
    required this.noResi,
    required this.noPesanan,
    required this.kurir,
    required this.customer,
    required this.tanggalTransaksi,
    required this.tanggalDelivery,
    this.onCheckboxChanged,
    this.showSelection = false,
    this.isSelected = '',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: showSelection,
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: onCheckboxChanged,
              child: Container(
                height: 20,
                width: 20,
                padding: isSelected == noPesanan
                    ? const EdgeInsets.all(2)
                    : null,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: Colors.blue),
                ),
                child: isSelected == noPesanan
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                      )
                    : null,
              ),
              // Radio<String>(
              //   value: isSelected,
              //   onChanged: onCheckboxChanged,
              //   visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              // ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected == noPesanan
                    ? Colors.grey.shade100
                    : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: isSelected == noPesanan
                    ? []
                    : const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                          spreadRadius: 0,
                        ),
                      ],
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      _buildInfoText(title: 'ID Transaksi', value: idTransaksi),
                      const SizedBox(height: 9),
                      _buildInfoText(title: 'No. Resi', value: noResi),
                      const SizedBox(height: 9),
                      buildShippingText(kurir),
                      const SizedBox(height: 9),
                      _buildInfoText(title: 'No. Pesanan', value: noPesanan),
                      const Divider(
                        thickness: 1,
                        height: 20,
                        color: Colors.grey,
                      ),
                      _buildInfoIconText(
                        image: Assets.icons.person2.path,
                        value: customer,
                      ),
                      const SizedBox(height: 10),
                      _buildInfoIconText(
                        image: Assets.icons.dateIn.path,
                        value: tanggalTransaksi,
                      ),
                      const SizedBox(height: 10),
                      _buildInfoIconText(
                        image: Assets.icons.dateOrder.path,
                        value: tanggalDelivery,
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 10,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFD9D9D9),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFF7C7C7C),
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildShippingText(String text) {
    final parts = text.split('-');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          // padding: const EdgeInsets.only(top: 1),
          child: Text('Pengiriman', style: _textStyle()), //
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: ':  ${parts[0]} ${parts.length > 1 ? "-" : ""} ',
                  style: _textStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                if (parts.length > 1)
                  TextSpan(
                    text: parts[1],
                    style: _textStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoText({required String title, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 100, child: Text(title, style: _textStyle())),
        Expanded(
          child: Text(
            ':  $value',
            style: _textStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoIconText({required String image, required String value}) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 19,
          clipBehavior: Clip.none,
          child: Image.asset(image),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            value,
            style: _textStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  TextStyle _textStyle({
    double fontSize = 13,
    FontWeight fontWeight = FontWeight.w400,
    double? height,
    Color color = const Color(0xFF171717),
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: 'Inter',
      fontWeight: fontWeight,
      height: height,
    );
  }
}
