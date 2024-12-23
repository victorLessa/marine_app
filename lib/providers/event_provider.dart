import 'package:flutter/material.dart';
import 'package:marine/models/event_state.dart';
import 'package:marine/models/form_event_state.dart';
import 'package:marine/repositories/event.dart';

class EventProvider with ChangeNotifier {
  final List<EventState> _eventList = [
    EventState(
        title: "Evento 1",
        description: "",
        endDay: DateTime.now(),
        startDay: DateTime.now(),
        startHour: TimeOfDay.now(),
        endHour: TimeOfDay.now(),
        color: Colors.blue),
  ];

  bool formEventIsBusy = false;

  late FormEventState _formEventState = FormEventState();

  final EventRepository _eventRepository = EventRepository();

  FormEventState get formEventState => _formEventState;
  List<EventState> get eventList => _eventList;

  Future<void> loadEvents() async {
    _eventList.clear();
    _eventList.addAll(await _eventRepository.getEvents());
    notifyListeners();
  }

  void formIsBusy(bool value) {
    formEventIsBusy = value;
    notifyListeners();
  }

  void setStartHour(TimeOfDay? value) {
    if (value != null) {
      _formEventState.startHour = value;
      notifyListeners();
    }
  }

  void setEndHour(TimeOfDay? value) {
    if (value != null) {
      _formEventState.endHour = value;
      notifyListeners();
    }
  }

  void setColor(Color color) {
    _formEventState.color = color;
    notifyListeners();
  }

  void setStartDay(DateTime? value) {
    if (value != null) {
      _formEventState.startDay = value;
      notifyListeners();
    }
  }

  void setEndDay(DateTime? value) {
    if (value != null) {
      _formEventState.endDay = value;
      notifyListeners();
    }
  }

  void setAllDay(bool value) {
    _formEventState.allDay = value;

    notifyListeners();
  }

  Future<void> addEvent(FormEventState eventData) async {
    await _eventRepository.insertEvent(eventData.toEventState());

    cleanFormEvent();

    await loadEvents();
    notifyListeners();
  }

  void removeEvent(
    DateTime day,
    int index,
  ) {
    int? event = _eventList.indexWhere((event) {
      if (day.isAfter(event.startDay) && day.isBefore(event.endDay)) {
        return true;
      }
      return false;
    });

    if (!event.isNaN) {
      _eventList.removeRange(index, index);
      notifyListeners();
    }
  }

  cleanFormEvent() {
    _formEventState = FormEventState();
  }
}
