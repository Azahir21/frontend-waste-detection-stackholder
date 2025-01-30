import 'dart:ui';

import 'package:flutter/material.dart';

class AppDimensionsTheme extends ThemeExtension<AppDimensionsTheme> {
  final double radiusHelpIndication;
  final EdgeInsets paddingHelpIndication;

  const AppDimensionsTheme._internal({
    required this.radiusHelpIndication,
    required this.paddingHelpIndication,
  });

  factory AppDimensionsTheme.main(FlutterView flutterView) =>
      AppDimensionsTheme._internal(
        radiusHelpIndication: flutterView.isSmartphone
            ? 8
            : 16, // Only two categories now: Smartphone or Desktop
        paddingHelpIndication:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );

  @override
  ThemeExtension<AppDimensionsTheme> copyWith() {
    return AppDimensionsTheme._internal(
      radiusHelpIndication: radiusHelpIndication,
      paddingHelpIndication: paddingHelpIndication,
    );
  }

  @override
  ThemeExtension<AppDimensionsTheme> lerp(
          covariant ThemeExtension<AppDimensionsTheme>? other, double t) =>
      this;
}

extension FlutterViewExtended on FlutterView {
  static const double responsiveTablet =
      600; // Threshold for smartphone vs. desktop

  double get logicalWidth => physicalSize.width / devicePixelRatio;
  double get logicalHeight => physicalSize.height / devicePixelRatio;
  double get logicalWidthSA =>
      (physicalSize.width - padding.left - padding.right) / devicePixelRatio;
  double get logicalHeightSA =>
      (physicalSize.height - padding.top - padding.bottom) / devicePixelRatio;

  /// A device is classified as a smartphone if its width is below the tablet threshold
  bool get isSmartphone {
    return logicalWidthSA < responsiveTablet;
  }

  /// A device is classified as a desktop (which includes tablets)
  bool get isDesktop {
    return !isSmartphone;
  }
}
