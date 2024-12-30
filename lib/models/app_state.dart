import 'package:marine/models/work_schedule_state.dart';

class AppState {
  String userName;
  WorkScheduleState? workScheduleState;

  AppState({this.userName = 'N/A', this.workScheduleState});
}
