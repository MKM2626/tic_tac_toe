import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SaveData {
  // Finds file path / creates scores.json file
  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/scores.json';
  }

  // Loads wins/draws from scores.json
  Future<Map<String, int>> loadScores() async {
    try {
      final file = File(await _getFilePath());
      if (!await file.exists()) {
        await file.writeAsString(jsonEncode({'playerWins': 0, 'aiWins': 0, 'draws': 0}));
      }
      final jsonString = await file.readAsString();
      return Map<String, int>.from(jsonDecode(jsonString));
    } 
    // If error, says it and uses default values
    catch (e) {
      print("Error loading scores: $e");
      return {'playerWins': 0, 'aiWins': 0, 'draws': 0};
    }
  }

  // Saves wins / draws
  Future<void> saveScores(Map<String, int> scores) async {
    try {
      final file = File(await _getFilePath());
      await file.writeAsString(jsonEncode(scores));
    } 
    // If error, states an error when saving
    catch (e) {
      print("Error saving scores: $e");
    }
  }
}