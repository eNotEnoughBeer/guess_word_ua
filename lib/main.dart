import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/navigation.dart';
import 'services/notification_service.dart';
import 'services/rate_my_application.dart';
import 'providers/shared_prefs_singleton.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  rateMyApp.init();
  await NotificationService().init();
  await SharedPrefs.init();
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
    return MaterialApp(
      navigatorKey: NavigationActions.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'game_font',
      ),
      title: 'Вгадай слово',
      initialRoute: Navigation().initialRoute,
      routes: Navigation().routes,
      onGenerateRoute: Navigation().onGenerateRoute,
    );
  }
}
