import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  Future<bool> isLessonCompleted(String lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('progress_$lessonId') ?? false;
  }

  Future<void> setLessonCompleted(String lessonId, [bool completed = true]) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('progress_$lessonId', completed);
  }
}
