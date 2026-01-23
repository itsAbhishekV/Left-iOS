import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import 'app.dart';
import 'core/exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure home_widget for iOS (App Group ID for data sharing)
  await HomeWidget.setAppGroupId('group.com.example.left');

  final sharedPrefs = SharedPrefsService();
  final dob = await sharedPrefs.getDob();
  final name = await sharedPrefs.getUserName();
  final colorIndex = await sharedPrefs.getColorIndex();

  // Update home widgets on app start
  await WidgetService.updateAllWidgets();

  runApp(
    ProviderScope(
      child: App(
        name: name,
        dob: dob,
        colorIndex: colorIndex,
      ),
    ),
  );
}
