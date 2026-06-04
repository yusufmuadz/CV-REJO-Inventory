import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SharedTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool? readOnly;
  final String? labelText;
  final String? hintText;
  final Icon? prefixIcon;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final Widget? suffixIcon;
  final int? maxLines;
  final bool? isDense;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const SharedTextField({
    super.key,
    this.readOnly,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.textInputAction = TextInputAction.next,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLines,
    this.isDense,
    this.inputFormatters,
    this.fillColor,
    this.validator,
    this.contentPadding,
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
      decoration: InputDecoration(
        isDense: isDense,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        hintText: hintText,
        hintStyle: GoogleFonts.hankenGrotesk(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.48,
          color: const Color(0xFF9FA2B4),
        ),
        filled: true,
        fillColor: fillColor ?? Colors.white70,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(),
        ),
        labelText: labelText,
        labelStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      ),
      validator: validator,
    );
  }
}
