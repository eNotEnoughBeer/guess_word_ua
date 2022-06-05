import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/colors_map.dart';
import 'package:guess_word_ua/UI/game_button.dart';
import 'package:guess_word_ua/services/navigation.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double logoSize = MediaQuery.of(context).size.width * 0.4;
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
                child: const Image(image: AssetImage('assets/logo.png')),
              ),
              const Spacer(),
              GameButton(
                text: 'assets/letter4.png',
                onPressed: () => Navigation.onGameStart(context, 4),
              ),
              const SizedBox(height: 20),
              GameButton(
                text: 'assets/letter5.png',
                onPressed: () => Navigation.onGameStart(context, 5),
              ),
              const SizedBox(height: 20),
              GameButton(
                text: 'assets/letter6.png',
                onPressed: () => Navigation.onGameStart(context, 6),
              ),
              const SizedBox(height: 20),
              GameButton(
                text: 'assets/letter7.png',
                onPressed: () => Navigation.onGameStart(context, 7),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GameButton(
                    text: 'досягнення',
                    buttonWidth: MediaQuery.of(context).size.width * 0.46,
                    onPressed: () => Navigation.showStatisticsScreen(context),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  GameButton(
                    text: '?',
                    buttonWidth: MediaQuery.of(context).size.width * 0.12,
                    onPressed: () => Navigation.showRulesScreen(context),
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
