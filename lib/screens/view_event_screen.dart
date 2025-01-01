import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marine/models/event_state.dart';
import 'package:marine/providers/event_provider.dart';
import 'package:marine/screens/form_event_screen.dart';
import 'package:marine/widgets/custom_view.dart';
import 'package:marine/widgets/utils_app.dart';
import 'package:provider/provider.dart';

enum EventAction { delete }

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

    return result;
  }

  void popupMenuButtonAction(EventAction action) async {
    switch (action) {
      case EventAction.delete:
        final eventProvider =
            Provider.of<EventProvider>(context, listen: false);
        await eventProvider.removeEvent(widget.eventId);
        if (mounted) {
          Navigator.of(context).pop();
          snackSuccess(context, 'Evento excluído com sucesso');
        }
        break;
      default:
    }
  }

  void updateEvent(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormEvent(eventId: widget.eventId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      appBar: AppBar(
        centerTitle: true,
        title:
            const Text('Evento', style: TextStyle(fontWeight: FontWeight.w500)),
        actions: [
          InkWell(
            child: const Icon(Icons.edit),
            onTap: () {
              updateEvent(context);
            },
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
                  value: EventAction.delete,
                  child: Text('Excluir'),
                ),
              ],
            ),
          )
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: FutureBuilder<EventState>(
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
            EventState event = snapshot.data!;
            return SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: event.color),
                        ),
                        Container(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title.text,
                              style: const TextStyle(
                                fontSize: 20,
                                height: 1,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              DateFormat('EEEE, d MMM', 'pt_BR')
                                  .format(event.startDay),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                                'até ${DateFormat('EEEE, d MMM', 'pt_BR').format(event.endDay)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500))
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.notifications_none_outlined,
                          size: 20,
                        ),
                        Container(
                          width: 20,
                        ),
                        event.allDay
                            ? const Text('Dia inteiro',
                                style: TextStyle(fontWeight: FontWeight.w500))
                            : Text(
                                "${event.startHour.format(context)} - ${event.endHour.format(context)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.description_outlined,
                          size: 20,
                        ),
                        Container(
                          width: 20,
                        ),
                        Text(event.description.text,
                            style: const TextStyle(fontWeight: FontWeight.w500))
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
