import 'dart:collection';

import 'package:flutter/material.dart';
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
                        minValue: 0,
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
                        minValue: 0,
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

  @override
  Widget build(BuildContext context) {
    return CustomView(
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
      body: Consumer<WorkScheduleProvider>(
        builder: (BuildContext context, workScheduleProvider, child) {
          return Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formController,
                child: Column(
                  children: [
                    DropdownMenu<String>(
                      width: double.infinity,
                      label: const Text('Selecione data de embarque'),
                      initialSelection:
                          workScheduleProvider.workScheduleOPtions.first,
                      controller:
                          workScheduleProvider.workScheduleState.schedule,
                      onSelected: (String? value) async {
                        if (value == "Personalizar") {
                          _showCustomScale(context);
                        }
                      },
                      dropdownMenuEntries: UnmodifiableListView<MenuEntry>(
                        workScheduleProvider.workScheduleOPtions.map<MenuEntry>(
                            (String name) =>
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
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          workScheduleProvider.setBoardingDay(pickedDate);
                        }
                      },
                    ),
                    const SizedBox(
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
                              value: workScheduleProvider
                                  .workScheduleState.preBoardingMeeting,
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
                        bool result = !workScheduleProvider
                            .workScheduleState.preBoardingMeeting;

                        workScheduleProvider.setPreBoardingMeeting(result);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ButtonLoading(
                          onPressed: () async {
                            if (_formController.currentState!.validate()) {
                              try {
                                await workScheduleProvider.addWorkSchedule(
                                    workScheduleProvider.workScheduleState);
                                if (context.mounted) {
                                  snackSuccess(context,
                                      'Escala ataulizada com sucesso!');
                                  Navigator.of(context).pop();
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  snackError(context, 'Erro: ${e.toString()}');
                                }
                              }
                            }
                          },
                          isBusy: workScheduleProvider.isBusy),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
