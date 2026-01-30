import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supadots/core/enum.dart';
import 'package:supadots/features/exports.dart';

import 'dot.dart';

class DotsDisplayGrid extends ConsumerWidget {
  const DotsDisplayGrid({
    super.key,
    required this.totalDots,
    required this.dulledDots,
    this.isCurrentDay = false,
    this.handleDotTap,
    this.handleDotRelease,
  });

  final int totalDots;
  final int dulledDots;
  final bool? isCurrentDay;
  final void Function(int)? handleDotTap;
  final void Function()? handleDotRelease;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(dotTypeStateProvider);
    return Wrap(
      spacing: type == DotsType.life ? 8.0 : 12.0,
      runSpacing: type == DotsType.life ? 8.0 : 16.0,
      children: List.generate(
        totalDots,
        (index) => (handleDotRelease == null && handleDotTap == null)
            ? Dot(
                forHomeWidget: true,
                dull: index < dulledDots,
                type: DotsType.month, // for home widget
              )
            : GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (_) {
                  handleDotTap!(index);
                },
                onTapUp: (_) => handleDotRelease!(),
                onTapCancel: handleDotRelease,
                child: Dot(
                  isCurrentDay: isCurrentDay,
                  dull: index < dulledDots,
                  type: type,
                ),
              ),
      ),
    );
  }
}
