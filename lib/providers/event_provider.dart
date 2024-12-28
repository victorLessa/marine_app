import 'package:flutter/material.dart';
import 'package:marine/models/event_state.dart';
import 'package:marine/repositories/event.dart';

class EventProvider with ChangeNotifier {
  bool formEventIsBusy = false;

  List<EventState> eventList = [];

  late EventState _formEventState = EventState();

  final EventRepository _eventRepository = EventRepository();

  EventState get formEventState => _formEventState;

  void setFormEventState(EventState data) {
    _formEventState = data;
  }

  Future<EventState> findEventById(int id) async {
    EventState result = await _eventRepository.findById(id);
    return result;
  }

  Future<List<EventState>> findEventByDate(DateTime date) async {
    List<EventState> result = await _eventRepository.findByDate(date);
    return result;
  }

  Future<List<EventState>> findEventByMonth(DateTime date) async {
    List<EventState> result = await _eventRepository.findByMonth(date);

    return result;
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

  void setTitle(String title) {
    _formEventState.title.text = title;
    notifyListeners();
  }

  void setDescription(String description) {
    _formEventState.description.text = description;
    notifyListeners();
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
      // Precisa salvar como UTC pq na hora se selecionar a data no table datepicker ele retorna o valor em UTC sem a hora
      _formEventState.startDay = value;
      notifyListeners();
    }
  }

  void setEndDay(DateTime? value) {
    if (value != null) {
      // Precisa salvar como UTC pq na hora se selecionar a data no table datepicker ele retorna o valor em UTC sem a hora
      _formEventState.endDay = value;
      notifyListeners();
    }
  }

  void setAllDay(bool value) {
    _formEventState.allDay = value;

    notifyListeners();
  }

  Future<void> addEvent(EventState eventData) async {
    try {
      formEventIsBusy = true;
      await _eventRepository.insertEvent(eventData);

      cleanFormEvent();
    } finally {
      formEventIsBusy = false;
      notifyListeners();
    }
  }

  Future<void> editEvent(int eventId, EventState eventData) async {
    try {
      formEventIsBusy = true;
      await _eventRepository.updateEvent(eventId, eventData);

      cleanFormEvent();

      notifyListeners();
    } finally {
      formEventIsBusy = false;
    }
  }

  Future<void> removeEvent(int eventId) async {
    try {
      formEventIsBusy = true;
      await _eventRepository.deleteEvent(eventId);

      cleanFormEvent();
    } finally {
      formEventIsBusy = false;
      notifyListeners();
    }
  }

  Future<void> deleteEmbarked() async {
    await _eventRepository.deleteEmbarked();
    notifyListeners();
  }

  cleanFormEvent() {
    _formEventState = EventState();
    notifyListeners();
  }
}
