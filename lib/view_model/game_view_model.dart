import 'package:flutter/material.dart';
import 'package:tic_tac_toe/model/game_logic_model.dart';
import 'package:tic_tac_toe/services/save_data_model.dart';

class GameViewModel extends ChangeNotifier {
  final GameLogic _game = GameLogic();
  final SaveData _data = SaveData();

  // Default values
  String _difficulty = "easy"; // default difficulty
  String playerSymbol = "X"; // default player symbol
  String aiSymbol = "O";

  // get score from game logic
  int get playerScore => _game.playerScore;
  int get aiScore => _game.aiScore;
  int get drawScore => _game.drawScore;

  // Persistent stats / values which will be saved / loaded into / displayed in home
  int playerWins = 0;
  int aiWins = 0;
  int draws = 0;

  // Loads saved data (wins/draws)
  GameViewModel(){
    _loadData();
  }

  // Getters
  List<List<String>> get board => _game.board;
  String get difficulty => _difficulty;
  bool get playerTurn => _game.playerTurn;

    // Background / button colours setter
    Color get playerColor => playerSymbol == "X" ? Colors.blue : Colors.red;
    Color get aiColor => aiSymbol == "O" ? Colors.red : Colors.blue;
    Color get currentTurnColor => playerTurn ? playerColor : aiColor;

  // Setters
  void setDifficulty(String difficulty) {
    _difficulty = difficulty;
    notifyListeners();
  }

  void setPlayerSymbol(String symbol) {
    playerSymbol = symbol;
    aiSymbol = (symbol == "X") ? "O" : "X";
    notifyListeners();
  }

  // game logic
  String? checkWinner() => _game.checkWinner();
  
  bool checkMove(int row, int col) => _game.checkMove(row, col);

  void makeMove(int row, int col, String symbol) {
    _game.makeMove(row, col, symbol);
    notifyListeners();
  }

  void makeAIMove() { 
    _game.makeAIMove(_difficulty, aiSymbol, playerSymbol);
    notifyListeners();
  }

  void undo() {
    _game.undo();
    notifyListeners();
  }

  void resetBoard() {
    _game.resetBoard(
      _difficulty,
      playerSymbol,
      aiSymbol,
    );
    notifyListeners();
  }

  // Passer for update score & save score to persistent values, and save to file
  Future<void> updateScore(String winner) async {
    _game.updateScore(winner, playerSymbol, aiSymbol);
    // Update persisten wins
    if (winner == playerSymbol) {
      playerWins++;
    } else if (winner == aiSymbol) {
      aiWins++;
    } else if (winner == "draw") {
      draws++;
    }
    await _saveScores();
    notifyListeners();
  }

  // Clears the board, and score in game board
  void clearGame() {
    _game.resetBoard(_difficulty, playerSymbol, aiSymbol);
    _game.playerScore = 0;
    _game.aiScore = 0;
    _game.drawScore = 0;
    notifyListeners();
  }

  // Clear win/draws the saved data 
  Future<void> clearWins() async {
    playerWins = 0;
    aiWins = 0;
    draws = 0;
    await _saveScores();
    notifyListeners();
  }

  // Load wins/draws/losses from file
  Future<void> _loadData() async {
    final scores = await _data.loadScores();
    playerWins = scores['playerWins'] ?? 0;
    aiWins = scores['aiWins'] ?? 0;
    draws = scores['draws'] ?? 0; 
    notifyListeners();
  }
  // Saves wins/draws/losses to file
  Future<void> _saveScores() async {
    await _data.saveScores({
      'playerWins': playerWins,
      'aiWins': aiWins,
      'draws': draws,
    });
  }
}
