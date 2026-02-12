import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final double size; // Optional parameter, can change

  const BackButtonWidget({
    super.key,
    required this.onPressed,
    this.size = 36, // default size
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0), // Push button down a bit
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white, size: size), // Back arrow
        onPressed: onPressed,
      ),
    );
  }
}





