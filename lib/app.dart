import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:left/core/exports.dart';
import 'package:left/features/exports.dart';

const String appGroupId = 'home_widget';
const String androidWidgetName = 'HomeWidget';

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
  void updateWidget() {
    final title = getCurrentMonthName();
    HomeWidget.saveWidgetData<String>('title', title);
    HomeWidget.updateWidget(
      androidName: androidWidgetName,
    );
  }

  @override
  void initState() {
    super.initState();

    HomeWidget.setAppGroupId(appGroupId);

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
        ref.read(dobProvider.notifier).state = widget.dob!;
      } else {
        ref.read(userProvider.notifier).update((state) => null);
      }
    });

    updateWidget();
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
