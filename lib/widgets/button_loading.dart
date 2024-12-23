import 'package:flutter/material.dart';

class ButtonLoading extends StatelessWidget {
  final bool isBusy;
  final Function()? onPressed;
  final Widget? child;

  const ButtonLoading(
      {super.key, this.child, required this.onPressed, required this.isBusy});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(backgroundColor: Colors.blue),
      onPressed: onPressed,
      child: isBusy
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ))
          : child ?? const Text('Salvar'),
    );
  }
}
