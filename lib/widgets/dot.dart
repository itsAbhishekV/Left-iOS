import 'package:flutter/material.dart';
import 'package:left/core/palette.dart';

class Dot extends StatelessWidget {
  const Dot({
    super.key,
    this.dull = false,
  });

  final bool dull;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor:
          dull ? AppPalette.secondary.withAlpha(69) : AppPalette.secondary,
      radius: 16.0,
    );
  }
}
