import 'package:flutter/material.dart';

class AppColorsTheme extends ThemeExtension<AppColorsTheme> {
  // reference colors:
  static const Color _green = Color(0xff17C690);
  static const Color _darkgreen = Color(0xff114C3A);
  static const Color _red = Color(0xffff0000);
  static const Color _brown = Color(0xff1F9254);
  static const Color _gray = Color(0xffD4D4D4);
  static const Color _smoke = Color(0xffF6F6F6);

  static const LinearGradient _greenGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xff169870), Color(0xff17C18D)],
  );
  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xffA60303), Color(0xffF80101)],
  );

  // actual colors used throughout the app:
  final LinearGradient backgroundGradient;
  final LinearGradient greenGradient;
  final LinearGradient redGradient;
  final Color backgroundDefault;
  final Color backgroundSmoke;
  final Color borderPrimary;
  final Color borderSecondary;
  final Color formFieldBorder;
  final Color snackbarSuccess;
  final Color snackbarError;
  final Color textPrimary;
  final Color textSecondary;
  final Color textWhite;
  final Color textBlack;
  final Color textRed;
  final Color textBrown;
  final Color buttonPrimary;
  final Color buttonSecondary;
  final Color buttonTertiary;
  final Color buttonQuaternary;
  final Color buttonDisabled;
  final Color iconPrimary;
  final Color iconSecondary;
  final Color iconTertiary;
  final Color iconButtonPrimary;
  final Color iconButtonSecondary;
  final Color iconDefault;
  final Color iconActivate;
  final Color iconDisable;

  // private constructor (use factories below instead):
  const AppColorsTheme._internal({
    required this.backgroundGradient,
    required this.greenGradient,
    required this.redGradient,
    required this.backgroundDefault,
    required this.backgroundSmoke,
    required this.borderPrimary,
    required this.borderSecondary,
    required this.formFieldBorder,
    required this.snackbarSuccess,
    required this.snackbarError,
    required this.textPrimary,
    required this.textSecondary,
    required this.textWhite,
    required this.textBlack,
    required this.textRed,
    required this.textBrown,
    required this.buttonPrimary,
    required this.buttonSecondary,
    required this.buttonTertiary,
    required this.buttonQuaternary,
    required this.buttonDisabled,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.iconTertiary,
    required this.iconButtonPrimary,
    required this.iconButtonSecondary,
    required this.iconDefault,
    required this.iconActivate,
    required this.iconDisable,
  });

  // factory for light mode:
  factory AppColorsTheme.light() {
    return const AppColorsTheme._internal(
      backgroundGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xffD0f3E8), Colors.white],
        tileMode: TileMode.decal,
        stops: [.001, 0.1],
      ),
      greenGradient: _greenGradient,
      redGradient: _redGradient,
      backgroundDefault: Color(0xffFFFFFF),
      backgroundSmoke: _smoke,
      borderPrimary: _green,
      borderSecondary: _gray,
      formFieldBorder: _gray,
      snackbarSuccess: _green,
      snackbarError: _red,
      textPrimary: _green,
      textSecondary: _darkgreen,
      textWhite: Colors.white,
      textBlack: Colors.black,
      textRed: _red,
      textBrown: _brown,
      buttonPrimary: _green,
      buttonSecondary: _smoke,
      buttonTertiary: _darkgreen,
      buttonQuaternary: _red,
      buttonDisabled: _gray,
      iconPrimary: _green,
      iconSecondary: _gray,
      iconTertiary: _red,
      iconButtonPrimary: Colors.white,
      iconButtonSecondary: _smoke,
      iconDefault: _green,
      iconActivate: _darkgreen,
      iconDisable: _gray,
    );
  }

  // factory for dark mode:
  factory AppColorsTheme.dark() {
    return const AppColorsTheme._internal(
      backgroundGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xffD0f3E8), Colors.white],
        tileMode: TileMode.decal,
        stops: [.001, 0.1],
      ),
      greenGradient: _greenGradient,
      redGradient: _redGradient,
      backgroundDefault: Color(0xffFFFFFF),
      backgroundSmoke: _smoke,
      borderPrimary: _green,
      borderSecondary: _gray,
      formFieldBorder: _gray,
      snackbarSuccess: _green,
      snackbarError: _red,
      textPrimary: _green,
      textSecondary: _darkgreen,
      textWhite: Colors.white,
      textBlack: Colors.black,
      textRed: _red,
      textBrown: _brown,
      buttonPrimary: _green,
      buttonSecondary: _smoke,
      buttonTertiary: _darkgreen,
      buttonQuaternary: _red,
      buttonDisabled: _gray,
      iconPrimary: _green,
      iconSecondary: _smoke,
      iconTertiary: _red,
      iconButtonPrimary: _green,
      iconButtonSecondary: _smoke,
      iconDefault: _green,
      iconActivate: _darkgreen,
      iconDisable: _gray,
    );
  }

  @override
  ThemeExtension<AppColorsTheme> copyWith({bool? lightMode}) {
    if (lightMode == null || lightMode == true) {
      return AppColorsTheme.light();
    }
    return AppColorsTheme.dark();
  }

  @override
  ThemeExtension<AppColorsTheme> lerp(
          covariant ThemeExtension<AppColorsTheme>? other, double t) =>
      this;
}
