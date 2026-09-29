import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService extends ChangeNotifier {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;
  LocalizationService._internal();

  String _currentLanguage = 'id'; // 'id' or 'en'

  String get currentLanguage => _currentLanguage;
  bool get isEnglish => _currentLanguage == 'en';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('app_language') ?? 'id';
    notifyListeners();
  }

  Future<void> setLanguage(String langCode) async {
    if (_currentLanguage != langCode) {
      _currentLanguage = langCode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_language', langCode);
      notifyListeners();
    }
  }

  String translate(String key) {
    final Map<String, Map<String, String>> localizedValues = {
      'id': {
        'netropia': 'Netropia',
        'settings': 'Pengaturan',
        'account': 'Akun',
        'preferences': 'Preferensi',
        'learning': 'Pembelajaran',
        'security': 'Keamanan',
        'edit_name': 'Edit Nama',
        'edit_photo': 'Edit Foto',
        'edit_email': 'Edit Email',
        'change_password': 'Ubah Password',
        'notifications': 'Notifikasi',
        'dark_mode': 'Dark Mode',
        'language': 'Bahasa',
        'indonesian': 'Bahasa Indonesia',
        'english': 'English',
        'learning_reminder': 'Pengingat Belajar',
        'daily_target': 'Target Belajar Harian',
        'streak': 'Streak Belajar',
        'login_session': 'Login Session',
        'logout': 'Keluar',
        'main_menu': 'Menu Utama',
        'study_materials': 'Materi TKJ',
        'study_materials_desc': 'Pelajari materi TKJ',
        'subnet_calculator': 'Kalkulator Subnet',
        'subnet_desc': 'Hitung subnet',
        'device_3d': 'Perangkat 3D',
        'device_3d_desc': 'Eksplorasi alat TKJ',
        'attendance': 'Absen',
        'attendance_desc': 'Kehadiran belajar',
        'borrowing': 'Peminjaman',
        'borrowing_desc': 'Pinjam alat TKJ',
        'project': 'Project',
        'project_desc': 'Tugas & Project',
        'recent_activities': 'Aktivitas Terbaru',
        'see_all': 'Lihat Semua',
        'learning_progress': 'Progress Belajar',
        'continue_learning': 'Lanjutkan Belajar',
        'learning_module': 'Modul Pembelajaran',
        'continue_button': 'Lanjutkan Pembelajaran',
        'welcome_halo': 'Halo, ',
        'welcome_subtitle': 'Semangat belajar, masa depanmu dimulai dari sini.',
        'profile': 'Profil',
        'achievements': 'Pencapaian',
        'edit_profile': 'Edit Profil',
        'help': 'Bantuan',
        'about_netropia': 'Tentang Netropia',
        'mark_all_read': 'Tandai Semua Dibaca',
        'all': 'Semua',
        'no_notifications': 'Belum ada notifikasi',
        'refresh': 'Perbarui Data',
        'badges_prestasi': 'Lencana & Prestasi',
        'activity_history': 'Riwayat Aktivitas',
      },
      'en': {
        'netropia': 'Netropia',
        'settings': 'Settings',
        'account': 'Account',
        'preferences': 'Preferences',
        'learning': 'Learning',
        'security': 'Security',
        'edit_name': 'Edit Name',
        'edit_photo': 'Edit Photo',
        'edit_email': 'Edit Email',
        'change_password': 'Change Password',
        'notifications': 'Notifications',
        'dark_mode': 'Dark Mode',
        'language': 'Language',
        'indonesian': 'Bahasa Indonesia',
        'english': 'English',
        'learning_reminder': 'Learning Reminder',
        'daily_target': 'Daily Learning Target',
        'streak': 'Learning Streak',
        'login_session': 'Login Session',
        'logout': 'Logout',
        'main_menu': 'Main Menu',
        'study_materials': 'TKJ Materials',
        'study_materials_desc': 'Study TKJ materials',
        'subnet_calculator': 'Subnet Calculator',
        'subnet_desc': 'Calculate subnets',
        'device_3d': '3D Devices',
        'device_3d_desc': 'Explore TKJ tools',
        'attendance': 'Attendance',
        'attendance_desc': 'Learning attendance',
        'borrowing': 'Borrowing',
        'borrowing_desc': 'Borrow TKJ tools',
        'project': 'Projects',
        'project_desc': 'Tasks & Projects',
        'recent_activities': 'Recent Activities',
        'see_all': 'See All',
        'learning_progress': 'Learning Progress',
        'continue_learning': 'Continue Learning',
        'learning_module': 'Learning Module',
        'continue_button': 'Continue Learning',
        'welcome_halo': 'Hello, ',
        'welcome_subtitle': 'Keep learning, your future starts here.',
        'profile': 'Profile',
        'achievements': 'Achievements',
        'edit_profile': 'Edit Profile',
        'help': 'Help',
        'about_netropia': 'About Netropia',
        'mark_all_read': 'Mark All as Read',
        'all': 'All',
        'no_notifications': 'No notifications yet',
        'refresh': 'Refresh Data',
        'badges_prestasi': 'Badges & Achievements',
        'activity_history': 'Activity History',
      },
    };

    return localizedValues[_currentLanguage]?[key] ?? localizedValues['id']?[key] ?? key;
  }
}

final localizationService = LocalizationService();
