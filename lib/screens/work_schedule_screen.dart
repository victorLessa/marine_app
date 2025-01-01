import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:marine/models/work_schedule_state.dart';
import 'package:marine/providers/work_schedule_provider.dart';
import 'package:marine/widgets/button_loading.dart';
import 'package:marine/widgets/custom_view.dart';
import 'package:marine/widgets/utils_app.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class EscalaScreen extends StatefulWidget {
  const EscalaScreen({super.key});

  @override
  State<EscalaScreen> createState() => _EscalaScreenState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _EscalaScreenState extends State<EscalaScreen> {
  final GlobalKey<FormState> _formController = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  void _showCustomScale(BuildContext context) async {
    final workScheduleProvider =
        Provider.of<WorkScheduleProvider>(context, listen: false);
    await showDialog(
      context: context,
      builder: (BuildContext contex) {
        return Consumer<WorkScheduleProvider>(
            builder: (context, setState, child) {
          return AlertDialog(
            title: const Center(
              child: Text(
                "Crie sua escala",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NumberPicker(
                        value: workScheduleProvider.leftSchedule,
                        minValue: 2,
                        maxValue: 30,
                        step: 1,
                        itemWidth: 50,
                        itemHeight: 50,
                        axis: Axis.vertical,
                        onChanged: workScheduleProvider.setLeftSchedule,
                      ),
                      const Text("/"),
                      NumberPicker(
                        value: workScheduleProvider.rightSchedule,
                        minValue: 2,
                        maxValue: 30,
                        step: 1,
                        itemWidth: 50,
                        itemHeight: 50,
                        axis: Axis.vertical,
                        onChanged: workScheduleProvider.setRightSchedule,
                      )
                    ],
                  )
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.blue)),
                  onPressed: () {
                    workScheduleProvider
                        .setSchedule(workScheduleProvider.workSchedule);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Salvar'),
                ),
              )
            ],
          );
        });
      },
    );
  }

  Future<void> submit(WorkScheduleProvider workScheduleProvider) async {
    if (_formController.currentState!.validate()) {
      try {
        await workScheduleProvider
            .addWorkSchedule(workScheduleProvider.workScheduleState);
        if (mounted) {
          snackSuccess(context, 'Escala ataulizada com sucesso!');
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          snackError(context, 'Erro: ${e.toString()}');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final workScheduleProvider =
        Provider.of<WorkScheduleProvider>(context, listen: false);
    return CustomView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Escala'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          FutureBuilder(
            future: workScheduleProvider.getWorkSchedule(),
            builder: (BuildContext context,
                AsyncSnapshot<WorkScheduleState?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Erro: ${snapshot.error}'),
                );
              } else {
                final form = snapshot.data;
                workScheduleProvider.setFormWorkSchedule(form);
                return Consumer<WorkScheduleProvider>(builder:
                    (BuildContext context, workScheduleProvider, child) {
                  final workScheduleState =
                      workScheduleProvider.workScheduleState;
                  return Form(
                    key: _formController,
                    child: Column(
                      children: [
                        DropdownMenu<String>(
                          width: double.infinity,
                          label: const Text('Selecione data de embarque'),
                          initialSelection: workScheduleState.schedule.text,
                          controller: workScheduleState.schedule,
                          onSelected: (String? value) async {
                            if (value == "Personalizar") {
                              _showCustomScale(context);
                            }
                          },
                          dropdownMenuEntries: UnmodifiableListView<MenuEntry>(
                            workScheduleProvider.workScheduleOptions
                                .map<MenuEntry>((String name) =>
                                    MenuEntry(value: name, label: name)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          readOnly: true,
                          controller: TextEditingController(
                            text: workScheduleProvider.getBoardingDayString,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Selecione data de embarque',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              currentDate: workScheduleState.boardingDay,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              workScheduleProvider.setBoardingDay(pickedDate);
                            }
                          },
                        ),
                        Container(
                          height: 20,
                        ),
                        DropdownMenu<String>(
                          width: double.infinity,
                          label: const Text('Gerar por quantos anos?'),
                          initialSelection: workScheduleState.years.text,
                          controller: workScheduleState.years,
                          dropdownMenuEntries: UnmodifiableListView<MenuEntry>(
                            ['1', '2', '3'].map<MenuEntry>((String name) =>
                                MenuEntry(value: name, label: name)),
                          ),
                        ),
                        Container(
                          height: 5,
                        ),
                        InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: Transform.translate(
                            offset: const Offset(-14, 0),
                            child: Row(
                              children: [
                                Checkbox(
                                  activeColor: Colors.blue,
                                  checkColor: Colors.white,
                                  value: workScheduleState.preBoardingMeeting,
                                  onChanged: (bool? value) {
                                    workScheduleProvider
                                        .setPreBoardingMeeting(value!);
                                  },
                                ),
                                const Text("Reunião de Embarque"),
                              ],
                            ),
                          ),
                          onTap: () {
                            bool result = !workScheduleState.preBoardingMeeting;

                            workScheduleProvider.setPreBoardingMeeting(result);
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ButtonLoading(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(Colors.blue),
                              ),
                              onPressed: () async =>
                                  await submit(workScheduleProvider),
                              isBusy: workScheduleProvider.isBusy),
                        )
                      ],
                    ),
                  );
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
