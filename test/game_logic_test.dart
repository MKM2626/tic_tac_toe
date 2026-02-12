import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/model/game_logic_model.dart'; // adjust the import path

void main() {
  late GameLogic game;

  setUp(() {
    game = GameLogic();
  });

  group('Basic moves', () {
    // Player makes a valid move
    test('mM1', () {
      bool result = game.checkMove(0,0);
      game.makeMove(0, 0, 'X');
      expect(result, true);
      expect(game.board[0][0], 'X');
      expect(game.playerTurn, false);
    });

    // Player makes an invalid move
    test('mM2', () {
      game.makeMove(0, 0, 'X');
      bool result = game.checkMove(0, 0);
      game.makeMove(0, 0, 'O');
      expect(result, false);
      expect(game.board[0][0], 'X');
    });
  });

  group('Undo', () {
    // Undo requires at least 2 moves
    test('u1', () {
      game.makeMove(0, 0, 'X');
      game.undo();
      expect(game.board[0][0], 'X'); // still empty because only 1 move
    });

    // Undo removes last 2 moves
    test('u2', () {
      game.makeMove(0, 0, 'X');
      game.makeMove(0, 1, 'O');
      game.undo();
      expect(game.board[0][0], '');
      expect(game.board[0][1], '');
      expect(game.playerTurn, true);
    });
  });

  group('Winner detection', () {
    // Detect row winner
    test('cW1', () {
      game.board = [
        ['', '', ''],
        ['X', 'X', 'X'],
        ['', '', '']
      ];
      expect(game.checkWinner(), 'X');
    });

    // Detect column winner
    test('cW2', () {
      game.board = [
        ['', 'O', ''],
        ['', 'O', ''],
        ['', 'O', '']
      ];
      expect(game.checkWinner(), 'O');
    });

    // Detect diagonal winner, down to up
    test('cW3', () {
      game.board = [
        ['', '', 'X'],
        ['', 'X', ''],
        ['X', '', '']
      ];
      expect(game.checkWinner(), 'X');
    });

    // Detect diagonal winner, up to down
    test('cW4', () {
      game.board = [
        ['X', '', ''],
        ['', 'X', ''],
        ['', '', 'X']
      ];
      expect(game.checkWinner(), 'X');
    });

    // Detect draw
    test('cW5', () {
      game.board = [
        ['X','O','X'],
        ['X','O','O'],
        ['O','X','X']
      ];
      expect(game.checkWinner(), 'draw');
    });

    // Ongoing game returns null
    test('cW6', () {
      game.board = [
        ['X','O',''],
        ['','',''],
        ['','','']
      ];
      expect(game.checkWinner(), null);
    });
  });

  group('AI moves', () {
    // Easy AI makes a move
    test('mAM1', () {
      game.makeAIMove('easy', 'O', 'X');
      int filled = 0;
      // Made move somewhere on the board
      for (var row in game.board) {
        for (var cell in row) {
          if (cell != '') filled++;
        }
      }
      expect(filled, 1); 
    });

    // Hard AI wins row - twoInARow
    test('mAM2', () {
      game.board = [
        ['O', 'O', ''],
        ['X', '', ''],
        ['', '', '']
      ];
      game.makeAIMove('hard', 'O', 'X');
      expect(game.board[0][2], 'O'); // AI completes the row
    });

    // Hard AI blocks player row - twoInARow
    test('mAM3', () {
      game.board = [
        ['X', 'X', ''],
        ['O', '', ''],
        ['', '', '']
      ];
      game.makeAIMove('hard', 'O', 'X');
      expect(game.board[0][2], 'O'); // blocks player
    });

    // Hard AI wins column - twoInARow
    test('mAM4', () {
      game.board = [
        ['O', 'X', ''],
        ['O', 'X', ''],
        ['', '', '']
      ];
      game.makeAIMove('hard', 'O', 'X');
      expect(game.board[2][0], 'O'); // AI completes column
    });

    // Hard AI blocks column - twoInARow'
    test('mAM5', () {
      game.board = [
        ['O', 'X', ''],
        ['', 'X', ''],
        ['', '', '']
      ];
      game.makeAIMove('hard', 'O', 'X');
      expect(game.board[2][1], 'O'); // blocks player
    });
    
    // Hard AI wins diagonal descending - twoInARow
    test('mAM6', () {
      game.board = [
        ['O', '', ''],
        ['', 'O', ''],
        ['', '', '']
      ];
      game.makeAIMove('hard', 'O', 'X');
      expect(game.board[2][2], 'O'); // AI complete diagonal
    });

    // Hard AI blocks diagonal descending - twoInARow
    test('mAM7', () {
      game.board = [
        ['X', '', ''],
        ['', 'X', ''],
        ['', '', '']
      ];
      game.makeAIMove('hard', 'O', 'X');
      expect(game.board[2][2], 'O'); // blocks player
    });

    // Hard AI wins diagonal descending - twoInARow
    test('mAM8', () {
      game.board = [
        ['', '', 'X'],
        ['', 'X', ''],
        ['', '', '']
      ];
      game.makeAIMove('hard', 'O', 'X');
      expect(game.board[2][0], 'O'); // AI complete diagonal
    });

    // Hard AI blocks diagonal descending - twoInARow
    test('mAM9', () {
      game.board = [
        ['', '', 'O'],
        ['', 'O', ''],
        ['', '', '']
      ];
      game.makeAIMove('hard', 'O', 'X');
      expect(game.board[2][0], 'O'); // blocks player
    });

    // Hard AI play fork - findFork / countTwoInARow
    test('mAM10', () {
      game.board = [
        ['O', '', ''],
        ['', 'X', ''],
        ['', '', 'O']
      ];
      game.makeAIMove('hard', 'O', 'X');
      expect(game.board[0][2], 'O'); // plays fork
    });

    // Hard AI take middle
    test('mAM11', () {
      game.board = [
        ['', '', ''],
        ['', '', ''],
        ['', '', '']
      ];
      game.makeAIMove('hard', 'O', 'X');
      expect(game.board[1][1], 'O'); // takes middle 
    });

    // Hard AI play opposite corner - oppositeCorner
    test('mAM12', () {
      game.board = [
        ['X', '', ''],
        ['', 'O', ''],
        ['', '', '']
      ];
      game.makeAIMove('hard','O','X');
      expect(game.board[2][2], 'O'); // takes opposite corner
    });

    // Hard AI plays empty corner - emptyCorner
    test('mAM13', () {
      game.board = [
        ['X', 'O', 'X'],
        ['', 'O', ''],
        ['O', 'X', '']
      ];
      game.makeAIMove('hard', 'O', 'X');
      expect(game.board[2][2], 'O'); // plays empty corner
    });

    // Hard AI take empty side
    test('mAM14', () {
      game.board = [
        ['X', 'O', 'X'],
        ['', 'O', ''],
        ['O', 'X', 'O']
      ];
      game.makeAIMove('hard','O','X');
      expect(game.board[1][0], 'O'); // plays empty side
    });

    // Medium AI alternates between easy and hard moves
    test('mAM15', () {
      final game = GameLogic();

      // First move should be random
      game.makeAIMove('medium', 'O', 'X');
      int filled = 0;
      // plays randomly somewhere on the board
      for (var row in game.board) {
        for (var cell in row) {
          if (cell != '') filled++;
        }
      }
      expect(filled, 1);

      // Prepare board so a strategic move is obvious (block player)
      game.board = [
        ['X', 'X', ''],
        ['', 'O', ''],
        ['', '', '']
      ];

      // Second move should be strategic (block X at (0,2))
      game.makeAIMove('medium', 'O', 'X');
      expect(game.board[0][2], 'O');
    });
  });

  group('Reset', () {

    // Reset board clears board and history
    test('rB1', () {
      game.makeMove(0, 0, 'X');
      game.resetBoard('hard', 'X', 'O'); // symbols and such
      expect(game.board, [['','',''],['','',''],['','','']]);
      expect(game.history, []);
    });

    // Reset board with AI first
    test('rB2', () {
      game.makeMove(0, 0, 'X');
      game.resetBoard('hard', 'O', 'X'); // symbols and such
      expect(game.history.length, 1);
      int count = 0;
      // Count number of empty cells available
      for (List row in game.board) {
        for (String col in row) {
          if (col == '') count++;
        }
      }
      expect(count, 8); // If AI went first, only 8 empty cells remain
    });
  });

  group('Update score', () {
    // updates the score for all scores
    test('uS1', () {
      game.updateScore('X', 'X', 'O');
      expect(game.playerScore, 1);
      game.updateScore('O', 'X', 'O');
      expect(game.aiScore, 1);
      game.updateScore('draw', 'X', 'O');
      expect(game.drawScore, 1);
    });
  });
}