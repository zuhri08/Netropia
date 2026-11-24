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

  static const String channelId = 'netropia_headsup_channel_v3';
  static const String channelName = 'Notifikasi Netropia';
  static const String channelDesc = 'Saluran notifikasi pengingat belajar dan aktivitas Netropia';

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

      final androidImpl = _notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidImpl != null) {
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          channelId,
          channelName,
          description: channelDesc,
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        );

        await androidImpl.createNotificationChannel(channel);
        await androidImpl.requestNotificationsPermission();
        try {
          await androidImpl.requestExactAlarmsPermission();
        } catch (_) {}
      }

      final iosImpl = _notificationsPlugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (iosImpl != null) {
        await iosImpl.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    } catch (e) {
      debugPrint('Local notifications init exception: $e');
    }

    _isInitialized = true;
  }

  Future<bool> requestPermission() async {
    await init();
    bool granted = false;

    try {
      final androidImpl = _notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidImpl != null) {
        final res = await androidImpl.requestNotificationsPermission();
        granted = res ?? false;
      }

      final iosImpl = _notificationsPlugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (iosImpl != null) {
        final res = await iosImpl.requestPermissions(alert: true, badge: true, sound: true);
        granted = res ?? false;
      }
    } catch (e) {
      debugPrint('Request permission exception: $e');
    }

    return granted;
  }

  NotificationDetails _getAlarmNotificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDesc,
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.reminder,
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

  /// Menampilkan notifikasi banner di atas layar seketika
  Future<void> showBanner({
    required String title,
    required String body,
  }) async {
    await init();

    try {
      await _notificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        _getAlarmNotificationDetails(),
        payload: 'netropia_headsup',
      );
    } catch (e) {
      debugPrint('Banner notification show error: $e');
    }
  }

  /// Menampilkan notifikasi dan membunyikan alarm seketika (untuk pengujian)
  Future<void> showTestNotification({
    required String title,
    required String body,
  }) async {
    await showBanner(title: title, body: body);

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
