import 'package:flutter/material.dart';
import 'package:marine/providers/event_provider.dart';
import 'package:marine/screens/form_event.dart';
import 'package:marine/widgets/calendar_events.dart';
import 'package:marine/widgets/custom_view.dart';
import 'package:marine/widgets/legend.dart';
import 'package:marine/widgets/table_calendar.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    EventProvider eventProvider = Provider.of<EventProvider>(context);
    return CustomView(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            isScrollControlled:
                true, // Permite que o modal ocupe o espaço necessário
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            builder: (BuildContext context) {
              return const ModalBottomFormEvent();
            },
          );

          eventProvider.cleanFormEvent();
        },
        backgroundColor: const Color.fromARGB(255, 0, 156, 208),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Jornada de trabalho: 28/28',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
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
