import 'dart:math';
import 'dart:async';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/colors_map.dart';
import 'package:guess_word_ua/providers/data.dart';
import 'package:guess_word_ua/model/guess_word_model.dart';
import 'package:guess_word_ua/services/statistics_service.dart';
import 'package:guess_word_ua/model/virtual_keyboard_model.dart';

enum GameStatus { inProcess, lose, win }

enum LetterStatus { onCorrectPlace, usedButNotHere, useless, error, init }

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

class ViewModel extends ChangeNotifier {
  var gameStatus = GameStatus.inProcess;
  bool keyboardIsLocked = false;
  var resultWord = '';
  var explanationStr = '';
  final int guessWordLettersCount;
  late String _wordToGuess;
  String get answer => _wordToGuess;
  late final KeyboardModel keyboardModel;
  late final GuessWordModel guessWordModel;
  late final List<String> database5letters;
  var errorTimer = Timer(const Duration(days: 1), () {});

  var lettersByUsage = <LetterByUsage>[];

  ViewModel(this.guessWordLettersCount) {
    _attachAll();
    database5letters = database
        .where((element) => element.length == guessWordLettersCount)
        .map((e) => e.toUpperCase())
        .toList(growable: false);
    _wordToGuess = _randomWordToGuess();
  }

  Future<void> getExplanation(String word) async {
    const errorString =
        'Не вдалося знайти визначення слова у тлумачному словнику. '
        'Можливо немає з\'єднання з мережою Інтернет або проблема '
        'з тлумачним словником.';
    explanationStr = errorString;
    try {
      var response = await http.Client()
          .get(Uri.parse('https://goroh.pp.ua/Тлумачення/$word'));
      if (response.statusCode == 200) {
        final document = parse(response.body);
        final body = document.getElementsByClassName('interpret-formula');
        if (body.isNotEmpty) {
          if (body[0].nodes.isNotEmpty) {
            explanationStr = _parseExplanationTree(body[0].nodes.toList());
          }
        }
      }
    } catch (e) {
      rethrow;
    }
    /*if (resultString.isEmpty) { // резерв
      var response = await http.Client().get(Uri.parse(
          'http://ukrlit.org/slovnyk/$word'));
      if (response.statusCode == 200) {
        final document = parse(response.body);
        final body = document
            .getElementsByClassName('word__description'); //toggle-content
        if (body.isNotEmpty) {
          if (body[0].nodes.isNotEmpty) {
            // вот здесь нужно добраться до каждой строки в каждом элементе
            // из этого всего собрать строку, а потом ее резать.
            // слева - по входному слову, потом до первой точки.
            // справа - остается всё, по первый встреченный '\n'
            explanationStr = _parseExplanationTree(body[0].nodes.toList());
          }
        }
      }
    }*/
  }

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
      // убираем мусор вначале
      var index = resStr.indexOf('\n');
      if (index == 0) {
        resStr = resStr.substring(1, resStr.length - 1);
      } else {
        break;
      }
    }
    // строка начинается с букв а не с пробелов
    resStr = resStr.trimLeft();
    var index = resStr.indexOf('\n'); // оставляем только первый абзац
    if (index != -1) {
      resStr = resStr.substring(0, index - 1);
    }
    return resStr;
  }

  String _randomWordToGuess() {
    var result = '';
    bool isFound = false;
    while (!isFound) {
      int randomNumber = Random().nextInt(database5letters.length);
      result = database5letters[randomNumber];
      var apostropheFound = false;
      for (var i = 0; i < result.length; i++) {
        if (result[i] == '`') {
          apostropheFound = true;
          break;
        }
      }
      isFound = !apostropheFound;
    }
    //print(result);
    getExplanation(result); // пока доиграет, оно ему уже и толкование найдет
    return result;
  }

  void _attachAll() {
    keyboardModel = KeyboardModel(
      color: backgroundColor,
      onTextInput: onVirtualKeyboardPressedLetter,
      onBackspacePressed: onVirtualKeyboardPressedBackspace,
      onEnterPressed: onVirtualKeyboardPressedEnter,
    );
    guessWordModel = GuessWordModel(guessWordLettersCount);
  }

  void newGame() {
    _wordToGuess = _randomWordToGuess();
    resultWord = '';
    gameStatus = GameStatus.inProcess;
    keyboardIsLocked = false;
    keyboardModel.resetKeyboard();
    guessWordModel.resetGuessMatrix();
    notifyListeners();
  }

  void endGame(bool isWin) {
    keyboardIsLocked = true;
    gameStatus = isWin ? GameStatus.win : GameStatus.lose;
    final stats = StatisticsService();
    if (isWin) {
      // внутрянка асинхронная, но дожидаться окончания не будем
      stats.saveWin(guessWordLettersCount);
    } else {
      stats.saveLoose(guessWordLettersCount);
    }
    notifyListeners();
  }

  void onVirtualKeyboardPressedLetter(String currentLetter) {
    if (keyboardIsLocked) return;
    if (resultWord.length < guessWordLettersCount) {
      resultWord += currentLetter;
      guessWordModel.addLetter(currentLetter); //в guessWordModel добавить букву
    }
  }

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
    guessWordModel.removeLetter(); //в guessWordModel убавить букву
    if (resultWord.isNotEmpty) {
      resultWord = resultWord.substring(0, resultWord.length - 1);
    }
  }

  void onVirtualKeyboardPressedEnter() {
    if (keyboardIsLocked) return;
    if (resultWord.length == guessWordLettersCount) {
      if (!_isWordExists) {
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
        endGame(true);
        return;
      } else {
        getLists(); // разбили на три листа наши буковки
        keyboardModel.redrawColors(lettersByUsage);
        guessWordModel.redrawColors(lettersByUsage);
        if (_isGameOver) {
          endGame(false);
          return;
        }
        _nextTry();
      }
    }
  }

  void _nextTry() {
    guessWordModel.nextTry();
    resultWord = '';
  }

  bool get _isWordExists => database5letters.contains(resultWord);
  bool get _isGuessedRight => _wordToGuess.compareTo(resultWord) == 0;
  bool get _isGameOver => guessWordModel.isGameOver;

  void getLists() {
    var listCorrect = _wordToGuess.split('');
    var listVariant = resultWord.split('');
    // сначала заполним все LetterStatus.useless
    lettersByUsage = List.generate(
        guessWordLettersCount,
        (index) => LetterByUsage(
            char: listVariant[index], status: LetterStatus.useless),
        growable: false);

    // заполняем точные попадания LetterStatus.onCorrectPlace
    for (var i = 0; i < guessWordLettersCount; i++) {
      if (listVariant[i] == listCorrect[i]) {
        lettersByUsage[i] =
            lettersByUsage[i].copyWith(status: LetterStatus.onCorrectPlace);
        listCorrect[i] = '+';
      }
    }

    // а теперь есть, но не на своем месте LetterStatus.usedButNotHere
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
