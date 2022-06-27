import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/widgets/alert_dialog.dart';
import 'package:guess_word_ua/UI/widgets/game_button.dart';
import 'package:guess_word_ua/UI/colors_map.dart';
import 'package:guess_word_ua/UI/guess_word/words_widget.dart';
import 'package:guess_word_ua/UI/virtual_keyboard/keyboard.dart';
import 'package:guess_word_ua/UI/widgets/win_animation.dart';
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

  void showWinAnimation(BuildContext context) {
    OverlayEntry? entry;
    final overlay = Overlay.of(context)!;
    entry = OverlayEntry(builder: (context) {
      Future.delayed(const Duration(seconds: 4), () {
        entry?.remove();
      });
      return const Material(
        color: Colors.transparent,
        elevation: 8,
        child: WinAnimationWidget(),
      );
    });
    overlay.insert(entry);
  }

  Widget buildWinAnimation() => const Material(
        color: Colors.transparent,
        elevation: 8,
        child: WinAnimationWidget(),
      );

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ViewModel>();
    if (viewModel.gameStatus == GameStatus.lose) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showExplanationDialog(
            context,
            title: 'ВАРТО ЗНАТИ',
            body: '${viewModel.answer} - ${viewModel.explanationStr}',
          ));
    }
    if (viewModel.gameStatus == GameStatus.win) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => showWinAnimation(context));
    }
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
              icon: const Icon(
                Icons.cancel_outlined,
                color: cardBorder,
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
          Visibility(
            visible: viewModel.gameStatus != GameStatus.inProcess,
            child: viewModel.gameStatus == GameStatus.lose
                ? GameButton(
                    text: 'далі',
                    onPressed: viewModel.newGame,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GameButton(
                        buttonWidth: MediaQuery.of(context).size.width * 0.53,
                        text: 'далі',
                        onPressed: viewModel.newGame,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.04,
                      ),
                      GameButton(
                        buttonWidth: MediaQuery.of(context).size.height * 0.08,
                        text: '?',
                        onPressed: () {
                          showExplanationDialog(
                            context,
                            title: 'ВАРТО ЗНАТИ',
                            body:
                                '${viewModel.answer} - ${viewModel.explanationStr}',
                          );
                        },
                      )
                    ],
                  ),
          ),
          const Spacer(),
          ChangeNotifierProvider.value(
            value: viewModel.keyboardModel,
            child: const Keyboard(),
          ),
        ]));
  }
}
