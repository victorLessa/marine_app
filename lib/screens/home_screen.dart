import 'package:flutter/material.dart';
import 'package:marine/providers/app_provider.dart';
import 'package:marine/widgets/legend.dart';
import 'package:marine/widgets/table_calendar.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      drawer: const CustomDrawer(),
      body: Consumer<AppProvider>(
        builder: (ctx, appState, child) {
          return const Column(
            children: [
              Text(
                'Jornada de trabalho: 28/28',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Legend(
                      title: 'Embarcado', color: Color.fromRGBO(214, 0, 0, 1)),
                  Legend(
                      title: 'Reunião pré embarque',
                      color: Color.fromARGB(255, 0, 156, 208)),
                  Legend(
                      title: 'Desembarque',
                      color: Color.fromARGB(255, 122, 208, 255)),
                ],
              ),
              const Calendar(),
            ],
          );
        },
      ),
    );
  }
}
