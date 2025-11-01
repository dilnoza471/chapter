import 'package:flutter/material.dart';

class GlassyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GlassyButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      child: Text(
        text,
        style: TextStyle(color: colorScheme.onSecondary),
      ),
    );
  }
}
