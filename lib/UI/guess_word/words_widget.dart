import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../model/guess_word_model.dart';
import '../colors_map.dart';
import 'letter_card.dart';

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
                              ))))
              .animate(delay: 200.ms)
              .slideY(begin: 0.25, end: 0, duration: 0.2.seconds, curve: Curves.easeInOut)
              .fadeIn(duration: 0.2.seconds, curve: Curves.easeInOut),
          Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(
                          wordsModel.guessWordLettersCount,
                          (int index) => ChangeNotifierProvider.value(
                                value: wordsModel.guessVariants[1][index],
                                child: const LetterCard(),
                              ))))
              .animate(delay: 400.ms)
              .slideY(begin: 0.25, end: 0, duration: 0.2.seconds, curve: Curves.easeInOut)
              .fadeIn(duration: 0.2.seconds, curve: Curves.easeInOut),
          Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(
                          wordsModel.guessWordLettersCount,
                          (int index) => ChangeNotifierProvider.value(
                                value: wordsModel.guessVariants[2][index],
                                child: const LetterCard(),
                              ))))
              .animate(delay: 600.ms)
              .slideY(begin: 0.25, end: 0, duration: 0.2.seconds, curve: Curves.easeInOut)
              .fadeIn(duration: 0.2.seconds, curve: Curves.easeInOut),
          Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(
                          wordsModel.guessWordLettersCount,
                          (int index) => ChangeNotifierProvider.value(
                                value: wordsModel.guessVariants[3][index],
                                child: const LetterCard(),
                              ))))
              .animate(delay: 800.ms)
              .slideY(begin: 0.25, end: 0, duration: 0.2.seconds, curve: Curves.easeInOut)
              .fadeIn(duration: 0.2.seconds, curve: Curves.easeInOut),
          Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(
                          wordsModel.guessWordLettersCount,
                          (int index) => ChangeNotifierProvider.value(
                                value: wordsModel.guessVariants[4][index],
                                child: const LetterCard(),
                              ))))
              .animate(delay: 1000.ms)
              .slideY(begin: 0.25, end: 0, duration: 0.2.seconds, curve: Curves.easeInOut)
              .fadeIn(duration: 0.2.seconds, curve: Curves.easeInOut),
          Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(
                          wordsModel.guessWordLettersCount,
                          (int index) => ChangeNotifierProvider.value(
                                value: wordsModel.guessVariants[5][index],
                                child: const LetterCard(),
                              ))))
              .animate(delay: 1200.ms)
              .slideY(begin: 0.25, end: 0, duration: 0.2.seconds, curve: Curves.easeInOut)
              .fadeIn(duration: 0.2.seconds, curve: Curves.easeInOut),
        ]));
  }
}
