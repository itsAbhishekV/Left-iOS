import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:left/core/exports.dart';

class ThemeNotifier extends StateNotifier<Color> {
  ThemeNotifier(this.ref) : super(appColors[0]);

  final Ref ref;

  void changeThemeColor(int newColorIndex) {
    // updating the colorIndexProvider to reflect the selected index
    ref.read(colorIndexProvider.notifier).state = newColorIndex;

    state = appColors[newColorIndex];
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, Color>((ref) {
  return ThemeNotifier(ref);
});

final colorIndexProvider = StateProvider<int>((ref) {
  return 0;
});
