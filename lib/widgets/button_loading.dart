import 'package:flutter/material.dart';

class ButtonLoading extends StatelessWidget {
  final bool isBusy;
  final Function()? onPressed;
  final Widget? child;
  final ButtonStyle? style;
  final Color? progressIndicatorColor;

  const ButtonLoading(
      {super.key,
      this.child,
      this.progressIndicatorColor,
      this.onPressed,
      this.style,
      this.isBusy = false});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: style,
      onPressed: onPressed,
      child: isBusy
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                    progressIndicatorColor ?? Colors.white),
              ))
          : child ?? const Text('Salvar'),
    );
  }
}
