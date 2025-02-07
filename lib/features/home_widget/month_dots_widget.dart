import 'package:flutter/material.dart';
import 'package:left/core/exports.dart';
import 'package:left/widgets/dots_display_grid.dart';

class MonthDotsWidget extends StatefulWidget {
  const MonthDotsWidget({super.key});

  @override
  State<MonthDotsWidget> createState() => _MonthDotsWidgetState();
}

class _MonthDotsWidgetState extends State<MonthDotsWidget> {
  late int totalDots;
  late int dulledDots;

  @override
  void initState() {
    super.initState();

    totalDots = getDaysInCurrentMonth();
    dulledDots = DateTime.now().day - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DotsDisplayGrid(
        totalDots: totalDots,
        dulledDots: dulledDots,
      ),
    );
  }
}
