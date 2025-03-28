import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// ## push-up notifications (it's time to play, new word is waiting for you,...  )
class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// ### use it in main() to fill class with initial data.
  Future<void> init() async {
    const InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings,
    );
  }

  /// ### cancel all notifications
  Future<void> _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  /// ### here, we set a schedule notifications and remove a previous one
  Future<void> scheduleNotifications() async {
    // fix Android13+ features :)
    var status = await Permission.notification.status;
    if (status.isDenied) status = await Permission.notification.request();
    if (!status.isGranted) return;

    await _cancelAllNotifications(); // cancel previous schedule. we don't need it any more
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      'guess_word_ua'.hashCode,
      "Вгадай слово",
      "Гра дня вже чекає на тебе!",
      _nextInstanceOfNotification(),
      const NotificationDetails(
          android: AndroidNotificationDetails(
        'Вгадай слово',
        'Вгадай слово',
        channelDescription: 'Вгадай слово',
      )),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // plans, where and when we need to show next notification
  tz.TZDateTime _nextInstanceOfNotification() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 12);
    // BTW, we NEVER set a schedule for today:
    // if the game is done before today's notify - we don't need in today's notify
    // if the game is done after today's notify - we already saw a notify and don't need it today any more
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    } else {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
