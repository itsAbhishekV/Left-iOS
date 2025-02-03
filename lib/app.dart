import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:left/core/exports.dart';
import 'package:left/features/exports.dart';

class LeftApp extends ConsumerStatefulWidget {
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
  ConsumerState<LeftApp> createState() => _LeftAppState();
}

class _LeftAppState extends ConsumerState<LeftApp> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      if (widget.dob != null &&
          widget.name != null &&
          widget.colorIndex != null) {
        ref.read(userProvider.notifier).update((state) {
          return UserModel(
            name: widget.name!,
            dob: widget.dob!,
            colorIndex: widget.colorIndex!,
          );
        });
        ref.read(themeProvider.notifier).changeThemeColor(widget.colorIndex!);
      } else {
        ref.read(userProvider.notifier).update((state) => null);
      }
    });
  }

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
