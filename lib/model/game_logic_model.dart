import "dart:math";

class GameLogic {
  // 3x3 board represented as a list
  List<List<String>> board = [['','', ''],['','', ''],['','', '']];
  List<List<List<String>>> history = [];

  bool playerTurn = true;
  bool playerStartRound = true;
  int _mediumTurnCounter = 0;
  final Random _rand = Random();

  int aiScore = 0;
  int playerScore = 0;
  int drawScore = 0;

  bool checkMove(int row, int col) {
    if (board[row][col] != '') {
      return false;
    } else {
      return true;
    }
  }

  // Handle a move at [row][col]
  void makeMove(int row, int col, String symbol) {
    if (checkMove(row, col)) {
      board[row][col] = symbol;
      playerTurn = !playerTurn;
      history.add(_copyBoard());
    }
  }
  
  List<List<String>> _copyBoard() {
    return board.map((row) => List<String>.from(row)).toList();
  }

  void undo() {
    // Require at least 2 moves (player + AI) to undo
    if (history.length < 2) return;

    // Remove the last two moves
    history.removeLast();
    history.removeLast();

    // Restore board from last history entry
    if (history.isNotEmpty) {
      board = history.last.map((row) => List<String>.from(row)).toList();
    } else {
      board = [['', '', ''], ['', '', ''], ['', '', '']];
    }
    playerTurn = true; 
  }
  
  // Check if there’s a winner or draw
  String? checkWinner() {
    // Rows
    for (int r = 0; r < 3; r++) {
      if (board[r][0] != '' &&
          board[r][0] == board[r][1] &&
          board[r][1] == board[r][2]) {
        return board[r][0];
      }
    }

    // Columns
    for (int c = 0; c < 3; c++) {
      if (board[0][c] != '' &&
          board[0][c] == board[1][c] &&
          board[1][c] == board[2][c]) {
        return board[0][c];
      }
    }

    // Diagonals
    if (board[0][0] != '' &&
        board[0][0] == board[1][1] &&
        board[1][1] == board[2][2]) {
      return board[0][0];
    }
    if (board[0][2] != '' &&
        board[0][2] == board[1][1] &&
        board[1][1] == board[2][0]) {
      return board[0][2];
    }

    // Draw
    int count = 0;
    for (var row in board) {
      for (var cell in row) {
        if (cell != '') {
          count++;
        }
      }
    }
    if (count == 9) return "draw";

    return null; // game ongoing
  }

  // Reset board
  void resetBoard(String difficulty, String playerSymbol, String aiSymbol) {
    board = [['','', ''],['','', ''],['','', '']];
    history.clear();
    _mediumTurnCounter = 0;

    // If player chose "O", AI starts first
    if (playerSymbol == "O") {
      makeAIMove(difficulty, aiSymbol, playerSymbol); // ensure it's player's turn after AI move
    }
    playerTurn = true;
  }

  void updateScore(String winner, String playerSymbol, String aiSymbol) {
    if (winner == playerSymbol) {
      playerScore++;
    } else if (winner == aiSymbol) {
      aiScore++;
    } else if (winner == "draw") {
      drawScore++;
    }
  }

  // Makes an AI move based on difficulty: 'easy', 'medium', 'hard'
  void makeAIMove(String difficulty, String aiSymbol, String playerSymbol) {
    List<int>? move;
    switch (difficulty) {
      case 'easy':
        move = _randomMove();
        break;
      case 'medium':
        if (_mediumTurnCounter % 2 == 0) {
          move = _randomMove();
        } else {
          move = _hardMove(aiSymbol, playerSymbol);
        }
        _mediumTurnCounter++;
        break;
      case 'hard':
        move = _hardMove(aiSymbol, playerSymbol);
        break;
    }

    if (move != null) {
      makeMove(move[0], move[1], aiSymbol);
    }
  }

  List<int>? _hardMove(String aiSymbol, String playerSymbol) {
    // 1. Try to win if possible
    List<int>? move = _findTwoInARow(aiSymbol);
    if (move != null) return move;

    // 2. Block opponent if they can win
    move = _findTwoInARow(playerSymbol);
    if (move != null) return move;

    // 3. Create a fork if possible
    move = _findFork(aiSymbol);
    if (move != null) return move;

    // 4. Take the center if it’s free
    if (board[1][1] == '') return [1, 1];

    // 5. Play opposite corner if opponent is in a corner
    move = _oppositeCorner(playerSymbol);
    if (move != null) return move;

    // 6. Take any empty corner
    move = _emptyCorner();
    if (move != null) return move;

    // 7. Take any empty side
    move = _emptySide();
    if (move != null) return move;

    // 8. No move found (should not happen unless board is full)
    return null;
  }

  List<int>? _randomMove() {
    final empty = _emptyCells();
    if (empty.isEmpty) return null;
    return empty[_rand.nextInt(empty.length)];
  }

  List<List<int>> _emptyCells() {
    // Create a list to store empty cell coordinates
    List<List<int>> empty = [];

    // Go through each row
    for (int row = 0; row < 3; row++) {
      // Go through each column in the row
      for (int col = 0; col < 3; col++) {
        // Check if the cell is empty
        if (board[row][col] == '') {
          // Add the row and column as a pair to the empty list
          empty.add([row, col]);
        }
      }
    }
    // Return all empty cell coordinates
    return empty;
  }

  // Finds a move that would complete a two in a row
  List<int>? _findTwoInARow(String symbol) {
    // Rows
    for (int r = 0; r < 3; r++) {
      int count = 0;      // Number of symbols that occurred in this row
      int emptyC = -1;    // Column index of the empty cell in this row
      for (int c = 0; c < 3; c++) {
        if (board[r][c] == symbol) count++;
        if (board[r][c] == '') emptyC = c;
      }
      if (count == 2 && emptyC != -1) return [r, emptyC];
    }

    // Columns
    for (int c = 0; c < 3; c++) {
      int count = 0;      // Number of symbols that occurred in this column
      int emptyR = -1;    // Row index of the empty cell in this column
      for (int r = 0; r < 3; r++) {
        if (board[r][c] == symbol) count++;
        if (board[r][c] == '') emptyR = r;
      }
      if (count == 2 && emptyR != -1) return [emptyR, c];
    }

    // Diagonals to left to bottom right
    int count1 = 0;     // Symbol count in this diagonal 
    int empty1 = -1;    // empty cell index along the diagonal 
    for (int i = 0; i < 3; i++) {
      if (board[i][i] == symbol) count1++;
      if (board[i][i] == '') empty1 = i;
    }
    if (count1 == 2 && empty1 != -1) return [empty1, empty1];

    // Diagonal top right to bottom left
    int count2 = 0;     // Symbol count in this diagonal 
    int empty2R = -1;   // Row of empty cell
    int empty2C = -1;   // Column of empty cell
    for (int i = 0; i < 3; i++) {
      int r = i, c = 2 - i;
      if (board[r][c] == symbol) count2++;
      if (board[r][c] == '') {
        empty2R = r;
        empty2C = c;
      }
    }
    if (count2 == 2 && empty2R != -1) return [empty2R, empty2C];
    // No two in a row found
    return null;
  }

  // Counts how many lines have 2 given symbol and 1 empty cell
  int _countTwoInARow(String symbol) {
    int count = 0; 

    //Rows
    for (int r = 0; r < 3; r++) {
      int sym = 0, empty = 0; 
      for (int c = 0; c < 3; c++) {
          if (board[r][c] == symbol) sym++; // Counts how many symbols
          if (board[r][c] == '') empty++; // Counts the empty spaces
        }
        // If there are 2 symbols and 1 empty cell, it's a potential win/block
        if (sym == 2 && empty == 1) count++;
      }

      // Columns
      for (int c = 0; c < 3; c++) {
        int sym = 0, empty = 0;
        for (int r = 0; r < 3; r++) {
          if (board[r][c] == symbol) sym++;
          if (board[r][c] == '') empty++;
        }
        if (sym == 2 && empty == 1) count++;
      }

      // Diagonals
      int diag1Sym = 0, diag1Empty = 0; // top left to bottom right
      int diag2Sym = 0, diag2Empty = 0; // top right to bottom left
      for (int i = 0; i < 3; i++) {
        // Diagonal 1
        if (board[i][i] == symbol) diag1Sym++;
        if (board[i][i] == '') diag1Empty++;
        // Diagonal 2
        if (board[i][2 - i] == symbol) diag2Sym++;
        if (board[i][2 - i] == '') diag2Empty++;
      }
      if (diag1Sym == 2 && diag1Empty == 1) count++;
      if (diag2Sym == 2 && diag2Empty == 1) count++;

      return count; // Total number of two-in-a-row opportunities
    }

  // Checks each empty cell, to see if placing a symbol creates a fork, 
  // 2 or more lines where the player could get a two in a row
  List<int>? _findFork(String symbol) {
    final empty = _emptyCells();
    // Check each empty cell to see if it can create a fork
    for (var cell in empty) {
      int r = cell[0], c = cell[1];
      // Temporarily place the player's mark in this cell
      board[r][c] = symbol;
      //  Count how many "two in a row" opportunities this move creates
      int forks = _countTwoInARow(symbol);
      // Undo the temporary move
      board[r][c] = '';
      // If placing here creates 2 or more opportunities, it's a fork
      if (forks >= 2) return [r, c];
    }
    // No fork found, return null
    return null;
  }

  List<int>? _oppositeCorner(String playerSymbol) {
    // If player symbol in cormer, play in opposite
    if (board[0][0] == playerSymbol && board[2][2] == '') return [2, 2];
    else if (board[2][2] == playerSymbol && board[0][0] == '') return [0, 0];
    else if (board[0][2] == playerSymbol && board[2][0] == '') return [2, 0];
    else if (board[2][0] == playerSymbol && board[0][2] == '') return [0, 2];
    return null;
  }

  List<int>? _emptyCorner() {
    final corners = [
      // Corners
      [0, 0],
      [0, 2],
      [2, 0],
      [2, 2],
    ];
    // Goes through each corner and checks if its empty
    for (var corner in corners) {
      if (board[corner[0]][corner[1]] == '') return corner;
    }
    return null;
  }

  List<int>? _emptySide() {
    // Sides
    final sides = [
      [0, 1],
      [1, 0],
      [1, 2],
      [2, 1],
    ];
    // Goes through each side and checks if its empty
    for (var side in sides) {
      if (board[side[0]][side[1]] == '') return side;
    }
    return null;
  }
}