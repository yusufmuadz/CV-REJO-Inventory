import 'package:cv_rejo/core/middlewares/app_role.dart';
import 'package:flutter/material.dart';

import '../../core/theme/text_styles.dart';
import '../../features/list_order/domain/entities/list_order_entity.dart';
import '../../features/rit_information/presentation/controllers/enums/enum_rit.dart';
import '../../gen/assets.gen.dart';
import '../box/box_status.dart';

class CustomCardList extends StatelessWidget {
  final Function() onTap;
  final bool showSelection;
  final String isSelected;
  final Function()? onCheckboxChanged;
  final OrderEntity transaction;
  final String? color;
  final bool isHistory;
  final EnumButtonRIT? buttonRIT;
  final Function()? onTapMaps;

  const CustomCardList({
    super.key,
    required this.onTap,
    required this.transaction,
    this.onCheckboxChanged,
    this.showSelection = false,
    this.isSelected = '',
    this.color,
    this.isHistory = false,
    this.buttonRIT,
    this.onTapMaps,
  });

  @override
  Widget build(BuildContext context) {
    Color colorShow = isSelected == transaction.invoice
        ? Colors.grey.shade100
        : color != null
        ? Color(int.parse('0xFF$color')).withOpacity(0.3)
        : Colors.white;

    if (transaction.number.value != 0 &&
        buttonRIT == EnumButtonRIT.buttonConfirmChangePO) {
      colorShow = Color(int.parse('0xFF$color')).withOpacity(0.6);
    }

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
                color: colorShow,
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
                        showStatus: !isHistory,
                        title: 'ID Transaksi',
                        value:
                            AppRole.isDriver && transaction.suratJalan != null
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
                      Visibility(
                        visible: AppRole.isDriver,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: _buildInfoIconText(
                            image: Assets.icons.phone.path,
                            value: transaction.noTelp ?? '-',
                          ),
                        ),
                      ),
                      _buildInfoIconText(
                        image: Assets.icons.dateIn.path,
                        value: transaction.date.transaction,
                      ),
                      const SizedBox(height: 10),
                      _buildInfoIconText(
                        image: Assets.icons.maps.path,
                        value: transaction.district,
                        address: transaction.address,
                        isDistrict: true,
                        isIcon: isHistory,
                      ),
                      Visibility(
                        visible: isHistory,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: _buildInfoIconText(
                            image: Assets.icons.dateOrder.path,
                            value: transaction.route ?? '-',
                            isIcon: true,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: AppRole.isDriver,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: onTapMaps,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                              margin: const EdgeInsets.only(top: 10, left: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: const Color(0xFFffd8ab),
                                ),
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.map_outlined,
                                    size: 16,
                                    color: const Color(0xFFd68e85),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Buka Peta',
                                    style: _textStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFFd68e85),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible:
                        transaction.number.value != 0 &&
                        buttonRIT == EnumButtonRIT.buttonConfirmChangePO,
                    child: Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Center(
                        child: Text(
                          '${transaction.number}',
                          style: TextStyles.basicTextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !AppRole.isDriver,
                    child: Positioned(
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

  Widget _buildInfoText({
    required String title,
    required String value,
    bool showStatus = false,
  }) {
    final statusLoader = transaction.loader?.status ?? '';
    bool isShowStatus = true;

    if (AppRole.isChecker2 && statusLoader == 'completed') {
      isShowStatus = false;
    }

    if (AppRole.isDriver) {
      isShowStatus = showStatus;
    }

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
          visible: isShowStatus,
          child: Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: BoxStatus.buildColor(
                statusPIC: transaction.pic?.status ?? '',
                statusChecker1: transaction.checker1?.status ?? '',
                statusChecker2: transaction.checker2?.status ?? '',
                statusDriver: transaction.driver?.status ?? '',
                statusScanDriver: transaction.driver?.scanDriver ?? false,
                statusArriveDriver: transaction.driver?.arriveDriver ?? false,
                statusDelivCancel:
                    transaction.driver?.statusDelivCancel ?? false,
              ),
            ),
            child: Text(
              BoxStatus.buildText(
                statusPIC: transaction.pic?.status ?? '',
                statusChecker1: transaction.checker1?.status ?? '',
                statusChecker2: transaction.checker2?.status ?? '',
                statusDriver: transaction.driver?.status ?? '',
                statusScanDriver: transaction.driver?.scanDriver ?? false,
                statusArriveDriver: transaction.driver?.arriveDriver ?? false,
                statusDelivCancel:
                    transaction.driver?.statusDelivCancel ?? false,
              ),
              style: _textStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoIconText({
    required String image,
    required String value,
    String? address,
    bool isDistrict = false,
    bool isIcon = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 19,
          clipBehavior: Clip.none,
          child: Image.asset(image),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value.isEmpty ? '-' : value,
                style: _textStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              Visibility(
                visible: AppRole.isDriver && isDistrict,
                child: Text(
                  address?.isEmpty == true ? '-' : address ?? '-',
                  style: _textStyle(fontSize: 12, fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
        ),
        Visibility(visible: isIcon, child: const SizedBox(width: 40)),
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
