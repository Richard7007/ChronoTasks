import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuildTextFormFieldWidget extends StatelessWidget {
  final String? hintText;
  final TextInputType? textInputType;
  final Widget? suffixIcon;
  final TextAlign textAlign;
  final TextEditingController? controller;
  final VoidCallback? onPressed;
  final bool readOnly;
  final InputDecoration decoration;
  final VoidCallback? onTapped;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final double? size;

  const BuildTextFormFieldWidget({
    super.key,
    this.hintText,
    this.textInputType,
    this.suffixIcon,
    required this.textAlign,
    this.controller,
    this.onPressed,
    required this.readOnly,
    required this.decoration,
    this.onTapped,
    this.validator,
    this.inputFormatters,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      keyboardType: textInputType,
      textAlign: textAlign,
      controller: controller,
      maxLines: null,
      inputFormatters: inputFormatters,
      textCapitalization: TextCapitalization.words,
      decoration: decoration,
      onTap: onTapped,
      validator: validator,
      style: TextStyle(
        color: Colors.white,
        fontSize: size,
      ),
    );
  }
}
