import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //* A method to schedule a notification asking the user to create a budget.
  Future<void> scheduleReminderNotification(
      {required String title, required String body}) async {
    await init();

    tz.initializeTimeZones();
    var location = tz.getLocation('Africa/Nairobi');
    final now = tz.TZDateTime.now(location);
    final DateTime currentDate = DateTime.now();
    final this28th = tz.TZDateTime(location, now.year, now.month, 28);
    final next28th = tz.TZDateTime(location, now.year, now.month + 1, 28);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'budget_channel_id',
      'Budget Channel',
      channelDescription: 'Channel for budget notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      currentDate.day >= 28 ? next28th : this28th,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    log('Scheduled notification');
  }

  Future<void> cancelScheduledNotification() async {
    await _flutterLocalNotificationsPlugin.cancel(0);
    log('Removed notification');
  }
}
