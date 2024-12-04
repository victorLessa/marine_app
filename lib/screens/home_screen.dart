import 'package:flutter/material.dart';
import 'package:marine/providers/app_provider.dart';
import 'package:marine/widgets/table_calendar.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: const CustomDrawer(),
      body: Consumer<AppProvider>(
        builder: (context, appState, child) {
          return const Calendar();
        },
      ),
    );
  }
}
