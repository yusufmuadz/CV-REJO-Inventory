import 'package:cv_rejo/core/middlewares/app_role.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/theme/text_styles.dart';
import '../../features/list_order/domain/entities/list_order_entity.dart';
import '../../features/rit_information/presentation/controllers/enums/enum_rit.dart';
import '../box/box_status.dart';

class CustomCardList extends StatelessWidget {
  final Function() onTap;
  final bool showSelection;
  final String isSelected;
  final Function()? onCheckboxChanged;
  final OrderEntity orderEntity;
  final String? color;
  final bool isHistory;
  final bool isTrackingDriver;
  final bool isSisipan;
  final EnumButtonRIT? buttonRIT;
  final Function()? onTapMaps;

  const CustomCardList({
    super.key,
    required this.onTap,
    required this.orderEntity,
    this.onCheckboxChanged,
    this.showSelection = false,
    this.isSelected = '',
    this.color,
    this.isHistory = false,
    this.isTrackingDriver = false,
    this.isSisipan = false,
    this.buttonRIT,
    this.onTapMaps,
  });

  @override
  Widget build(BuildContext context) {
    Color colorShow = isSelected == orderEntity.invoice
        ? Colors.grey.shade100
        : color != null
        ? Color(int.parse('0xFF$color')).withOpacity(0.3)
        : Colors.white;

    final isNumberSorting =
        orderEntity.number.value != 0 &&
        buttonRIT == EnumButtonRIT.buttonConfirmChangePO;

    // if (isNumberShow) {
    //   colorShow = Color(int.parse('0xFF$color')).withOpacity(0.6);
    // }

    return InkWell(
      onTap: onTap,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isNumberSorting ? Color(0xFFECFDF5) : Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(width: 2, color: colorShow),
          // boxShadow: const [
          //   BoxShadow(
          //     color: Color.fromARGB(10, 0, 0, 0),
          //     blurRadius: 2,
          //     offset: Offset(0, 1),
          //     spreadRadius: 0,
          //   ),
          // ],
        ),
        child: Stack(
          children: [
            Column(
              children: [
                _buildInfoText(
                  showStatus: !isHistory,
                  title: 'ID TRANSAKSI',
                  value: orderEntity.orderNo.replaceAll('SL', 'SO'),
                  valueSJ: orderEntity.suratJalan?.replaceAll('SJ/', ''),
                ),
                Divider(
                  thickness: 1,
                  height: 28,
                  color: const Color(0xFFE2E8F0),
                ),
                _buildInfoIconText(
                  label: 'Customer',
                  value: orderEntity.customer,
                  fontWeightValue: FontWeight.bold,
                  bgColor: const Color(0xFFFDF2F8),
                  borderColor: const Color(0xFFFCE7F3),
                  icon: CupertinoIcons.person,
                  iconColor: const Color(0xFFDB2777),
                ),
                Visibility(
                  visible: AppRole.isDriver,
                  child: Container(
                    margin: const EdgeInsets.only(top: 14),
                    child: _buildInfoIconText(
                      label: 'No. Telp',
                      value: orderEntity.noTelp ?? '-',
                      fontWeightValue: FontWeight.bold,
                      bgColor: const Color(0xFFFEF5D2),
                      borderColor: const Color(0xFFFDEA9C),
                      icon: CupertinoIcons.phone,
                      iconColor: const Color(0xFFD97706),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _buildInfoIconText(
                  isDate: true,
                  label: 'Tanggal Invoice',
                  value: orderEntity.date.transaction,
                  icon: CupertinoIcons.timer,
                  bgColor: const Color(0xFFFFF1F2),
                  borderColor: const Color(0xFFFFE4E6),
                  iconColor: const Color(0xFFF43F5E),
                ),
                const SizedBox(height: 14),
                _buildInfoIconText(
                  value: orderEntity.district,
                  fontWeightValue: FontWeight.bold,
                  address: orderEntity.address,
                  isDistrict: true,
                  isIcon: isHistory,
                  icon: Ionicons.business_outline,
                  bgColor: const Color(0xFFFAF5FF),
                  borderColor: const Color(0xFFF3E8FF),
                  iconColor: const Color(0xFFA855F7),
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                Visibility(
                  visible: isHistory,
                  child: Container(
                    margin: const EdgeInsets.only(top: 14),
                    child: _buildInfoIconText(
                      label: 'ROUTE',
                      value: orderEntity.route ?? '-',
                      fontWeightValue: FontWeight.bold,
                      bgColor: const Color(0xFFD6FCF4),
                      borderColor: const Color(0xFF9DF6E5),
                      icon: CupertinoIcons.location,
                      iconColor: const Color(0xFF0D9488),
                    ),
                  ),
                ),
                Visibility(
                  visible: AppRole.isDriver || isTrackingDriver,
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
            Visibility(visible: isNumberSorting, child: _buildNumerSorting()),
          ],
        ),
      ),
    );
  }

  Widget _buildNumerSorting() {
    return Positioned(
      top: 0,
      bottom: 0,
      right: 0,
      left: 0,
      child: Center(
        child: Text(
          '${orderEntity.number}',
          style: TextStyles.basicTextStyle(
            fontSize: 100,
            fontWeight: FontWeight.bold,
            color: Colors.black.withValues(alpha: 0.3),
          ),
        ),
      ),
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
    String? valueSJ,
    bool showStatus = false,
  }) {
    final statusLoader = orderEntity.loader?.status ?? '';
    bool isShowStatus = true;
    String valueName = value.replaceAll('SL', 'SO');

    if (AppRole.isChecker2 &&
        statusLoader == 'completed' &&
        !isTrackingDriver) {
      isShowStatus = false;
    }

    if (AppRole.isDriver) {
      isShowStatus = showStatus;
    }

    if (AppRole.isDriver && valueSJ != null && valueSJ.isNotEmpty) {
      valueName = valueSJ.replaceAll('SJ/', '');
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: showSelection,
          child: Container(
            height: 20,
            width: 20,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              border: isSelected == orderEntity.invoice
                  ? null
                  : Border.all(width: 1, color: Color(0xFFCBD5E1)),
              borderRadius: BorderRadius.circular(6),
              color: isSelected == orderEntity.invoice
                  ? const Color(0xFF22C55E)
                  : Colors.white,
            ),
            child: isSelected == orderEntity.invoice
                ? Icon(Icons.check_rounded, size: 18, color: Colors.white)
                : null,
          ),
        ),
        SizedBox(width: 90, child: Text(title, style: _textStyle())),
        Expanded(
          child: Text(
            ' :  $valueName',
            style: _textStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        Visibility(
          visible: isShowStatus && !isHistory,
          child: Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: BoxStatus.buildColor(
                statusPIC: orderEntity.pic?.status ?? '',
                statusChecker1: orderEntity.checker1?.status ?? '',
                statusChecker2: orderEntity.checker2?.status ?? '',
                statusDriver: orderEntity.driver?.status ?? '',
                statusScanDriver: orderEntity.driver?.scanDriver ?? false,
                statusArriveDriver: orderEntity.driver?.arriveDriver ?? false,
                statusDelivCancel:
                    orderEntity.driver?.statusDelivCancel ?? false,
                isTrackingDriver: isTrackingDriver,
              ),
            ),
            child: Text(
              BoxStatus.buildText(
                statusPIC: orderEntity.pic?.status ?? '',
                statusChecker1: orderEntity.checker1?.status ?? '',
                statusChecker2: orderEntity.checker2?.status ?? '',
                statusDriver: orderEntity.driver?.status ?? '',
                statusScanDriver: orderEntity.driver?.scanDriver ?? false,
                statusArriveDriver: orderEntity.driver?.arriveDriver ?? false,
                statusDelivCancel:
                    orderEntity.driver?.statusDelivCancel ?? false,
                isTrackingDriver: isTrackingDriver,
              ),
              style: _textStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoIconText({
    required IconData icon,
    required String value,
    String? label,
    String? address,
    bool isDistrict = false,
    bool isIcon = false,
    bool isDate = false,
    FontWeight fontWeightValue = FontWeight.w600,
    Color? bgColor,
    Color? borderColor,
    Color? iconColor,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: borderColor ?? Colors.white),
            borderRadius: BorderRadius.circular(7),
            color: bgColor,
          ),
          // clipBehavior: Clip.none,
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: label != null,
                child: Text(
                  label ?? '-',
                  style: _textStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.isEmpty ? '-' : value,
                style: _textStyle(
                  fontSize: 12,
                  fontWeight: fontWeightValue,
                  color: const Color(0xFF1E293B),
                ),
              ),
              Visibility(
                visible: isDistrict,
                child: Container(
                  margin: const EdgeInsets.only(top: 2),
                  child: Text(
                    address?.isEmpty == true ? '-' : address ?? '-',
                    style: _textStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                  ),
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
