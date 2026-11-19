import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'notification_service.dart';

class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();
    } catch (e) {
      debugPrint('Timezone initialization error: $e');
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (details) {
          debugPrint('Notification clicked: ${details.payload}');
        },
      );

      final androidImplementation = _notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
        try {
          await androidImplementation.requestExactAlarmsPermission();
        } catch (_) {}
      }
    } catch (e) {
      debugPrint('Local notifications init exception: $e');
    }

    _isInitialized = true;
  }

  NotificationDetails _getAlarmNotificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      'study_reminder_channel_v2',
      'Pengingat Belajar Netropia',
      channelDescription: 'Saluran notifikasi dan alarm pengingat belajar Netropia',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      styleInformation: BigTextStyleInformation(''),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    return const NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
  }

  /// Menampilkan notifikasi dan membunyikan alarm seketika (untuk pengujian)
  Future<void> showTestNotification({
    required String title,
    required String body,
  }) async {
    await init();

    try {
      await _notificationsPlugin.show(
        888,
        title,
        body,
        _getAlarmNotificationDetails(),
        payload: 'study_reminder_test',
      );
    } catch (e) {
      debugPrint('Test notification show error: $e');
    }

    await NotificationService().addNotification(
      title: title,
      message: body,
      type: NotificationType.belajar,
      route: 'materi',
    );
  }

  /// Menjadwalkan pengingat harian pada jam & menit tertentu (misal: 19:00)
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    await init();
    await cancelReminder();

    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    try {
      tz.Location location;
      try {
        location = tz.getLocation('Asia/Jakarta');
      } catch (_) {
        location = tz.local;
      }

      final scheduledTzDate = tz.TZDateTime.from(scheduledDate, location);

      await _notificationsPlugin.zonedSchedule(
        777,
        title,
        body,
        scheduledTzDate,
        _getAlarmNotificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'study_reminder_daily',
      );
      debugPrint('Study reminder scheduled daily at $hour:$minute');
    } catch (e) {
      debugPrint('Exact alarm failed ($e), attempting inexact fallback...');
      try {
        final location = tz.local;
        final scheduledTzDate = tz.TZDateTime.from(scheduledDate, location);
        await _notificationsPlugin.zonedSchedule(
          777,
          title,
          body,
          scheduledTzDate,
          _getAlarmNotificationDetails(),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: 'study_reminder_inexact',
        );
      } catch (e2) {
        debugPrint('Fallback inexact schedule exception: $e2');
      }
    }
  }

  /// Membatalkan jadwal pengingat
  Future<void> cancelReminder() async {
    try {
      await _notificationsPlugin.cancel(777);
    } catch (_) {}
  }
}
