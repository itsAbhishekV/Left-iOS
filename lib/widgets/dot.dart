import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:left/core/enum.dart';
import 'package:left/features/exports.dart';

class Dot extends ConsumerWidget {
  const Dot({
    super.key,
    this.dull = false,
    this.type = DotsType.month,
    this.forHomeWidget = false,
  });

  final bool dull;
  final DotsType type;
  final bool? forHomeWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    double size;

    switch (type) {
      case DotsType.month:
        size = forHomeWidget == true ? 12.0 : 18.0;
        break;
      case DotsType.year:
        size = 4.0;
        break;
      case DotsType.life:
        size = 3.0;
        break;
    }

    return CircleAvatar(
      backgroundColor: forHomeWidget == true
          ? (dull ? Colors.white.withAlpha(69) : Colors.white)
          : (dull ? theme.withAlpha(69) : theme),
      radius: size,
    );
  }
}
