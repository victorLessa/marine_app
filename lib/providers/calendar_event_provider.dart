import 'package:flutter/foundation.dart';

class CalendarEventProvider with ChangeNotifier {
  final Map<DateTime, List<Map<String, dynamic>>> _events = {
    DateTime.utc(2024, 12, 5): [
      {"name": "Evento 1", "color": ""},
      {"name": "Evento 2", "color": ""}
    ],
    DateTime.utc(2024, 12, 6): [
      {"name": 'Evento 3', "color": ""}
    ],
    DateTime.utc(2024, 12, 7): [
      {"name": 'Evento 3', "color": ""}
    ],
  };

  DateTime? _selectedDay;
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());

  Map<DateTime, List<Map<String, dynamic>>> get events => _events;

  ValueNotifier<DateTime> get focusedDay => _focusedDay;
  DateTime? get selectedDay => _selectedDay;

  void addFocusedDay(DateTime day) {
    _focusedDay.value = day;
    notifyListeners();
  }

  void addSelectedDay(DateTime day) {
    _selectedDay = day;
    notifyListeners();
  }

  void addEvent(DateTime day, Map<String, dynamic> eventData) {
    List<Map<String, dynamic>>? event = _events[day];
    if (event != null) {
      event.add(eventData);
      _events[day] = event;

      notifyListeners();
    }
  }

  void removeEvent(
    DateTime day,
    int index,
  ) {
    List<Map<String, dynamic>>? event = _events[day];
    if (event != null) {
      event.removeRange(index, index);
      notifyListeners();
    }
  }
}
