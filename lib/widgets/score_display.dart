import 'package:flutter/material.dart';

class ScoreDisplay extends StatelessWidget {
  final String title;
  final int score;
  final Color textColor;
  final double fontSize;
  final bool showBox;
  final Color boxColor;
  final double borderRadius;

  const ScoreDisplay({
    super.key,
    required this.title,
    required this.score,
    this.textColor = Colors.white,
    this.fontSize = 20,
    this.showBox = false,
    this.boxColor = const Color.fromARGB(255, 186, 194, 255),
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        Text(
          score.toString(),
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
          ),
        ),
      ],
    );

    if (showBox) { // Gives it the box for the home page
      content = Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.2 * 255).round()),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: content,
      );
    }

    return Expanded(child: content);
  }
}
