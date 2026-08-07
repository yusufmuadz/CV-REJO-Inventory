import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/text_styles.dart';

class AppBarWidget {
  Widget content({required String title, IconData? icon, Function()? onTap}) {
    return Container(
      height: 90,
      padding: EdgeInsets.all(16),
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 3,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyles.basicTextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
              letterSpacing: 0.5,
              color: Color(0xFF151C27),
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Icon(
              icon ?? Icons.add_circle_outline,
              size: 27,
              color: Color(0xFF151C27),
            ),
          ),
        ],
      ),
    );
  }
}
