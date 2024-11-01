import 'package:flutter/material.dart';

class BuildIconButton extends StatelessWidget {
  final Icon? icon;
  final VoidCallback? onPressed;

  const BuildIconButton({
    Key? key,
    this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon ??
          const Icon(
            Icons.error,
          ),
    );
  }
}
