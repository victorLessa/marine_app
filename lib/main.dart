import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:marine/providers/appointment_provider.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/app_provider.dart';

void main() {
  initializeDateFormatting('pt_BR', null).then(
    (_) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
          ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}
