import 'package:flutter/material.dart';

import '../services/navigation.dart';
import 'colors_map.dart';
import 'widgets/back_to_previous_page.dart';
import 'widgets/game_button.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontHeight = MediaQuery.of(context).size.width / 20;
    final textStyle = TextStyle(
      color: textColor,
      fontSize: fontHeight,
    );
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackToPreviousButton(
          radius: 12,
          child: IconButton(
            padding: EdgeInsets.zero,
            splashRadius: 15,
            onPressed: () => NavigationActions.instance.returnToPreviousPage(),
            icon: const Icon(
              Icons.cancel_outlined,
              color: cardBorder,
            ),
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Вам потрібно відгадати слово з шести спроб.', style: textStyle),
            Text(
                'Введіть свою здогадку у рядок ігрового поля, '
                'після чого отримаєте підказку про те, наскільки близькою '
                'була здогадка по кожній букві:',
                style: textStyle),
            const SizedBox(height: 10),
            Center(
              child: Image.asset(
                'assets/howto.png',
                width: MediaQuery.of(context).size.width * 0.6,
              ),
            ),
            const SizedBox(height: 10),
            Text(
                'Зеленим кольором підсвічуються букви, які вгадано '
                'точно включаючи їхню позицію в слові.',
                style: textStyle),
            Text('Жовтим - ті, що є у слові, але у іншому місці.', style: textStyle),
            Text('Чорним - ті, яких у слові немає.', style: textStyle),
            const Spacer(),
            Center(
              child: GameButton(
                text: 'далі',
                onPressed: () => NavigationActions.instance.returnToPreviousPage(),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
