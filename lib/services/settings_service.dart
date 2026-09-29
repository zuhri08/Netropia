import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _reminderTimeKey = 'reminder_time';
  static const String _dailyTargetKey = 'daily_learning_target';
  static const String _isReminderEnabledKey = 'is_reminder_enabled';
  static const String _streakKey = 'learning_streak';

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
    return prefs.getInt(_streakKey) ?? 3; // Default 3 days
  }

  Future<void> setStreak(int days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_streakKey, days);
  }
}
