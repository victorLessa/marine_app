import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';

class RadarScreen extends StatelessWidget {
  const RadarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Radar')),
      drawer: const CustomDrawer(),
      body: const Center(child: Text('Página do Radar')),
    );
  }
}
