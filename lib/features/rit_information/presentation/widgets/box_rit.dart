import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BoxRit extends StatelessWidget {
  final String rit;
  final String? dateRit;
  final Color? colorBox;
  final Function()? onPressed;

  const BoxRit({
    super.key,
    required this.rit,
    this.dateRit,
    this.colorBox,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorBox ?? const Color(0xFFf5f6f6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 33,
              width: 33,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFdaeafc),
              ),
              child: Icon(
                Icons.calendar_month_outlined,
                color: const Color(0xFF165be3),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RIT-$rit',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    dateRit != null
                        ? DateFormat(
                            'dd MMMM yyyy',
                          ).format(DateTime.parse(dateRit!))
                        : '-',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF4d5461),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: onPressed != null,
              child: Icon(CupertinoIcons.arrow_right_arrow_left_circle, size: 24),
            ),
            // const SizedBox(width: 10),
            // Container(
            //   padding: const EdgeInsets.all(5),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(7),
            //     color: const Color(0xFFd6f2dd),
            //   ),
            //   child: Text(
            //     'Selesai',
            //     style: _textStyle(
            //       fontSize: 12,
            //       fontWeight: FontWeight.w600,
            //       letterSpacing: 0.45,
            //       color: Color(0xFF69b47c),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
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
