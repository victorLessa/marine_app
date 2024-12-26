import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marine/models/work_schedule_state.dart';
import 'package:marine/repositories/work_schedule.dart';

class WorkScheduleProvider with ChangeNotifier {
  final List<String> workScheduleOPtions = ['14/14', '28/28', 'Personalizar'];
  final WorkScheduleState _workScheduleState = WorkScheduleState();
  final WorkScheduleRepository _workScheduleRepository =
      WorkScheduleRepository();
  int leftSchedule = 0;
  int rightSchedule = 0;

  bool isBusy = false;

  WorkScheduleState get workScheduleState => _workScheduleState;

  String? get getBoardingDayString {
    if (_workScheduleState.boardingDay != null) {
      return DateFormat('dd/MM/yyyy').format(_workScheduleState.boardingDay!);
    }
    return "";
  }

  String get workSchedule {
    return "$leftSchedule/$rightSchedule";
  }

  void setBoardingDay(DateTime date) {
    _workScheduleState.boardingDay = date;
    notifyListeners();
  }

  void setLeftSchedule(int value) {
    leftSchedule = value;
    notifyListeners();
  }

  void setRightSchedule(int value) {
    rightSchedule = value;
    notifyListeners();
  }

  void setSchedule(String setSchadule) {
    _workScheduleState.schedule.text = setSchadule;
    notifyListeners();
  }

  void setPreBoardingMeeting(bool value) {
    _workScheduleState.preBoardingMeeting = value;
    notifyListeners();
  }

  Future<void> addWorkSchedule(WorkScheduleState data) async {
    try {
      isBusy = true;
      await _workScheduleRepository.createWorkSchedule(data);
      notifyListeners();
    } finally {
      isBusy = false;
    }
  }
}
