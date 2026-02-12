import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/view/home_page_screen.dart';
import 'package:tic_tac_toe/view_model/game_view_model.dart';

void main() {
  return runApp(
    ChangeNotifierProvider(
      create: (_) => GameViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

