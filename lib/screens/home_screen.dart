import 'package:flutter/material.dart';
import 'package:marine/providers/work_schedule_provider.dart';
import 'package:marine/routes/paths.dart';
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
        centerTitle: true,
        actions: [
          TextButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
              ),
              minimumSize: WidgetStateProperty.all<Size>(
                const Size(0, 0),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRouterPaths.escala);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<WorkScheduleProvider>(
                    builder: (context, workScheduleProvider, _) {
                  return Text(
                    'Escala: ${workScheduleProvider.workScheduleState.schedule.text}',
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  );
                }),
                Container(
                  width: 5,
                ),
                const Icon(
                  Icons.edit_calendar,
                  size: 16,
                  color: Colors.black,
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label:
            const Text('Criar evento', style: TextStyle(color: Colors.white)),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.lightBlue,
        onPressed: () {
          Navigator.pushNamed(context, AppRouterPaths.escala);
        },
      ),
      drawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: [
                const Calendar(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Legend(
                                title: 'Embarcado', color: AppColors.embarked),
                            const SizedBox(
                              width: 10,
                            ),
                            Legend(
                                title: 'Reunião pré embarque',
                                color: AppColors.preBoardingMeeting),
                          ],
                        ),
                        Legend(
                            title: 'Desembarque',
                            color: AppColors.desembarkationDay),
                      ],
                    ),
                  ],
                )
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
