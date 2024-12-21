import 'package:flutter/material.dart';

class EventState {
  String title;
  Color color;
  String description;
  DateTime startDay;
  bool? allDay;
  DateTime endDay;
  TimeOfDay startHour;
  TimeOfDay endHour;

  EventState(
      {required this.title,
      required this.color,
      required this.startDay,
      required this.description,
      this.allDay = false,
      required this.endDay,
      required this.endHour,
      required this.startHour});
}
