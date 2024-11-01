import 'package:flutter/material.dart';

class BuildIconWidget extends StatelessWidget {
  final Icon icon;
  final Color? color;
  final double? size;

  const BuildIconWidget({super.key, required this.icon, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return icon;
  }
}
