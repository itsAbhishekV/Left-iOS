import 'package:flutter/material.dart';
import 'package:left/core/palette.dart';

enum DotSize {
  month,
  year,
  life,
}

class Dot extends StatelessWidget {
  const Dot({
    super.key,
    this.dull = false,
    this.dotSize = DotSize.month,
  });

  final bool dull;
  final DotSize dotSize;

  @override
  Widget build(BuildContext context) {
    double size;

    switch (dotSize) {
      case DotSize.month:
        size = 16.0;
        break;
      case DotSize.year:
        size = 14.0;
        break;
      case DotSize.life:
        size = 10.0;
        break;
    }

    return CircleAvatar(
      backgroundColor:
          dull ? AppPalette.secondary.withAlpha(69) : AppPalette.secondary,
      radius: size,
    );
  }
}
