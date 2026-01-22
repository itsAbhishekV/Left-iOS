import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:left/core/exports.dart';
import 'package:left/features/exports.dart';

import 'dot.dart';

class DotsDisplayGrid extends ConsumerWidget {
  const DotsDisplayGrid({
    super.key,
    required this.totalDots,
    required this.dulledDots,
    required this.handleDotTap,
    required this.handleDotRelease,
  });

  final int totalDots;
  final int dulledDots;
  final void Function(int) handleDotTap;
  final void Function() handleDotRelease;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(dotTypeStateProvider);
    return Wrap(
      spacing: type == DotsType.life ? 8.0 : 12.0,
      runSpacing: type == DotsType.life ? 8.0 : 16.0,
      children: List.generate(
        totalDots,
        (index) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) {
            handleDotTap(index);
          },
          onTapUp: (_) => handleDotRelease(),
          onTapCancel: handleDotRelease,
          child: Dot(
            dull: index < dulledDots,
            type: type,
          ),
        ),
      ),
    );
  }
}
