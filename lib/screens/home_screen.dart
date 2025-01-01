import 'package:flutter/material.dart';
import 'package:marine/providers/work_schedule_provider.dart';
import 'package:marine/screens/form_event_screen.dart';
import 'package:marine/styles/app_style.dart';
import 'package:marine/widgets/list_view_events.dart';
import 'package:marine/widgets/custom_view.dart';
import 'package:marine/widgets/legend.dart';
import 'package:marine/widgets/table_calendar.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomView(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormEvent(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      drawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Consumer<WorkScheduleProvider>(
                                builder: (context, workScheduleProvider, _) {
                              return Text(
                                'Jornada de trabalho: ${workScheduleProvider.workScheduleState.schedule.text}',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              );
                            }),
                            Container(
                              width: 5,
                            ),
                            const Icon(
                              Icons.edit_calendar,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Legend(title: 'Embarcado', color: AppColors.embarked),
                          Legend(
                              title: 'Reunião pré embarque',
                              color: AppColors.preBoardingMeeting),
                          Legend(
                              title: 'Desembarque',
                              color: AppColors.desembarkationDay),
                        ],
                      ),
                    ],
                  ),
                ),
                const Calendar(),
                Container(
                  height: 10,
                ),
                // const SizedBox(height: 400, child: CalendarEvents())
              ],
            ),
          ),
          const SliverFillRemaining(
            child: CalendarEvents(),
          ),
        ],
      ),
    );
  }
}
