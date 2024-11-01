import 'package:flutter/material.dart';
import 'package:to_do_list/build_text_widget.dart';

class BuildTextButton extends StatelessWidget {
  final Color? buttonColor;
  final String? text;
  final Color? textColor;
  final VoidCallback? onPressed;
  final OutlinedBorder? shape;

  const BuildTextButton({
    super.key,
    this.buttonColor,
    this.text,
    this.textColor,
    this.onPressed,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          buttonColor,
        ),
        shape: WidgetStatePropertyAll(
          shape,
        ),
      ),
      onPressed: onPressed,
      child: BuildTextWidget(
        text: text,
        style: TextStyle(
          color: textColor,
        ),
        textColor: textColor,
      ),
    );
  }
}
