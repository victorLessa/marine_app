import 'package:flutter/material.dart';

class WorkScheduleState {
  int? id;
  TextEditingController schedule;
  DateTime? boardingDay;
  TextEditingController years;
  bool preBoardingMeeting;

  WorkScheduleState(
      {required this.schedule,
      this.id,
      TextEditingController? years,
      this.preBoardingMeeting = false,
      this.boardingDay})
      : years = years ?? TextEditingController(text: '1');

  factory WorkScheduleState.fromMap(Map<String, dynamic> map) {
    return WorkScheduleState(
      id: map["id"],
      boardingDay: DateTime.fromMicrosecondsSinceEpoch(map['boardingDay']),
      preBoardingMeeting: map['preBoardingMeeting'] == 1 ? true : false,
      years: TextEditingController(text: map["years"].toString()),
      schedule: TextEditingController(text: map["schedule"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'preBoardingMeeting': preBoardingMeeting ? 1 : 0,
      'boardingDay': boardingDay?.microsecondsSinceEpoch,
      'years': int.parse(years.text),
      'schedule': schedule.text,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WorkScheduleState &&
        other.id == id &&
        other.schedule.text == schedule.text &&
        other.boardingDay == boardingDay &&
        other.years.text == years.text &&
        other.preBoardingMeeting == preBoardingMeeting;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        schedule.text.hashCode ^
        boardingDay.hashCode ^
        years.text.hashCode ^
        preBoardingMeeting.hashCode;
  }
}
