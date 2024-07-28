import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../services/navigation.dart';
import '../colors_map.dart';
import 'game_button.dart';

Future<void> showShareDialog(BuildContext context,
    {required String title,
    required Uint8List bodyBytes,
    required int totalTries}) {
  return showDialog<void>(
    context: context,
    builder: (context) => _ShareDialog(
      title: title,
      body: bodyBytes,
      count: totalTries,
    ),
  );
}

class _ShareDialog extends StatelessWidget {
  final controller = ScreenshotController();
  _ShareDialog({
    Key? key,
    required this.title,
    required this.body,
    required this.count,
  }) : super(key: key);

  final String title;
  final Uint8List body;
  final int count;

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
      title: const Text('ПЕРЕМОГА!'),
      content: Screenshot(
        controller: controller,
        child: Container(
          color: backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star,
                      color: presentColor,
                      size: 40,
                    ),
                    Icon(
                      count <= 4 ? Icons.star : Icons.star_border,
                      color: presentColor,
                      size: 40,
                    ),
                    Icon(
                      count <= 2 ? Icons.star : Icons.star_border,
                      color: presentColor,
                      size: 40,
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Text(title,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 21,
                        color: cardBorder,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Image.memory(body),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GameButton(
            buttonWidth: MediaQuery.of(context).size.width * 0.5,
            text: 'поділитися',
            onPressed: () async {
              final pixelRatio = MediaQuery.of(context).devicePixelRatio;
              // don't need in READ_EXTERNAL_STORAGE/WRITE_EXTERNAL_STORAGE
              // cause we work with getTemporaryDirectory (getApplicationSupportDirectory)
              final directory = await getTemporaryDirectory();
              final imagePath =
                  await File('${directory.path}/game.png').create();

              controller.capture(pixelRatio: pixelRatio).then((bytes) async {
                img.Image image = img.decodeImage(bytes!)!;
                img.Image resized = img.copyResize(image, width: 400);
                imagePath.writeAsBytesSync(img.encodePng(resized));
                await Share.shareXFiles(
                  [XFile(imagePath.path)],
                  text:
                      'https://play.google.com/store/apps/details?id=com.gonini.guess_word_ua',
                );
                NavigationActions.instance.returnToPreviousPage();
              });
            },
          ),
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(horizontal: 0.0),
    );
  }
}
