import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now(); // Dia atual
  DateTime? _selectedDay;

  Map<DateTime, List<String>> events = {
    DateTime(2024, 12, 5): ['Evento 1', 'Evento 2'],
    DateTime(2024, 12, 25): ['Natal'],
  };

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'pt_BR',
      firstDay: DateTime.utc(2000, 1, 1), // Primeiro dia possível
      lastDay: DateTime.utc(2100, 12, 31), // Último dia possível
      focusedDay: _focusedDay,
      calendarFormat: CalendarFormat.month, // Formato inicial do calendário
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      eventLoader: (day) => events[day] ?? [],
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      headerStyle: const HeaderStyle(
        formatButtonVisible: false, // Oculta botão de alterar formato
        titleCentered: true, // Centraliza o título
      ),
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        weekendTextStyle: TextStyle(color: Colors.red),
      ),
    );
  }
}
