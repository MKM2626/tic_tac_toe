import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/view_model/game_view_model.dart';

void main() {
  late GameViewModel viewModel;

  setUp(() {
    viewModel = GameViewModel();
  });

  group('Update score', () {
    // Update score for player win
    test('uS2', () async {
      await viewModel.updateScore("X");
      expect(viewModel.playerScore, 1);
      expect(viewModel.playerWins, 1);
      expect(viewModel.aiScore, 0);
      expect(viewModel.aiWins, 0);
      expect(viewModel.drawScore, 0);
      expect(viewModel.draws, 0);
    });

    // Update score for AI win
    test('uS3', () async {
      await viewModel.updateScore("O");
      expect(viewModel.aiScore, 1);
      expect(viewModel.aiWins, 1);
      expect(viewModel.playerScore, 0);
      expect(viewModel.playerWins, 0);
      expect(viewModel.drawScore, 0);
      expect(viewModel.draws, 0);
    });

    // Update score for draw
    test('uS3', () async {
      await viewModel.updateScore('draw');
      expect(viewModel.drawScore, 1);
      expect(viewModel.draws, 1);
      expect(viewModel.playerScore, 0);
      expect(viewModel.aiScore, 0);
    });
  });

  group('setters', () {
    // Changing player symbol updates AI symbol
    test('sPS1', () {
      viewModel.setPlayerSymbol('O');
      expect(viewModel.playerSymbol, 'O');
      expect(viewModel.aiSymbol, 'X');

      viewModel.setPlayerSymbol('X');
      expect(viewModel.playerSymbol, 'X');
      expect(viewModel.aiSymbol, 'O');
    });

    // Changing difficulty updates value
    test('sD1', () {
      viewModel.setDifficulty('easy');
      expect(viewModel.difficulty, 'easy');

      viewModel.setDifficulty('medium');
      expect(viewModel.difficulty, 'medium');

      viewModel.setDifficulty('hard');
      expect(viewModel.difficulty, 'hard');
    });
  });

  group('clear board / game', () {
    // Clear game resets scores and board
    test('cG1', () {
      viewModel.updateScore("x");
      viewModel.updateScore("O");
      viewModel.updateScore("draw");
      viewModel.makeMove(0, 0, 'X');

      viewModel.clearGame();

      expect(viewModel.playerScore, 0);
      expect(viewModel.aiScore, 0);
      expect(viewModel.drawScore, 0);
      expect(viewModel.board, [['','',''],['','',''],['','','']]);
    });

    // clearWins clears wins and draws
    test('cW1', () async {
      // Score update
      await viewModel.updateScore("X");
      await viewModel.updateScore("O");
      await viewModel.updateScore("draw");

      // Updated correctly
      expect(viewModel.playerWins, 1);
      expect(viewModel.aiWins, 1);
      expect(viewModel.draws, 1);

      // Clear wins
      await viewModel.clearWins();

      // Clears wins and draws
      expect(viewModel.playerWins, 0);
      expect(viewModel.aiWins, 0);
      expect(viewModel.draws, 0);
    });
  });
}