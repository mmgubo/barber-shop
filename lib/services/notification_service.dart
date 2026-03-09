import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import '../models/appointment.dart';

class NotificationService {
  static const _channelId = 'appointment_reminders';
  static const _channelName = 'Appointment Reminders';
  static const _channelDesc =
      'Reminders for upcoming barber shop appointments';

  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  // ── Init ───────────────────────────────────────────────────────

  static Future<void> init() async {
    if (_initialized) return;
    // Notifications are not supported on web
    if (kIsWeb) return;

    tz_data.initializeTimeZones();
    try {
      final localTz = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localTz));
    } catch (_) {
      // Fall back to UTC
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
    _initialized = true;
  }

  // ── Permissions ────────────────────────────────────────────────

  /// Requests notification permission. Returns true if granted.
  static Future<bool> requestPermission() async {
    if (kIsWeb) return false;

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return true;
  }

  // ── Scheduling ─────────────────────────────────────────────────

  /// Schedules a 24-hour and 1-hour reminder for [appointment].
  /// Silently skips any reminder whose time has already passed.
  static Future<void> scheduleReminders(Appointment appointment) async {
    if (!_initialized) return;

    final apptTime = _parseTime(appointment);
    if (apptTime == null) return;

    final now = DateTime.now();
    final barberLabel = appointment.barber != null
        ? 'with ${appointment.barber!.name}'
        : 'at The Sharp Edge';

    // 24-hour reminder
    final at24h = apptTime.subtract(const Duration(hours: 24));
    if (at24h.isAfter(now)) {
      await _zonedSchedule(
        id: _idFor(appointment.id, 0),
        title: 'Appointment Tomorrow',
        body:
            '${appointment.service.name} $barberLabel at ${appointment.time}. See you then!',
        at: at24h,
      );
    }

    // 1-hour reminder
    final at1h = apptTime.subtract(const Duration(hours: 1));
    if (at1h.isAfter(now)) {
      await _zonedSchedule(
        id: _idFor(appointment.id, 1),
        title: 'Starting in 1 Hour',
        body:
            '${appointment.service.name} $barberLabel at ${appointment.time}. Don\'t forget!',
        at: at1h,
      );
    }
  }

  /// Cancels both reminders for the given appointment ID.
  static Future<void> cancelReminders(String appointmentId) async {
    if (!_initialized) return;
    await _plugin.cancel(_idFor(appointmentId, 0));
    await _plugin.cancel(_idFor(appointmentId, 1));
  }

  /// Cancels every scheduled notification.
  static Future<void> cancelAll() async {
    if (!_initialized) return;
    await _plugin.cancelAll();
  }

  // ── Private helpers ────────────────────────────────────────────

  static Future<void> _zonedSchedule({
    required int id,
    required String title,
    required String body,
    required DateTime at,
  }) async {
    final tzTime = tz.TZDateTime.from(at, tz.local);
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      NotificationDetails(
        android: const AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Parses the appointment's date + time string into a [DateTime].
  /// Handles "10:30 AM" / "2:00 PM" format.
  static DateTime? _parseTime(Appointment a) {
    try {
      final parts = a.time.trim().split(' ');
      final tp = parts[0].split(':');
      int hour = int.parse(tp[0]);
      final minute = int.parse(tp[1]);
      if (parts[1].toUpperCase() == 'PM' && hour != 12) hour += 12;
      if (parts[1].toUpperCase() == 'AM' && hour == 12) hour = 0;
      return DateTime(a.date.year, a.date.month, a.date.day, hour, minute);
    } catch (_) {
      return null;
    }
  }

  /// Produces a stable 32-bit-safe notification ID.
  /// [slot] 0 = 24h reminder, 1 = 1h reminder.
  static int _idFor(String appointmentId, int slot) =>
      (appointmentId.hashCode.abs() % 100000000) * 10 + slot;
}
