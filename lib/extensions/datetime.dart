extension DateOnly on DateTime {
  DateTime toDateOnly() {
    return DateTime(year, month, day);
  }
}
