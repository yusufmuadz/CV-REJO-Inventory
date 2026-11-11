import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/middlewares/app_role.dart';
import '../../core/theme/text_styles.dart';

class SharedCardRIT extends StatelessWidget {
  final bool isSelected;
  final bool? isTracking;
  final String totalPO;
  final String? totalOnProgressPO;
  final String noRIT;
  final String dateRIT;
  final String? nameRoute;

  final int colorRIT;

  final List<String> routeRIT;

  final RxBool isSelection;

  final Function() onTap;
  final Function() onTapSeePO;

  const SharedCardRIT({
    super.key,
    this.isTracking,
    required this.isSelected,
    required this.totalPO,
    required this.noRIT,
    required this.dateRIT,
    required this.colorRIT,
    required this.routeRIT,
    required this.isSelection,
    required this.onTap,
    required this.onTapSeePO,
    this.totalOnProgressPO,
    this.nameRoute,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: isSelection.value,
            child: Container(
              margin: const EdgeInsets.only(top: 10, right: 10),
              child: Container(
                height: 20,
                width: 20,
                padding: isSelected ? const EdgeInsets.all(2) : null,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: Colors.blue),
                ),
                child: isSelected
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
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1, color: Color(colorRIT)),
                  bottom: BorderSide(width: 1, color: Color(colorRIT)),
                  right: BorderSide(width: 1, color: Color(colorRIT)),
                  left: BorderSide(width: 7, color: Color(colorRIT)),
                ),
                borderRadius: BorderRadius.circular(12),
                color: isSelected ? Colors.grey.shade200 : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRowContent(
                    title: AppRole.isCollector ? 'RUTE' : 'NOMOR RIT',
                    value: 'Tanggal',
                    color: const Color(0xFF524439),
                    fontWeightTitle: FontWeight.w600,
                  ),
                  const SizedBox(height: 3),
                  _buildRowContent(
                    title: AppRole.isCollector
                        ? nameRoute ?? '-'
                        : 'RIT - $noRIT',
                    value: dateRIT.isEmpty || dateRIT == '-'
                        ? '-'
                        : DateFormat(
                            'dd MMMM yyyy',
                          ).format(DateTime.parse(dateRIT)),
                    color: const Color(0xFF151C27),
                    fontWeightTitle: FontWeight.bold,
                    fontWeightValue: FontWeight.w500,
                  ),
                  const Divider(
                    thickness: 1,
                    height: 24,
                    color: Color(0xFFE7EEFE),
                  ),
                  _buildContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isTracking == true) return _buildContentIsTracking();
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 18,
              color: const Color(0xFF8A5012),
            ),
            const SizedBox(width: 5),
            RichText(
              text: TextSpan(
                text: '$totalPO ',
                style: TextStyles.basicTextStyle(
                  fontSize: 16,
                  fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF151C27),
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Total ${AppRole.isCollector ? 'INVOICE/SJ' : 'PO'}',
                    style: TextStyles.basicTextStyle(
                      fontSize: 16,
                      fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF524439),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Visibility(
              visible: totalOnProgressPO != null,
              child: Icon(
                CupertinoIcons.cube_box,
                size: 18,
                color: const Color(0xFFD68F4D),
              ),
            ),
            Visibility(
              visible: totalOnProgressPO != null,
              child: Container(
                margin: const EdgeInsets.only(left: 5),
                child: RichText(
                  text: TextSpan(
                    text: '$totalOnProgressPO ',
                    style: TextStyles.basicTextStyle(
                      fontSize: 16,
                      fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF151C27),
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'PO Berjalan',
                        style: TextStyles.basicTextStyle(
                          fontSize: 16,
                          fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF524439),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: !AppRole.isCollector,
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Color(0xFF8A5012),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    routeRIT.isEmpty ? '-' : routeRIT.join(', '),
                    style: TextStyles.basicTextStyle(
                      fontSize: 16,
                      fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF524439),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Visibility(
          visible: AppRole.isPIC || AppRole.isChecker2,
          child: Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: onTapSeePO,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xFFd5914d),
                ),
                child: Text(
                  'Lihat PO',
                  style: TextStyles.basicTextStyle(
                    fontSize: 12,
                    letterSpacing: 0.48,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentIsTracking() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRowContentTracking(
          text1: 'Nama Driver',
          text2: 'Nopol',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF9CA3AF),
        ),
        const SizedBox(height: 2),
        _buildRowContentTracking(text1: 'TESTING', text2: 'T 357 ING'),
        const SizedBox(height: 12),
        _buildRowContentTracking(
          text1: 'Nama Armada',
          text2: 'Status Armada',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF9CA3AF),
        ),
        const SizedBox(height: 2),
        _buildRowContentTracking(
          isStatus: true,
          text1: 'MOBIL',
          text2: 'INTERNAL',
        ),
        const SizedBox(height: 12),
        Text(
          'Rute',
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF9CA3AF),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          routeRIT.join(', '),
          style: GoogleFonts.roboto(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status RIT',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 2),
                _buildStatusRIT(value: 'Completed'),
              ],
            ),
            InkWell(
              onTap: onTapSeePO,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xFFd5914d),
                ),
                child: Text(
                  'Lihat PO',
                  style: TextStyles.basicTextStyle(
                    fontSize: 12,
                    letterSpacing: 0.48,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRowContent({
    required String title,
    required String value,
    required Color color,
    required FontWeight fontWeightTitle,
    FontWeight fontWeightValue = FontWeight.w400,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.basicTextStyle(
              fontSize: 16,
              fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
              fontWeight: fontWeightTitle,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: fontWeightValue,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildRowContentTracking({
    required String text1,
    required String text2,
    bool? isStatus,
    Color? color,
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text1,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: color ?? Color(0xFF1F2937),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: isStatus == true
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: _buildBoxStatus(value: text2),
                )
              : Text(
                  text2,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    color: color ?? Color(0xFF1F2937),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildStatusRIT({required String value}) {
    Color bgColor = const Color(0xFFECFDF5);
    Color bdColor = const Color(0xFFA7F3D0);
    Color dotColor = const Color(0xFF10B981);
    Color txtColor = const Color(0xFF047857);

    if (value == 'Ongoing') {
      bgColor = const Color(0xFFEFF6FF);
      bdColor = const Color(0xFFBFDBFE);
      dotColor = const Color(0xFF10B981);
      txtColor = const Color(0xFF1D4ED8);
    } else if (value == 'Completed') {
      bgColor = const Color(0xFFF3F4F6);
      bdColor = const Color(0xFFE5E7EB);
      dotColor = const Color(0xFF9CA3AF);
      txtColor = const Color(0xFF374151);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: bdColor),
        borderRadius: BorderRadius.circular(20),
        color: bgColor,
      ),
      child: Row(
        children: [
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: txtColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoxStatus({required String value}) {
    Color bgColor = const Color(0xFFFFFBEB);
    Color bdColor = const Color(0xFFFDE68A);
    Color txtColor = const Color(0xFFB45309);

    if (value == 'INTERNAL') {
      bgColor = const Color(0xFFEFF6FF);
      bdColor = const Color(0xFFBFDBFE);
      txtColor = const Color(0xFF1D4ED8);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: bdColor),
        borderRadius: BorderRadius.circular(6),
        color: bgColor,
      ),
      child: Text(
        value,
        style: GoogleFonts.roboto(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: txtColor,
        ),
      ),
    );
  }
}
