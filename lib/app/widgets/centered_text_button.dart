import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/widgets/app_text.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';
import 'package:frontend_waste_management_stackholder/core/values/app_icon_name.dart';

class CenteredTextButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final bool isEnabled;
  final Function() onTap;
  final Color color;
  final Color fontColor;
  final double width;
  final double height;
  final AppIconName? leftIcon;
  final AppIconName? rightIcon;

  const CenteredTextButton._internal({
    Key? key,
    required this.label,
    required this.isPrimary,
    required this.isEnabled,
    required this.onTap,
    required this.color,
    required this.height,
    required this.width,
    required this.fontColor,
    this.leftIcon,
    this.rightIcon,
  }) : super(key: key);

  factory CenteredTextButton.primary({
    Key? key,
    required String label,
    bool isEnabled = true,
    required Function() onTap,
    required BuildContext context,
    double width = 350,
    double height = 50.0,
  }) {
    return CenteredTextButton._internal(
      key: key,
      label: label,
      isPrimary: true,
      isEnabled: isEnabled,
      onTap: onTap,
      color: Theme.of(context).appColors.buttonPrimary,
      fontColor: Theme.of(context).appColors.textWhite,
      width: width,
      height: height,
    );
  }

  factory CenteredTextButton.secondary({
    Key? key,
    required String label,
    bool isEnabled = true,
    required Function() onTap,
    required BuildContext context,
    double width = 350,
    double height = 50.0,
  }) {
    return CenteredTextButton._internal(
      key: key,
      label: label,
      isPrimary: false,
      isEnabled: isEnabled,
      onTap: onTap,
      color: Theme.of(context).appColors.buttonSecondary,
      fontColor: Theme.of(context).appColors.textPrimary,
      width: width,
      height: height,
    );
  }

  factory CenteredTextButton.tertiary({
    Key? key,
    required String label,
    bool isEnabled = true,
    required Function() onTap,
    required BuildContext context,
    double width = 350,
    double height = 50.0,
  }) {
    return CenteredTextButton._internal(
      key: key,
      label: label,
      isPrimary: false,
      isEnabled: isEnabled,
      onTap: onTap,
      color: Theme.of(context).appColors.buttonTertiary,
      fontColor: Theme.of(context).appColors.textWhite,
      width: width,
      height: height,
    );
  }

  factory CenteredTextButton.quaternary({
    Key? key,
    required String label,
    bool isEnabled = true,
    required Function() onTap,
    required BuildContext context,
    double width = 350,
    double height = 50.0,
  }) {
    return CenteredTextButton._internal(
      key: key,
      label: label,
      isPrimary: false,
      isEnabled: isEnabled,
      onTap: onTap,
      color: Theme.of(context).appColors.buttonQuaternary,
      width: width,
      height: height,
      fontColor: Theme.of(context).appColors.textWhite,
    );
  }

  factory CenteredTextButton.custom({
    Key? key,
    required String label,
    bool isEnabled = true,
    required Function() onTap,
    required BuildContext context,
    double width = 350,
    double height = 50.0,
    required Color color,
    required Color fontColor,
  }) {
    return CenteredTextButton._internal(
      key: key,
      label: label,
      isPrimary: false,
      isEnabled: isEnabled,
      onTap: onTap,
      color: color,
      fontColor: fontColor,
      width: width,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
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
          child: AppText.labelSmallDefault(
            label,
            context: context,
            color: fontColor,
          ),
        ),
      ),
    );
  }
}
