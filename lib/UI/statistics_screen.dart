import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../UI/colors_map.dart';
import '../UI/widgets/back_to_previous_page.dart';
import '../UI/widgets/game_button.dart';
import '../providers/statistics_provider.dart';
import '../providers/word_of_day_provider.dart';
import '../services/navigation.dart';
import '../services/statistics_service.dart';
import '../services/word_of_day_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  var stats = StatisticsService();
  var dayGameData = GameOfDayService();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    stats.getFullStatistics();
    dayGameData.getFullStatistics();
    final textStyle = TextStyle(
      color: textColor,
      fontSize: MediaQuery.of(context).size.width / 20,
      fontWeight: FontWeight.bold,
    );

    final textStyleSmall = TextStyle(
      color: textColor,
      fontSize: MediaQuery.of(context).size.width / 25,
      fontWeight: FontWeight.bold,
    );

    var percentWinDayGame = '';
    if (dayGameData.statisticsData.totalPlayed > 0) {
      percentWinDayGame =
          '${((dayGameData.statisticsData.win / dayGameData.statisticsData.totalPlayed) * 100).toStringAsFixed(2)}%';
    }

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Вільна гра:',
                style: textStyle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: backgroundColor,
                boxShadow: const [
                  BoxShadow(color: lightShadowColor, offset: Offset(1, 4), blurRadius: 3),
                  BoxShadow(color: shadowColor, offset: Offset(-1, -4), blurRadius: 3),
                ],
              ),
              child: _statisticsGrid(stats.data),
            ),
          ),
          ////////////////////
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Слово дня:',
                style: textStyle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'усього: ${dayGameData.statisticsData.totalPlayed}   успішно: $percentWinDayGame',
                style: textStyleSmall,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: backgroundColor,
                boxShadow: const [
                  BoxShadow(color: lightShadowColor, offset: Offset(1, 4), blurRadius: 3),
                  BoxShadow(color: shadowColor, offset: Offset(-1, -4), blurRadius: 3),
                ],
              ),
              child: _dayGameGrid(dayGameData.statisticsData),
            ),
          ),
          const Spacer(),
          GameButton(
            text: 'далі',
            onPressed: () => NavigationActions.instance.returnToPreviousPage(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _statisticsGrid(List<LevelData> data) {
    data.insert(0, LevelData(win: -1, loose: -1, level: -1));
    final fontHeight = MediaQuery.of(context).size.width / 25;
    final textStyle = TextStyle(
      color: textColor,
      fontSize: fontHeight,
      fontWeight: FontWeight.bold,
    );
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Table(
          border: const TableBorder(
            horizontalInside: BorderSide(
              width: 1,
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
              percent = '${((e.win / (e.win + e.loose)) * 100).toStringAsFixed(2)}%';
              total = '${e.win + e.loose}';
            }

            return TableRow(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                child: Center(
                  child: e.level == -1
                      ? const Text('')
                      : Align(alignment: Alignment.centerLeft, child: Text('${e.level}*', style: textStyle)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                child: Center(child: e.level == -1 ? Text('Усього', style: textStyle) : Text(total, style: textStyle)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                child:
                    Center(child: e.level == -1 ? Text('Успішно', style: textStyle) : Text(percent, style: textStyle)),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _dayGameGrid(DayWordStats data) {
    final fontHeight = MediaQuery.of(context).size.width / 25;
    final textStyle = TextStyle(
      color: textColor,
      fontSize: fontHeight,
      fontWeight: FontWeight.bold,
    );
    var maxWin = data.try1;
    if (data.try2 > maxWin) maxWin = data.try2;
    if (data.try3 > maxWin) maxWin = data.try3;
    if (data.try4 > maxWin) maxWin = data.try4;
    if (data.try5 > maxWin) maxWin = data.try5;
    if (data.try6 > maxWin) maxWin = data.try6;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: const TableBorder(
            horizontalInside: BorderSide(
              width: 1,
              color: cardBorder,
            ),
          ),
          columnWidths: const {
            0: FixedColumnWidth(30),
            1: FlexColumnWidth(1),
            2: FixedColumnWidth(50),
          },
          children: [
            _oneRowData(1, /*data.totalPlayed*/ maxWin, data.try1, textStyle),
            _oneRowData(2, maxWin, data.try2, textStyle),
            _oneRowData(3, maxWin, data.try3, textStyle),
            _oneRowData(4, maxWin, data.try4, textStyle),
            _oneRowData(5, maxWin, data.try5, textStyle),
            _oneRowData(6, maxWin, data.try6, textStyle),
          ],
        ),
      ),
    );
  }

  TableRow _oneRowData(int first, int total, int curWin, TextStyle textStyle) {
    final barMaxWidth = MediaQuery.of(context).size.width - 60 - 16 - 80;
    return TableRow(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
            child: Text(
              '$first',
              style: textStyle,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: total > 0 ? barMaxWidth * (curWin / total) : 0,
            height: 10,
            color: textColor,
          )
              .animate(delay: 100.ms)
              .scaleX(begin: 0, end: 1, duration: 0.4.seconds, curve: Curves.easeInOut, alignment: Alignment.centerLeft)
              .fadeIn(duration: 0.6.seconds, curve: Curves.easeInOut),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            child: Text(
              '$curWin',
              style: textStyle,
            ),
          ),
        ),
      ],
    );
  }
}
