import 'package:flutter/material.dart';

class WinDialog extends StatelessWidget {
  final String winner;
  final Color buttonColor;
  final VoidCallback onPlayAgain;

  const WinDialog({
    super.key,
    required this.winner,
    required this.buttonColor,
    required this.onPlayAgain,
  });

  // Basically the pop up window content
  @override
  Widget build(BuildContext context) {
    String announcement = winner == 'draw' ? "It's a Draw!" : '"$winner" is the winner!';

    return AlertDialog(
      title: Text(announcement),
      actions: [
        TextButton(
          style: TextButton.styleFrom(foregroundColor: buttonColor),
          onPressed: onPlayAgain,
          child: const Text("Play Again"),
        ),
      ],
    );
  }
}
