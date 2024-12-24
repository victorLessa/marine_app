import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marine/models/form_event_state.dart';
import 'package:marine/providers/calendar_provider.dart';
import 'package:marine/providers/event_provider.dart';
import 'package:marine/widgets/button_loading.dart';
import 'package:marine/widgets/timer_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ModalBottomCreateEvent extends StatefulWidget {
  final bool isEdit;
  final int? eventId;

  const ModalBottomCreateEvent({super.key, this.isEdit = false, this.eventId});

  @override
  State<ModalBottomCreateEvent> createState() => _ModalBottomCreateEventState();
}

class _ModalBottomCreateEventState extends State<ModalBottomCreateEvent> {
  bool allDay = false;
  late TimeOfDay? selectedTime;
  Orientation? orientation;
  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;

  // GlobalKey para o formulário
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    selectedTime = TimeOfDay.now();
  }

  void _selectColor(BuildContext context, EventProvider eventProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecione uma cor'),
          content: SingleChildScrollView(
            child: Column(children: [
              ColorPicker(
                pickerColor: eventProvider.formEventState.color,
                onColorChanged: (Color color) {
                  eventProvider.setColor(color);
                },
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Selecionar'),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }

  Future<void> submitEvent(BuildContext context, EventProvider eventState,
      FormEventState formEventState) async {
    if (eventState.formEventIsBusy) return;

    if (_formKey.currentState!.validate()) {
      eventState.formIsBusy(true);
      if (widget.isEdit && widget.eventId != null) {
        await eventState.editEvent(widget.eventId as int, formEventState);
      } else {
        await eventState.addEvent(formEventState);
      }
      eventState.formIsBusy(false);
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .9,
      expand: false,
      maxChildSize: .9, // Define o tamanho máximo do modal
      builder: (context, scrollController) {
        return Consumer<EventProvider>(
            builder: (BuildContext context, eventState, child) {
          FormEventState formEventState = eventState.formEventState;
          CalendarProvider calendarProvider =
              Provider.of<CalendarProvider>(context);
          return SingleChildScrollView(
            controller: scrollController, // Permite rolar o conteúdo
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                  child: Center(
                    child: Container(
                      transformAlignment: Alignment.center,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(139, 158, 158, 158),
                      ),
                      width: 50,
                    ),
                  ),
                ),
                // Título e botão de voltar
                const Padding(
                  padding: EdgeInsets.only(
                      left: 5.0, right: 5.0, top: 10, bottom: 20.0),
                  child: Center(
                    child: Text(
                      'Evento',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Formulário
                Padding(
                  padding: EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Campo de texto 1
                        TextFormField(
                          controller: formEventState.title,
                          decoration: const InputDecoration(
                            labelText: 'Título',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira um título';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.watch_later_outlined,
                                  size: 36,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Dia inteiro?",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            Switch(
                              activeColor: Colors.blueAccent,
                              value: formEventState.allDay,
                              onChanged: (bool value) {
                                eventState.setAllDay(value);
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        // Hora de inicio
                        Column(
                          children: [
                            // Hora de início
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 45, right: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    child: Text(
                                      DateFormat('EEE, dd MMM yyyy', 'pt_BR')
                                          .format(formEventState.startDay),
                                    ),
                                    onTap: () async {
                                      DateTime? dateTime = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            calendarProvider.selectedDay,
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2099),
                                        locale: const Locale('pt', 'BR'),
                                      );

                                      eventState.setStartDay(dateTime);
                                    },
                                  ),
                                  Visibility(
                                    visible: !formEventState.allDay,
                                    child: InkWell(
                                      child: Text(formEventState.startHour
                                          .format(context)),
                                      onTap: () async {
                                        TimeOfDay? time =
                                            await dialogTimePicker(context,
                                                initialEntryMode: entryMode);

                                        eventState.setStartHour(time);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),
                            // Hora de fim
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 45,
                                right: 12,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    child: Text(
                                      DateFormat('EEE, dd MMM yyyy', 'pt_BR')
                                          .format(formEventState.endDay),
                                    ),
                                    onTap: () async {
                                      DateTime? dateTime = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            calendarProvider.selectedDay,
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2099),
                                        locale: const Locale('pt', 'BR'),
                                      );

                                      eventState.setEndDay(dateTime);
                                    },
                                  ),
                                  Visibility(
                                    visible: !formEventState.allDay,
                                    child: InkWell(
                                      child: Text(formEventState.endHour
                                          .format(context)),
                                      onTap: () async {
                                        TimeOfDay? time =
                                            await dialogTimePicker(context,
                                                initialEntryMode: entryMode);

                                        eventState.setEndHour(time);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                        // Campo de texto 2
                        TextFormField(
                          controller: formEventState.description,
                          decoration: const InputDecoration(
                            labelText: 'Descrição',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira uma descrição';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Cor do Evento:'),
                            GestureDetector(
                              onTap: () => _selectColor(context, eventState),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: formEventState.color,
                                ),
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Botão de envio
                        SizedBox(
                          width: double.infinity,
                          child: ButtonLoading(
                            onPressed: () async {
                              await submitEvent(
                                  context, eventState, formEventState);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Evento excluído com sucesso')),
                                );
                              }
                            },
                            isBusy: eventState.formEventIsBusy,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }
}
