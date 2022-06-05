import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/colors_map.dart';
import 'package:guess_word_ua/services/navigation.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: страница правил
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          padding: EdgeInsets.zero,
          splashRadius: 15,
          onPressed: () => Navigation.returnToPreviousPage(context),
          icon: const Icon(
            Icons.cancel_outlined,
            color: unusedColor,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Container(),
    );
  }
}
