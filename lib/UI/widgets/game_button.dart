import 'dart:math';

import 'package:flutter/material.dart';

import '../colors_map.dart';
import 'neumorphic_button.dart';

class GameButton extends StatelessWidget {
  final double? width;
  final double? height;
  final bool? isBold;
  final String text;
  final VoidCallback? onPressed;

  const GameButton(
      {Key? key, this.onPressed, double? buttonWidth, double? buttonHeight, bool? isBoldText, required this.text})
      : width = buttonWidth,
        height = buttonHeight,
        isBold = isBoldText,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? MediaQuery.of(context).size.height * 0.08;
    final buttonWidth = width ?? MediaQuery.of(context).size.width * 0.7;
    final fontHeight = min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) / 17;
    bool textIsImagePath = text.indexOf('assets/images/') == 0;
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: NeumorphicButton(
        padding: (isBold != null && isBold == true) ? const EdgeInsets.only(bottom: 10.0) : const EdgeInsets.all(10.0),
        onPress: onPressed,
        backgroundColor: backgroundColor,
        bottomRightShadowColor: shadowColor,
        topLeftShadowColor: lightShadowColor,
        topLeftOffset: const Offset(-4, -2),
        bottomRightOffset: const Offset(4, 3),
        borderRadius: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textIsImagePath
                ? Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.asset(text),
                  )
                : Padding(
                    padding: (isBold != null && isBold == true)
                        ? const EdgeInsets.only(top: 4.0)
                        : const EdgeInsets.only(bottom: 4),
                    child: Text(text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: cardBorder,
                          fontSize: (isBold != null && isBold == true) ? fontHeight * 1.2 : fontHeight,
                          fontWeight: (isBold != null && isBold == true) ? FontWeight.bold : FontWeight.normal,
                        )),
                  ),
          ],
        ),
      ),
    );
  }
}
