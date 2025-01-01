import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marine/models/event_state.dart';
import 'package:marine/models/work_schedule_state.dart';
import 'package:marine/providers/event_provider.dart';
import 'package:marine/repositories/work_schedule.dart';
import 'package:marine/styles/app_style.dart';

class WorkScheduleProvider with ChangeNotifier {
  final List<String> workScheduleOptions = ['14/14', '28/28', 'Personalizar'];
  late WorkScheduleState _workScheduleState =
      WorkScheduleState(schedule: TextEditingController(text: ''));
  final WorkScheduleRepository _workScheduleRepository =
      WorkScheduleRepository();
  int leftSchedule = 0;
  int rightSchedule = 0;

  late EventProvider _eventProvider;

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

  void setEventProvider(EventProvider eventProvider) {
    _eventProvider = eventProvider;
  }

  void setFormWorkSchedule(WorkScheduleState? data) {
    if (data != null) {
      _workScheduleState = data;
    }
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

  Future<WorkScheduleState?> getWorkSchedule() async {
    return await _workScheduleRepository.getWorkSchedule();
  }

  Future<List<EventState>?> generateDaysOnBoard(WorkScheduleState data) async {
    await _eventProvider.deleteEmbarked();

    int years = int.parse(data.years.text);
    List<String> scale = data.schedule.text.split('/');
    DateTime? boardingDay = data.boardingDay;
    bool preBoardingMeeting = data.preBoardingMeeting;
    if (boardingDay == null) return [];

    DateTime lastDate = DateTime(
      boardingDay.year + years,
      boardingDay.month,
      boardingDay.day,
    );

    // Obter o número de dias
    int daysOn = int.parse(scale[0]);
    int daysOff = int.parse(scale[1]);
    List<EventState> events = [];

    DateTime currentDate = boardingDay;
    while (currentDate.isBefore(lastDate)) {
      if (preBoardingMeeting) {
        await _eventProvider.addEvent(EventState(
          title: TextEditingController(text: 'Reunião pré Embarque'),
          startDay: currentDate.subtract(const Duration(days: 1)),
          color: AppColors.preBoardingMeeting,
          embarked: true,
          endDay: currentDate.subtract(const Duration(days: 1)),
          allDay: true,
        ));
      }
      await _eventProvider.addEvent(EventState(
        title: TextEditingController(text: 'Embarcado'),
        startDay: currentDate,
        color: AppColors.embarked,
        embarked: true,
        endDay: currentDate.add(Duration(days: daysOn - 1)),
        allDay: true,
      ));
      await _eventProvider.addEvent(EventState(
        title: TextEditingController(text: 'Desembarque'),
        startDay: currentDate.add(Duration(days: daysOn)),
        color: AppColors.desembarkationDay,
        embarked: true,
        endDay: currentDate.add(Duration(days: daysOn)),
        allDay: true,
      ));

      currentDate = currentDate.add(Duration(days: daysOn));
      currentDate = currentDate.add(Duration(days: daysOff));
    }

    return events;
  }

  Future<void> addWorkSchedule(WorkScheduleState data) async {
    try {
      isBusy = true;
      notifyListeners();
      final existingSchedule = await getWorkSchedule();
      int? workScheduleId = existingSchedule?.id;

      if (existingSchedule != null && workScheduleId != null) {
        await _workScheduleRepository.updateWorkSchedule(workScheduleId, data);

        if (existingSchedule != data) await generateDaysOnBoard(data);
      } else {
        await _workScheduleRepository.createWorkSchedule(data);
        await generateDaysOnBoard(data);
      }
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }
}
