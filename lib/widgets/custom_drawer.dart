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
            onTap: () => Navigator.pushNamed(context, '/'),
          ),
          ListTile(
            title: const Text('Escala'),
            onTap: () => Navigator.pushNamed(context, '/escala'),
          ),
          ListTile(
            title: const Text('Radar'),
            onTap: () => Navigator.pushNamed(context, '/radar'),
          ),
        ],
      ),
    );
  }
}
