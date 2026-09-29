import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const String _activityKey = 'recent_activities';

  static const List<String> modules = [
    'k3',
    'komponen_komputer',
    'perangkat_jaringan',
    'dasar_jaringan',
    'ip_address',
    'kabel_jaringan',
  ];

  static const List<String> featureSuffixes = [
    'pre_test',
    'post_test',
    'penugasan',
    'portofolio',
    'peta_konsep',
    'forum_diskusi',
    'evaluasi',
  ];

  Future<bool> isLessonCompleted(String lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('progress_$lessonId') ?? false;
  }

  Future<void> setLessonCompleted(String lessonId, [bool completed = true]) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('progress_$lessonId', completed);
  }

  Future<int> getOverallProgress() async {
    final List<String> allKeys = [];

    // All module features
    for (final module in modules) {
      for (final suffix in featureSuffixes) {
        allKeys.add('${module}_$suffix');
      }
    }

    // Legacy dasar_jaringan sub-lessons
    allKeys.addAll([
      'pengertian_jaringan',
      'tujuan_manfaat_jaringan',
      'cara_kerja_jaringan',
      'jenis_jaringan',
      'topologi_jaringan',
      'protokol_jaringan',
      'keamanan_jaringan',
      'penerapan_jaringan',
    ]);

    int completedCount = 0;

    for (final key in allKeys) {
      final isDone = await isLessonCompleted(key);
      if (isDone) {
        completedCount++;
      }
    }

    if (allKeys.isEmpty) {
      return 0;
    }

    return ((completedCount / allKeys.length) * 100).round();
  }

  Future<int> getModuleProgress(String materiId) async {
    final List<String> keys = featureSuffixes.map((s) => '${materiId}_$s').toList();
    int completedCount = 0;

    for (final key in keys) {
      if (await isLessonCompleted(key)) {
        completedCount++;
      }
    }

    if (keys.isEmpty) return 0;
    return ((completedCount / keys.length) * 100).round();
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

    if (activities.length > 15) {
      activities.removeRange(15, activities.length);
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
