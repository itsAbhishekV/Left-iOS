import 'package:flutter/material.dart';
import 'package:left/core/exports.dart';
import 'package:left/widgets/dots_display_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final now = DateTime.now();
  late final int totalDots;
  late final int dulledDots;

  bool showPercentage = false;

  bool showDate = false;
  String? formattedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    totalDots = getDaysInCurrentMonth();
    dulledDots = now.day - 1;
  }

  void _handleDotTap(int index) {
    final date = DateTime(now.year, now.month, index + 1);
    setState(() {
      showDate = true;
      formattedDate = getFormattedDate(date);
    });
  }

  void _handleDotRelease() {
    setState(() {
      showDate = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('totalDots: $totalDots');
    debugPrint('dotsDulled: $dulledDots');
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            children: [
              Expanded(
                child: DotsDisplayGrid(
                  totalDots: totalDots,
                  dulledDots: dulledDots,
                  handleDotTap: _handleDotTap,
                  handleDotRelease: _handleDotRelease,
                ),
              ),
              const Spacer(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // month name
        Text(
          showDate ? formattedDate ?? '' : getMonthName(DateTime.now().month),
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
                ? '${(((totalDots - dulledDots) / totalDots) * 100).toStringAsFixed(0)}% left'
                : '${totalDots - dulledDots} days left',
            style: AppTextStyle.titleMedium.copyWith(
              color: AppPalette.secondary.withAlpha(180),
            ),
          ),
        ),
      ],
    );
  }
}
