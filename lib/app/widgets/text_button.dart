import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color color;
  final TextStyle style;

  const CustomTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.color,
    required this.style,
  }) : super(key: key);

  factory CustomTextButton.primary({
    Key? key,
    required String text,
    required Function onPressed,
    required BuildContext context,
    TextStyle? style,
  }) {
    return CustomTextButton(
      key: key,
      text: text,
      onPressed: onPressed,
      color: Theme.of(context).appColors.textPrimary,
      style: style ?? Theme.of(context).appTexts.textPrimary,
    );
  }

  factory CustomTextButton.secondary({
    Key? key,
    required String text,
    required Function onPressed,
    required BuildContext context,
    TextStyle? style,
  }) {
    return CustomTextButton(
      key: key,
      text: text,
      onPressed: onPressed,
      color: Theme.of(context).appColors.textSecondary,
      style: style ?? Theme.of(context).appTexts.textPrimary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Text(
        text,
        style: style.copyWith(color: color),
      ),
    );
  }
}
