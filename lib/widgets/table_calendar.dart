import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<Calendar> {
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  DateTime? _selectedDay;
  late Map<DateTime, List<Object>> _events;

  List<Object> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  void initState() {
    super.initState();

    // Inicializando os eventos
    _events = {
      DateTime.utc(2024, 12, 5): [
        {"name": "Evento 1", "color": ""},
        {"name": "Evento 2", "color": ""}
      ],
      DateTime.utc(2024, 12, 6): [
        {"name": 'Evento 3', "color": ""}
      ],
      DateTime.utc(2024, 12, 7): [
        {"name": 'Evento 3', "color": ""}
      ],
    };

    _selectedDay = _focusedDay.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TableCalendar(
        locale: 'pt_BR',
        firstDay: DateTime.utc(2000, 1, 1), // Primeiro dia possível
        lastDay: DateTime.utc(2100, 12, 31), // Último dia possível
        focusedDay: _focusedDay.value,
        calendarFormat: CalendarFormat.month, // Formato inicial do calendário
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        eventLoader: _getEventsForDay,
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay.value = focusedDay;
          });
        },
        calendarBuilders: CalendarBuilders(
          todayBuilder: (context, day, focusedDay) {
            return dayBuilder(const Color.fromARGB(255, 0, 156, 208), context,
                day, focusedDay);
          },
          selectedBuilder: (context, day, focusedDay) {
            return dayBuilder(const Color.fromARGB(255, 123, 148, 164), context,
                day, focusedDay);
          },
          markerBuilder: (context, day, events) {
            if (events.isNotEmpty) {
              return Positioned(
                bottom: 10, // Ajusta a posição das bolinhas
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: events.take(3).map((event) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red, // Você pode personalizar a cor
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
      ValueListenableBuilder<DateTime>(
        valueListenable: _focusedDay,
        builder: (context, value, _) {
          List<Object> events = _events[value] ?? [];

          if (events.isNotEmpty) {
            return Column(
              children: events.take(3).map((event) {
                return Center(
                  child: Text((event as Map<String, dynamic>)["name"]),
                );
              }).toList(),
            );
          }
          return const Text("Sem Evento");
        },
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
