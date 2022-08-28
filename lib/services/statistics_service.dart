import '../providers/statistics_provider.dart';

/// ## service class for statistics
class StatisticsService {
  final _statisticsProvider = StatisticsDataProvider();
  late List<LevelData> _data;

  List<LevelData> get data => _data;

  /// ### index to enum converter
  GameLevel _convertIndexToEnum(int index) {
    switch (index) {
      case 4:
        return GameLevel.lvl4;
      case 5:
        return GameLevel.lvl5;
      case 6:
        return GameLevel.lvl6;
      default:
        return GameLevel.lvl7;
    }
  }

  /// ### just like caption says, here we get all stats data
  void getFullStatistics() {
    _data = Iterable.generate(
        4,
        (index) => _statisticsProvider.getStatisticsDataForLevel(
            _convertIndexToEnum(index + 4))).toList();
  }

  /// ### user wins, have to save results for [lettersCount]-letters word
  void saveWin(int lettersCount) {
    _statisticsProvider.increaseStatisticsDataForWin(
      _convertIndexToEnum(lettersCount),
    );
  }

  /// ### user looses, have to save results for [lettersCount]-letters word
  void saveLoose(int lettersCount) {
    _statisticsProvider.increaseStatisticsDataForLoose(
      _convertIndexToEnum(lettersCount),
    );
  }
}
