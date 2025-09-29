import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    final isGranted = await _checkPermission();

    if (isGranted) {
      _setupFlutterNotifications();
    }
  }

  Future<bool> _checkPermission() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      return true;
    }
    return false;
  }

  Future<void> _setupFlutterNotifications() async {
    // android setup
    const channel = AndroidNotificationChannel(
      'Video Call',
      'Incoming Call',
      description: 'This channel is used for incoming call notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // ios setup
    const initializationSettingsDarwin = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // flutter notification setup
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  Future<void> showNotification() async {
    if (!await Permission.notification.isGranted) {
      return;
    }

    await _localNotifications.show(
      101,
      "Video Call App",
      "Incoming Call",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'Video Call',
          'Incoming Call',
          channelDescription: 'This channel is used for offers notifications.',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: "Incoming Call From Unknown User",
    );
  }
}
