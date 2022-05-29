import 'dart:math';
import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/colors_map.dart';
import 'package:guess_word_ua/view_model/view_model.dart';

class ResetButton extends StatelessWidget {
  final GameStatus status;
  final VoidCallback? onPressed;
  const ResetButton({Key? key, required this.status, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonHeight = MediaQuery.of(context).size.height * 0.1;
    final buttonWidth = MediaQuery.of(context).size.width * 0.75;
    final fontHeight = min(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height) /
        17;
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: Material(
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: cardBorder, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        color: backgroundColor,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          onTap: onPressed,
          child: Center(
              child: Text(
                  status == GameStatus.win ? 'Молодець. Ще раз?' : 'Спробуй ще',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontHeight,
                  ))),
        ),
      ),
    );
  }
}
