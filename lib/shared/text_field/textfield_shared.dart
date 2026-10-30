import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/text_styles.dart';

class SharedTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool? readOnly;
  final String? labelText;
  final String? hintText;
  final Widget? prefix;
  final String? prefixText;
  final Widget? prefixIcon;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final TextAlignVertical? textAlignVertical;
  final bool? obscureText;
  final Widget? suffixIcon;
  final int? maxLines;
  final bool? isDense;
  final double? radius;
  final Color? fillColor;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;

  const SharedTextField({
    super.key,
    this.readOnly,
    this.labelText,
    this.hintText,
    this.prefix,
    this.prefixText,
    this.prefixIcon,
    this.textInputAction = TextInputAction.done,
    this.keyboardType,
    this.textAlignVertical,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLines,
    this.isDense,
    this.inputFormatters,
    this.fillColor,
    this.validator,
    this.contentPadding,
    this.radius,
    this.textStyle,
    this.hintStyle,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines ?? 1,
      readOnly: readOnly ?? false,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      textInputAction: textInputAction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: inputFormatters,
      style: textStyle,
      textAlignVertical: textAlignVertical,
      decoration: InputDecoration(
        isDense: isDense,
        prefix: prefix,
        prefixText: prefixText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,

        // prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),

        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        hintText: hintText,
        hintStyle:
            hintStyle ??
            TextStyles.basicTextStyle(
              fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.48,
              color: const Color(0xFF9FA2B4),
            ),
        filled: true,
        fillColor: fillColor ?? Colors.white70,
        border: border ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 10),
          borderSide: const BorderSide(color: AppTheme.divider),
        ),
        focusedBorder: focusedBorder ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 10),
          borderSide: const BorderSide(color: AppTheme.divider),
        ),
        enabledBorder: enabledBorder ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 10),
          borderSide: const BorderSide(color: AppTheme.divider),
        ),
        labelText: labelText,
        labelStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      ),
      validator: validator,
    );
  }
}
