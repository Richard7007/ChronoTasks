import 'package:flutter/material.dart';

class BuildTextWidget extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final Color? textColor;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final TextStyle? style;

  const BuildTextWidget({
    super.key,
    this.text,
    this.fontSize,
    this.textColor,
    this.fontWeight,
    this.textDecoration,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      style: style,
    );
  }
}
