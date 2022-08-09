import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/word_of_day_service.dart';

class InitialScreenViewModel extends ChangeNotifier {
  bool canPlay = false;
  InitialScreenViewModel() {
    checkAccess();
  }

  void checkAccess() {
    final dayGameData = GameOfDayService();
    dayGameData.getGameData();
    final status = dayGameData.gameData.gameStatus;
    DateFormat dateFormat = DateFormat('dd.MM.yyyy');
    final dateAsStr = dateFormat.format(DateTime.now());
    canPlay = false;

    if ((dayGameData.gameData.date.isEmpty) ||
        (dayGameData.gameData.date.compareTo(dateAsStr) == 0 && !status) ||
        (dayGameData.gameData.date.compareTo(dateAsStr) != 0)) {
      canPlay = true;
    }
    notifyListeners();
  }
}
