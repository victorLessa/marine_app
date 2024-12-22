import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UtilsDatabase {
  static TimeOfDay stringToTimeOfDay(String time) {
    final format = DateFormat.Hm(); //"6:00 AM"
    final DateTime dateTime = format.parse(time);
    TimeOfDay result = TimeOfDay.fromDateTime(dateTime);
    return result;
  }

  static String timeOfDayToString(TimeOfDay time) {
    final now = DateTime.now();
    final DateTime dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat.Hm(); // "HH:mm"
    String result = format.format(dateTime);

    return result;
  }
}
