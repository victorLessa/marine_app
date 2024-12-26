import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/work_schedule_screen.dart';
import 'screens/radar_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu App',
      locale:
          const Locale('pt', 'BR'), // Define o idioma como Português do Brasil
      supportedLocales: const [
        Locale('en', 'US'), // Inglês
        Locale('pt', 'BR'), // Português do Brasil
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
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
        '/escala': (context) => const EscalaScreen(),
        '/radar': (context) => const RadarScreen(),
      },
    );
  }
}
