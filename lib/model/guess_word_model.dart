import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/colors_map.dart';
import 'package:guess_word_ua/view_model/view_model.dart';

class GuessWordLetter extends ChangeNotifier {
  late String text;
  late Color color;
  late bool isHiden;

  GuessWordLetter(
      {this.text = '', this.color = backgroundColor, this.isHiden = false});

  GuessWordLetter copyWith({
    String? text,
    Color? color,
  }) {
    return GuessWordLetter(
      text: text ?? this.text,
      color: color ?? this.color,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GuessWordLetter &&
        other.text == text &&
        other.color == color;
  }

  @override
  int get hashCode => text.hashCode ^ color.hashCode;
}

class GuessWordModel extends ChangeNotifier {
  final int guessWordLettersCount;
  late int currentTry;
  late int letterIndex;
  static const maxTry = 6;
  late List<List<GuessWordLetter>> guessVariants;

  GuessWordModel(this.guessWordLettersCount) {
    _initGuessVariants();
  }

  void _initGuessVariants() {
    currentTry = 0;
    letterIndex = 0;
    guessVariants = List.generate(maxTry,
        (_) => List.generate(guessWordLettersCount, (_) => GuessWordLetter()));
  }

  void resetGuessMatrix() {
    currentTry = 0;
    letterIndex = 0;
    for (int i = 0; i < guessVariants.length; i++) {
      for (int a = 0; a < guessVariants[i].length; a++) {
        guessVariants[i][a].text = '';
        guessVariants[i][a].color = backgroundColor;
        guessVariants[i][a].notifyListeners();
      }
    }
  }

  void hideLetters() {
    for (int i = 0; i < guessVariants.length; i++) {
      for (int a = 0; a < guessVariants[i].length; a++) {
        guessVariants[i][a].isHiden = true;
        guessVariants[i][a].notifyListeners();
      }
    }
  }

  void showLetters() {
    for (int i = 0; i < guessVariants.length; i++) {
      for (int a = 0; a < guessVariants[i].length; a++) {
        guessVariants[i][a].isHiden = false;
        guessVariants[i][a].notifyListeners();
      }
    }
  }

  void addLetter(String newChar) {
    guessVariants[currentTry][letterIndex].text = newChar;
    guessVariants[currentTry][letterIndex].notifyListeners();
    letterIndex++;
  }

  void removeLetter() {
    letterIndex--;
    guessVariants[currentTry][letterIndex].text = '';
    guessVariants[currentTry][letterIndex].notifyListeners();
  }

  bool get isGameOver => currentTry == GuessWordModel.maxTry - 1;

  void nextTry() {
    currentTry++;
    letterIndex = 0;
  }

  void redrawColors(List<LetterByUsage> currentWord) {
    for (int i = 0; i < guessVariants[currentTry].length; i++) {
      switch (currentWord[i].status) {
        case LetterStatus.useless:
          guessVariants[currentTry][i].color = absentColor;
          break;
        case LetterStatus.onCorrectPlace:
          guessVariants[currentTry][i].color = presentOnCorrectPositionColor;
          break;
        case LetterStatus.usedButNotHere:
          guessVariants[currentTry][i].color = presentColor;
          break;
        case LetterStatus.error:
          guessVariants[currentTry][i].color = errorColor;
          break;
        case LetterStatus.init:
          guessVariants[currentTry][i].color = backgroundColor;
          break;
      }
      guessVariants[currentTry][i].notifyListeners();
    }
  }
}
