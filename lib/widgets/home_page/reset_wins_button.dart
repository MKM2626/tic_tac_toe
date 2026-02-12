import 'package:flutter/material.dart';

class ResetWinsButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  // Set text and on press functions
  const ResetWinsButton({super.key, required this.onPressed, this.text = "Reset Wins"});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade400,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
