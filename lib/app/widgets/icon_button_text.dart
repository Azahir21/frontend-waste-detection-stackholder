import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_icon.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';

class CustomIconButtonWithText extends StatelessWidget {
  final String label;
  final AppIconName iconName;
  final bool isActive;
  final Function() onTap;
  final Color color;
  final Color iconColor;
  final double width;
  final double height;
  final double iconSize;

  const CustomIconButtonWithText._internal({
    Key? key,
    required this.label,
    required this.iconName,
    required this.isActive,
    required this.onTap,
    required this.color,
    required this.iconColor,
    required this.width,
    required this.height,
    required this.iconSize,
  }) : super(key: key);

  factory CustomIconButtonWithText.primary({
    Key? key,
    required String label,
    required AppIconName iconName,
    bool isActive = true,
    required Function() onTap,
    required BuildContext context,
    double width = 65.0,
    double height = 65.0,
    double iconSize = 32.0,
  }) {
    return CustomIconButtonWithText._internal(
      key: key,
      label: label,
      iconName: iconName,
      isActive: isActive,
      onTap: onTap,
      color: Theme.of(context).appColors.iconButtonSecondary,
      iconColor: Theme.of(context).appColors.iconPrimary,
      width: width,
      height: height,
      iconSize: iconSize,
    );
  }

  factory CustomIconButtonWithText.custom({
    Key? key,
    required String label,
    required AppIconName iconName,
    bool isActive = true,
    required Function() onTap,
    required BuildContext context,
    double width = 65.0,
    double height = 65.0,
    double iconSize = 32.0,
  }) {
    return CustomIconButtonWithText._internal(
      key: key,
      label: label,
      iconName: iconName,
      isActive: isActive,
      onTap: onTap,
      color: Theme.of(context).appColors.iconButtonSecondary,
      iconColor: Theme.of(context).appColors.iconSecondary,
      width: width,
      height: height,
      iconSize: iconSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isActive
                ? Theme.of(context).appColors.iconPrimary
                : Theme.of(context).appColors.iconButtonSecondary,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppIcon.custom(
                appIconName: iconName,
                color: iconColor,
                size: iconSize,
                context: context,
              ),
              const SizedBox(height: 3),
              AppText.customSize(label, size: 8, context: context)
            ],
          ),
        ),
      ),
    );
  }
}
