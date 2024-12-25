import 'package:flutter/material.dart';
import 'package:marine/models/event_state.dart';
import 'package:marine/providers/calendar_provider.dart';
import 'package:marine/providers/event_provider.dart';
import 'package:marine/widgets/utils_calendar.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<Calendar> {
  final Color todayColor = const Color.fromARGB(255, 0, 156, 208);
  final Color selectedColor = const Color.fromARGB(255, 123, 148, 164);
  late Future<List<EventState>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = _loadEvents();
  }

  Future<List<EventState>> _loadEvents() async {
    final calendarProvider =
        Provider.of<CalendarProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final result =
        await eventProvider.findEventByMonth(calendarProvider.focusedDay.value);

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final calendarProvider = Provider.of<CalendarProvider>(context);

    return Consumer<EventProvider>(
        builder: (BuildContext context, eventState, child) {
      return Column(children: [
        FutureBuilder(
          future: _eventsFuture,
          builder: (context, snapshot) {
            final events = snapshot.data ?? [];

            return TableCalendar(
              locale: 'pt_BR',
              firstDay: DateTime.utc(2000, 1, 1), // Primeiro dia possível
              lastDay: DateTime.utc(2100, 12, 31), // Último dia possível
              focusedDay: calendarProvider.focusedDay.value,
              calendarFormat:
                  CalendarFormat.month, // Formato inicial do calendário
              selectedDayPredicate: (day) =>
                  isSameDay(calendarProvider.selectedDay, day),
              eventLoader: (DateTime day) => whereEvent(events, day),
              onDaySelected: (selectedDay, focusedDay) {
                calendarProvider.addSelectedDay(context, selectedDay);

                calendarProvider.addFocusedDay(focusedDay);
              },
              calendarBuilders: CalendarBuilders(
                todayBuilder: (context, date, focusedDay) =>
                    dayBuilder(todayColor, context, date, focusedDay),
                selectedBuilder: (context, date, focusedDay) =>
                    dayBuilder(selectedColor, context, date, focusedDay),
                markerBuilder: (context, day, List<EventState> events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      bottom: 10, // Ajusta a posição das bolinhas
                      child: _buildEventsMarker(day, events),
                    );
                  }
                  return null;
                },
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false, // Oculta botão de alterar formato
                titleCentered: true, // Centraliza o título
              ),
              calendarStyle: const CalendarStyle(
                weekendTextStyle: TextStyle(color: Colors.red),
              ),
            );
          },
        ),
      ]);
    });
  }

  Widget dayBuilder(Color color, context, date, focusedDay) {
    return Container(
      margin: const EdgeInsets.all(3.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color, // Cor de fundo para o dia de hoje
        shape: BoxShape.circle,
      ),
      child: Text(
        '${date.day}',
        style: const TextStyle(color: Colors.white), // Cor do texto
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List<EventState> events) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: events.take(3).map((event) {
        Color color = (event as EventState?)?.color ?? Colors.grey;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color, // Você pode personalizar a cor
          ),
        );
      }).toList(),
    );
  }
}
