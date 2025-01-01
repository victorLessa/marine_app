import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marine/providers/app_provider.dart';
import 'package:marine/providers/event_provider.dart';
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
      final appState = await appProvider.loadUserData();

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
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: const Center(
            child: Text("Carregando"),
          ),
          // Add your splash screen UI components here
        ),
      ),
    );
  }
}
