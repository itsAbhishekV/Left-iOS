import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:supadots/core/exports.dart';
import 'package:supadots/features/exports.dart';

const String appGroupId = 'home_widget';
const String androidWidgetName = 'HomeWidget';

class App extends ConsumerStatefulWidget {
  final String? name;
  final String? dob;
  final int? colorIndex;

  const App({
    super.key,
    this.name,
    this.dob,
    this.colorIndex,
  });

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
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

  // updates the home widget
  void updateWidget() {
    final title = getCurrentMonthName();
    HomeWidget.saveWidgetData<String>('title', title);

    HomeWidget.updateWidget(androidName: androidWidgetName);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: darkTheme(),
      home: HomeScreen(),
    );
  }
}
