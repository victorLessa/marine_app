import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:marine/providers/appointment_provider.dart';
import 'package:marine/providers/calendar_provider.dart';
import 'package:marine/providers/event_provider.dart';
import 'package:marine/providers/work_schedule_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/app_provider.dart';

void main() {
  initializeDateFormatting('pt_BR', null).then(
    (_) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppointmentProvider()),
          ChangeNotifierProvider(create: (_) => CalendarProvider()),
          ChangeNotifierProvider(create: (_) => EventProvider()),
          ChangeNotifierProvider(create: (context) {
            final eventProvider =
                Provider.of<EventProvider>(context, listen: false);
            final workScheduleProvider = WorkScheduleProvider();
            workScheduleProvider.setEventProvider(eventProvider);
            return workScheduleProvider;
          }),
          ChangeNotifierProvider(create: (context) {
            final workScheduleProvider =
                Provider.of<WorkScheduleProvider>(context, listen: false);
            final appProvider = AppProvider();

            appProvider.setWorkScheduleProvider(workScheduleProvider);
            return appProvider;
          }),
        ],
        child: const MyApp(),
      ),
    ),
  );
}
