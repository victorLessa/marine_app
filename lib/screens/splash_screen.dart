import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marine/providers/app_provider.dart';
import 'package:marine/providers/event_provider.dart';
import 'package:marine/providers/work_schedule_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      final workScheduleProvider =
          Provider.of<WorkScheduleProvider>(context, listen: false);
      final appState = await appProvider.loadUserData();
      final workSchedule = await workScheduleProvider.getWorkSchedule();
      workScheduleProvider.setFormWorkSchedule(workSchedule);
      if (mounted) {
        if (appState.userName.text.isEmpty) {
          Navigator.pushReplacementNamed(context, '/intro');
          return;
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Carregando"),

          // Add your splash screen UI components here
        ),
      ),
    );
  }
}
