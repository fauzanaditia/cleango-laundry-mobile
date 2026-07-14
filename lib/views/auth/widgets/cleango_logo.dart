import 'package:flutter/material.dart';

class CleanGoLogo extends StatelessWidget {
  const CleanGoLogo({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/image/logo.jpg',
      width: size,
      height: size,
    );
  }
}
