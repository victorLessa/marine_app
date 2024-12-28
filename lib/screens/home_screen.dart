import 'package:flutter/material.dart';
import 'package:marine/providers/work_schedule_provider.dart';
import 'package:marine/screens/form_event.dart';
import 'package:marine/widgets/list_view_events.dart';
import 'package:marine/widgets/custom_view.dart';
import 'package:marine/widgets/legend.dart';
import 'package:marine/widgets/table_calendar.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomView(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormEvent(),
            ),
          );
        },
      ),
      drawer: const CustomDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Column(
              children: [
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.pushNamed(context, '/escala');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Consumer<WorkScheduleProvider>(
                          builder: (context, workScheduleProvider, _) {
                        return Text(
                          'Jornada de trabalho: ${workScheduleProvider.workScheduleState.schedule.text}',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        );
                      }),
                      Container(
                        width: 5,
                      ),
                      const Icon(
                        Icons.edit_calendar,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Legend(
                        title: 'Embarcado',
                        color: Color.fromRGBO(214, 0, 0, 1)),
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
            ),
          ),
          const Expanded(child: CalendarEvents()),
        ],
      ),
    );
  }
}
