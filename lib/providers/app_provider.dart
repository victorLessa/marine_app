import 'package:flutter/material.dart';
import '../models/app_state.dart';

class AppProvider with ChangeNotifier {
  final AppState _state = AppState();

  AppState get state => _state;

  void updateUserName(String name) {
    _state.userName = name;
    notifyListeners();
  }
}
