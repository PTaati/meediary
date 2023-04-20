import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<void> setUpNotification() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
  }

  static String channelId = 'MEEDIARY_NOTIFICATION_CHANNEL_ID';
  static String channelName = 'MEEDIARY_NOTIFICATION_CHANNEL';
  static AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    channelId,
    channelName,
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  static NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> addScheduleNotification({
    required String title,
    required String body,
    required,
    required DateTime notificationTime,
  }) async {
    tz.TZDateTime.from(notificationTime, tz.local);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, title,
      body,
      tz.TZDateTime.from(notificationTime, tz.local),
// tz.TZDateTime.now(tz.local).add(
//   const Duration(seconds: 5),
// ),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
