import 'package:flutter/material.dart';
import 'package:marine/models/work_schedule_state.dart';

class AppState {
  TextEditingController userName;
  WorkScheduleState? workScheduleState;

  AppState({TextEditingController? userName, this.workScheduleState})
      : userName = userName ?? TextEditingController();

  Map<String, dynamic> toMap() {
    return {'userName': userName.text};
  }

  factory AppState.fromMap(Map<String, dynamic> map) {
    return AppState(
      userName: TextEditingController(text: map['userName']),
    );
  }
}
