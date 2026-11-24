import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum NotificationType { belajar, peminjaman, absensi, project, system }

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  bool isRead;
  final String? route;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.route,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
        'type': type.name,
        'isRead': isRead,
        'route': route,
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
        id: json['id'],
        title: json['title'],
        message: json['message'],
        timestamp: DateTime.parse(json['timestamp']),
        type: NotificationType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => NotificationType.system,
        ),
        isRead: json['isRead'] ?? false,
        route: json['route'],
      );
}

class NotificationService {
  static const String _storageKey = 'app_notifications_v1';

  List<AppNotification> _getDefaultNotifications() {
    final now = DateTime.now();
    return [
      AppNotification(
        id: 'notif_1',
        title: 'Pengingat Belajar 🔥',
        message: 'Jangan lupa selesaikan materi K3LH untuk menjaga streak belajar kamu!',
        timestamp: now.subtract(const Duration(minutes: 15)),
        type: NotificationType.belajar,
        isRead: false,
        route: 'materi',
      ),
      AppNotification(
        id: 'notif_2',
        title: 'Project Baru Ditambahkan 📋',
        message: 'Tugas "Membangun LAN Sederhana" telah ditambahkan. Yuk kerjakan!',
        timestamp: now.subtract(const Duration(hours: 2)),
        type: NotificationType.project,
        isRead: false,
        route: 'project',
      ),
      AppNotification(
        id: 'notif_3',
        title: 'Peminjaman Disetujui 🛠️',
        message: 'Pengajuan peminjaman Tang Crimping & Cable Tester telah disetujui oleh guru.',
        timestamp: now.subtract(const Duration(hours: 5)),
        type: NotificationType.peminjaman,
        isRead: true,
        route: 'peminjaman',
      ),
      AppNotification(
        id: 'notif_4',
        title: 'Pengingat Absensi 📝',
        message: 'Sesi absensi kelas TKJ hari ini telah dibuka. Jangan lupa melakukan presensi!',
        timestamp: now.subtract(const Duration(days: 1)),
        type: NotificationType.absensi,
        isRead: true,
        route: 'absensi',
      ),
      AppNotification(
        id: 'notif_5',
        title: 'Selamat Datang di Netropia! 🎉',
        message: 'Nikmati kemudahan belajar materi TKJ, simulasi lab, dan peminjaman alat secara digital.',
        timestamp: now.subtract(const Duration(days: 2)),
        type: NotificationType.system,
        isRead: true,
      ),
    ];
  }

  Future<List<AppNotification>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString == null) {
      final defaults = _getDefaultNotifications();
      await _saveNotifications(defaults);
      return defaults;
    }

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => AppNotification.fromJson(e)).toList();
    } catch (e) {
      final defaults = _getDefaultNotifications();
      await _saveNotifications(defaults);
      return defaults;
    }
  }

  Future<void> _saveNotifications(List<AppNotification> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(notifications.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  Future<int> getUnreadCount() async {
    final notifications = await getNotifications();
    return notifications.where((n) => !n.isRead).length;
  }

  Future<void> markAsRead(String id) async {
    final notifications = await getNotifications();
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index].isRead = true;
      await _saveNotifications(notifications);
    }
  }

  Future<void> markAllAsRead() async {
    final notifications = await getNotifications();
    for (var n in notifications) {
      n.isRead = true;
    }
    await _saveNotifications(notifications);
  }

  Future<void> deleteNotification(String id) async {
    final notifications = await getNotifications();
    notifications.removeWhere((n) => n.id == id);
    await _saveNotifications(notifications);
  }

  Future<void> addNotification({
    required String title,
    required String message,
    required NotificationType type,
    String? route,
  }) async {
    final notifications = await getNotifications();
    final newNotif = AppNotification(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      timestamp: DateTime.now(),
      type: type,
      isRead: false,
      route: route,
    );
    notifications.insert(0, newNotif);
    await _saveNotifications(notifications);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
