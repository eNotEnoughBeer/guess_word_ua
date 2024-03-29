import 'package:flutter/material.dart';

import '../../services/navigation.dart';
import '../colors_map.dart';
import 'game_button.dart';

Future<void> showExplanationDialog(BuildContext context, {required String title, required String body}) {
  return showDialog<void>(
    context: context,
    builder: (context) => _ExDialog(
      title: title,
      body: body,
    ),
  );
}

class _ExDialog extends StatelessWidget {
  const _ExDialog({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final titleHeight = MediaQuery.of(context).size.width / 17;
    final contentHeight = MediaQuery.of(context).size.width / 25;
    return AlertDialog(
      titleTextStyle: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: titleHeight,
      ),
      contentTextStyle: TextStyle(
        color: textColor,
        fontSize: contentHeight,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: backgroundColor,
      title: Text(title),
      content: Text(body),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GameButton(
            buttonWidth: MediaQuery.of(context).size.width * 0.3,
            text: 'oк',
            onPressed: () {
              NavigationActions.instance.returnToPreviousPage();
            },
          ),
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(horizontal: 0.0),
    );
  }
}
