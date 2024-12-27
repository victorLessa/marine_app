import 'package:flutter/material.dart';
import 'package:marine/database/utils.database.dart';
import 'package:marine/extensions/datetime.dart';

class EventState {
  int? id;
  TextEditingController title;
  late Color color;
  TextEditingController description;
  DateTime startDay;
  bool allDay;
  DateTime endDay;
  TimeOfDay startHour;
  TimeOfDay endHour;

  EventState({
    this.id,
    TextEditingController? title,
    TextEditingController? description,
    bool? allDay,
    TimeOfDay? startHour,
    DateTime? startDay,
    DateTime? endDay,
    Color? color,
    TimeOfDay? endHour,
  })  : title = title ?? TextEditingController(),
        description = description ?? TextEditingController(),
        startHour = startHour ?? TimeOfDay.now(),
        endHour = endHour ?? TimeOfDay.now(),
        startDay = startDay ?? DateTime.now(),
        endDay = endDay ?? DateTime.now(),
        color = color ?? Colors.blue,
        allDay = allDay ?? true;

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      'title': title.text,
      'description': description.text,
      'startDay': startDay.toDateOnly().microsecondsSinceEpoch,
      'endDay': endDay.toDateOnly().microsecondsSinceEpoch,
      'allDay': allDay ? 1 : 0,
      'startHour': UtilsDatabase.timeOfDayToString(startHour),
      'endHour': UtilsDatabase.timeOfDayToString(endHour),
      'color': color.value,
    };
  }

  factory EventState.fromMap(Map<String, dynamic> map) {
    return EventState(
      id: map['id'],
      title: TextEditingController(text: map['title']),
      description: TextEditingController(text: map['description']),
      allDay: map['allDay'] == 1 ? true : false,
      startDay: DateTime.fromMicrosecondsSinceEpoch(map['startDay']),
      endDay: DateTime.fromMicrosecondsSinceEpoch(map['endDay']),
      startHour: UtilsDatabase.stringToTimeOfDay(map['startHour']),
      endHour: UtilsDatabase.stringToTimeOfDay(map['endHour']),
      color: Color(map['color']),
    );
  }
}
