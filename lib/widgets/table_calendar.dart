import 'package:flutter/material.dart';
import 'package:marine/providers/calendar_event_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final calendarEventProvider = Provider.of<CalendarEventProvider>(context);

    return Column(children: [
      TableCalendar(
        locale: 'pt_BR',
        firstDay: DateTime.utc(2000, 1, 1), // Primeiro dia possível
        lastDay: DateTime.utc(2100, 12, 31), // Último dia possível
        focusedDay: calendarEventProvider.focusedDay.value,
        calendarFormat: CalendarFormat.month, // Formato inicial do calendário
        selectedDayPredicate: (day) =>
            isSameDay(calendarEventProvider.selectedDay, day),
        eventLoader: (DateTime day) => calendarEventProvider.events[day] ?? [],
        onDaySelected: (selectedDay, focusedDay) {
          calendarEventProvider.addSelectedDay(selectedDay);

          calendarEventProvider.addFocusedDay(focusedDay);
        },
        calendarBuilders: CalendarBuilders(
          todayBuilder: (context, day, focusedDay) =>
              dayBuilder(todayColor, context, day, focusedDay),
          selectedBuilder: (context, day, focusedDay) =>
              dayBuilder(selectedColor, context, day, focusedDay),
          markerBuilder: (context, day, events) {
            if (events.isNotEmpty) {
              return Positioned(
                bottom: 10, // Ajusta a posição das bolinhas
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: events.take(3).map((event) {
                    Color color = (event as Map<String, dynamic>?)?['color'] ??
                        Colors.grey;

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
      ),
    ]);
  }

  Widget dayBuilder(Color color, context, day, focusedDay) {
    return Container(
      margin: const EdgeInsets.all(3.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color, // Cor de fundo para o dia de hoje
        shape: BoxShape.circle,
      ),
      child: Text(
        '${day.day}',
        style: const TextStyle(color: Colors.white), // Cor do texto
      ),
    );
  }
}
