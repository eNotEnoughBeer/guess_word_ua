import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/navigation.dart';
import '../view_model/vm_initial_screen.dart';
import 'colors_map.dart';
import 'widgets/game_button.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  static Widget withProvider() {
    return ChangeNotifierProvider(
      create: (_) => InitialScreenViewModel(),
      child: const InitialScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    /*final dayGameData = GameOfDayService();
    dayGameData.clearGameData();
    print('done');*/
    final double logoSize = MediaQuery.of(context).size.width * 0.6;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 40),
              SizedBox(
                width: logoSize,
                height: logoSize,
                child: const Image(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.fill),
              ),
              const Spacer(),
              const DayGameButton(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GameButton(
                    text: 'assets/images/letter4.png',
                    buttonWidth: MediaQuery.of(context).size.width * 0.33,
                    onPressed: () =>
                        NavigationActions.instance.onGameStart(context, 4),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  GameButton(
                    text: 'assets/images/letter5.png',
                    buttonWidth: MediaQuery.of(context).size.width * 0.33,
                    onPressed: () =>
                        NavigationActions.instance.onGameStart(context, 5),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GameButton(
                    text: 'assets/images/letter6.png',
                    buttonWidth: MediaQuery.of(context).size.width * 0.33,
                    onPressed: () =>
                        NavigationActions.instance.onGameStart(context, 6),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  GameButton(
                    text: 'assets/images/letter7.png',
                    buttonWidth: MediaQuery.of(context).size.width * 0.33,
                    onPressed: () =>
                        NavigationActions.instance.onGameStart(context, 7),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GameButton(
                    text: 'досягнення',
                    buttonWidth: MediaQuery.of(context).size.width * 0.53,
                    onPressed: () => NavigationActions.instance
                        .showStatisticsScreen(context),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  GameButton(
                    text: '?',
                    buttonWidth: MediaQuery.of(context).size.height * 0.08,
                    onPressed: () =>
                        NavigationActions.instance.showRulesScreen(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class DayGameButton extends StatefulWidget {
  const DayGameButton({Key? key}) : super(key: key);

  @override
  State<DayGameButton> createState() => _DayGameButtonState();
}

class _DayGameButtonState extends State<DayGameButton> {
  late CountdownTimerController controller;
  late int endTime;

  @override
  void initState() {
    super.initState();
    initTimer();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void initTimer() {
    final now = DateTime.now();
    final midnight =
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    endTime = midnight.millisecondsSinceEpoch;
    controller = CountdownTimerController(endTime: endTime, onEnd: null);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<InitialScreenViewModel>();
    return CountdownTimer(
      controller: controller,
      widgetBuilder: (_, CurrentRemainingTime? time) {
        if (time == null) {
          controller.disposeTimer();
          initTimer();
          Future.delayed(const Duration(seconds: 1))
              .then((_) => viewModel.checkAccess());
          controller.start();
        }

        DateFormat dateFormat = DateFormat("HH:mm:ss");
        final timeAsStr = dateFormat.format(DateTime(
            1997,
            1,
            1,
            time == null ? 0 : time.hours ?? 0,
            time == null ? 0 : time.min ?? 0,
            time == null ? 0 : time.sec ?? 0));
        return GameButton(
          isBoldText: true,
          text: viewModel.canPlay ? 'гра дня' : timeAsStr,
          buttonWidth: MediaQuery.of(context).size.width * 0.7,
          onPressed: viewModel.canPlay
              ? () async {
                  await NavigationActions.instance.onGameStart(context, -5);
                  viewModel.checkAccess();
                }
              : () {},
        );
      },
    );
  }
}
