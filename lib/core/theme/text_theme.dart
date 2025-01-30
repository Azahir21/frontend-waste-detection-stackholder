import 'package:flutter/material.dart';

class AppTextsTheme extends ThemeExtension<AppTextsTheme> {
  static const _baseFamily = 'Poppins';

  final TextStyle labelBigEmphasis;
  final TextStyle labelBigDefault;
  final TextStyle labelDefaultEmphasis;
  final TextStyle labelDefaultDefault;
  final TextStyle labelSmallEmphasis;
  final TextStyle labelSmallDefault;
  final TextStyle labelTinyDefault;
  final TextStyle labelTinyEmphasis;
  final TextStyle textPrimary;

  const AppTextsTheme._internal({
    required this.labelBigEmphasis,
    required this.labelBigDefault,
    required this.labelDefaultEmphasis,
    required this.labelDefaultDefault,
    required this.labelSmallEmphasis,
    required this.labelSmallDefault,
    required this.labelTinyDefault,
    required this.labelTinyEmphasis,
    required this.textPrimary,
  });

  factory AppTextsTheme.main() => const AppTextsTheme._internal(
        labelBigEmphasis: TextStyle(
          fontFamily: _baseFamily,
          fontWeight: FontWeight.bold,
          fontSize: 24,
          height: 1.4,
        ),
        labelBigDefault: TextStyle(
          fontFamily: _baseFamily,
          fontWeight: FontWeight.normal,
          fontSize: 24,
          height: 1.4,
        ),
        labelDefaultEmphasis: TextStyle(
          fontFamily: _baseFamily,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          height: 1.4,
        ),
        labelDefaultDefault: TextStyle(
          fontFamily: _baseFamily,
          fontWeight: FontWeight.normal,
          fontSize: 20,
          height: 1.4,
        ),
        labelSmallEmphasis: TextStyle(
          fontFamily: _baseFamily,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          height: 1.4,
        ),
        labelSmallDefault: TextStyle(
          fontFamily: _baseFamily,
          fontWeight: FontWeight.normal,
          fontSize: 16,
          height: 1.4,
        ),
        labelTinyDefault: TextStyle(
          fontFamily: _baseFamily,
          fontWeight: FontWeight.normal,
          fontSize: 12,
          height: 1.4,
        ),
        labelTinyEmphasis: TextStyle(
          fontFamily: _baseFamily,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          height: 1.4,
        ),
        textPrimary: TextStyle(
          fontFamily: _baseFamily,
          fontWeight: FontWeight.normal,
          fontSize: 16,
          height: 1.4,
        ),
      );

  @override
  ThemeExtension<AppTextsTheme> copyWith() {
    return AppTextsTheme._internal(
      labelBigEmphasis: labelBigEmphasis,
      labelBigDefault: labelBigDefault,
      labelDefaultEmphasis: labelDefaultEmphasis,
      labelDefaultDefault: labelDefaultDefault,
      labelSmallEmphasis: labelSmallEmphasis,
      labelSmallDefault: labelSmallDefault,
      labelTinyDefault: labelTinyDefault,
      labelTinyEmphasis: labelTinyEmphasis,
      textPrimary: textPrimary,
    );
  }

  @override
  ThemeExtension<AppTextsTheme> lerp(
          covariant ThemeExtension<AppTextsTheme>? other, double t) =>
      this;
}
