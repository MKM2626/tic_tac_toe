import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/widgets/widgets.dart';
import 'package:tic_tac_toe/view/game_board_screen.dart';
import 'package:tic_tac_toe/view_model/game_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GameViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title of game / symbols behind it
            const TitleBanner(), 

            // Win/draw board
            Consumer<GameViewModel>(
              builder: (context, viewModel, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: ScoreDisplay(
                          title: 'Human',
                          score: viewModel.playerWins,
                          showBox: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ScoreDisplay(
                          title: 'Draws',
                          score: viewModel.draws,
                          showBox: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ScoreDisplay(
                          title: 'AI',
                          score: viewModel.aiWins,
                          showBox: true,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            SymbolSelector(),

            const SizedBox(height: 20),

            DifficultySelector(),

            const SizedBox(height: 40),

            StartButton(
              onPressed: () {
                viewModel.resetBoard(); // Reset board, needed if player chooses "O", as it makes AI go first before they enter
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Gameboard()),
                );
              },
            ),

            const SizedBox(height: 20),

            ResetWinsButton(onPressed: () async => await viewModel.clearWins()), // Reset win / draws

            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
