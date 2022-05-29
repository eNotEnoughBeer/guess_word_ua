import 'dart:math';
import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/reset_button.dart';
import 'package:guess_word_ua/UI/colors_map.dart';
import 'package:guess_word_ua/guess_word/words_widget.dart';
import 'package:guess_word_ua/view_model/view_model.dart';
import 'package:guess_word_ua/virtual_keyboard/keyboard.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topPaddingHeight = max(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height) *
        0.05;
    final viewModel = context.watch<ViewModel>();
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Column(children: [
          SizedBox(height: topPaddingHeight),
          ChangeNotifierProvider.value(
            value: viewModel.guessWordModel,
            child: const WordsWidget(),
          ),
          const Spacer(),
          viewModel.gameStatus == GameStatus.inProcess
              ? const SizedBox.shrink()
              : ResetButton(
                  status: viewModel.gameStatus,
                  onPressed: viewModel.newGame,
                ),
          const Spacer(),
          ChangeNotifierProvider.value(
            value: viewModel.keyboardModel,
            child: const Keyboard(),
          ),
        ]));
  }
}
