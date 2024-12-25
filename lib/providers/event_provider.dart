import 'dart:io';

import 'package:flutter/material.dart';
import 'package:marine/models/event_state.dart';
import 'package:marine/models/form_event_state.dart';
import 'package:marine/repositories/event.dart';

class EventProvider with ChangeNotifier {
  final List<EventState> _eventList = [];

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
      _formEventState.startDay = value.toUtc();
      notifyListeners();
    }
  }

  void setEndDay(DateTime? value) {
    if (value != null) {
      // Precisa salvar como UTC pq na hora se selecionar a data no table datepicker ele retorna o valor em UTC sem a hora
      _formEventState.endDay = value.toUtc();
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

    notifyListeners();
  }

  Future<void> editEvent(int eventId, FormEventState eventData) async {
    await _eventRepository.updateEvent(eventId, eventData.toEventState());

    cleanFormEvent();

    notifyListeners();
  }

  Future<void> removeEvent(int eventId) async {
    _eventRepository.deleteEvent(eventId);

    notifyListeners();
  }

  cleanFormEvent() {
    _formEventState = FormEventState();
  }
}
