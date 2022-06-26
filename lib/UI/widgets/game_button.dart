import 'dart:math';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
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
    final buttonWidth = width ?? MediaQuery.of(context).size.width * 0.7;
    final fontHeight = min(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height) /
        17;
    bool textIsImagePath = text.indexOf('assets/images/') == 0;
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: NeumorphicButton(
        onPressed: onPressed,
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(100)),
          depth: 4,
          lightSource: LightSource.topLeft,
          color: backgroundColor,
          shadowDarkColor: shadowColor,
          shadowLightColor: lightShadowColor,
        ),
        minDistance: -1,
        child: Center(
          child: textIsImagePath
              ? Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Image.asset(text),
                )
              : Text(text,
                  style: TextStyle(
                    color: cardBorder,
                    fontSize: fontHeight,
                  )),
        ),
      ),
    );
  }
}
