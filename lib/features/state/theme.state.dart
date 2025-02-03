import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:left/core/exports.dart';

class ThemeNotifier extends StateNotifier<Color> {
  ThemeNotifier() : super(AppPalette.secondary);

  void changeThemeColor(Color newColor) {
    state = newColor;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, Color>((ref) {
  return ThemeNotifier();
});
