import 'package:flutter/material.dart';
import 'package:marine/providers/app_provider.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Consumer<AppProvider>(builder: (context, appState, child) {
            return ListTile(
              title: Text(
                'Bem vindo, ${appState.state.userName}',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            );
          }),
          ListTile(
            title: const Text('Inicio'),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          ListTile(
            title: const Text('Agendamento'),
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/agendamento'),
          ),
          ListTile(
            title: const Text('Radar'),
            onTap: () => Navigator.pushReplacementNamed(context, '/radar'),
          ),
        ],
      ),
    );
  }
}
