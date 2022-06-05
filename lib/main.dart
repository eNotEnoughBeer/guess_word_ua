import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guess_word_ua/services/navigation.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'game_font',
      ),
      title: 'Вгадай слово',
      initialRoute: Navigation.initialRoute(),
      routes: Navigation().routes,
      onGenerateRoute: (RouteSettings settings) =>
          Navigation().onGenerateRoute(settings),
    );
  }
}
