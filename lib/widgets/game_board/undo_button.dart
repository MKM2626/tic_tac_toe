import 'package:flutter/material.dart';

class UndoButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;

  const UndoButton({super.key, required this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, left: 24), // Position
      child: Align(
        alignment: Alignment.bottomLeft, // Alignment
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: color,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
          ),
          onPressed: onPressed,
          child: const Icon(Icons.undo, size: 30), // Size
        ),
      ),
    );
  }
}