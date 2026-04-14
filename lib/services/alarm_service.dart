import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class AlarmService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );

    if (Platform.isAndroid) {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      // Request notification permission (Android 13+)
      await androidPlugin?.requestNotificationsPermission();

      // Request exact alarm permission (Android 12+)
      await androidPlugin?.requestExactAlarmsPermission();
    }
  }

  /// Schedule an alarm for a task reminder at a specific time
  static Future<void> scheduleAlarm(String id, String title, DateTime dateTime) async {
    final now = DateTime.now();
    if (dateTime.isBefore(now)) return;

    final scheduleTime = tz.TZDateTime.from(dateTime, tz.local);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'focus_alarm_channel',
      'Focus Alarms',
      channelDescription: 'Channel for Focus+ task alarms and reminders',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      category: AndroidNotificationCategory.alarm,
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 500, 200, 500, 200, 500]),
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
      categoryIdentifier: 'alarm_category',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notificationsPlugin.zonedSchedule(
      id.hashCode,
      '⏰ Task Reminder',
      title,
      scheduleTime,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Show an immediate notification when a focus session completes
  static Future<void> showSessionCompleteNotification({
    required int minutes,
    bool isSuccess = true,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'focus_session_channel',
      'Focus Sessions',
      channelDescription: 'Notifications when focus sessions complete',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 800, 300, 800, 300, 800]),
      category: AndroidNotificationCategory.alarm,
      fullScreenIntent: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      9999, // Fixed ID for session notifications
      isSuccess ? '🎉 Focus Complete!' : '⏱️ Session Ended',
      isSuccess
          ? 'Amazing! You focused for $minutes minutes. Keep the streak going!'
          : 'You focused for $minutes minutes. Every bit counts!',
      details,
    );
  }

  static Future<void> cancelAlarm(String id) async {
    await _notificationsPlugin.cancel(id.hashCode);
  }
}
