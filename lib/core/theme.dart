import 'package:flutter/material.dart';
import 'package:left/core/palette.dart';

class AppTextStyle {
  static TextStyle title = TextStyle(
    fontFamily: 'Sora',
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    color: AppPalette.secondary,
  );
  static TextStyle titleMedium = TextStyle(
    fontFamily: 'Sora',
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: AppPalette.secondary,
  );
  static TextStyle smallTitle = TextStyle(
    fontFamily: 'Sora',
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    color: AppPalette.secondary,
  );
  static TextStyle smallBody = TextStyle(
    fontFamily: 'Sora',
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: AppPalette.secondary,
  );
}

ThemeData darkTheme() {
  return ThemeData(
    fontFamily: 'Sora',
    brightness: Brightness.dark,
    useMaterial3: true,
    primaryColor: AppPalette.primary,
    scaffoldBackgroundColor: AppPalette.background,
  );
}
