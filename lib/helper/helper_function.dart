import 'package:intl/intl.dart';

double converStringToDouble(String string) {
  double? amount = double.tryParse(string);
  return amount ?? 0;
}

String formatAmount(double amount) {
  final format =
      NumberFormat.currency(locale: 'en_US', symbol: "\s", decimalDigits: 2);
  return format.format(amount);
}
// calculate the number of months since the first start month

int calculateMonthCount(int staYear, startMonth, currentYear, currentMonth) {
  int monthCount = (currentYear - staYear) * 12 + currentMonth - startMonth + 1;

  return monthCount;
}

String getCurrentMonthName() {
  DateTime now = DateTime.now();
  List<String> months = [
    "Jan",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEP",
    "OCT",
    "NOV",
    "DEC,"
  ];
  return months[now.month - 1];
}
