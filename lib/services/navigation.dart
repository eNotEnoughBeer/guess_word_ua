import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/game_screen.dart';
import 'package:guess_word_ua/UI/initial_screen.dart';
import 'package:guess_word_ua/UI/rules_screen.dart';
import 'package:guess_word_ua/UI/splash_screen.dart';
import 'package:guess_word_ua/UI/statistics_screen.dart';

abstract class NavigationRouteNames {
  static const gameScreen = '/game';
  static const launchScreen = '/splash';
  static const chooseLevel = '/';
  static const statistics = '/stats';
  static const rules = '/rules';
}

class Navigation {
  static String initialRoute() => NavigationRouteNames.launchScreen;

  final routes = <String, Widget Function(BuildContext context)>{
    NavigationRouteNames.launchScreen: (context) => const SplashScreen(),
    NavigationRouteNames.chooseLevel: (context) => const InitialScreen(),
    NavigationRouteNames.statistics: (context) => const StatisticsScreen(),
    NavigationRouteNames.rules: (context) => const RulesScreen(),
  };

  static void showInitialScreen(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        NavigationRouteNames.chooseLevel, (route) => false);
  }

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NavigationRouteNames.gameScreen:
        final count =
            settings.arguments is int ? settings.arguments as int : -1;
        return MaterialPageRoute(
          builder: (context) => GameScreen.withProvider(count),
        );
      default:
        const widget = Scaffold(body: Center(child: Text('Error')));
        return MaterialPageRoute(builder: (context) => widget);
    }
  }

  static void onGameStart(BuildContext context, int count) {
    Navigator.of(context)
        .pushNamed(NavigationRouteNames.gameScreen, arguments: count);
  }

  static void returnToPreviousPage(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void showStatisticsScreen(BuildContext context) {
    Navigator.of(context).pushNamed(NavigationRouteNames.statistics);
  }

  static void showRulesScreen(BuildContext context) {
    Navigator.of(context).pushNamed(NavigationRouteNames.rules);
  }
}
