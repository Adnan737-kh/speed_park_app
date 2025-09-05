import 'package:flutter/material.dart';

import '../core/constants/colors.dart';


class MyText extends StatelessWidget {
  final String text;
  final double? size;
  final weight;
  final color;
  final align;
  final decoration;
  final fontFamily;
  final maxLines;

  const MyText({
    super.key,
    required this.text,
    this.size = 12.0,
    this.weight = FontWeight.normal,
    this.color = black,
    this.align = TextAlign.left,
    this.decoration,
    this.fontFamily = 'Poppins',
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color,
        decoration: decoration,
        fontFamily: fontFamily,
      ),
      textAlign: align,
      maxLines: maxLines,
    );
  }
}
