import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SharedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final Icon? prefixIcon;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Function(String?) validator;
  const SharedTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.textInputAction = TextInputAction.next,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      textInputAction: textInputAction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        hintText: hintText,
        hintStyle: GoogleFonts.hankenGrotesk(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.48,
          color: Colors.grey.shade400,
        ),
        fillColor: Colors.white70,
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
      validator: (value) => validator(value),
    );
  }
}
