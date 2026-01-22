import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supadots/core/enum.dart';
import 'package:supadots/features/exports.dart';

class Dot extends ConsumerWidget {
  const Dot({
    super.key,
    this.dull = false,
    this.type = DotsType.month,
  });

  final bool dull;
  final DotsType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
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
      backgroundColor: dull ? theme.withAlpha(69) : theme,
      radius: size,
    );
  }
}
