import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/widgets/game_button.dart';
import 'package:guess_word_ua/UI/colors_map.dart';
import 'package:guess_word_ua/UI/guess_word/words_widget.dart';
import 'package:guess_word_ua/UI/virtual_keyboard/keyboard.dart';
import 'package:guess_word_ua/services/navigation.dart';
import 'package:guess_word_ua/view_model/view_model.dart';
import 'package:provider/provider.dart';
import 'widgets/back_to_previous_page.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  static Widget withProvider(int lettersCount) {
    return ChangeNotifierProvider(
      create: (_) => ViewModel(lettersCount),
      child: const GameScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: анимашка с салютами, если выиграл
    final viewModel = context.watch<ViewModel>();
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 30,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackToPreviousButton(
            radius: 12,
            child: IconButton(
              padding: EdgeInsets.zero,
              splashRadius: 15,
              onPressed: () =>
                  NavigationActions.instance.returnToPreviousPage(context),
              icon: Icon(
                Icons.cancel_outlined,
                color: textColor.withAlpha(170),
              ),
            ),
          ),
        ),
        backgroundColor: backgroundColor,
        body: Column(children: [
          ChangeNotifierProvider.value(
            value: viewModel.guessWordModel,
            child: const WordsWidget(),
          ),
          const Spacer(),
          viewModel.gameStatus == GameStatus.inProcess
              ? const SizedBox.shrink()
              : GameButton(
                  text: 'далі',
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
