import 'shared_prefs_singleton.dart';

/// ## class for "word of the day" statistics controlling
class DayWordStats {
  final int totalPlayed;
  final int win;
  final int try1;
  final int try2;
  final int try3;
  final int try4;
  final int try5;
  final int try6;

  const DayWordStats({
    required this.totalPlayed,
    required this.win,
    required this.try1,
    required this.try2,
    required this.try3,
    required this.try4,
    required this.try5,
    required this.try6,
  });

  factory DayWordStats.initial() => const DayWordStats(
        totalPlayed: 0,
        win: 0,
        try1: 0,
        try2: 0,
        try3: 0,
        try4: 0,
        try5: 0,
        try6: 0,
      );

  DayWordStats copyWith({
    int? totalPlayed,
    int? win,
    int? try1,
    int? try2,
    int? try3,
    int? try4,
    int? try5,
    int? try6,
  }) {
    return DayWordStats(
      totalPlayed: totalPlayed ?? this.totalPlayed,
      win: win ?? this.win,
      try1: try1 ?? this.try1,
      try2: try2 ?? this.try2,
      try3: try3 ?? this.try3,
      try4: try4 ?? this.try4,
      try5: try5 ?? this.try5,
      try6: try6 ?? this.try6,
    );
  }
}

/// ## class for "game of the day" data
class GameOfTheDay {
  final bool gameStatus; // true - game finished, false - "in progress"
  final String date;
  final String row1;
  final String row2;
  final String row3;
  final String row4;
  final String row5;
  final String row6;

  const GameOfTheDay({
    required this.gameStatus,
    required this.date,
    required this.row1,
    required this.row2,
    required this.row3,
    required this.row4,
    required this.row5,
    required this.row6,
  });

  factory GameOfTheDay.initial() => const GameOfTheDay(
        gameStatus: false,
        date: '',
        row1: '',
        row2: '',
        row3: '',
        row4: '',
        row5: '',
        row6: '',
      );

  GameOfTheDay copyWith({
    String? date,
    String? row1,
    String? row2,
    String? row3,
    String? row4,
    String? row5,
    String? row6,
    bool? status,
  }) {
    return GameOfTheDay(
      gameStatus: status ?? gameStatus,
      date: date ?? this.date,
      row1: row1 ?? this.row1,
      row2: row2 ?? this.row2,
      row3: row3 ?? this.row3,
      row4: row4 ?? this.row4,
      row5: row5 ?? this.row5,
      row6: row6 ?? this.row6,
    );
  }
}

/// ## "word of the day" shared_prefs keys
abstract class DayWordKeyField {
  static const totalPlayed = 'total';
  static const winCount = 'win';
  static const index = 'try';
  static const wordDate = 'word_date';
  static const guessIndex = 'guess_index';
  static const gameStatus = 'game_status';
}

/// ## total "word of the day" data provider
class DayWordDataProvider {
  /// ### get all statistics for stats screen
  DayWordStats getStatisticsData() {
    final instance = SharedPrefs.instance;

    final int win = instance.getInt(DayWordKeyField.winCount) ?? 0;
    final int tp = instance.getInt(DayWordKeyField.totalPlayed) ?? 0;
    final int try1 = instance.getInt('${DayWordKeyField.index}_1') ?? 0;
    final int try2 = instance.getInt('${DayWordKeyField.index}_2') ?? 0;
    final int try3 = instance.getInt('${DayWordKeyField.index}_3') ?? 0;
    final int try4 = instance.getInt('${DayWordKeyField.index}_4') ?? 0;
    final int try5 = instance.getInt('${DayWordKeyField.index}_5') ?? 0;
    final int try6 = instance.getInt('${DayWordKeyField.index}_6') ?? 0;

    return DayWordStats(
      win: win,
      totalPlayed: tp,
      try1: try1,
      try2: try2,
      try3: try3,
      try4: try4,
      try5: try5,
      try6: try6,
    );
  }

  /// ### update statistics after game ends
  void updateStatisticsData(DayWordStats data) {
    final instance = SharedPrefs.instance;
    instance.setInt(DayWordKeyField.totalPlayed, data.totalPlayed);
    instance.setInt(DayWordKeyField.winCount, data.win);
    instance.setInt('${DayWordKeyField.index}_1', data.try1);
    instance.setInt('${DayWordKeyField.index}_2', data.try2);
    instance.setInt('${DayWordKeyField.index}_3', data.try3);
    instance.setInt('${DayWordKeyField.index}_4', data.try4);
    instance.setInt('${DayWordKeyField.index}_5', data.try5);
    instance.setInt('${DayWordKeyField.index}_6', data.try6);
  }

  /// ### get initial data of the "game of the day", when game screen launches
  /// it is a prevent cheats mechanism.
  /// when you start game of the day, you cant reset it. you have 6 tries only
  GameOfTheDay getGameData() {
    final instance = SharedPrefs.instance;

    final bool status = instance.getBool(DayWordKeyField.gameStatus) ?? false;
    final String date = instance.getString(DayWordKeyField.wordDate) ?? '';
    final String try1 =
        instance.getString('${DayWordKeyField.guessIndex}_1') ?? '';
    final String try2 =
        instance.getString('${DayWordKeyField.guessIndex}_2') ?? '';
    final String try3 =
        instance.getString('${DayWordKeyField.guessIndex}_3') ?? '';
    final String try4 =
        instance.getString('${DayWordKeyField.guessIndex}_4') ?? '';
    final String try5 =
        instance.getString('${DayWordKeyField.guessIndex}_5') ?? '';
    final String try6 =
        instance.getString('${DayWordKeyField.guessIndex}_6') ?? '';

    return GameOfTheDay(
      gameStatus: status,
      date: date,
      row1: try1,
      row2: try2,
      row3: try3,
      row4: try4,
      row5: try5,
      row6: try6,
    );
  }

  /// ### update "game of the day" data after each new guess word line
  /// the user may cancel game any time he wants.
  /// so, we need to keep all of his filled guesses.
  void saveGameData(GameOfTheDay data) {
    final instance = SharedPrefs.instance;
    instance.setBool(DayWordKeyField.gameStatus, data.gameStatus);
    instance.setString(DayWordKeyField.wordDate, data.date);
    instance.setString('${DayWordKeyField.guessIndex}_1', data.row1);
    instance.setString('${DayWordKeyField.guessIndex}_2', data.row2);
    instance.setString('${DayWordKeyField.guessIndex}_3', data.row3);
    instance.setString('${DayWordKeyField.guessIndex}_4', data.row4);
    instance.setString('${DayWordKeyField.guessIndex}_5', data.row5);
    instance.setString('${DayWordKeyField.guessIndex}_6', data.row6);
  }

  /// ### clear "game of the day" data.
  /// if the user wins or looses a day word, we don't need to keep data any more
  void clearGameData() {
    final instance = SharedPrefs.instance;
    instance.remove(DayWordKeyField.gameStatus);
    instance.remove(DayWordKeyField.wordDate);
    instance.remove('${DayWordKeyField.guessIndex}_1');
    instance.remove('${DayWordKeyField.guessIndex}_2');
    instance.remove('${DayWordKeyField.guessIndex}_3');
    instance.remove('${DayWordKeyField.guessIndex}_4');
    instance.remove('${DayWordKeyField.guessIndex}_5');
    instance.remove('${DayWordKeyField.guessIndex}_6');
  }

  /// ### get a game status for current game
  bool getGameStatus() {
    final instance = SharedPrefs.instance;
    return instance.getBool(DayWordKeyField.gameStatus) ?? false;
  }
}
