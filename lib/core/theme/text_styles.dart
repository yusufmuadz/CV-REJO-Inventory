import 'package:flutter/material.dart';

/// Centralized text styles for consistent typography
/// Follows DRY principle for maintainability
class TextStyles {
  const TextStyles._();

  // Regular weights
  static const TextStyle regular = TextStyle(
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  static const TextStyle medium = TextStyle(
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static const TextStyle semiBold = TextStyle(
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle bold = TextStyle(
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );

  // Display styles
  static TextStyle displayLarge(Color color) =>
      regular.copyWith(fontSize: 57, height: 1.12, color: color);

  static TextStyle displayMedium(Color color) =>
      regular.copyWith(fontSize: 45, height: 1.16, color: color);

  static TextStyle displaySmall(Color color) =>
      regular.copyWith(fontSize: 36, height: 1.22, color: color);

  // Headline styles
  static TextStyle headlineLarge(Color color) =>
      semiBold.copyWith(fontSize: 32, height: 1.25, color: color);

  static TextStyle headlineMedium(Color color) =>
      semiBold.copyWith(fontSize: 28, height: 1.29, color: color);

  static TextStyle headlineSmall(Color color) =>
      semiBold.copyWith(fontSize: 24, height: 1.33, color: color);

  // Title styles
  static TextStyle titleLarge(Color color) =>
      semiBold.copyWith(fontSize: 22, height: 1.27, color: color);

  static TextStyle titleMedium(Color color) =>
      semiBold.copyWith(fontSize: 16, height: 1.5, color: color);

  static TextStyle titleSmall(Color color) => medium.copyWith(
    fontSize: 14,
    height: 1.43,
    color: color,
    letterSpacing: 0.1,
  );

  // Body styles
  static TextStyle bodyLarge(Color color) =>
      regular.copyWith(fontSize: 16, height: 1.5, color: color);

  static TextStyle bodyMedium(Color color) =>
      regular.copyWith(fontSize: 14, height: 1.43, color: color);

  static TextStyle bodySmall(Color color) =>
      regular.copyWith(fontSize: 12, height: 1.33, color: color);

  // Label styles
  static TextStyle labelLarge(Color color) => medium.copyWith(
    fontSize: 14,
    height: 1.43,
    color: color,
    letterSpacing: 0.1,
  );

  static TextStyle labelMedium(Color color) => medium.copyWith(
    fontSize: 12,
    height: 1.33,
    color: color,
    letterSpacing: 0.5,
  );

  static TextStyle labelSmall(Color color) => medium.copyWith(
    fontSize: 11,
    height: 1.45,
    color: color,
    letterSpacing: 0.5,
  );

  // Button style
  static TextStyle button(Color color) => semiBold.copyWith(
    fontSize: 14,
    height: 1.43,
    color: color,
    letterSpacing: 0.1,
  );

  // Custom utility styles
  static TextStyle caption(Color color) =>
      regular.copyWith(fontSize: 12, height: 1.33, color: color);

  static TextStyle overline(Color color) => regular.copyWith(
    fontSize: 10,
    height: 1.6,
    color: color,
    letterSpacing: 1.5,
  );

  static TextStyle price(Color color) =>
      bold.copyWith(fontSize: 24, height: 1.2, color: color);

  static TextStyle priceSmall(Color color) =>
      semiBold.copyWith(fontSize: 18, height: 1.3, color: color);

  static TextStyle basicTextStyle({
    String fontFamily = 'Inter',
    double fontSize = 13,
    FontWeight fontWeight = FontWeight.w400,
    double? height,
    Color color = const Color(0xFF171717),
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      height: height,
    );
  }
}
