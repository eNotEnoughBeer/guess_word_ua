import '../providers/word_of_day_provider.dart';

/// ## "game of the day" data control
/// there are 2 functions for statistics: [getFullStatistics], [updateStatistics]<br>
/// and 3 functions for game process: [getGameData], [saveGameDataForThisTry]
/// and [clearGameData]
class GameOfDayService {
  final _dataProvider = DayWordDataProvider();
  DayWordStats statisticsData = DayWordStats.initial();
  GameOfTheDay gameData = GameOfTheDay.initial();

  /// ### function fills [statisticsData] with shared_preferences data
  void getFullStatistics() {
    statisticsData = _dataProvider.getStatisticsData();
  }

  /// ### use to update statistics data in shared_preferences.
  /// don't forget to modify [statisticsData], before function usage.<br>
  /// for example,<br>
  /// [statisticsData = statisticsData.copyWith(]<br>
  /// [totalPlayed: statisticsData.totalPlayed+1,]<br>
  /// [win: statisticsData.win+1,]<br>
  /// [try3: statisticsData.try3+1);]
  void updateStatistics() {
    _dataProvider.updateStatisticsData(statisticsData);
  }

  /// ### function fills [gameData] with shared_preferences data
  void getGameData() {
    gameData = _dataProvider.getGameData();
  }

  /// ### use to update shared_prefs after each try to guess a word of the day
  /// don't forget to modify [gameData] before usage
  void saveGameDataForThisTry() {
    _dataProvider.saveGameData(gameData);
  }

  /// ### use to clear shared_preferences after game ends, loose or win - don't care
  /// don't forget to launch [updateStatistics] too
  /// before use it, check [getGameStatus == true] and saved date != today
  void clearGameData() {
    _dataProvider.clearGameData();
    gameData = GameOfTheDay.initial();
  }

  /// ### true - if the game is done, false - if the game is in process
  /// additional check for date comparison is needed.
  /// for example the game may be in process, but current date is different
  /// from saved in shared_prefs. so, game data must be cleared for unlocking
  /// this day game
  bool getGameStatus() {
    return _dataProvider.getGameStatus();
  }
}
