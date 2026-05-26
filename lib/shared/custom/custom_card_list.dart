import 'package:cv_rejo/core/middlewares/app_role.dart';
import 'package:flutter/material.dart';

import '../../features/list_order/domain/entities/list_order_entity.dart';
import '../../gen/assets.gen.dart';

class CustomCardList extends StatelessWidget {
  final Function() onTap;
  final bool showSelection;
  final String isSelected;
  final Function()? onCheckboxChanged;
  final OrderEntity transaction;
  final String? color;

  const CustomCardList({
    super.key,
    required this.onTap,
    required this.transaction,
    this.onCheckboxChanged,
    this.showSelection = false,
    this.isSelected = '',
    this.color,
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
                padding: isSelected == transaction.invoice
                    ? const EdgeInsets.all(2)
                    : null,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: Colors.blue),
                ),
                child: isSelected == transaction.invoice
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected == transaction.invoice
                    ? Colors.grey.shade100
                    : color != null
                    ? Color(int.parse('0xFF$color')).withOpacity(0.3)
                    : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: color != null
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
                      _buildInfoText(
                        title: 'ID Transaksi',
                        isStatus: true,
                        value: AppRole.isDriver
                            ? transaction.suratJalan!.replaceAll('SJ/', '')
                            : transaction.orderNo.replaceAll('SL', 'SO'),
                      ),
                      Divider(
                        thickness: 1,
                        height: 20,
                        color: Colors.grey[300],
                      ),
                      _buildInfoIconText(
                        image: Assets.icons.person2.path,
                        value: transaction.customer,
                      ),
                      const SizedBox(height: 10),
                      _buildInfoIconText(
                        image: Assets.icons.dateIn.path,
                        value: transaction.date.transaction,
                      ),
                      const SizedBox(height: 10),
                      _buildInfoIconText(
                        image: Assets.icons.district.path,
                        value: transaction.district,
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

  String _buildText({
    String statusPIC = '',
    String statusChecker2 = '',
    String statusDriver = '',
  }) {
    String text = 'Checker';

    if (AppRole.isPIC) {
      if (statusPIC == 'available') {
        text = 'Available';
      } else if (statusPIC == 'ongoing') {
        text = 'Ongoing';
      } else if (statusPIC == 'completed') {
        text = 'Completed';
      }
    } else {
      if (statusChecker2 == 'completed') {
        text = 'Leader';
      }
    }

    if (AppRole.isDriver) {
      if (statusDriver == 'completed') {
        text = 'Ready';
      } else {
        text = 'On Progress';
      }
    }

    return text;
  }

  Color _buildColor({
    String statusPIC = '',
    String statusChecker2 = '',
    String statusDriver = '',
  }) {
    Color color = Color(0xFF5eb75f);

    if (AppRole.isPIC) {
      if (statusPIC == 'available') {
        color = const Color(0xFF5eb75f);
      } else if (statusPIC == 'ongoing' || statusPIC == 'completed') {
        color = const Color(0xFF666666);
      }
    } else {
      if (statusChecker2 == 'ongoing') {
        color = const Color(0xFF5eb75f);
      } else if (statusChecker2 == 'completed') {
        color = const Color(0xFF666666);
      }
    }

    if (AppRole.isDriver) {
      if (statusDriver == 'completed') {
        color = const Color(0xFF5eb75f);
      } else {
        color = const Color(0xFF666666);
      }
    }

    return color;
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

  Widget _buildInfoText({
    required String title,
    required String value,
    bool isStatus = false,
  }) {
    final statusLoader = transaction.loader?.status ?? '';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 100, child: Text(title, style: _textStyle())),
        Expanded(
          child: Text(
            ':  $value',
            style: _textStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        Visibility(
          visible:
              (AppRole.isChecker2 && isStatus && statusLoader != 'completed') ||
              AppRole.isDriver ||
              AppRole.isPIC,
          child: Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: _buildColor(
                statusPIC: transaction.pic?.status ?? '',
                statusChecker2: transaction.checker2?.status ?? '',
                statusDriver: transaction.driver?.status ?? '',
              ),
            ),
            child: Text(
              _buildText(
                statusPIC: transaction.pic?.status ?? '',
                statusChecker2: transaction.checker2?.status ?? '',
                statusDriver: transaction.driver?.status ?? '',
              ),
              style: _textStyle(color: Colors.white),
            ),
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
