import 'package:shared_preferences/shared_preferences.dart';
import 'local_notification_service.dart';

class SettingsService {
  static const String _reminderTimeKey = 'reminder_time';
  static const String _dailyTargetKey = 'daily_learning_target';
  static const String _isReminderEnabledKey = 'is_reminder_enabled';
  static const String _streakKey = 'learning_streak';
  static const String _lastLoginDateKey = 'last_login_date';

  Future<void> setReminderTime(String time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_reminderTimeKey, time);
  }

  Future<String?> getReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_reminderTimeKey);
  }

  Future<void> setDailyTarget(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dailyTargetKey, minutes);
  }

  Future<int> getDailyTarget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_dailyTargetKey) ?? 30; // Default 30 minutes
  }

  Future<void> setReminderEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isReminderEnabledKey, enabled);
  }

  Future<bool> isReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isReminderEnabledKey) ?? false;
  }

  Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 1;
  }

  Future<void> setStreak(int days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_streakKey, days);
  }

  /// Memeriksa dan memperbarui streak belajar HANYA PADA HARI YANG BERBEDA.
  /// - Jika siswa membuka aplikasi di hari yang sama: streak tetap (tidak bertambah).
  /// - Jika siswa membuka aplikasi di hari berikutnya (1 hari berbeda): streak bertambah +1.
  /// - Jika terlewat > 1 hari: streak di-reset kembali ke 1.
  Future<int> checkAndUpdateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final lastLoginStr = prefs.getString(_lastLoginDateKey);
    int currentStreak = prefs.getInt(_streakKey) ?? 1;

    if (lastLoginStr == null) {
      // Pertama kali membuka aplikasi
      currentStreak = 1;
      await prefs.setInt(_streakKey, currentStreak);
      await prefs.setString(_lastLoginDateKey, todayStr);
    } else if (lastLoginStr != todayStr) {
      // Membuka aplikasi di HARI YANG BERBEDA
      try {
        final lastParts = lastLoginStr.split('-');
        final lastDate = DateTime(
          int.parse(lastParts[0]),
          int.parse(lastParts[1]),
          int.parse(lastParts[2]),
        );

        final todayDateOnly = DateTime(now.year, now.month, now.day);
        final diffDays = todayDateOnly.difference(lastDate).inDays;

        if (diffDays == 1) {
          // Kemarin aktif, hari ini aktif -> Tambah 1
          currentStreak += 1;
        } else if (diffDays > 1) {
          // Terlewat lebih dari 1 hari -> Reset ke 1
          currentStreak = 1;
        }

        await prefs.setInt(_streakKey, currentStreak);
        await prefs.setString(_lastLoginDateKey, todayStr);
      } catch (e) {
        currentStreak += 1;
        await prefs.setInt(_streakKey, currentStreak);
        await prefs.setString(_lastLoginDateKey, todayStr);
      }
    }

    _scheduleStreakWarningNotification(currentStreak);

    return currentStreak;
  }

  /// Menjadwalkan pengingat harian pada jam 19:00 untuk mengingatkan jika streak belum aktif.
  Future<void> _scheduleStreakWarningNotification(int streakCount) async {
    try {
      await LocalNotificationService().scheduleDailyReminder(
        hour: 19, // Jam 7 malam
        minute: 0,
        title: 'Streak Belajar Terancam! 🔥',
        body: 'Kamu belum belajar di Netropia hari ini! Buka aplikasi sekarang agar streak $streakCount hari kamu tidak terputus.',
      );
    } catch (_) {}
  }
}
