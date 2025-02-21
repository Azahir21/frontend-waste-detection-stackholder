import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_icon.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';

class CenteredTextButtonWithIcon extends StatelessWidget {
  final String label;
  final bool isEnabled;
  final Function() onTap;
  final Color color;
  final Color fontColor;
  final double width;
  final double height;
  final AppIconName? leftIcon;
  final AppIconName? rightIcon;

  const CenteredTextButtonWithIcon({
    Key? key,
    required this.label,
    this.isEnabled = true,
    required this.onTap,
    required this.color,
    required this.fontColor,
    this.width = 350,
    this.height = 50.0,
    this.leftIcon,
    this.rightIcon,
  }) : super(key: key);

  factory CenteredTextButtonWithIcon.primary({
    Key? key,
    required String label,
    bool isEnabled = true,
    required Function() onTap,
    required BuildContext context,
    double width = 350.0,
    double height = 50.0,
    AppIconName? leftIcon,
    AppIconName? rightIcon,
  }) {
    return CenteredTextButtonWithIcon(
      key: key,
      label: label,
      isEnabled: isEnabled,
      onTap: onTap,
      color: Theme.of(context).appColors.buttonPrimary,
      fontColor: Theme.of(context).appColors.textWhite,
      width: width,
      height: height,
      leftIcon: leftIcon,
      rightIcon: rightIcon,
    );
  }

  factory CenteredTextButtonWithIcon.secondary({
    Key? key,
    required String label,
    bool isEnabled = true,
    required Function() onTap,
    required BuildContext context,
    double width = 350.0,
    double height = 50.0,
    AppIconName? leftIcon,
    AppIconName? rightIcon,
  }) {
    return CenteredTextButtonWithIcon(
      key: key,
      label: label,
      isEnabled: isEnabled,
      onTap: onTap,
      color: Theme.of(context).appColors.buttonSecondary,
      fontColor: Theme.of(context).appColors.textPrimary,
      width: width,
      height: height,
      leftIcon: leftIcon,
      rightIcon: rightIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isEnabled ? onTap : null,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(color),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leftIcon != null)
              AppIcon.custom(
                appIconName: leftIcon!,
                context: context,
                color: fontColor,
                size: 32,
              ),
            AppText.labelSmallEmphasis(
              label,
              color: fontColor,
              context: context,
            ),
            if (rightIcon != null)
              AppIcon.custom(
                appIconName: rightIcon!,
                context: context,
                color: fontColor,
                size: 32,
              ),
          ],
        ),
      ),
    );
  }
}
