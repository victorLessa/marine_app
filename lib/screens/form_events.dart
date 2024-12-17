import 'package:flutter/material.dart';
import 'package:marine/models/form_event_state.dart';
import 'package:marine/providers/calendar_event_provider.dart';
import 'package:provider/provider.dart';

class ModalBottom extends StatefulWidget {
  const ModalBottom({super.key});

  @override
  State<ModalBottom> createState() => _ModalBottomState();
}

class _ModalBottomState extends State<ModalBottom> {
  bool allDay = false;
  late TimeOfDay? selectedTime;
  Orientation? orientation;
  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;

  // GlobalKey para o formulário
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .9,
      expand: false,
      maxChildSize: .9, // Define o tamanho máximo do modal
      builder: (context, scrollController) {
        return Consumer<CalendarEventProvider>(
            builder: (BuildContext context, calendarProvider, child) {
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
                    child: Column(
                      children: [
                        // Campo de texto 1
                        TextFormField(
                          controller: calendarProvider.formEventState.title,
                          decoration: const InputDecoration(
                            labelText: 'Título',
                            border: OutlineInputBorder(),
                          ),
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
                              value: allDay,
                              onChanged: (bool value) {
                                setState(() {
                                  allDay = value;
                                });
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.only(left: 45, right: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Inicio",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              InkWell(
                                child: Text(
                                    '${selectedTime?.hour.toString().padLeft(2, '0')}:${selectedTime?.minute.toString().padLeft(2, '0')}'),
                                onTap: () async {
                                  final TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        selectedTime ?? TimeOfDay.now(),
                                    initialEntryMode: entryMode,
                                    orientation: orientation,
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          materialTapTargetSize: tapTargetSize,
                                        ),
                                        child: Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: MediaQuery(
                                            data:
                                                MediaQuery.of(context).copyWith(
                                              alwaysUse24HourFormat: true,
                                            ),
                                            child: child!,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  if (time != null) {
                                    setState(() {
                                      selectedTime = time;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 45,
                            right: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Fim",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              InkWell(
                                child: Text(
                                    '${selectedTime?.hour.toString().padLeft(2, '0')}:${selectedTime?.minute.toString().padLeft(2, '0')}'),
                                onTap: () async {
                                  final TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        selectedTime ?? TimeOfDay.now(),
                                    initialEntryMode: entryMode,
                                    orientation: orientation,
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          materialTapTargetSize: tapTargetSize,
                                        ),
                                        child: Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: MediaQuery(
                                            data:
                                                MediaQuery.of(context).copyWith(
                                              alwaysUse24HourFormat: true,
                                            ),
                                            child: child!,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  if (time != null) {
                                    setState(() {
                                      selectedTime = time;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        // Campo de texto 2
                        const SizedBox(height: 30),
                        TextFormField(
                          controller:
                              calendarProvider.formEventState.description,
                          decoration: const InputDecoration(
                            labelText: 'Descrição',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Botão de envio
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Ação do botão
                              Navigator.pop(context); // Fecha o modal
                            },
                            child: const Text('Salvar'),
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

void showCustomModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Permite que o modal ocupe o espaço necessário
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (BuildContext context) {
      return const ModalBottom();
    },
  );
}
