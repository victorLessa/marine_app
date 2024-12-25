import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marine/models/event_state.dart';
import 'package:marine/providers/event_provider.dart';
import 'package:marine/screens/form_event.dart';
import 'package:provider/provider.dart';

enum EventAction { update, delete }

class ViewEvent extends StatefulWidget {
  final int eventId;
  const ViewEvent({super.key, required this.eventId});

  @override
  State<ViewEvent> createState() => _ViewEventState();
}

class _ViewEventState extends State<ViewEvent> {
  @override
  void initState() {
    super.initState();
  }

  Future<EventState> _loadEvent(BuildContext context) async {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    EventState result = await eventProvider.findEventById(widget.eventId);

    eventProvider.setTitle(result.title);
    eventProvider.setAllDay(result.allDay);
    eventProvider.setColor(result.color);
    eventProvider.setEndDay(result.endDay);
    eventProvider.setEndHour(result.endHour);
    eventProvider.setStartDay(result.startDay);
    eventProvider.setStartHour(result.startHour);
    eventProvider.setDescription(result.description);
    return result;
  }

  popupMenuButtonAction(EventAction action) async {
    switch (action) {
      case EventAction.update:
        Navigator.of(context).pop();
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          builder: (BuildContext context) {
            return ModalBottomFormEvent(
              isEdit: true,
              eventId: widget.eventId,
            );
          },
        );

        break;
      case EventAction.delete:
        final eventProvider =
            Provider.of<EventProvider>(context, listen: false);
        await eventProvider.removeEvent(widget.eventId);
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Evento excluído com sucesso')),
          );
        }
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .9,
      expand: false,
      maxChildSize: .9, // Define o tamanho máximo do modal
      builder: (context, scrollController) {
        return FutureBuilder<EventState>(
          future: _loadEvent(context),
          builder: (BuildContext context, AsyncSnapshot<EventState> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
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
              final formEventState =
                  Provider.of<EventProvider>(context, listen: false)
                      .formEventState;

              return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
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
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 50,
                          ),
                          const Center(
                            child: Text(
                              'Evento',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: PopupMenuButton(
                              onSelected: (EventAction item) {
                                popupMenuButtonAction(item);
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<EventAction>>[
                                const PopupMenuItem<EventAction>(
                                  value: EventAction.update,
                                  child: Text('Editar'),
                                ),
                                const PopupMenuItem<EventAction>(
                                  value: EventAction.delete,
                                  child: Text('Excluir'),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Form(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: formEventState.title,
                              readOnly: true,
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                                Switch(
                                  activeColor: Colors.blueAccent,
                                  value: formEventState.allDay,
                                  onChanged: (value) {},
                                )
                              ],
                            ),
                            const SizedBox(height: 15),
                            // Hora de inicio
                            Column(
                              children: [
                                // Hora de início
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 45, right: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat('EEE, dd MMM yyyy', 'pt_BR')
                                            .format(formEventState.startDay),
                                      ),
                                      Visibility(
                                        visible: !formEventState.allDay,
                                        child: Text(
                                          formEventState.startHour
                                              .format(context),
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
                                      Text(
                                        DateFormat('EEE, dd MMM yyyy', 'pt_BR')
                                            .format(formEventState.endDay),
                                      ),
                                      Visibility(
                                        visible: !formEventState.allDay,
                                        child: Text(formEventState.endHour
                                            .format(context)),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 30),
                              ],
                            ),
                            TextFormField(
                              controller: formEventState.description,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: 'Descrição',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Cor do Evento:'),
                                GestureDetector(
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
