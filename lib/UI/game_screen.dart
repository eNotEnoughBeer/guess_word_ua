import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:screenshot/screenshot.dart';

import '../UI/colors_map.dart';
import '../UI/guess_word/words_widget.dart';
import '../UI/virtual_keyboard/keyboard.dart';
import '../UI/widgets/alert_dialog.dart';
import '../UI/widgets/game_button.dart';
import '../UI/widgets/win_animation.dart';
import '../services/navigation.dart';
import '../services/notification_service.dart';
import '../services/rate_my_application.dart';
import '../view_model/view_model.dart';
import 'widgets/back_to_previous_page.dart';
import 'widgets/neumorphic_button.dart';
import 'widgets/share_dialog.dart';

class GameScreen extends StatelessWidget {
  GameScreen({Key? key}) : super(key: key);

  final controller = ScreenshotController();
  static Widget withProvider(int lettersCount) {
    bool isDayGame = lettersCount < 0 ? true : false;
    if (isDayGame) lettersCount *= -1;
    return ChangeNotifierProvider(
      create: (_) => ViewModel(lettersCount, isDayGame),
      child: GameScreen(),
    );
  }

  void showWinAnimation(BuildContext context) {
    OverlayEntry? entry;
    final overlay = Overlay.of(context);
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

  void popUpShareWindow(BuildContext context) {
    // подготовить скриншот,
    DateFormat dateFormat = DateFormat('dd.MM.yyyy');
    final dateAsStr = dateFormat.format(DateTime.now());
    Future.delayed(const Duration(seconds: 4), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        double pixelRatio = MediaQuery.of(context).devicePixelRatio;
        final viewModel = context.read<ViewModel>();
        viewModel.hideLetters();
        Future.delayed(const Duration(milliseconds: 100))
            .then(
              (_) => controller.capture(pixelRatio: pixelRatio).then((bytes) async {
                await showShareDialog(
                  context,
                  title: 'Гра дня: $dateAsStr',
                  bodyBytes: bytes!,
                  totalTries: viewModel.guessedWordFromXTries + 1,
                );
              }),
            )
            .then((_) => viewModel.showLetters());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ViewModel>();
    if (viewModel.isGameOfDay && viewModel.gameStatus != GameStatus.inProcess) {
      // no matter if the user wins or looses. the game is just over
      // so, it's time to set notifications for next day
      NotificationService().scheduleNotifications();
    }
    if (viewModel.gameStatus == GameStatus.lose) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showExplanationDialog(
            context,
            title: 'ВАРТО ЗНАТИ',
            body: viewModel.explanationStr,
          ));
    }
    if (viewModel.gameStatus == GameStatus.win) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showWinAnimation(context);
        if (viewModel.isGameOfDay) {
          popUpShareWindow(context);
        }
        if (rateMyApp.shouldOpenDialog) {
          Future.delayed(const Duration(seconds: 5), () {
            rateMyApp.showStarRateDialog(
              context,
              title: 'Подобається гра?',
              message: 'Поділіться своїми враженнями від гри у Google PlayStore',
              actionsBuilder: (context, stars) {
                return [
                  SizedBox(
                    width: 100,
                    child: NeumorphicButton(
                      onPress: () async {
                        final result = await rateMyApp.launchStore();
                        if (result == LaunchStoreResult.storeOpened) {
                          await rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
                        }

                        NavigationActions.navigatorKey.currentState
                            ?.pop<RateMyAppDialogButton>(RateMyAppDialogButton.rate);
                      },
                      backgroundColor: const Color(0xFFEFEFEF),
                      bottomRightShadowColor: Colors.black,
                      topLeftShadowColor: Colors.black12,
                      borderRadius: 100,
                      child: const Center(child: Text('ОК')),
                    ),
                  ),
                ];
              },
              ignoreNativeDialog: Platform.isAndroid,
              dialogStyle: const DialogStyle(
                titleAlign: TextAlign.center,
                messageAlign: TextAlign.center,
                messagePadding: EdgeInsets.only(bottom: 20),
              ),
              starRatingOptions: const StarRatingOptions(initialRating: 3),
              onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
            );
          });
        }
      });
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
              onPressed: () => NavigationActions.instance.returnToPreviousPage(),
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
            child: Screenshot(
              controller: controller,
              child: const WordsWidget(),
            ),
          ),
          const Spacer(),
          Visibility(
            visible: viewModel.gameStatus != GameStatus.inProcess,
            child: viewModel.gameStatus == GameStatus.lose
                ? viewModel.isGameOfDay
                    ? GameButton(
                        text: 'назад',
                        onPressed: () => NavigationActions.instance.returnToPreviousPage(),
                      )
                    : GameButton(
                        text: 'далі',
                        onPressed: viewModel.newGame,
                      )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      viewModel.isGameOfDay
                          ? GameButton(
                              buttonWidth: MediaQuery.of(context).size.width * 0.53,
                              text: 'назад',
                              onPressed: () => NavigationActions.instance.returnToPreviousPage(),
                            )
                          : GameButton(
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
                            body: viewModel.explanationStr,
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
