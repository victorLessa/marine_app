import 'package:flutter/material.dart';
import 'package:marine/providers/event_provider.dart';
import 'package:provider/provider.dart';

class CalendarProvider with ChangeNotifier {
  DateTime _focusedDay = DateTime.now();

  DateTime _selectedDay = DateTime.now();

  DateTime get focusedDay => _focusedDay;

  DateTime get selectedDay => _selectedDay;

  void addFocusedDay(DateTime day) {
    _focusedDay = day;
    notifyListeners();
  }

  void addSelectedDay(BuildContext context, DateTime day) {
    _selectedDay = day;
    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    eventProvider.setEndDay(day);
    eventProvider.setStartDay(day);
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
