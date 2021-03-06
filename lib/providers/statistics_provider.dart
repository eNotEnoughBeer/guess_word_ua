import 'package:shared_preferences/shared_preferences.dart';

enum GameLevel { lvl4, lvl5, lvl6, lvl7 }

class LevelData {
  final int level;
  final int loose;
  final int win;
  LevelData({required this.level, required this.loose, required this.win});
}

abstract class StatisticsKeyField {
  static const statistics4 = 'level_4';
  static const statistics5 = 'level_5';
  static const statistics6 = 'level_6';
  static const statistics7 = 'level_7';
}

class StatisticsDataProvider {
  final _sharedPreferences = SharedPreferences.getInstance();

  String _getKey(GameLevel level) {
    switch (level) {
      case GameLevel.lvl4:
        return StatisticsKeyField.statistics4;
      case GameLevel.lvl5:
        return StatisticsKeyField.statistics5;
      case GameLevel.lvl6:
        return StatisticsKeyField.statistics6;
      case GameLevel.lvl7:
        return StatisticsKeyField.statistics7;
    }
  }

  int _convertEnumToIndex(GameLevel level) {
    switch (level) {
      case GameLevel.lvl4:
        return 4;
      case GameLevel.lvl5:
        return 5;
      case GameLevel.lvl6:
        return 6;
      case GameLevel.lvl7:
        return 7;
    }
  }

  Future<LevelData> getStatisticsDataForLevel(GameLevel level) async {
    final int win =
        (await _sharedPreferences).getInt('${_getKey(level)}_win') ?? 0;
    final int loose =
        (await _sharedPreferences).getInt('${_getKey(level)}_loose') ?? 0;
    return LevelData(level: _convertEnumToIndex(level), loose: loose, win: win);
  }

  Future<void> increaseStatisticsDataForWin(GameLevel level) async {
    final int win =
        (await _sharedPreferences).getInt('${_getKey(level)}_win') ?? 0;
    (await _sharedPreferences).setInt('${_getKey(level)}_win', win + 1);
  }

  Future<void> increaseStatisticsDataForLoose(GameLevel level) async {
    final int win =
        (await _sharedPreferences).getInt('${_getKey(level)}_loose') ?? 0;
    (await _sharedPreferences).setInt('${_getKey(level)}_loose', win + 1);
  }
}
