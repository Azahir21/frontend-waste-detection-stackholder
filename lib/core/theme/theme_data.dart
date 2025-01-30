import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/core/theme/dimension_theme.dart';
import 'package:frontend_waste_management_stackholder/core/theme/text_theme.dart';
import 'package:frontend_waste_management_stackholder/core/theme/color_theme.dart';

extension ThemeDataExtended on ThemeData {
  AppDimensionsTheme get appDimensions => extension<AppDimensionsTheme>()!;
  AppColorsTheme get appColors => extension<AppColorsTheme>()!;
  AppTextsTheme get appTexts => extension<AppTextsTheme>()!;
}
