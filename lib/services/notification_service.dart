import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';

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

  static const Uuid _uuid = Uuid();

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      _uuid.v1().hashCode,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> addScheduleNotification({
    required String title,
    required String body,
    String? payload,
    required,
    required DateTime notificationTime,
  }) async {
    tz.TZDateTime.from(notificationTime, tz.local);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      _uuid.v1().hashCode,
      title,
      body,
      tz.TZDateTime.from(notificationTime, tz.local),
      notificationDetails,
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
