import 'package:flutter/material.dart';

class TitleBanner extends StatelessWidget {
  const TitleBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack( // Makes it all on top of each other
      alignment: Alignment.center,
      children: [
        Row( // X and O side be side
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20), // Move it down a bit
              child: Transform.rotate(
                angle: -0.3, // Tilt it to the left
                child: Text(
                  'X',
                  style: TextStyle(
                    fontSize: 200,
                    color: Colors.blue.withAlpha((0.2 * 255).round()), // Colour
                    fontWeight: FontWeight.bold, 
                    shadows: const [Shadow(color: Colors.black12, blurRadius: 4)], // Symbol gets blured and a shadow
                  ),
                ),
              ),
            ),
            const SizedBox(width: 80),
            Padding(
              padding: const EdgeInsets.only(top: 20), // Move it down a bit
              child: Transform.rotate(
                angle: 0.3, // Tilt it to the right
                child: Text(
                  'O',
                  style: TextStyle(
                    fontSize: 200,
                    color: Colors.red.withAlpha((0.2 * 255).round()),
                    fontWeight: FontWeight.bold,
                    shadows: const [Shadow(color: Colors.black12, blurRadius: 4)], // Symbol gets blured and a shadow
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned( // Put underline underneath the tic tac toe title
          top: 250, // Moves it down
          child: Container(
            width: 320,
            padding: const EdgeInsets.only(bottom: 5.0),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color.fromARGB(239, 73, 81, 143),
                  width: 3,
                ),
              ),
            ),
          ),
        ),
        const Positioned( // Title
          top: 170,
          child: Text(
            "Tic Tac Toe",
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(239, 73, 81, 143),
              shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
            ),
          ),
        ),
      ],
    );
  }
}
