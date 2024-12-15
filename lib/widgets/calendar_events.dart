import 'package:flutter/material.dart';
import 'package:marine/providers/calendar_event_provider.dart';
import 'package:provider/provider.dart';

class CalendarEvents extends StatefulWidget {
  const CalendarEvents({super.key});

  @override
  State<CalendarEvents> createState() => _CalendarEventsState();
}

class _CalendarEventsState extends State<CalendarEvents>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final Color todayColor = const Color.fromARGB(255, 0, 156, 208);
  final Color selectedColor = const Color.fromARGB(255, 123, 148, 164);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarEventProvider>(builder: (context, appState, child) {
      return ValueListenableBuilder<DateTime>(
        valueListenable: appState.focusedDay,
        builder: (context, value, _) {
          String day = value.day.toString();
          List<Map<String, dynamic>> events = appState.events[value] ?? [];
          if (events.isNotEmpty) {
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 50,
                width: 50,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Text(
                  day,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "${events[index]["name"]}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              )
            ]);
          }
          return const Text("Sem Evento");
        },
      );
    });
  }
}
