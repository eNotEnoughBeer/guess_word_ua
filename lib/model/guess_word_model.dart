import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/colors_map.dart';
import 'package:guess_word_ua/view_model/view_model.dart';

/// ## ChangeNotifier class for one letter tile
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

/// ## ChangeNotifier class for all of the tiles of the game field
class GuessWordModel extends ChangeNotifier {
  final int guessWordLettersCount; // how much letters will be in the word
  late int currentTry; // we are at [currentTry] row now
  late int letterIndex; // we are at letter [letterIndex] on row = currentTry
  static const maxTry = 6;

  // game field. size is X*N, where X = maxTry, N = guessWordLettersCount
  late List<List<GuessWordLetter>> guessVariants;

  GuessWordModel(this.guessWordLettersCount) {
    _initGuessVariants();
  }

  /// ### generate an empty game field of needed quantity of letters in row
  void _initGuessVariants() {
    currentTry = 0;
    letterIndex = 0;
    guessVariants = List.generate(maxTry,
        (_) => List.generate(guessWordLettersCount, (_) => GuessWordLetter()));
  }

  /// ### clear all tiles => "Reset" or "New Game"
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

  /// ### to make a nice screenshot for "share", we don't need letters,
  /// just empty tiles wanted, so we need to hide letters
  void hideLetters() {
    for (int i = 0; i < guessVariants.length; i++) {
      for (int a = 0; a < guessVariants[i].length; a++) {
        guessVariants[i][a].isHiden = true;
        guessVariants[i][a].notifyListeners();
      }
    }
  }

  /// ### restore letters "visibility" after hiding em all
  void showLetters() {
    for (int i = 0; i < guessVariants.length; i++) {
      for (int a = 0; a < guessVariants[i].length; a++) {
        guessVariants[i][a].isHiden = false;
        guessVariants[i][a].notifyListeners();
      }
    }
  }

  /// ### change "empty tile" for current position to "tile with letter" for game field
  void addLetter(String newChar) {
    guessVariants[currentTry][letterIndex].text = newChar;
    guessVariants[currentTry][letterIndex].notifyListeners();
    letterIndex++;
  }

  /// ### clear last changed tile (remove the letter)
  void removeLetter() {
    letterIndex--;
    guessVariants[currentTry][letterIndex].text = '';
    guessVariants[currentTry][letterIndex].notifyListeners();
  }

  /// ### are we done?
  bool get isGameOver => currentTry == GuessWordModel.maxTry - 1;

  /// ### move to next row of tiles
  void nextTry() {
    currentTry++;
    letterIndex = 0;
  }

  /// ### change background color of row tiles according to [currentWord]
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
