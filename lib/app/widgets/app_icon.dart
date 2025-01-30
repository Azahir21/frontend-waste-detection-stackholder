import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';

class AppIcon extends StatelessWidget {
  final String name;
  final Color? color;
  final double? size;

  const AppIcon._internal({
    super.key,
    required this.name,
    this.color,
    this.size,
  });

  factory AppIcon.custom(
          {Key? key,
          required AppIconName appIconName,
          required BuildContext context,
          Color? color,
          double size = 32}) =>
      AppIcon._internal(
        key: key,
        name: appIconName.name,
        color: color,
        size: size,
      );

  factory AppIcon.main({
    Key? key,
    required AppIconName appIconName,
    required BuildContext context,
  }) =>
      AppIcon._internal(
        key: key,
        name: appIconName.name,
        color: Theme.of(context).appColors.iconDefault,
        size: 32,
      );

  factory AppIcon.reversed({
    Key? key,
    required AppIconName appIconName,
    required BuildContext context,
  }) =>
      AppIcon._internal(
        key: key,
        name: appIconName.name,
        color: Theme.of(context).appColors.iconDefault,
        size: 32,
      );

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      name,
      color: color,
      width: size,
      height: size,
    );
  }
}
