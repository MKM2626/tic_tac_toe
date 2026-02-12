import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/widgets/Widgets.dart';
import 'package:tic_tac_toe/view_model/game_view_model.dart';

class Gameboard extends StatefulWidget {
  const Gameboard({super.key});

  @override
  State<Gameboard> createState() => _GameboardState();
}

class _GameboardState extends State<Gameboard> {
  Future<void> _handleTap(BuildContext context, int row, int col) async {
    final viewModel = context.read<GameViewModel>();
    // If not player turn or cell on board is not empty ignore move
    if (!viewModel.playerTurn) return;
    if (!viewModel.checkMove(row, col)) return;

    viewModel.makeMove(row, col, viewModel.playerSymbol);

    // Check if player won
    String? winner = viewModel.checkWinner();
    if (winner != null) {
      _showWinDialog(context, winner);
      return;
    }

    await Future.delayed(const Duration(milliseconds: 500));

    viewModel.makeAIMove();

    // Check if AI won
    winner = viewModel.checkWinner();
    if (winner != null) {
      // ignore: use_build_context_synchronously
      _showWinDialog(context, winner);
    }
  }

  // Pop up window for user win / loss / draw
  void _showWinDialog(BuildContext context, String winner) {
    final viewModel = context.read<GameViewModel>();
    viewModel.updateScore(winner);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => WinDialog(
        winner: winner,
        buttonColor: viewModel.currentTurnColor,
        onPlayAgain: () {
          viewModel.resetBoard();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        // Back button, displayed in app bar
        return Scaffold(
          backgroundColor: viewModel.currentTurnColor,
          appBar: AppBar(
            backgroundColor: viewModel.currentTurnColor,
            elevation: 0,
            leading: BackButtonWidget(
              onPressed: () {
                viewModel.clearGame();
                Navigator.of(context).pop();
              },
            ),
          ),
          // Rest of the app below app bar
          body: Container(
            color: viewModel.currentTurnColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                // Score board
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ScoreDisplay(
                        title: "Player ${viewModel.playerSymbol}",
                        score: viewModel.playerScore,
                        showBox: false,
                        fontSize: 20,
                      ),
                      ScoreDisplay(
                        title: "Draws",
                        score: viewModel.drawScore,
                        showBox: false,
                        fontSize: 20,
                      ),
                      ScoreDisplay(
                        title: "Player ${viewModel.aiSymbol}",
                        score: viewModel.aiScore,
                        showBox: false,
                        fontSize: 20,
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 1),

                // Board grid
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: BoardGrid(
                      board: viewModel.board,
                      onTap: (row, col) => _handleTap(context, row, col),
                      cellColor: viewModel.currentTurnColor,
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                // Undo button
                UndoButton(
                  color: viewModel.currentTurnColor,
                  onPressed: () => viewModel.undo(),
                ),

                const Spacer(flex: 1),
              ],
            ),
          ),
        );
      },
    );

  }
}
