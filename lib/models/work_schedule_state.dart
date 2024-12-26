import 'package:flutter/material.dart';

class WorkScheduleState {
  int? id;
  TextEditingController schedule;
  DateTime? boardingDay;
  bool preBoardingMeeting;

  WorkScheduleState(
      {TextEditingController? schedule,
      this.id,
      this.preBoardingMeeting = false,
      this.boardingDay})
      : schedule = schedule ?? TextEditingController();

  factory WorkScheduleState.fromMap(Map<String, dynamic> map) {
    return WorkScheduleState(
      id: map["id"],
      boardingDay: DateTime.fromMicrosecondsSinceEpoch(map['boardingDay']),
      preBoardingMeeting: map['preBoardingMeeting'] == 1 ? true : false,
      schedule: TextEditingController(text: map["schedule"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'preBoardingMeeting': preBoardingMeeting! ? true : false,
      'boardingDay': boardingDay?.microsecondsSinceEpoch,
      'schedule': schedule.text,
    };
  }
}
