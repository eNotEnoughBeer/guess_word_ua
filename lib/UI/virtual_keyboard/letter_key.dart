import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/widgets/neumorphic_button.dart';
import 'package:provider/provider.dart';

import '../../model/virtual_keyboard_model.dart';
import '../colors_map.dart';

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
      child: NeumorphicButton(
        padding: EdgeInsets.zero,
        onPress: () {
          letter.text == null ? letter.onPressed?.call() : letter.onTextInput?.call(letter.text!);
        },
        backgroundColor: letter.color,
        bottomRightShadowColor: letter.color == unusedColor ? shadowColor : backgroundColor,
        topLeftShadowColor: letter.color == unusedColor ? lightShadowColor : backgroundColor,
        borderRadius: 4,
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
    );
  }
}
