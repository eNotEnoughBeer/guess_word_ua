import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/colors_map.dart';
import 'package:guess_word_ua/UI/widgets/game_button.dart';

Future<void> showExplanationDialog(BuildContext context,
    {required String title, required String body}) {
  return showDialog<void>(
    context: context,
    builder: (context) => _exDialog(
      title: title,
      body: body,
    ),
  );
}

class _exDialog extends StatelessWidget {
  const _exDialog({
    // ignore: unused_element
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        titleTextStyle:
            const TextStyle(color: textColor, fontWeight: FontWeight.bold),
        contentTextStyle: const TextStyle(color: textColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: backgroundColor,
        title: Text(title),
        content: Text(body),
        actions: [
          GameButton(
            buttonWidth: 80,
            text: 'ок',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ]);
  }
}
