import 'package:flutter/material.dart';
import 'package:left/core/palette.dart';

class AppTextStyle {
  static TextStyle title = TextStyle(
    fontFamily: 'AlbertSans',
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    color: AppPalette.secondary,
  );
  static TextStyle titleMedium = TextStyle(
    fontFamily: 'AlbertSans',
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: AppPalette.secondary,
  );
  static TextStyle smallTitle = TextStyle(
    fontFamily: 'AlbertSans',
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    color: AppPalette.secondary,
  );
  static TextStyle smallBody = TextStyle(
    fontFamily: 'AlbertSans',
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: AppPalette.secondary,
  );
}

ThemeData darkTheme() {
  return ThemeData(
    fontFamily: 'AlbertSans',
    brightness: Brightness.dark,
    useMaterial3: true,
    primaryColor: AppPalette.primary,
    scaffoldBackgroundColor: AppPalette.background,
  );
}
