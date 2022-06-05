import 'dart:math';
import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/colors_map.dart';

class GameButton extends StatelessWidget {
  final double? width;
  final double? height;
  final String text;
  final VoidCallback? onPressed;

  const GameButton(
      {Key? key,
      this.onPressed,
      double? buttonWidth,
      double? buttonHeight,
      required this.text})
      : width = buttonWidth,
        height = buttonHeight,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? MediaQuery.of(context).size.height * 0.08;
    final buttonWidth = width ?? MediaQuery.of(context).size.width * 0.6;
    final fontHeight = min(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height) /
        17;
    bool textIsImagePath = text.indexOf('assets/') == 0;
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: Material(
        elevation: 8,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: cardBorder, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        color: backgroundColor,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          onTap: onPressed,
          child: Center(
            child: textIsImagePath
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(text),
                  )
                : Text(text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontHeight,
                    )),
          ),
        ),
      ),
    );
  }
}
