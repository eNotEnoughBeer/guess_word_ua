import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../colors_map.dart';
import 'game_button.dart';

Future<void> showShareDialog(BuildContext context,
    {required String title, required Uint8List bodyBytes}) {
  return showDialog<void>(
    context: context,
    builder: (context) => _ShareDialog(
      title: title,
      body: bodyBytes,
    ),
  );
}

class _ShareDialog extends StatelessWidget {
  const _ShareDialog({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);

  final String title;
  final Uint8List body;

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
      content: Image.memory(body),
      actions: [
        GameButton(
          buttonWidth: MediaQuery.of(context).size.width * 0.5,
          text: 'поділитися',
          onPressed: () async {
            var status = await Permission.storage.status;
            if (status.isDenied) {
              status = await Permission.storage.request();
            }
            if (!status.isGranted) {
              Navigator.of(context).pop();
              return;
            }
            final directory = await getApplicationDocumentsDirectory();
            final imagePath = await File('${directory.path}/game.png').create();

            img.Image image = img.decodeImage(body)!;
            img.Image resized = img.copyResize(image, width: 400);
            imagePath.writeAsBytesSync(img.encodePng(resized));
            await Share.shareFiles([imagePath.path],
                text:
                    'https://play.google.com/store/apps/details?id=com.gonini.guess_word_ua',
                subject: title);

            Navigator.of(context).pop();
          },
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(horizontal: 0.0),
    );
  }
}
