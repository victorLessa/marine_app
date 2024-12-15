import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/agendamento_screen.dart';
import 'screens/radar_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Montserrat',
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 24.0),
          titleMedium: TextStyle(fontSize: 18.0),
          titleSmall: TextStyle(fontSize: 14.0),
          labelSmall: TextStyle(fontSize: 12.0),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/agendamento': (context) => const AgendamentoScreen(),
        '/radar': (context) => const RadarScreen(),
      },
    );
  }
}
