import 'package:flutter/material.dart';
import 'package:left/core/exports.dart';

class LeftApp extends StatelessWidget {
  const LeftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Left',
      theme: darkTheme(),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: Text(
            'My App',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ),
    );
  }
}
