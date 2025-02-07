import 'package:intl/intl.dart';
import 'package:left/core/enum.dart';

// for home widget
String getCurrentMonthName() {
  return DateFormat('MMMM').format(DateTime.now());
}

int getDaysInCurrentYear() {
  int year = DateTime.now().year;

  bool isLeapYear = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));

  return isLeapYear ? 366 : 365;
}

int getDaysPassedInYear() {
  final now = DateTime.now();
  final startOfYear = DateTime(now.year, 1, 1);
  return now.difference(startOfYear).inDays + 1;
}

// returns the number of days in the current month
int getDaysInCurrentMonth() {
  DateTime now = DateTime.now();

  DateTime firstDayNextMonth = DateTime(now.year, now.month + 1, 1);

  DateTime lastDayOfCurrentMonth =
      firstDayNextMonth.subtract(Duration(days: 1));

  return lastDayOfCurrentMonth.day;
}

int getTotalMonthsInLife() {
  const totalLifeExpectancyInYears = 82;
  return totalLifeExpectancyInYears * 12;
}

int getMonthsPassedInLife(DateTime dateOfBirth) {
  final now = DateTime.now();
  int yearsPassed = now.year - dateOfBirth.year;
  int monthsPassed = now.month - dateOfBirth.month;

  if (now.month < dateOfBirth.month ||
      (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
    yearsPassed -= 1;
  }

  int totalMonthsPassed = (yearsPassed * 12) + now.month - dateOfBirth.month;

  // Debugging prints
  // print('DOB: $dateOfBirth');
  // print('Now: $now');
  // print('Years Passed: $yearsPassed');
  // print('Months Passed: ${now.month - dateOfBirth.month}');
  // print('Total Months Passed: $totalMonthsPassed');

  return totalMonthsPassed;
}

int getRemainingMonthsInLife(DateTime dateOfBirth) {
  return getTotalMonthsInLife() - getMonthsPassedInLife(dateOfBirth);
}

// returns the name of the month for a given month index.
String getMonthName(int month) {
  const monthNames = [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  return monthNames[month];
}

// returns formatted date with weekday string
String getFormattedDate(DateTime date, DotsType type) {
  switch (type) {
    case DotsType.month:
      return DateFormat('EEEE d, yyyy').format(date);
    case DotsType.year:
      return DateFormat('d MMMM, yyyy').format(date);
    case DotsType.life:
      return DateFormat('MMMM, yyyy').format(date);
  }
}
