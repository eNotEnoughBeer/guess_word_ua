import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.all(2.0),
        child: Material(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          color: letter.color,
          child: InkWell(
            onTap: () {
              letter.text == null
                  ? letter.onPressed?.call()
                  : letter.onTextInput?.call(letter.text!);
            },
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
      ),
    );
  }
}
