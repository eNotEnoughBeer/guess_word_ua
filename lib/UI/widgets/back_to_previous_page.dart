import 'package:flutter/material.dart';

import '../colors_map.dart';

class BackToPreviousButton extends StatelessWidget {
  final double radius;
  final Widget child;
  const BackToPreviousButton(
      {Key? key, required this.radius, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 3,
          left: 16,
          child: Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(radius),
              boxShadow: const [
                BoxShadow(
                  color: shadowColor,
                  offset: Offset(2, 1),
                  blurRadius: 2,
                ),
                BoxShadow(
                  color: lightShadowColor,
                  offset: Offset(-2, -1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}
