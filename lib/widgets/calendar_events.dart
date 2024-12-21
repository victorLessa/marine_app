import 'package:flutter/material.dart';
import 'package:marine/models/event_state.dart';
import 'package:marine/providers/calendar_provider.dart';
import 'package:marine/providers/event_provider.dart';
import 'package:marine/widgets/utils_calendar.dart';
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
    return Consumer<CalendarProvider>(builder: (context, calendarState, child) {
      EventProvider eventProvider = Provider.of<EventProvider>(context);
      return ValueListenableBuilder<DateTime>(
        valueListenable: calendarState.focusedDay,
        builder: (context, value, _) {
          String day = value.day.toString();
          List<EventState> events = whereEvent(eventProvider.eventList, value);
          if (events.isNotEmpty) {
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 45,
                width: 45,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 123, 148, 164),
                ),
                child: Text(
                  day,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: events[index].color,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          events[index].title,
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
