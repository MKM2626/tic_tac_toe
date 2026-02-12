import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/view_model/game_view_model.dart';

class SymbolSelector extends StatelessWidget {
  const SymbolSelector({super.key});

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
                "Select Symbol",
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
                    viewModel.playerSymbol == "X",
                    viewModel.playerSymbol == "O",
                  ],
                  onPressed: (index) {
                    // Setters
                    if (index == 0) viewModel.setPlayerSymbol("X");
                    else if (index == 1) viewModel.setPlayerSymbol("O");
                  },
                  borderRadius: BorderRadius.circular(8.0),
                  borderWidth: 2.0,
                  borderColor: Colors.grey[400]!,
                  selectedBorderColor: Colors.grey[400]!,
                  fillColor: viewModel.playerSymbol == "X" ? Colors.blue.shade400 : Colors.red.shade400,
                  selectedColor: Colors.white,
                  color: Colors.black,
                  children: const [
                    // Button text display
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("X", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("O", style: TextStyle(fontWeight: FontWeight.bold)),
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
