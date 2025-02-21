import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_icon.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/horizontal_gap.dart';
import 'dart:math' as math;
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';

import 'package:get/get.dart';

import '../../controllers/statistic_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatisticCard extends GetView<StatisticController> {
  const StatisticCard({
    super.key,
    this.witdhFactor = 0.25,
    this.heightFactor = 1.0,
    this.fontSizeFactor = 0.08,
    this.fontSizeFactorBig = 0.3,
    required this.title,
    required this.value,
    required this.iconName,
    required this.gradient,
  });

  final double witdhFactor;
  final double heightFactor;
  final double fontSizeFactor;
  final double fontSizeFactorBig;
  final String title;
  final int value;
  final AppIconName iconName;
  final Gradient gradient;

  double _calculateFontSize(double containerWidth, double containerHeight,
      {double factor = 0.1}) {
    double smallerDimension = math.min(containerWidth, containerHeight);
    return smallerDimension * factor;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var color = Theme.of(context).appColors;
    return Container(
      width: size.width * witdhFactor,
      height: 225 * heightFactor,
      decoration: BoxDecoration(
        color: color.backgroundSmoke,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: color.borderPrimary,
          width: 2,
        ),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        double fontSize = _calculateFontSize(
            constraints.maxWidth, constraints.maxHeight,
            factor: fontSizeFactor);
        double bigFontSize = _calculateFontSize(
          constraints.maxWidth,
          constraints.maxHeight,
          factor: 0.3,
        );
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                        child: AppIcon.custom(
                            appIconName: iconName,
                            color: Colors.white,
                            context: context)),
                  ),
                  HorizontalGap.formMedium(),
                  Expanded(
                    child: AppText.customSize(
                      title,
                      size: fontSize,
                      color: color.textSecondary,
                      context: context,
                    ),
                  ),
                ],
              ),
            ),
            AppText.customSize(
              value.toString(),
              fontWeight: FontWeight.bold,
              size: bigFontSize,
              color: color.textSecondary,
              context: context,
            ),
          ],
        );
      }),
    );
  }
}
