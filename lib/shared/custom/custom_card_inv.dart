import 'package:cv_rejo/core/middlewares/app_role.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../features/list_order/domain/entities/invoice_entity.dart';
import '../../features/list_order/presentation/controllers/enums/button_inv_enum.dart';
import '../../gen/assets.gen.dart';
import '../box/box_status.dart';

class CustomCardInv extends StatelessWidget {
  final Function() onTap;
  final bool showSelection;
  final String isSelected;
  final Function()? onCheckboxChanged;
  final InvoiceEntity invEntity;
  final String? color;
  final bool isHistory;
  final EnumButtonInv? buttonINV;
  final Function()? onTapMaps;

  const CustomCardInv({
    super.key,
    required this.onTap,
    required this.invEntity,
    this.onCheckboxChanged,
    this.isSelected = '',
    this.color,
    this.buttonINV,
    this.onTapMaps,
    this.showSelection = false,
    this.isHistory = false,
  });

  @override
  Widget build(BuildContext context) {
    Color colorShow = invEntity.isChecked ? Color(0xFFECFDF5) : Colors.white;

    return InkWell(
      onTap: onTap,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colorShow,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: const Color(0xFFA7F3D0)),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(10, 0, 0, 0),
              blurRadius: 2,
              offset: Offset(0, 1),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            _buildInfoText(
              showStatus: !isHistory,
              title: 'INVOICE',
              value: invEntity.suratJalan!.replaceAll('SJ/', ''),
            ),
            Divider(thickness: 1, height: 28, color: const Color(0xFFE2E8F0)),
            _buildInfoIconText(
              label: 'Customer',
              value: invEntity.customer ?? '-',
              fontWeightValue: FontWeight.bold,
              bgColor: const Color(0xFFFDF2F8),
              borderColor: const Color(0xFFFCE7F3),
              icon: CupertinoIcons.person,
              iconColor: const Color(0xFFDB2777),
            ),
            const SizedBox(height: 14),
            _buildInfoIconText(
              label: 'Tanggal Pengiriman',
              value: invEntity.date?.transaction ?? '-',
              icon: CupertinoIcons.timer,
              bgColor: const Color(0xFFFFF1F2),
              borderColor: const Color(0xFFFFE4E6),
              iconColor: const Color(0xFFF43F5E),
            ),
            const SizedBox(height: 14),
            _buildInfoIconText(
              value: invEntity.district ?? '-',
              fontWeightValue: FontWeight.bold,
              address: invEntity.address,
              isDistrict: true,
              isIcon: isHistory,
              icon: Ionicons.business_outline,
              bgColor: const Color(0xFFFAF5FF),
              borderColor: const Color(0xFFF3E8FF),
              iconColor: const Color(0xFFA855F7),
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            Align(
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
          ],
        ),
      ),
    );
  }

  Widget _buildInfoText({
    required String title,
    required String value,
    bool showStatus = false,
  }) {
    final statusLoader = invEntity.loader?.status ?? '';
    bool isShowStatus = true;

    if (AppRole.isChecker2 && statusLoader == 'completed') {
      isShowStatus = false;
    }

    if (AppRole.isDriver) {
      isShowStatus = showStatus;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: buttonINV == EnumButtonInv.acceptINV,
          child: Container(
            height: 20,
            width: 20,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              border: invEntity.isChecked
                  ? null
                  : Border.all(width: 1, color: Color(0xFFCBD5E1)),
              borderRadius: BorderRadius.circular(6),
              color: invEntity.isChecked
                  ? const Color(0xFF22C55E)
                  : Colors.white,
            ),
            child: invEntity.isChecked
                ? Icon(Icons.check_rounded, size: 18, color: Colors.white)
                : null,
          ),
        ),
        SizedBox(
          width: 75,
          child: Text(
            '$title : ',
            style: _textStyle(
              // height: 1,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF94A3B8),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: _textStyleCousine(
              // height: 1.22,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Visibility(
          visible: isShowStatus,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: BoxStatus.buildBorderColor(
                  statusScanDriver: invEntity.driver?.scanDriver ?? false,
                  statusArriveDriver: invEntity.driver?.arriveDriver ?? false,
                  statusDelivCancel:
                      invEntity.driver?.statusDelivCancel ?? false,
                ),
              ),
              color: BoxStatus.buildBgColor(
                statusScanDriver: invEntity.driver?.scanDriver ?? false,
                statusArriveDriver: invEntity.driver?.arriveDriver ?? false,
                statusDelivCancel: invEntity.driver?.statusDelivCancel ?? false,
              ),
            ),
            child: Text(
              BoxStatus.buildText(
                statusScanDriver: invEntity.driver?.scanDriver ?? false,
                statusArriveDriver: invEntity.driver?.arriveDriver ?? false,
                statusDelivCancel: invEntity.driver?.statusDelivCancel ?? false,
              ),
              style: _textStyle(
                fontWeight: FontWeight.bold,
                color: BoxStatus.buildTextColor(),
              ),
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
            borderRadius: BorderRadius.circular(7),
            // border: Border.all(
            //   width: 1,
            //   color: borderColor ?? Colors.transparent,
            // ),
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
    return GoogleFonts.plusJakartaSans(
      color: color,
      // backgroundColor: Colors.blue,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
    );
  }

  TextStyle _textStyleCousine({
    double fontSize = 13,
    FontWeight fontWeight = FontWeight.w400,
    double? height,
    Color color = const Color(0xFF171717),
  }) {
    return GoogleFonts.ibmPlexMono(
      color: color,
      // backgroundColor: Colors.amber,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      textBaseline: TextBaseline.ideographic,
    );
  }
}
