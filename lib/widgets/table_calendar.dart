import 'package:flutter/material.dart';
import 'package:marine/extensions/datetime.dart';
import 'package:marine/models/event_state.dart';
import 'package:marine/providers/calendar_provider.dart';
import 'package:marine/providers/event_provider.dart';
import 'package:marine/styles/app_style.dart';
import 'package:marine/widgets/utils_calendar.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<Calendar> {
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
                    dayBuilder(AppColors.todayColor, context, date),
                selectedBuilder: (context, date, focusedDay) =>
                    dayBuilder(AppColors.selectedColor, context, date),
                markerBuilder: (context, day, List<EventState> events) {
                  if (events.isNotEmpty) {
                    return _buildEventsMarker(day, events, calendarProvider);
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

  Widget dayBuilder(Color color, context, date) {
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

  Widget _buildEventsMarker(DateTime date, List<EventState> events,
      CalendarProvider calendarProvider) {
    DateTime focusedDay = calendarProvider.focusedDay;

    if (isSameDay(focusedDay, date)) {
      return dayBuilder(AppColors.selectedColor, context, date);
    } else if (isSameDay(date, DateTime.now())) {
      return dayBuilder(AppColors.todayColor, context, date);
    }

    int embarkedIndex = events.indexWhere((EventState event) => event.embarked);
    if (embarkedIndex != -1) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: events[embarkedIndex].color),
            ),
          ),
          Center(
            child: Text(
              '${date.day}',
            ),
          ),
          Positioned(
            bottom: 10.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  events.take(3).where((event) => !event.embarked).map((event) {
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
    return Positioned(
      bottom: 8.0,
      child: Row(
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
    );
  }
}
