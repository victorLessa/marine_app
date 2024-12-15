import 'package:flutter/material.dart';
import 'package:marine/widgets/custom_view.dart';
import '../widgets/custom_drawer.dart';

class AgendamentoScreen extends StatelessWidget {
  const AgendamentoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomView(
      appBar: AppBar(title: const Text('Agendamento')),
      drawer: const CustomDrawer(),
      body: const Center(child: Text('Página de Agendamentos')),
    );
  }
}
