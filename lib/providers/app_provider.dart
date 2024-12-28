import 'package:flutter/material.dart';
import 'package:marine/providers/work_schedule_provider.dart';
import '../models/app_state.dart';

class AppProvider with ChangeNotifier {
  final AppState _state = AppState();
  late WorkScheduleProvider _workScheduleProvider;
  AppState get state => _state;

  void updateUserName(String name) {
    _state.userName = name;
    notifyListeners();
  }

  void setWorkScheduleProvider(WorkScheduleProvider provider) {
    _workScheduleProvider = provider;
  }

  Future<AppState> loadUserData() async {
    _state.workScheduleState = await _workScheduleProvider.getWorkSchedule();

    return _state;
  }
}
