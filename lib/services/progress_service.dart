import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const String _activityKey = 'recent_activities';

  Future<bool> isLessonCompleted(String lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('progress_$lessonId') ?? false;
  }

  Future<void> setLessonCompleted(String lessonId, [bool completed = true]) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('progress_$lessonId', completed);
  }

  Future<int> getOverallProgress() async {
    final lessonIds = [
      'pengertian_jaringan',
      'tujuan_manfaat_jaringan',
      'cara_kerja_jaringan',
      'jenis_jaringan',
      'topologi_jaringan',
      'protokol_jaringan',
      'keamanan_jaringan',
      'penerapan_jaringan',
    ];

    int completed = 0;

    for (final lessonId in lessonIds) {
      final isCompleted = await isLessonCompleted(lessonId);
      if (isCompleted) {
        completed++;
      }
    }

    if (lessonIds.isEmpty) {
      return 0;
    }

    return ((completed / lessonIds.length) * 100).round();
  }

  Future<void> saveActivity({
    required String title,
    required String subtitle,
    required String time,
    required String type,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final activities = prefs.getStringList(_activityKey) ?? [];

    final activity = [title, subtitle, time, type].join('|||');

    activities.removeWhere((item) => item.startsWith('$title|||'));
    activities.insert(0, activity);

    if (activities.length > 10) {
      activities.removeRange(10, activities.length);
    }

    await prefs.setStringList(_activityKey, activities);
  }

  Future<List<Map<String, String>>> getRecentActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final activities = prefs.getStringList(_activityKey) ?? [];

    return activities.map((item) {
      final parts = item.split('|||');
      return {
        'title': parts.isNotEmpty ? parts[0] : '',
        'subtitle': parts.length > 1 ? parts[1] : '',
        'time': parts.length > 2 ? parts[2] : '',
        'type': parts.length > 3 ? parts[3] : '',
      };
    }).toList();
  }

  Future<void> clearActivities() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activityKey);
  }
}
