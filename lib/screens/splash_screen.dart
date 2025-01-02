import 'package:flutter/material.dart';
import 'package:marine/providers/app_provider.dart';
import 'package:marine/providers/work_schedule_provider.dart';
import 'package:marine/routes/paths.dart';
import 'package:marine/widgets/utils_app.dart';
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
      try {
        final appProvider = Provider.of<AppProvider>(context, listen: false);
        final workScheduleProvider =
            Provider.of<WorkScheduleProvider>(context, listen: false);
        final appState = await appProvider.loadUserData();
        final workSchedule = await workScheduleProvider.getWorkSchedule();
        workScheduleProvider.setFormWorkSchedule(workSchedule);
        if (mounted) {
          if (appState.userName.text.isEmpty) {
            Navigator.pushReplacementNamed(context, AppRouterPaths.intro);
            return;
          } else {
            Navigator.pushReplacementNamed(context, AppRouterPaths.home);
          }
        }
      } catch (e) {
        if (mounted) {
          snackError(context, e.toString());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF8B9CFF),
        body: Center(
          child: Image(
            image: AssetImage('assets/images/logo.png'),
            width: 200, // Defina a largura desejada
            height: 200, // Defina a altura desejada
          ),
          // Add your splash screen UI components here
        ),
      ),
    );
  }
}
