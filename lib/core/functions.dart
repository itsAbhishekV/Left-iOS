int getDaysInCurrentYear() {
  int year = DateTime.now().year;

  bool isLeapYear = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));

  return isLeapYear ? 366 : 365;
}

// returns the number of days in the current month
int getDaysInCurrentMonth() {
  DateTime now = DateTime.now();

  DateTime firstDayNextMonth = DateTime(now.year, now.month + 1, 1);

  DateTime lastDayOfCurrentMonth =
      firstDayNextMonth.subtract(Duration(days: 1));

  return lastDayOfCurrentMonth.day;
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
