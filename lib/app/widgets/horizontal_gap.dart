import 'package:flutter/material.dart';

class HorizontalGap extends StatelessWidget {
  final double width;

  const HorizontalGap._internal({
    super.key,
    required this.width,
  });

  factory HorizontalGap.formHuge({Key? key}) =>
      HorizontalGap._internal(key: key, width: 32);
  factory HorizontalGap.formBig({Key? key}) =>
      HorizontalGap._internal(key: key, width: 24);
  factory HorizontalGap.formMedium({Key? key}) =>
      HorizontalGap._internal(key: key, width: 16);
  factory HorizontalGap.formSmall({Key? key}) =>
      HorizontalGap._internal(key: key, width: 8);
  factory HorizontalGap.formTiny({Key? key}) =>
      HorizontalGap._internal(key: key, width: 4);

  // because sometimes you need it:
  factory HorizontalGap.custom(double width, {Key? key}) =>
      HorizontalGap._internal(key: key, width: width);

  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}
