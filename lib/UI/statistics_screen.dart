import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/colors_map.dart';
import 'package:guess_word_ua/UI/widgets/back_to_previous_page.dart';
import 'package:guess_word_ua/UI/widgets/game_button.dart';
import 'package:guess_word_ua/providers/statistics_provider.dart';
import 'package:guess_word_ua/services/navigation.dart';
import 'package:guess_word_ua/services/statistics_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  var stats = StatisticsService();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: () =>
                NavigationActions.instance.returnToPreviousPage(context),
            icon: const Icon(
              Icons.cancel_outlined,
              color: cardBorder,
            ),
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: FutureBuilder(
        future: stats.getFullStatistics(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }
          return Column(children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: backgroundColor,
                  boxShadow: const [
                    BoxShadow(
                        color: lightShadowColor,
                        offset: Offset(1, 4),
                        blurRadius: 3),
                    BoxShadow(
                        color: shadowColor,
                        offset: Offset(-1, -4),
                        blurRadius: 3),
                  ],
                ),
                child: _statisticsGrid(stats.data),
              ),
            ),
            const Spacer(),
            GameButton(
              text: 'далі',
              onPressed: () =>
                  NavigationActions.instance.returnToPreviousPage(context),
            ),
            const SizedBox(height: 20),
          ]);
        },
      ),
    );
  }

  Widget _statisticsGrid(List<LevelData> data) {
    data.insert(0, LevelData(win: -1, loose: -1, level: -1));
    final fontHeight = MediaQuery.of(context).size.width / 20;
    final textStyle = TextStyle(
      color: textColor,
      fontSize: fontHeight,
      fontWeight: FontWeight.bold,
    );
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Table(
          border: const TableBorder(
            horizontalInside: BorderSide(
              width: 3,
              color: cardBorder,
            ),
          ),
          columnWidths: const {
            0: FixedColumnWidth(70),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
          },
          children: data.map((e) {
            var percent = '';
            var total = '';
            if (e.win != 0 || e.loose != 0) {
              percent =
                  '${((e.win / (e.win + e.loose)) * 100).toStringAsFixed(2)}%';
              total = '${e.win + e.loose}';
            }

            return TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: e.level == -1
                      ? const Text('')
                      : Text('${e.level}*', style: textStyle),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: e.level == -1
                        ? Text('Усього', style: textStyle)
                        : Text(total, style: textStyle)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: e.level == -1
                        ? Text('Успішно', style: textStyle)
                        : Text(percent, style: textStyle)),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
