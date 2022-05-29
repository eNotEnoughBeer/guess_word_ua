import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/game_screen.dart';
import 'package:guess_word_ua/UI/splash_screen.dart';

abstract class NavigationRouteNames {
  static const mainScreen = '/';
  static const launchScreen = '/splash';
}

class Navigation {
  static String initialRoute() => NavigationRouteNames.launchScreen;

  final routes = <String, Widget Function(BuildContext context)>{
    NavigationRouteNames.launchScreen: (context) => const SplashScreen(),
    NavigationRouteNames.mainScreen: (context) => const GameScreen(),
  };

  static void showMainScreen(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        NavigationRouteNames.mainScreen, (route) => false);
  }
}
