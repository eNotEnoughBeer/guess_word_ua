import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/colors_map.dart';
import 'package:guess_word_ua/data.dart';
import 'package:guess_word_ua/guess_word/guess_word_model.dart';
import 'package:guess_word_ua/virtual_keyboard/virtual_keyboard_model.dart';

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
  final int guessWordLettersCount;
  late String _wordToGuess;
  late final KeyboardModel keyboardModel;
  late final GuessWordModel guessWordModel;
  late final List<String> database5letters;
  late Timer? errorTimer;

  var lettersByUsage = <LetterByUsage>[];

  ViewModel(this.guessWordLettersCount) {
    _attachAll();
    database5letters = database
        .where((element) => element.length == guessWordLettersCount)
        .map((e) => e.toUpperCase())
        .toList(growable: false);
    _wordToGuess = _randomWordToGuess();
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
    if (errorTimer != null) {
      if (errorTimer!.isActive) {
        errorTimer?.cancel();
        var tmp = resultWord.split('');
        lettersByUsage = List.generate(
            guessWordLettersCount,
            (index) =>
                LetterByUsage(char: tmp[index], status: LetterStatus.init),
            growable: false);
        guessWordModel.redrawColors(lettersByUsage);
      }
    }
    if (keyboardIsLocked) return;
    if (resultWord.isEmpty) return;
    guessWordModel.removeLetter(); //в guessWordModel убавить букву
    resultWord = resultWord.substring(0, resultWord.length - 1);
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
              // notifyListeners();
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
        notifyListeners();
        return;
      } else {
        getLists(); // разбили на три листа наши буковки
        keyboardModel.redrawColors(lettersByUsage);
        guessWordModel.redrawColors(lettersByUsage);
        if (_isGameOver) {
          endGame(false);
          notifyListeners();
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
