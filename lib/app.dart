import 'package:flutter/material.dart';

class LeftApp extends StatelessWidget {
  const LeftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Left',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('My App'),
        ),
      ),
    );
  }
}
