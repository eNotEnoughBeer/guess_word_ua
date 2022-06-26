import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/colors_map.dart';
import 'package:guess_word_ua/UI/widgets/game_button.dart';
import 'package:guess_word_ua/services/navigation.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double logoSize = MediaQuery.of(context).size.width * 0.45;
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
                child: const Image(image: AssetImage('assets/images/logo.png')),
              ),
              const Spacer(),
              GameButton(
                text: 'assets/letter4.png',
                onPressed: () =>
                    NavigationActions.instance.onGameStart(context, 4),
              ),
              const SizedBox(height: 20),
              GameButton(
                text: 'assets/letter5.png',
                onPressed: () =>
                    NavigationActions.instance.onGameStart(context, 5),
              ),
              const SizedBox(height: 20),
              GameButton(
                text: 'assets/letter6.png',
                onPressed: () =>
                    NavigationActions.instance.onGameStart(context, 6),
              ),
              const SizedBox(height: 20),
              GameButton(
                text: 'assets/letter7.png',
                onPressed: () =>
                    NavigationActions.instance.onGameStart(context, 7),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GameButton(
                    text: 'досягнення',
                    buttonWidth: MediaQuery.of(context).size.width * 0.54,
                    onPressed: () => NavigationActions.instance
                        .showStatisticsScreen(context),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.03,
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
