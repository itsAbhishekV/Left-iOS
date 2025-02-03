import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:left/core/exports.dart';
import 'package:left/features/exports.dart';
import 'package:left/widgets/dots_display_grid.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final now = DateTime.now();
  late int totalDots;
  late int dulledDots;

  final dob = DateTime(2003, 3, 26);

  bool showPercentage = false;
  bool showDate = false;
  String? formattedDate;

  void _initializeDots(DotsType type) {
    switch (type) {
      case DotsType.month:
        totalDots = getDaysInCurrentMonth();
        dulledDots = now.day - 1;
        break;
      case DotsType.year:
        totalDots = getDaysInCurrentYear();
        dulledDots = getDaysPassedInYear() - 1;
        break;
      case DotsType.life:
        totalDots = getMonthsInLife();
        dulledDots =
            getMonthsPassedInLife(DateTime(dob.year, dob.month + 3, dob.day));
        break;
    }
  }

  void _handleDotTap(int index) {
    final type = ref.watch(dotTypeStateProvider);
    switch (type) {
      case DotsType.month:
        final date = DateTime(now.year, now.month, index + 1);
        setState(() {
          showDate = true;
          formattedDate = getFormattedDate(date, type);
        });
        HapticFeedback.lightImpact();
        break;

      case DotsType.year:
        final date = DateTime(now.year, 1, 1).add(Duration(days: index));
        setState(() {
          showDate = true;
          formattedDate = getFormattedDate(date, type);
        });
        HapticFeedback.lightImpact();
        break;

      case DotsType.life:
        final date = DateTime(dob.year, dob.month + (index), dob.day);
        setState(() {
          showDate = true;
          formattedDate = getFormattedDate(date, type);
        });
        HapticFeedback.lightImpact();
        break;
    }
  }

  void _handleDotRelease() {
    setState(() {
      showDate = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final type = ref.watch(dotTypeStateProvider);
    final themeColor = ref.watch(themeProvider);

    // Ensure dots update whenever `type` changes
    _initializeDots(type);

    debugPrint('type: $type');
    debugPrint('totalDots: $totalDots');
    debugPrint('dulledDots: $dulledDots');

    return GestureDetector(
      onLongPress: () {
        showBottomModalDialog(
          context: context,
          children: [
            ThemeBottomSheet(),
            ProfileBottomSheet(),
          ],
        );
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DotsDisplayGrid(
                    totalDots: totalDots,
                    dulledDots: dulledDots,
                    handleDotTap: _handleDotTap,
                    handleDotRelease: _handleDotRelease,
                  ),
                ),
                _buildFooter(type, themeColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(DotsType type, Color theme) {
    final List<DotsType> dotsType = [
      DotsType.month,
      DotsType.year,
      DotsType.life
    ];

    String footerHeading;
    switch (type) {
      case DotsType.month:
        footerHeading = getMonthName(now.month);
        break;
      case DotsType.year:
        footerHeading = now.year.toString();
        break;
      case DotsType.life:
        footerHeading = 'Life';
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            HapticFeedback.vibrate();
            ref.read(dotTypeStateProvider.notifier).update((state) {
              final currentIndex = dotsType.indexOf(state);
              final nextIndex = (currentIndex + 1) % dotsType.length;
              return dotsType[nextIndex];
            });
          },
          child: Text(
            showDate ? formattedDate ?? '' : footerHeading,
            style: AppTextStyle.title.copyWith(
              color: theme,
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            HapticFeedback.heavyImpact();
            setState(() {
              showPercentage = !showPercentage;
            });
          },
          child: Text(
            showPercentage
                ? '${(((totalDots - dulledDots) / totalDots) * 100).toStringAsFixed(0)}% left'
                : '${totalDots - dulledDots} days left',
            style: AppTextStyle.titleMedium.copyWith(
              color: theme.withAlpha(180),
            ),
          ),
        ),
      ],
    );
  }
}
