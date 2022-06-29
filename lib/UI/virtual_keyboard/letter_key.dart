import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:guess_word_ua/UI/colors_map.dart';
import 'package:guess_word_ua/model/virtual_keyboard_model.dart';
import 'package:provider/provider.dart';

class LetterKey extends StatelessWidget {
  const LetterKey({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontHeight = MediaQuery.of(context).size.width / 20;
    final letter = context.watch<KeyboardKey>();
    return Expanded(
      flex: letter.flex,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: NeumorphicButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            letter.text == null
                ? letter.onPressed?.call()
                : letter.onTextInput?.call(letter.text!);
          },
          style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(4)),
            depth: 5,
            lightSource: LightSource.topLeft,
            color: letter.color,
            shadowDarkColor:
                letter.color == unusedColor ? shadowColor : backgroundColor,
            shadowLightColor: letter.color == unusedColor
                ? lightShadowColor
                : backgroundColor,
          ),
          minDistance: -1,
          child: Center(
              child: letter.text == null
                  ? Icon(
                      letter.iconData,
                      color: Colors.white,
                      size: fontHeight * 1.2,
                    )
                  : Text(letter.text!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontHeight,
                      ))),
        ),
      ),
    );
  }
}
