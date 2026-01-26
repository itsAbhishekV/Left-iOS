import 'package:home_widget/home_widget.dart';

import 'package:supadots/core/exports.dart';

/// Service to manage home widget updates
/// This communicates with native Android and iOS widgets
class WidgetService {
  /// Updates the monthly widget with current month data
  /// Shows: Current month name + dots for each day
  /// Dulls: Days from 1st to (current day - 1)
  static Future<void> updateMonthlyWidget() async {
    try {
      final now = DateTime.now();

      // Get month name (e.g., "JANUARY")
      final monthName = getMonthName(now.month).toUpperCase();

      // Total days in current month (28/29/30/31)
      final totalDays = getDaysInCurrentMonth();

      // Days that have passed (current day - 1)
      // Example: If today is 15th Jan, passedDays = 14
      // So dots 1-14 will be dulled, dots 15-31 will be normal
      final passedDays = now.day - 1;

      // Send data to native widgets (Android & iOS)
      await HomeWidget.saveWidgetData<String>('monthly_title', monthName);
      await HomeWidget.saveWidgetData<int>('monthly_total_items', totalDays);
      await HomeWidget.saveWidgetData<int>('monthly_passed_items', passedDays);

      // Trigger widget update
      await HomeWidget.updateWidget(
        name: 'MonthlyWidget',
        androidName: 'MonthlyWidget',
        iOSName: 'MonthlyWidget',
      );
    } catch (e) {
      print('Error updating monthly widget: $e');
    }
  }

  /// Updates the yearly widget with current year data
  /// Shows: Year (top left), Days left (top right), dots for each day
  /// Dulls: Days from Jan 1 to (current day - 1)
  static Future<void> updateYearlyWidget() async {
    try {
      final now = DateTime.now();

      // Current year (e.g., "2026")
      final year = now.year.toString();

      // Total days in current year (365 or 366)
      final totalDays = getDaysInCurrentYear();

      // Days that have passed (current day of year - 1)
      // Example: If today is Jan 19, passedDays = 18
      // So dots 1-18 will be dulled, dots 19-365 will be bright
      final passedDays = getDaysPassedInYear() - 1;

      // Send data to native widgets (Android & iOS)
      await HomeWidget.saveWidgetData<String>('yearly_title', year);
      await HomeWidget.saveWidgetData<int>('yearly_total_items', totalDays);
      await HomeWidget.saveWidgetData<int>('yearly_passed_items', passedDays);

      // Trigger widget update
      await HomeWidget.updateWidget(
        name: 'YearlyWidget',
        androidName: 'YearlyWidget',
        iOSName: 'YearlyWidget',
      );
    } catch (e) {
      print('Error updating yearly widget: $e');
    }
  }

  /// Updates all widgets
  static Future<void> updateAllWidgets() async {
    await updateMonthlyWidget();
    await updateYearlyWidget();
  }
}
