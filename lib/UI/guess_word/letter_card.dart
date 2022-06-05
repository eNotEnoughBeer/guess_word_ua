import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/colors_map.dart';
import 'package:guess_word_ua/model/guess_word_model.dart';
import 'package:provider/provider.dart';

class LetterCard extends StatelessWidget {
  const LetterCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final result = MediaQuery.of(context).size.width;
    final fontSize = result / 13;
    final tileWidth = result / 8;
    final letter = context.watch<GuessWordLetter>();
    return SizedBox(
        width: tileWidth,
        child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Material(
              shape: RoundedRectangleBorder(
                side: letter.color == backgroundColor ||
                        letter.color == errorColor
                    ? const BorderSide(color: cardBorder, width: 3)
                    : BorderSide.none,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              color: letter.color,
              child: Center(
                  child: Text(letter.text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ))),
            )));
  }
}
