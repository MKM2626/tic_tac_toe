import 'package:flutter/material.dart';

class BoardCell extends StatelessWidget {
  final String value;
  final VoidCallback onTap;
  final Border border;
  final Color backgroundColor;

  const BoardCell({
    super.key,
    required this.value,
    required this.onTap,
    required this.border,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
        ),
        child: Center(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 35,
            ),
          ),
        ),
      ),
    );
  }
}
