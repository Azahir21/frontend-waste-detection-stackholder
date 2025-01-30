import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/core/theme/theme_data.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final Color color;
  final TextAlign textAlign;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final int? size;

  const AppText._internal(
    this.text, {
    super.key,
    required this.textStyle,
    required this.color,
    this.textAlign = TextAlign.start,
    this.textOverflow,
    this.maxLines,
    this.size,
  });

  factory AppText.labelBigEmphasis(
    String text, {
    Key? key,
    required BuildContext context,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? textOverflow,
    int? maxLines,
  }) =>
      AppText._internal(
        text,
        key: key,
        textStyle: Theme.of(context).appTexts.labelBigEmphasis,
        color: color ?? Theme.of(context).appColors.textPrimary,
        textAlign: textAlign ?? TextAlign.start,
        textOverflow: textOverflow,
        maxLines: maxLines,
      );

  factory AppText.labelBigDefault(
    String text, {
    Key? key,
    required BuildContext context,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? textOverflow,
    int? maxLines,
  }) =>
      AppText._internal(
        text,
        key: key,
        textStyle: Theme.of(context).appTexts.labelBigDefault,
        color: color ?? Theme.of(context).appColors.textPrimary,
        textAlign: textAlign ?? TextAlign.start,
        textOverflow: textOverflow,
        maxLines: maxLines,
      );

  factory AppText.labelDefaultEmphasis(
    String text, {
    Key? key,
    required BuildContext context,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? textOverflow,
    int? maxLines,
  }) =>
      AppText._internal(
        text,
        key: key,
        textStyle: Theme.of(context).appTexts.labelDefaultEmphasis,
        color: color ?? Theme.of(context).appColors.textPrimary,
        textAlign: textAlign ?? TextAlign.start,
        textOverflow: textOverflow,
        maxLines: maxLines,
      );

  factory AppText.labelDefaultDefault(
    String text, {
    Key? key,
    required BuildContext context,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? textOverflow,
    int? maxLines,
  }) =>
      AppText._internal(
        text,
        key: key,
        textStyle: Theme.of(context).appTexts.labelDefaultDefault,
        color: color ?? Theme.of(context).appColors.textPrimary,
        textAlign: textAlign ?? TextAlign.start,
        textOverflow: textOverflow,
        maxLines: maxLines,
      );

  factory AppText.labelSmallEmphasis(
    String text, {
    Key? key,
    required BuildContext context,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? textOverflow,
    int? maxLines,
  }) =>
      AppText._internal(
        text,
        key: key,
        textStyle: Theme.of(context).appTexts.labelSmallEmphasis,
        color: color ?? Theme.of(context).appColors.textPrimary,
        textAlign: textAlign ?? TextAlign.start,
        textOverflow: textOverflow,
        maxLines: maxLines,
      );

  factory AppText.labelSmallDefault(
    String text, {
    Key? key,
    required BuildContext context,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? textOverflow,
    int? maxLines,
  }) =>
      AppText._internal(
        text,
        key: key,
        textStyle: Theme.of(context).appTexts.labelSmallDefault,
        color: color ?? Theme.of(context).appColors.textPrimary,
        textAlign: textAlign ?? TextAlign.start,
        textOverflow: textOverflow,
        maxLines: maxLines,
      );

  factory AppText.labelTinyDefault(
    String text, {
    Key? key,
    required BuildContext context,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? textOverflow,
    int? maxLines,
  }) =>
      AppText._internal(
        text,
        key: key,
        textStyle: Theme.of(context).appTexts.labelTinyDefault,
        color: color ?? Theme.of(context).appColors.textPrimary,
        textAlign: textAlign ?? TextAlign.start,
        textOverflow: textOverflow,
        maxLines: maxLines,
      );

  factory AppText.labelTinyEmphasis(
    String text, {
    Key? key,
    required BuildContext context,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? textOverflow,
    int? maxLines,
  }) =>
      AppText._internal(
        text,
        key: key,
        textStyle: Theme.of(context).appTexts.labelTinyEmphasis,
        color: color ?? Theme.of(context).appColors.textPrimary,
        textAlign: textAlign ?? TextAlign.start,
        textOverflow: textOverflow,
        maxLines: maxLines,
      );

  factory AppText.textPrimary(
    String text, {
    Key? key,
    required BuildContext context,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? textOverflow,
    int? maxLines,
  }) =>
      AppText._internal(
        text,
        key: key,
        textStyle: Theme.of(context).appTexts.textPrimary,
        color: color ?? Theme.of(context).appColors.textPrimary,
        textAlign: textAlign ?? TextAlign.start,
        textOverflow: textOverflow,
        maxLines: maxLines,
      );

  factory AppText.customSize(
    String text, {
    Key? key,
    required BuildContext context,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? textOverflow,
    int? maxLines,
    required int size,
  }) =>
      AppText._internal(
        text,
        key: key,
        textStyle: Theme.of(context)
            .appTexts
            .textPrimary
            .copyWith(fontSize: size.toDouble()),
        color: color ?? Theme.of(context).appColors.textPrimary,
        textAlign: textAlign ?? TextAlign.start,
        textOverflow: textOverflow,
        maxLines: maxLines,
        size: size,
      );

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: textOverflow,
      style: textStyle.copyWith(color: color),
    );
  }
}
