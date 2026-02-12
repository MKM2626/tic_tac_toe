import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/view_model/game_view_model.dart';

class DifficultySelector extends StatelessWidget {
  const DifficultySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Difficulty",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // Makes container behind toggle button that is white, 
              // so background of unselected buttons are white
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
                ),
                child: ToggleButtons(
                  isSelected: [
                    viewModel.difficulty == "easy",
                    viewModel.difficulty == "medium",
                    viewModel.difficulty == "hard",
                  ],
                  onPressed: (index) {
                    // Setters
                    if (index == 0) viewModel.setDifficulty("easy");
                    else if (index == 1) viewModel.setDifficulty("medium");
                    else if (index == 2) viewModel.setDifficulty("hard");
                  },
                  borderRadius: BorderRadius.circular(10.0),
                  borderWidth: 2.0,
                  borderColor: Colors.grey[400]!,
                  selectedBorderColor: Colors.grey[400]!,
                  // Change fill in colour based on selected mode
                  fillColor: viewModel.difficulty == "easy"
                      ? Colors.green
                      : viewModel.difficulty == "medium"
                          ? Colors.orange
                          : Colors.red,
                  selectedColor: Colors.white,
                  color: Colors.black,
                  children: const [
                    // Button text display
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Easy", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Medium", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Hard", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
