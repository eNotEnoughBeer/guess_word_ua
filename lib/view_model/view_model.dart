import 'dart:math';
import 'dart:async';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../UI/colors_map.dart';
import '../providers/data.dart';
import '../model/guess_word_model.dart';
import '../services/statistics_service.dart';
import '../services/word_of_day_service.dart';
import '../model/virtual_keyboard_model.dart';
import '../providers/day_word_dictionary.dart';

enum GameStatus { inProcess, lose, win }

enum LetterStatus { onCorrectPlace, usedButNotHere, useless, error, init }

/// ## helper class for logic needs
class LetterByUsage {
  final String char;
  final LetterStatus status;

  LetterByUsage({required this.char, required this.status});

  LetterByUsage copyWith({
    String? char,
    LetterStatus? status,
  }) {
    return LetterByUsage(
      char: char ?? this.char,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'LetterByUsage( $char, $status )';
  }
}

/// ## ChangeNotifier + logic class of the game
class ViewModel extends ChangeNotifier {
  var gameStatus = GameStatus.inProcess;
  bool keyboardIsLocked = false;
  var resultWord = '';
  var explanationStr = '';
  final int guessWordLettersCount;
  final bool isGameOfDay;
  late String _wordToGuess;
  String get answer => _wordToGuess;
  late final KeyboardModel keyboardModel;
  late final GuessWordModel guessWordModel;
  late final List<String> currentRoundDatabase;
  var errorTimer = Timer(const Duration(days: 1), () {});
  int get guessedWordFromXTries => guessWordModel.currentTry;
  var lettersByUsage = <LetterByUsage>[];

  ViewModel(this.guessWordLettersCount, this.isGameOfDay) {
    _attachAll();
    currentRoundDatabase = isGameOfDay
        ? dictionary.map((e) => e.toUpperCase()).toList(growable: false)
        : database
            .where((element) => element.length == guessWordLettersCount)
            .map((e) => e.toUpperCase())
            .toList(growable: false);
    if (!isGameOfDay) {
      _wordToGuess = _randomWordToGuess();
    } else {
      // if a can press a button (im here :) ), so, i can play.
      // "already played" processed elsewhere
      _wordToGuess = _getWordForToday();
      // get a current date
      DateFormat dateFormat = DateFormat('dd.MM.yyyy');
      final dateAsStr = dateFormat.format(DateTime.now());
      final dayGameData = GameOfDayService();
      dayGameData.getGameData();
      if (dayGameData.gameData.date.compareTo(dateAsStr) == 0 &&
          !dayGameData.gameData.gameStatus) {
        // date is the same, so user played but to to the end
        // dayGameData.gameData.row1-row5 restore data
        _updateLineFromSave(dayGameData.gameData.row1);
        _updateLineFromSave(dayGameData.gameData.row2);
        _updateLineFromSave(dayGameData.gameData.row3);
        _updateLineFromSave(dayGameData.gameData.row4);
        _updateLineFromSave(dayGameData.gameData.row5);
      } else {
        if (dayGameData.gameData.date.isNotEmpty) {
          // anti cheat :). user played but didn't loose or win
          // just gave up after several tries. so, he looses
          if (dayGameData.getGameStatus() != true) {
            dayGameData.getFullStatistics();
            dayGameData.statisticsData = dayGameData.statisticsData.copyWith(
                totalPlayed: dayGameData.statisticsData.totalPlayed + 1);
            dayGameData.updateStatistics();
          }
          dayGameData.clearGameData();
        }
        dayGameData.gameData = dayGameData.gameData.copyWith(date: dateAsStr);
        dayGameData.saveGameDataForThisTry(); // save the date
      }
    }
  }

  /// ### "game of the day" update game field after reopen the game
  void _updateLineFromSave(String guessWord) {
    if (guessWord.isNotEmpty) {
      resultWord = guessWord;
      for (var i = 0; i < resultWord.length; i++) {
        String element = resultWord[i];
        guessWordModel.addLetter(element);
      }
      _getLists(); // split letter to lists
      keyboardModel.redrawColors(lettersByUsage);
      guessWordModel.redrawColors(lettersByUsage);
      _nextTry();
    }
  }

  /// ### hide letter before screenshot
  void hideLetters() => guessWordModel.hideLetters();

  /// ### update visibility after screenshot
  void showLetters() => guessWordModel.showLetters();

  /// ### get a meaning of the word from internet dictionaries
  Future<void> _getExplanation(String word) async {
    final errorString =
        '$word - Не вдалося знайти визначення слова у тлумачному '
        'словнику. Можливо немає з\'єднання з мережою Інтернет або проблема '
        'з тлумачним словником.';
    explanationStr = '';
    try {
      var response = await http.Client()
          .get(Uri.parse('http://ukrlit.org/slovnyk/${word.toLowerCase()}'));
      if (response.statusCode == 200) {
        final document = parse(response.body);
        final body = document.getElementsByClassName('word__description');
        if (body.isNotEmpty) {
          if (body[0].nodes.isNotEmpty) {
            explanationStr = _parseExplanationTree(body[0].nodes.toList());
          }
        }
      }
      if (explanationStr.isEmpty) {
        response = await http.Client()
            .get(Uri.parse('https://goroh.pp.ua/Тлумачення/$word'));
        if (response.statusCode == 200) {
          final document = parse(response.body);
          final body = document.getElementsByClassName('interpret-formula');
          if (body.isNotEmpty) {
            if (body[0].nodes.isNotEmpty) {
              // something was found. let's find out what we get
              var parsedResult = _parseExplanationTree(body[0].nodes.toList());
              explanationStr =
                  parsedResult.isNotEmpty ? '$word - $parsedResult' : '';
            }
          }
        }
      }
      if (explanationStr.isEmpty) {
        explanationStr = errorString;
      }
    } catch (e) {
      explanationStr = errorString;
      rethrow;
    }
  }

  /// ### interpretations parsing
  String _parseExplanationTree(List<dom.Node> data) {
    var resStr = '';
    for (dom.Node a in data) {
      if (a.text == null) {
        for (dom.Node b in a.nodes) {
          if (b.text == null) {
            for (dom.Node c in b.nodes) {
              if (c.text != null) {
                resStr += c.text!;
              }
            }
          } else {
            resStr += b.text!;
          }
        }
      } else {
        resStr += a.text!;
      }
    }
    while (true) {
      // remove the garbage from the beginning
      var index = resStr.indexOf('\n');
      if (index == 0) {
        resStr = resStr.substring(1, resStr.length - 1);
      } else {
        break;
      }
    }
    // remove empty spaces
    resStr = resStr.trimLeft();
    var index = resStr.indexOf('\n'); // just first paragraph is enough
    if (index != -1) {
      resStr = resStr.substring(0, index - 1);
    }
    return resStr;
  }

  /// ### get a word of the day
  String _getWordForToday() {
    String result = '';
    final now = DateTime.now();
    final seed = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    // let's get the 5 letters word
    int randomNumber = Random(seed).nextInt(currentRoundDatabase.length);
    result = currentRoundDatabase[randomNumber];
    debugPrint(result);
    _getExplanation(result); // no need to use await
    return result;
  }

  /// ### get a random word to guess
  String _randomWordToGuess() {
    String result = '';
    int randomNumber = Random().nextInt(currentRoundDatabase.length);
    result = currentRoundDatabase[randomNumber];
    debugPrint(result);
    _getExplanation(result);
    return result;
  }

  // helper functions for class initialization
  void _attachAll() {
    keyboardModel = KeyboardModel(
      color: backgroundColor,
      onTextInput: onVirtualKeyboardPressedLetter,
      onBackspacePressed: onVirtualKeyboardPressedBackspace,
      onEnterPressed: onVirtualKeyboardPressedEnter,
    );
    guessWordModel = GuessWordModel(guessWordLettersCount);
  }

  /// ### start new game without quiting the game page
  void newGame() {
    _wordToGuess = _randomWordToGuess();
    resultWord = '';
    gameStatus = GameStatus.inProcess;
    keyboardIsLocked = false;
    keyboardModel.resetKeyboard();
    guessWordModel.resetGuessMatrix();
    notifyListeners();
  }

  /// ### everything has its end, the game hase the same feature :)
  void _endGame(bool isWin) {
    keyboardIsLocked = true;
    gameStatus = isWin ? GameStatus.win : GameStatus.lose;
    if (!isGameOfDay) {
      final stats = StatisticsService();
      if (isWin) {
        stats.saveWin(guessWordLettersCount);
      } else {
        stats.saveLoose(guessWordLettersCount);
      }
    } else if (isGameOfDay) {
      final dayGameData = GameOfDayService();
      dayGameData.getFullStatistics();
      dayGameData.statisticsData = dayGameData.statisticsData
          .copyWith(totalPlayed: dayGameData.statisticsData.totalPlayed + 1);

      if (isWin) {
        dayGameData.statisticsData = dayGameData.statisticsData
            .copyWith(win: dayGameData.statisticsData.win + 1);

        switch (guessWordModel.currentTry) {
          case 0:
            dayGameData.statisticsData = dayGameData.statisticsData
                .copyWith(try1: dayGameData.statisticsData.try1 + 1);
            break;
          case 1:
            dayGameData.statisticsData = dayGameData.statisticsData
                .copyWith(try2: dayGameData.statisticsData.try2 + 1);
            break;
          case 2:
            dayGameData.statisticsData = dayGameData.statisticsData
                .copyWith(try3: dayGameData.statisticsData.try3 + 1);
            break;
          case 3:
            dayGameData.statisticsData = dayGameData.statisticsData
                .copyWith(try4: dayGameData.statisticsData.try4 + 1);
            break;
          case 4:
            dayGameData.statisticsData = dayGameData.statisticsData
                .copyWith(try5: dayGameData.statisticsData.try5 + 1);
            break;
          case 5:
            dayGameData.statisticsData = dayGameData.statisticsData
                .copyWith(try6: dayGameData.statisticsData.try6 + 1);
            break;
          default:
            break;
        }
      }
      dayGameData.updateStatistics();
      dayGameData.getGameData();
      dayGameData.gameData = dayGameData.gameData.copyWith(status: true);
      dayGameData.saveGameDataForThisTry();
    }

    notifyListeners();
  }

  /// ### press a letter button on game keyboard
  void onVirtualKeyboardPressedLetter(String currentLetter) {
    if (keyboardIsLocked) return;
    if (resultWord.length < guessWordLettersCount) {
      resultWord += currentLetter;
      guessWordModel.addLetter(currentLetter); //ad a letter to guessWordModel
    }
  }

  /// ### press a Backspace button on game keyboard
  void onVirtualKeyboardPressedBackspace() {
    if (errorTimer.isActive && resultWord.length == guessWordLettersCount) {
      errorTimer.cancel();
      var tmp = resultWord.split('');
      lettersByUsage = List.generate(guessWordLettersCount,
          (index) => LetterByUsage(char: tmp[index], status: LetterStatus.init),
          growable: false);
      guessWordModel.redrawColors(lettersByUsage);
    }

    if (keyboardIsLocked) return;
    if (resultWord.isEmpty) return;
    guessWordModel.removeLetter(); //delete last letter from guessWordModel
    if (resultWord.isNotEmpty) {
      resultWord = resultWord.substring(0, resultWord.length - 1);
    }
  }

  /// ### pressed an Enter button on game keyboard
  void onVirtualKeyboardPressedEnter() {
    if (keyboardIsLocked) return;
    if (resultWord.length == guessWordLettersCount) {
      if (!_isWordExists) {
        // some blinking animations
        var cycle = 6;
        errorTimer = Timer.periodic(
          const Duration(milliseconds: 200),
          (Timer t) {
            if (cycle == 0) {
              t.cancel();
            } else {
              if (cycle.isEven) {
                var tmp = resultWord.split('');
                lettersByUsage = List.generate(
                    guessWordLettersCount,
                    (index) => LetterByUsage(
                        char: tmp[index], status: LetterStatus.error),
                    growable: false);
                guessWordModel.redrawColors(lettersByUsage);
              } else {
                var tmp = resultWord.split('');
                lettersByUsage = List.generate(
                    guessWordLettersCount,
                    (index) => LetterByUsage(
                        char: tmp[index], status: LetterStatus.init),
                    growable: false);
                guessWordModel.redrawColors(lettersByUsage);
              }
              --cycle;
            }
          },
        );
        return;
      }
      if (_isGuessedRight) {
        var listCorrect = _wordToGuess.split('');
        lettersByUsage = List.generate(
            guessWordLettersCount,
            (index) => LetterByUsage(
                char: listCorrect[index], status: LetterStatus.onCorrectPlace),
            growable: false);
        keyboardModel.redrawColors(lettersByUsage);
        guessWordModel.redrawColors(lettersByUsage);
        _endGame(true);
        return;
      } else {
        if (isGameOfDay) {
          // add a word resultWord to shared_prefs
          final dayGameData = GameOfDayService();
          dayGameData.getGameData();
          switch (guessWordModel.currentTry) {
            case 0:
              dayGameData.gameData =
                  dayGameData.gameData.copyWith(row1: resultWord);
              break;
            case 1:
              dayGameData.gameData =
                  dayGameData.gameData.copyWith(row2: resultWord);
              break;
            case 2:
              dayGameData.gameData =
                  dayGameData.gameData.copyWith(row3: resultWord);
              break;
            case 3:
              dayGameData.gameData =
                  dayGameData.gameData.copyWith(row4: resultWord);
              break;
            case 4:
              dayGameData.gameData =
                  dayGameData.gameData.copyWith(row5: resultWord);
              break;
            case 5:
              dayGameData.gameData =
                  dayGameData.gameData.copyWith(row6: resultWord);
              break;
            default:
              break;
          }
          dayGameData.gameData = dayGameData.gameData.copyWith(status: false);
          dayGameData.saveGameDataForThisTry();
        }
        _getLists(); // split word to lists
        keyboardModel.redrawColors(lettersByUsage);
        guessWordModel.redrawColors(lettersByUsage);
        if (_isGameOver) {
          _endGame(false);
          return;
        }
        _nextTry();
      }
    }
  }

  /// ### just a new guess try starts
  void _nextTry() {
    guessWordModel.nextTry();
    resultWord = '';
  }

  bool get _isWordExists => database.contains(resultWord.toLowerCase());
  bool get _isGuessedRight => _wordToGuess.compareTo(resultWord) == 0;
  bool get _isGameOver => guessWordModel.isGameOver;

  /// ### filling "colored" lists for guess
  void _getLists() {
    var listCorrect = _wordToGuess.split('');
    var listVariant = resultWord.split('');
    // first af all, init all with LetterStatus.useless
    lettersByUsage = List.generate(
        guessWordLettersCount,
        (index) => LetterByUsage(
            char: listVariant[index], status: LetterStatus.useless),
        growable: false);

    // fill "green" LetterStatus.onCorrectPlace
    for (var i = 0; i < guessWordLettersCount; i++) {
      if (listVariant[i] == listCorrect[i]) {
        lettersByUsage[i] =
            lettersByUsage[i].copyWith(status: LetterStatus.onCorrectPlace);
        listCorrect[i] = '+';
      }
    }

    // it's time to fill "orange" LetterStatus.usedButNotHere
    for (var i = 0; i < guessWordLettersCount; i++) {
      var pos = listCorrect.indexOf(listVariant[i]);
      if (lettersByUsage[i].status != LetterStatus.onCorrectPlace &&
          pos != -1) {
        listCorrect[pos] = '+';
        lettersByUsage[i] =
            lettersByUsage[i].copyWith(status: LetterStatus.usedButNotHere);
      }
    }
  }
}
