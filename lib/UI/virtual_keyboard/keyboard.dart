import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/virtual_keyboard/letter_key.dart';
import 'package:guess_word_ua/model/virtual_keyboard_model.dart';
import 'package:provider/provider.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).size.height * 0.2;
    final keyboardModel = context.watch<KeyboardModel>();
    return Container(
        color: keyboardModel.color,
        height: keyboardHeight,
        child: Column(children: [
          Expanded(
              child: Row(
                  children: List<Widget>.generate(
                      12,
                      (int index) => ChangeNotifierProvider.value(
                            value: keyboardModel.keyboard[index],
                            child: const LetterKey(),
                          )))),
          Expanded(
              child: Row(
                  children: List<Widget>.generate(
                      12,
                      (int index) => ChangeNotifierProvider.value(
                            value: keyboardModel.keyboard[index + 12],
                            child: const LetterKey(),
                          )))),
          Expanded(
              child: Row(
                  children: List<Widget>.generate(
                      11,
                      (int index) => ChangeNotifierProvider.value(
                            value: keyboardModel.keyboard[index + 24],
                            child: const LetterKey(),
                          )))),
        ]));
  }
}
