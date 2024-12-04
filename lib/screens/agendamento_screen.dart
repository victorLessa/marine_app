import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';

class AgendamentoScreen extends StatelessWidget {
  const AgendamentoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agendamento')),
      drawer: const CustomDrawer(),
      body: const Center(child: Text('Página de Agendamentos')),
    );
  }
}
