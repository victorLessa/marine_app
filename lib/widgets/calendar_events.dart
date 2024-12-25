import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marine/models/event_state.dart';
import 'package:marine/providers/calendar_provider.dart';
import 'package:marine/providers/event_provider.dart';
import 'package:marine/screens/view_event.dart';
import 'package:provider/provider.dart';

class CalendarEvents extends StatefulWidget {
  const CalendarEvents({super.key});

  @override
  State<CalendarEvents> createState() => _CalendarEventsState();
}

class _CalendarEventsState extends State<CalendarEvents>
    with SingleTickerProviderStateMixin {
  final Color todayColor = const Color.fromARGB(255, 0, 156, 208);
  final Color selectedColor = const Color.fromARGB(255, 123, 148, 164);

  @override
  void initState() {
    super.initState();
  }

  Future<void> openViewEvent(context, int? eventId) async {
    if (eventId == null) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite que o modal ocupe o espaço necessário
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return ViewEvent(
          eventId: eventId,
        );
      },
    );

    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    eventProvider.cleanFormEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarProvider>(
      builder: (context, calendarState, child) {
        EventProvider eventProvider = Provider.of<EventProvider>(context);
        return ValueListenableBuilder<DateTime>(
          valueListenable: calendarState.focusedDay,
          builder: (context, value, _) {
            String day = value.day.toString();
            String dayOfWeek = DateFormat.E('pt_BR').format(value);

            return Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 10, right: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(dayOfWeek),
                      const SizedBox(
                        height: 5,
                      ),
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
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: FutureBuilder(
                        future: eventProvider.findEventByDate(value),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<EventState>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return const Center(
                              child: Text('Erro ao carregar os eventos'),
                            );
                          } else if (snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('Nenhum evento encontrado'),
                            );
                          }

                          List<EventState> events = snapshot.data!;

                          return ListView.builder(
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () async => await openViewEvent(
                                    context, events[index].id),
                                child: Column(
                                  children: [
                                    index > 0 ? const Divider() : Container(),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: events[index].color,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              events[index].title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            events[index].allDay
                                                ? const Text("Dia inteiro")
                                                : Text(
                                                    '${events[index].startHour.format(context)} - ${events[index].endHour.format(context)}',
                                                  ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
