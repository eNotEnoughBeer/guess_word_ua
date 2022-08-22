import 'package:flutter/material.dart';
import '../UI/game_screen.dart';
import '../UI/initial_screen.dart';
import '../UI/rules_screen.dart';
import '../UI/splash_screen.dart';
import '../UI/statistics_screen.dart';

/// ## just route names
abstract class NavigationRouteNames {
  static const gameScreen = '/game';
  static const launchScreen = '/splash';
  static const chooseLevel = '/';
  static const statistics = '/stats';
  static const rules = '/rules';
}

class Navigation {
  String get initialRoute => NavigationRouteNames.launchScreen;

  Map<String, Widget Function(BuildContext context)> get routes => {
        NavigationRouteNames.launchScreen: (context) => const SplashScreen(),
        NavigationRouteNames.chooseLevel: (context) =>
            InitialScreen.withProvider(),
        NavigationRouteNames.statistics: (context) => const StatisticsScreen(),
        NavigationRouteNames.rules: (context) => const RulesScreen(),
      };

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
}

/// ## helper-class for navigation
class NavigationActions {
  static const instance = NavigationActions._();
  const NavigationActions._();
  // don't forget to add
  // MaterialApp(
  // navigatorKey: NavigationActions.navigatorKey, //<-!!!
  //...)
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// ### move from splash to main screen
  void showInitialScreen() {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
        NavigationRouteNames.chooseLevel, (route) => false);
  }

  /// ### start the game. [count] - letters quantity
  /// if [count == -5], that will be the game of the day
  Future<void> onGameStart(int count) async {
    await navigatorKey.currentState
        ?.pushNamed(NavigationRouteNames.gameScreen, arguments: count);
  }

  /// ### just back to previous page
  void returnToPreviousPage() {
    navigatorKey.currentState?.pop();
  }

  /// ### move to statistics screen
  void showStatisticsScreen() {
    navigatorKey.currentState?.pushNamed(NavigationRouteNames.statistics);
  }

  /// ### move to rules screen
  void showRulesScreen() {
    navigatorKey.currentState?.pushNamed(NavigationRouteNames.rules);
  }
}
