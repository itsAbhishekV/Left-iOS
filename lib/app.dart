import 'package:flutter/material.dart';
import 'package:left/core/exports.dart';
import 'package:left/features/exports.dart';

class LeftApp extends StatelessWidget {
  const LeftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Left',
      theme: darkTheme(),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
