import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guess_word_ua/UI/game_screen.dart';
import 'package:guess_word_ua/navigation.dart';
import 'package:guess_word_ua/view_model/view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
      create: (_) => ViewModel(5),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        title: 'Вгадай слово',
        initialRoute: Navigation.initialRoute(),
        routes: Navigation().routes,
      ),
    );
  }
}
