import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:left/core/exports.dart';
import 'package:left/features/exports.dart';

class LeftApp extends ConsumerWidget {
  final String? name;
  final String? dob;
  final int? colorIndex;

  const LeftApp({
    super.key,
    this.name,
    this.dob,
    this.colorIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // update the user state with the values if available
    if (dob != null && name != null && colorIndex != null) {
      ref.read(userProvider.notifier).update((state) {
        return UserModel(
          name: name!,
          dob: dob!,
          colorIndex: colorIndex!,
        );
      });
    } else {
      ref.read(userProvider.notifier).update((state) {
        return null;
      });
    }
    
    return MaterialApp(
      title: 'Left',
      theme: darkTheme(),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
