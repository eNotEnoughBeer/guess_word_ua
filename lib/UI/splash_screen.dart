import 'package:flutter/material.dart';
import '../services/navigation.dart';
import 'colors_map.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 5))
        .then((value) => NavigationActions.instance.showInitialScreen(context));
  }

  @override
  Widget build(BuildContext context) {
    final progressWidth = MediaQuery.of(context).size.width * 0.5;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          const Center(
            child: SizedBox(
              width: 270,
              height: 270,
              child: Image(image: AssetImage('assets/images/logo.png')),
            ),
          ),
          Center(
            child: Column(
              children: [
                const Spacer(),
                const Text(
                  'by',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'NickG',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: progressWidth,
                  child: const LinearProgressIndicator(
                    color: presentOnCorrectPositionColor,
                    backgroundColor: unusedColor,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
