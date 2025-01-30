import 'package:flutter/material.dart';

class VerticalGap extends StatelessWidget {
  final double height;

  const VerticalGap._internal({
    super.key,
    required this.height,
  });

  factory VerticalGap.formHuge({Key? key}) =>
      VerticalGap._internal(key: key, height: 32);
  factory VerticalGap.formBig({Key? key}) =>
      VerticalGap._internal(key: key, height: 24);
  factory VerticalGap.formMedium({Key? key}) =>
      VerticalGap._internal(key: key, height: 16);
  factory VerticalGap.formSmall({Key? key}) =>
      VerticalGap._internal(key: key, height: 8);
  factory VerticalGap.formTiny({Key? key}) =>
      VerticalGap._internal(key: key, height: 4);

  // because sometimes you need it:
  factory VerticalGap.custom(double height, {Key? key}) =>
      VerticalGap._internal(key: key, height: height);

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}
