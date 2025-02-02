import 'package:flutter/material.dart';
import 'package:left/core/palette.dart';

ThemeData darkTheme() {
  return ThemeData(
    fontFamily: 'AlbertSans',
    brightness: Brightness.dark,
    useMaterial3: true,
    primaryColor: AppPalette.primary,
    scaffoldBackgroundColor: AppPalette.background,
  );
}
