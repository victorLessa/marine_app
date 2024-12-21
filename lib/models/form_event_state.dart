import 'package:flutter/material.dart';
import 'package:marine/models/event_state.dart';

class FormEventState {
  TextEditingController title;
  TextEditingController description;
  TimeOfDay startHour;
  TimeOfDay endHour;
  DateTime endDay;
  DateTime startDay;
  bool allDay;
  late Color color;

  FormEventState({
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

  void dispose() {
    title.dispose();
    description.dispose();
  }

  EventState toJson() {
    return EventState(
        title: title.text,
        color: color,
        startDay: startDay,
        endDay: endDay,
        description: description.text,
        endHour: endHour,
        startHour: startHour);
  }
}
