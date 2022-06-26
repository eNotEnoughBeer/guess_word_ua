import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WinAnimationWidget extends StatefulWidget {
  const WinAnimationWidget({Key? key}) : super(key: key);

  @override
  State<WinAnimationWidget> createState() => _WinAnimationWidgetState();
}

class _WinAnimationWidgetState extends State<WinAnimationWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    Future<void>.delayed(const Duration(milliseconds: 10))
        .whenComplete(() => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: double.infinity,
      heightFactor: double.infinity,
      child: Lottie.asset(
        'assets/lottie/congrats.json',
        repeat: false,
        fit: BoxFit.fitHeight,
        controller: _controller,
        animate: true,
        onLoaded: (composition) {
          _controller.duration = composition.duration;
        },
      ),
    );
  }
}
