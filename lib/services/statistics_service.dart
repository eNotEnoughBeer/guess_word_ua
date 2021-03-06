import 'package:guess_word_ua/providers/statistics_provider.dart';

class StatisticsService {
  final _statisticsProvider = StatisticsDataProvider();
  late List<LevelData> _data;

  List<LevelData> get data => _data;

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

  Future<void> getFullStatistics() async {
    _data = await Future.wait(Iterable.generate(
        4,
        (index) => _statisticsProvider
            .getStatisticsDataForLevel(_convertIndexToEnum(index + 4))));
  }

  void saveWin(int lettersCount) {
    _statisticsProvider.increaseStatisticsDataForWin(
      _convertIndexToEnum(lettersCount),
    );
  }

  void saveLoose(int lettersCount) {
    _statisticsProvider.increaseStatisticsDataForLoose(
      _convertIndexToEnum(lettersCount),
    );
  }
}
