import 'package:flutter/material.dart';
import 'package:marine/database/utils.database.dart';

class EventState {
  int? id;
  String title;
  Color color;
  String description;
  DateTime startDay;
  bool allDay;
  DateTime endDay;
  TimeOfDay startHour;
  TimeOfDay endHour;

  EventState(
      {this.id,
      required this.title,
      required this.color,
      required this.startDay,
      required this.description,
      this.allDay = false,
      required this.endDay,
      required this.endHour,
      required this.startHour});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startDay': startDay.microsecondsSinceEpoch,
      'endDay': endDay.microsecondsSinceEpoch,
      'allDay': allDay ? 1 : 0,
      'startHour': UtilsDatabase.timeOfDayToString(startHour),
      'endHour': UtilsDatabase.timeOfDayToString(endHour),
      'color': color.value,
    };
  }

  factory EventState.fromMap(Map<String, dynamic> map) {
    return EventState(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      allDay: map['allDay'] == 1 ? true : false,
      startDay: DateTime.fromMicrosecondsSinceEpoch(map['startDay']),
      endDay: DateTime.fromMicrosecondsSinceEpoch(map['endDay']),
      startHour: UtilsDatabase.stringToTimeOfDay(map['startHour']),
      endHour: UtilsDatabase.stringToTimeOfDay(map['endHour']),
      color: Color(map['color']),
    );
  }
}
