import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/colors_map.dart';
import 'package:guess_word_ua/UI/widgets/game_button.dart';
import 'package:guess_word_ua/services/navigation.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    buttonWidth: MediaQuery.of(context).size.width * 0.333,
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
                    buttonWidth: MediaQuery.of(context).size.width * 0.333,
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
