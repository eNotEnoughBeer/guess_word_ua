import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/colors_map.dart';

class Logo extends StatelessWidget {
  final double size;
  const Logo({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size),
            gradient: const LinearGradient(
              colors: [shadowColor, lightShadowColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: shadowColor,
                offset: Offset(8, 3),
                blurRadius: 8,
              ),
              BoxShadow(
                color: lightShadowColor,
                offset: Offset(-6, -2),
                blurRadius: 5,
              ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          bottom: 8,
          right: 8,
          child: CircleAvatar(
              backgroundColor: backgroundColor,
              backgroundImage: Image.asset('assets/logo.png').image),
        ),
      ],
    );
  }
}
