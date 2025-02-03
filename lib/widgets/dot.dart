import 'package:flutter/material.dart';
import 'package:left/core/enum.dart';
import 'package:left/core/palette.dart';

class Dot extends StatelessWidget {
  const Dot({
    super.key,
    this.dull = false,
    this.type = DotsType.month,
  });

  final bool dull;
  final DotsType type;

  @override
  Widget build(BuildContext context) {
    double size;

    switch (type) {
      case DotsType.month:
        size = 18.0;
        break;
      case DotsType.year:
        size = 4.0;
        break;
      case DotsType.life:
        size = 3.0;
        break;
    }

    return CircleAvatar(
      backgroundColor:
          dull ? AppPalette.secondary.withAlpha(69) : AppPalette.secondary,
      radius: size,
    );
  }
}
