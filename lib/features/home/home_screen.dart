import 'package:flutter/material.dart';
import 'package:left/core/exports.dart';
import 'package:left/widgets/exports.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final int totalDays;
  late final int daysPassed;

  bool showPercentage = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    totalDays = getDaysInCurrentMonth();
    daysPassed = now.day - 1;
  }

  @override
  Widget build(BuildContext context) {
    print('totalDays: $totalDays');
    print('daysPassed: $daysPassed');
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            children: [
              Expanded(child: _buildDotGrid()),
              const Spacer(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDotGrid() {
    return Wrap(
      spacing: 12.0,
      runSpacing: 16.0,
      children: [
        // Days that have passed (dull)
        ...List.generate(
          daysPassed,
          (index) => const Dot(left: true),
        ),

        // Remaining days
        ...List.generate(
          totalDays - daysPassed,
          (index) => const Dot(),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // month name
        Text(
          getMonthName(DateTime.now().month),
          style: AppTextStyle.title,
        ),

        // days or percentage left in month
        GestureDetector(
          onTap: () {
            setState(() {
              showPercentage = !showPercentage;
            });
          },
          child: Text(
            showPercentage
                ? '${(((totalDays - daysPassed) / totalDays) * 100).toStringAsFixed(0)}% left'
                : '${totalDays - daysPassed} days left',
            style: AppTextStyle.titleMedium.copyWith(
              color: AppPalette.secondary.withAlpha(180),
            ),
          ),
        ),
      ],
    );
  }
}
