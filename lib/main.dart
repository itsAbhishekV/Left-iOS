import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPrefs = SharedPrefsService();
  final dob = await sharedPrefs.getDob();
  final name = await sharedPrefs.getUserName();
  final colorIndex = await sharedPrefs.getColorIndex();

  runApp(
    ProviderScope(
      child: LeftApp(
        dob: dob,
        name: name,
        colorIndex: colorIndex,
      ),
    ),
  );
}
