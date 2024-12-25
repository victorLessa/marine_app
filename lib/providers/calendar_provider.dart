import 'package:flutter/material.dart';
import 'package:marine/providers/event_provider.dart';
import 'package:provider/provider.dart';

class CalendarProvider with ChangeNotifier {
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());

  DateTime _selectedDay = DateTime.now();

  ValueNotifier<DateTime> get focusedDay => _focusedDay;

  DateTime get selectedDay => _selectedDay;

  void addFocusedDay(DateTime day) {
    _focusedDay.value = day;
    notifyListeners();
  }

  void addSelectedDay(BuildContext context, DateTime day) {
    _selectedDay = day;
    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    eventProvider.setEndDay(day);
    eventProvider.setStartDay(day);

    notifyListeners();
  }
}
