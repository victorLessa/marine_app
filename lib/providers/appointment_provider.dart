import 'package:flutter/foundation.dart';

class AppointmentProvider with ChangeNotifier {
  final List<String> _appointments = [];

  List<String> get appointments => _appointments;

  void addAppointment(String appointment) {
    _appointments.add(appointment);
    notifyListeners();
  }

  void removeAppointment(String appointment) {
    _appointments.remove(appointment);
    notifyListeners();
  }
}
