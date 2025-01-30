import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_icon.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';

class CustomIconButton extends StatelessWidget {
  final AppIconName iconName;
  final bool isPrimary;
  final bool isEnabled;
  final bool isBordered;
  final bool isActive;
  final Function() onTap;
  final Color color;
  final Color iconColor;
  final double width;
  final double height;
  final double iconSize;

  const CustomIconButton._internal({
    Key? key,
    required this.iconName,
    required this.isPrimary,
    required this.isEnabled,
    required this.isBordered,
    required this.isActive,
    required this.onTap,
    required this.color,
    required this.iconColor,
    required this.width,
    required this.height,
    required this.iconSize,
  }) : super(key: key);

  factory CustomIconButton.primary({
    Key? key,
    required AppIconName iconName,
    bool isEnabled = true,
    required Function() onTap,
    required BuildContext context,
    double width = 50.0,
    double height = 50.0,
    double iconSize = 32.0,
  }) {
    return CustomIconButton._internal(
      key: key,
      iconName: iconName,
      isPrimary: true,
      isActive: true,
      isEnabled: isEnabled,
      isBordered: false,
      onTap: onTap,
      color: Theme.of(context).appColors.iconButtonPrimary,
      iconColor: Theme.of(context).appColors.iconPrimary,
      width: width,
      height: height,
      iconSize: iconSize,
    );
  }

  factory CustomIconButton.secondary({
    Key? key,
    required AppIconName iconName,
    bool isEnabled = true,
    required Function() onTap,
    required BuildContext context,
    double width = 50.0,
    double height = 50.0,
    double iconSize = 32.0,
  }) {
    return CustomIconButton._internal(
      key: key,
      iconName: iconName,
      isPrimary: false,
      isEnabled: isEnabled,
      isBordered: false,
      isActive: true,
      onTap: onTap,
      color: Theme.of(context).appColors.iconButtonSecondary,
      iconColor: Theme.of(context).appColors.iconSecondary,
      width: width,
      height: height,
      iconSize: iconSize,
    );
  }

  factory CustomIconButton.activeBordered({
    Key? key,
    required AppIconName iconName,
    bool isEnabled = true,
    required Function() onTap,
    required BuildContext context,
    double width = 50.0,
    double height = 50.0,
    double iconSize = 32.0,
  }) {
    return CustomIconButton._internal(
      key: key,
      iconName: iconName,
      isPrimary: true,
      isEnabled: isEnabled,
      isBordered: true,
      isActive: true,
      onTap: onTap,
      color: Theme.of(context).appColors.iconButtonPrimary,
      iconColor: Theme.of(context).appColors.iconPrimary,
      width: width,
      height: height,
      iconSize: iconSize,
    );
  }

  factory CustomIconButton.inactiveBordered({
    Key? key,
    required AppIconName iconName,
    bool isEnabled = true,
    required Function() onTap,
    required BuildContext context,
    double width = 50.0,
    double height = 50.0,
    double iconSize = 32.0,
  }) {
    return CustomIconButton._internal(
      key: key,
      iconName: iconName,
      isPrimary: true,
      isEnabled: isEnabled,
      isBordered: true,
      isActive: false,
      onTap: onTap,
      color: Theme.of(context).appColors.iconButtonPrimary,
      iconColor: Theme.of(context).appColors.iconPrimary,
      width: width,
      height: height,
      iconSize: iconSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: isPrimary
                  ? Colors.black.withOpacity(0.2)
                  : Colors.transparent,
              offset: const Offset(0, 3),
              blurRadius: 6,
            ),
          ],
          border: isBordered
              ? Border.all(
                  color: isActive
                      ? Theme.of(context).appColors.iconPrimary
                      : Theme.of(context).appColors.iconSecondary,
                  width: 3.0,
                )
              : null,
        ),
        child: Center(
          child: AppIcon.custom(
            appIconName: iconName,
            color: iconColor,
            size: iconSize,
            context: context,
          ),
        ),
      ),
    );
  }
}
