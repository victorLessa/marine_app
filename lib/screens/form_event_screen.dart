import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marine/models/event_state.dart';
import 'package:marine/providers/calendar_provider.dart';
import 'package:marine/providers/event_provider.dart';
import 'package:marine/widgets/button_loading.dart';
import 'package:marine/widgets/custom_view.dart';
import 'package:marine/widgets/timer_picker.dart';
import 'package:marine/widgets/utils_app.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class FormEvent extends StatefulWidget {
  final int? eventId;

  const FormEvent({super.key, this.eventId});

  @override
  State<FormEvent> createState() => _FormEventState();
}

class _FormEventState extends State<FormEvent> {
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      DateTime focusDay =
          Provider.of<CalendarProvider>(context, listen: false).focusedDay;
      eventProvider.setStartDay(focusDay);
      eventProvider.setEndDay(focusDay);
    });
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
                    Navigator.of(context).pop();
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
      EventState formEventState) async {
    if (eventState.formEventIsBusy) return;

    if (_formKey.currentState!.validate()) {
      try {
        if (widget.eventId != null) {
          await eventState.editEvent(widget.eventId as int, formEventState);
        } else {
          await eventState.addEvent(formEventState);
        }
        if (context.mounted) {
          snackSuccess(context, 'Evento salvo com sucesso');
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          snackError(context, e.toString());
        }
      }
    }
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
              onPressed: () {
                Provider.of<EventProvider>(context, listen: false)
                    .cleanFormEvent();
                Navigator.of(context).pop();
              }),
        ),
      ),
      body: Consumer<EventProvider>(
        builder: (BuildContext context, eventProvider, child) {
          EventState formEventState = eventProvider.formEventState;
          return widget.eventId != null
              ? FutureBuilder(
                  future: eventProvider.findEventById(widget.eventId!),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Erro: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(
                        child: Text('Evento não encontrado'),
                      );
                    } else {
                      eventProvider.setFormEventState(snapshot.data!);
                      EventState formEventState = eventProvider.formEventState;
                      return form(eventProvider, formEventState);
                    }
                  })
              : form(eventProvider, formEventState);
        },
      ),
    );
  }

  Widget form(EventProvider eventProvider, EventState state) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            // Campo de texto 1
            TextFormField(
              controller: state.title,
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
                  value: state.allDay,
                  onChanged: (bool value) {
                    eventProvider.setAllDay(value);
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
                  padding: const EdgeInsets.only(left: 45, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: Text(
                          DateFormat('EEE, dd MMM yyyy', 'pt_BR')
                              .format(state.startDay),
                        ),
                        onTap: () async {
                          DateTime? dateTime = await showDatePicker(
                            context: context,
                            initialDate: state.startDay,
                            firstDate: DateTime(1900),
                            lastDate: state.endDay,
                            locale: const Locale('pt', 'BR'),
                          );

                          if (dateTime!.isAfter(state.endDay)) {
                            eventProvider.setEndDay(dateTime);
                          }
                          eventProvider.setStartDay(dateTime);
                        },
                      ),
                      Visibility(
                        visible: !state.allDay,
                        child: InkWell(
                          child: Text(state.startHour.format(context)),
                          onTap: () async {
                            TimeOfDay? time = await dialogTimePicker(context,
                                initialEntryMode: entryMode);

                            eventProvider.setStartHour(time);
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: Text(
                          DateFormat('EEE, dd MMM yyyy', 'pt_BR')
                              .format(state.endDay),
                        ),
                        onTap: () async {
                          DateTime? dateTime = await showDatePicker(
                            context: context,
                            initialDate: state.endDay,
                            firstDate: state.startDay,
                            lastDate: DateTime(2099),
                            locale: const Locale('pt', 'BR'),
                          );

                          eventProvider.setEndDay(dateTime);
                        },
                      ),
                      Visibility(
                        visible: !state.allDay,
                        child: InkWell(
                          child: Text(state.endHour.format(context)),
                          onTap: () async {
                            TimeOfDay? time = await dialogTimePicker(context,
                                initialEntryMode: entryMode);

                            eventProvider.setEndHour(time);
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
              controller: state.description,
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
                  onTap: () => _selectColor(context, eventProvider),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: state.color,
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
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                ),
                onPressed: () async {
                  await submitEvent(context, eventProvider, state);
                },
                isBusy: eventProvider.formEventIsBusy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
