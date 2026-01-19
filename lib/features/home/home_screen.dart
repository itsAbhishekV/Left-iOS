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

  late bool showEsterText;

  late DateTime dob;

  bool showPercentage = false;
  bool showDate = false;
  String? formattedDate;

  @override
  void initState() {
    super.initState();
    showEsterText = false;
    // Initialize dob to a default value. We'll update it later in the build method.
    dob = DateTime.now();
  }

  void _initializeDots(DotsType type, String dobInString) {
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
        totalDots = getTotalMonthsInLife();
        final myDob = DateTime.parse(dobInString);
        dulledDots = getMonthsPassedInLife(myDob) - 1;

        // if negative
        if ((totalDots - dulledDots) < 0) {
          setState(() {
            showEsterText = true;
          });
        } else {
          setState(() {
            showEsterText = false;
          });
        }
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
    final user = ref.watch(userProvider);
    final type = ref.watch(dotTypeStateProvider);
    final colorIndex = ref.watch(colorIndexProvider);
    final color = appColors[colorIndex];
    final dobInString = ref.watch(dobProvider);

    _initializeDots(type, dobInString);

    debugPrint('esterText: $showEsterText');
    debugPrint('type: $type');
    debugPrint('totalDots: $totalDots');
    debugPrint('dulledDots: $dulledDots');

    return GestureDetector(
      onDoubleTap: () {
        showBottomModalDialog(
          context: context,
          children: [
            ThemeBottomSheet(),
            ProfileBottomSheet(),
          ],
        );
        HapticFeedback.heavyImpact();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DotsDisplayGrid(
                    isCurrentDay: DateTime.now() == now,
                    totalDots: totalDots,
                    dulledDots: dulledDots,
                    handleDotTap: _handleDotTap,
                    handleDotRelease: _handleDotRelease,
                  ),
                ),
                if (showEsterText)
                  Text(
                    'YOU MADE IT PAST 82. FUCK.',
                    style: AppTextStyle.title.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (!showEsterText) _buildFooter(type, color, user),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(DotsType type, Color color, UserModel? user) {
    final List<DotsType> dotsType = [
      DotsType.month,
      DotsType.year,
      if (user != null) DotsType.life // only show life if user is present
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
        footerHeading = user?.name ?? 'Life';
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            ref.read(dotTypeStateProvider.notifier).update((state) {
              final currentIndex = dotsType.indexOf(state);
              final nextIndex = (currentIndex + 1) % dotsType.length;
              return dotsType[nextIndex];
            });
            HapticFeedback.vibrate();

            // Update widgets when switching views
            WidgetService.updateAllWidgets();
          },
          child: Text(
            showDate ? formattedDate ?? '' : footerHeading,
            style: AppTextStyle.title.copyWith(
              color: color,
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              showPercentage = !showPercentage;
            });
            HapticFeedback.heavyImpact();
          },
          child: Text(
            showPercentage
                ? '${(((totalDots - dulledDots) / totalDots) * 100).toStringAsFixed(0)}% left'
                : '${totalDots - dulledDots} ${type == DotsType.life ? 'months' : 'days'} left',
            style: AppTextStyle.titleMedium.copyWith(
              color: color.withAlpha(180),
            ),
          ),
        ),
      ],
    );
  }
}
