import 'package:flutter/material.dart';
import 'package:marine/providers/work_schedule_provider.dart';
import 'package:marine/repositories/user.dart';
import '../models/app_state.dart';

class AppProvider with ChangeNotifier {
  final AppState _state = AppState();
  late WorkScheduleProvider _workScheduleProvider;
  final UserRepository _userRepository = UserRepository();
  bool isBusy = false;

  AppState get state => _state;

  Future<void> updateUserName(AppState appState) async {
    try {
      isBusy = true;
      notifyListeners();
      await _userRepository.setUsername(appState);
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  void setWorkScheduleProvider(WorkScheduleProvider provider) {
    _workScheduleProvider = provider;
  }

  Future<AppState> loadUserData() async {
    _state.workScheduleState = await _workScheduleProvider.getWorkSchedule();

    return _state;
  }
}
