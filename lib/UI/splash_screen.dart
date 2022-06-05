import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/colors_map.dart';
import 'package:guess_word_ua/services/navigation.dart';

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
        .then((value) => Navigation.showInitialScreen(context));
  }

  @override
  Widget build(BuildContext context) {
    final topPaddingHeight = MediaQuery.of(context).size.height * 0.30;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: topPaddingHeight),
            SizedBox(
              width: topPaddingHeight * 1.3,
              height: topPaddingHeight * 1.3,
              child: const Image(image: AssetImage('assets/logo.png')),
            ),
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
              'eNotEnoughBeer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: topPaddingHeight,
              child: const LinearProgressIndicator(
                color: presentOnCorrectPositionColor,
                backgroundColor: unusedColor,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
