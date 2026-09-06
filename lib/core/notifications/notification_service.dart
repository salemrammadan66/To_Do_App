import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';

/// Wraps flutter_local_notifications to schedule/cancel a single reminder
/// per task, fired at the task's deadline.
class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    try {
      final currentTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));
    } catch (_) {
      // Falls back to the plugin's default location if the device
      // timezone couldn't be resolved.
    }

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings: settings);

    final granted = await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    debugPrint("NOTIFICATIONS PERMISSION GRANTED: $granted");
    debugPrint("RESOLVED LOCAL TIMEZONE: ${tz.local.name}");

    _initialized = true;
  }

  /// Schedules a reminder for [deadline]. Uses "inexact" scheduling so it
  /// doesn't require the special "Alarms & reminders" permission - the
  /// notification may arrive a few minutes late in rare cases, which is
  /// fine for a to-do reminder.
  static Future<void> scheduleTaskReminder({
    required int id,
    required String title,
    required DateTime deadline,
  }) async {
    final scheduledDate = tz.TZDateTime.from(deadline, tz.local);
    final now = tz.TZDateTime.now(tz.local);
    debugPrint("SCHEDULING for $scheduledDate (now is $now)");

    // Don't schedule a reminder for a deadline that's already in the past.
    if (scheduledDate.isBefore(now)) {
      debugPrint("SKIPPED: deadline is in the past relative to now");
      return;
    }

    await _plugin.zonedSchedule(
      id: id,
      title: "Task due",
      body: title,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_deadlines',
          'Task deadlines',
          channelDescription: 'Reminders for to-do deadlines',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static Future<void> cancelTaskReminder(int id) async {
    await _plugin.cancel(id: id);
  }
}
