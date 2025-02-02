import 'package:flutter/material.dart';

import 'dot.dart';

class DotsDisplayGrid extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 16.0,
      children: List.generate(
        totalDots,
        (index) => GestureDetector(
          onTapDown: (_) => handleDotTap(index),
          onTapUp: (_) => handleDotRelease(),
          onTapCancel: handleDotRelease,
          child: Dot(
            dull: index < dulledDots,
          ),
        ),
      ),
    );
  }
}
