import 'package:flutter/material.dart';

class Legend extends StatelessWidget {
  final String title;
  final Color color;

  const Legend({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Center(
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color, // Cor de fundo (opcional)
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}
