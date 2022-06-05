import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/colors_map.dart';
import 'package:guess_word_ua/UI/guess_word/letter_card.dart';
import 'package:guess_word_ua/model/guess_word_model.dart';
import 'package:provider/provider.dart';

class WordsWidget extends StatelessWidget {
  const WordsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tilesPaletteHeight = MediaQuery.of(context).size.height * 0.58;
    final wordsModel = context.watch<GuessWordModel>();
    return Container(
        color: backgroundColor,
        height: tilesPaletteHeight,
        child: Column(children: [
          Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                      wordsModel.guessWordLettersCount,
                      (int index) => ChangeNotifierProvider.value(
                            value: wordsModel.guessVariants[0][index],
                            child: const LetterCard(),
                          )))),
          Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                      wordsModel.guessWordLettersCount,
                      (int index) => ChangeNotifierProvider.value(
                            value: wordsModel.guessVariants[1][index],
                            child: const LetterCard(),
                          )))),
          Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                      wordsModel.guessWordLettersCount,
                      (int index) => ChangeNotifierProvider.value(
                            value: wordsModel.guessVariants[2][index],
                            child: const LetterCard(),
                          )))),
          Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                      wordsModel.guessWordLettersCount,
                      (int index) => ChangeNotifierProvider.value(
                            value: wordsModel.guessVariants[3][index],
                            child: const LetterCard(),
                          )))),
          Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                      wordsModel.guessWordLettersCount,
                      (int index) => ChangeNotifierProvider.value(
                            value: wordsModel.guessVariants[4][index],
                            child: const LetterCard(),
                          )))),
          Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                      wordsModel.guessWordLettersCount,
                      (int index) => ChangeNotifierProvider.value(
                            value: wordsModel.guessVariants[5][index],
                            child: const LetterCard(),
                          )))),
        ]));
  }
}
