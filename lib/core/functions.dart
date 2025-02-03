import 'package:intl/intl.dart';
import 'package:left/core/enum.dart';

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

int getMonthsInLife() {
  const leftExpectancyInYears = 82;
  const monthsInLife = leftExpectancyInYears * 12;
  return monthsInLife;
}

int getMonthsPassedInLife(DateTime dateOfBirth) {
  final monthsPassed = DateTime.now().difference(dateOfBirth).inDays ~/ 30;
  return monthsPassed;
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
      return DateFormat('EEEE d MMMM, yyyy').format(date);
    case DotsType.year:
      return DateFormat('d MMMM, yyyy').format(date);
    case DotsType.life:
      return DateFormat('MMMM, yyyy').format(date);
  }
}
