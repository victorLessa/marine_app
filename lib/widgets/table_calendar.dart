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

  @override
  void initState() {
    super.initState();
  }

  Future<List<EventState>> _loadEvents() async {
    final calendarProvider =
        Provider.of<CalendarProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    return await eventProvider.findEventByMonth(calendarProvider.focusedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
        builder: (BuildContext context, eventState, child) {
      final calendarProvider = Provider.of<CalendarProvider>(context);
      return FutureBuilder(
          future: _loadEvents(),
          builder: (context, AsyncSnapshot<List<EventState>> snapshot) {
            final events = snapshot.data ?? [];
            return TableCalendar(
              locale: 'pt_BR',
              firstDay: DateTime.utc(2000, 1, 1), // Primeiro dia possível
              lastDay: DateTime.utc(2100, 12, 31), // Último dia possível
              focusedDay: calendarProvider.focusedDay,
              calendarFormat:
                  CalendarFormat.month, // Formato inicial do calendário
              selectedDayPredicate: (day) =>
                  isSameDay(calendarProvider.selectedDay, day),
              eventLoader: (DateTime day) => whereEvent(events, day),
              currentDay: DateTime.now(),
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
                    // return Positioned(
                    //   bottom: 10, // Ajusta a posição das bolinhas
                    //   child: _buildEventsMarker(day, events),
                    // );
                    return _buildEventsMarker(day, events);
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
          });
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
    int hasEmbarked = events.indexWhere((EventState event) => event.embarked);
    if (hasEmbarked != -1) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(3.0),
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
          ),
          Center(
            child: Text('${date.day}'),
          ),
          Positioned(
            bottom: 10.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
            ),
          )
        ],
      );
    }
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
