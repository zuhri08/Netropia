import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/theme_manager.dart';
import '../theme/app_theme.dart';
import '../screens/login_screen.dart';
import '../screens/notification_screen.dart';
import '../services/settings_service.dart';
import '../services/localization_service.dart';
import '../services/local_notification_service.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settingsService = SettingsService();
  String _reminderTime = 'Belum diatur';
  int _dailyTarget = 30;
  bool _isReminderEnabled = false;
  int _streakCount = 1;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final time = await _settingsService.getReminderTime();
    final target = await _settingsService.getDailyTarget();
    final enabled = await _settingsService.isReminderEnabled();
    final streak = await _settingsService.getStreak();
    setState(() {
      _reminderTime = time ?? (localizationService.isEnglish ? 'Not set' : 'Belum diatur');
      _dailyTarget = target;
      _isReminderEnabled = enabled;
      _streakCount = streak;
    });
  }

  Future<void> _selectReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryBrown,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedTime = picked.format(context);
      await _settingsService.setReminderTime(formattedTime);
      await _settingsService.setReminderEnabled(true);

      await LocalNotificationService().scheduleDailyReminder(
        hour: picked.hour,
        minute: picked.minute,
        title: 'Pengingat Belajar Netropia 🔥',
        body: 'Waktunya belajar! Selesaikan materi TKJ dan jaga streak belajar kamu hari ini.',
      );

      setState(() {
        _reminderTime = formattedTime;
        _isReminderEnabled = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizationService.isEnglish
                ? 'Reminder set to $_reminderTime & scheduled!'
                : 'Pengingat diatur ke $_reminderTime & alarm dijadwalkan!'),
          ),
        );
      }
    }
  }

  Future<void> _setDailyTarget() async {
    final TextEditingController controller = TextEditingController(text: _dailyTarget.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(localizationService.translate('daily_target_title')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(localizationService.translate('daily_target_desc')),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                suffixText: localizationService.isEnglish ? 'minutes' : 'menit',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(localizationService.translate('cancel'))),
          TextButton(
            onPressed: () async {
              final val = int.tryParse(controller.text);
              if (val != null && val > 0) {
                await _settingsService.setDailyTarget(val);
                setState(() => _dailyTarget = val);
                if (mounted) Navigator.pop(context);
              }
            },
            child: Text(localizationService.translate('save')),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal keluar: $e')));
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(localizationService.translate('logout_title')),
        content: Text(localizationService.translate('logout_desc')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(localizationService.translate('cancel'))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            child: Text(localizationService.translate('logout'), style: const TextStyle(color: AppTheme.accentRed)),
          ),
        ],
      ),
    );
  }

  void _selectLanguage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(localizationService.translate('select_language')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇮🇩', style: TextStyle(fontSize: 22)),
              title: const Text('Bahasa Indonesia'),
              trailing: localizationService.currentLanguage == 'id'
                  ? const Icon(Icons.check_rounded, color: AppTheme.primaryBrown)
                  : null,
              onTap: () async {
                await localizationService.setLanguage('id');
                if (mounted) Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              leading: const Text('🇬🇧', style: TextStyle(fontSize: 22)),
              title: const Text('English'),
              trailing: localizationService.currentLanguage == 'en'
                  ? const Icon(Icons.check_rounded, color: AppTheme.primaryBrown)
                  : null,
              onTap: () async {
                await localizationService.setLanguage('en');
                if (mounted) Navigator.pop(context);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditEmailDialog() {
    final user = FirebaseAuth.instance.currentUser;
    final emailController = TextEditingController(text: user?.email ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Edit Email Akun'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Masukkan email baru kamu. Tautan verifikasi akan dikirim ke email tersebut.', style: TextStyle(fontSize: 12.5, color: AppTheme.textMuted)),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Baru',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              final newEmail = emailController.text.trim();
              if (newEmail.isNotEmpty && user != null) {
                try {
                  await user.verifyBeforeUpdateEmail(newEmail);
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Email verifikasi dikirim ke $newEmail.'), behavior: SnackBarBehavior.floating),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal memperbarui email: $e'), behavior: SnackBarBehavior.floating),
                    );
                  }
                }
              }
            },
            child: const Text('Kirim Verifikasi'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final user = FirebaseAuth.instance.currentUser;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Ubah Password'),
        content: Text('Tautan reset password akan dikirimkan ke email terdaftar (${user?.email ?? "-"}). Apakah kamu yakin?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              if (user?.email != null) {
                await FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email!);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email reset password berhasil dikirim! Silakan cek email kamu.'), behavior: SnackBarBehavior.floating),
                  );
                }
              }
            },
            child: const Text('Kirim Email Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text('Pengaturan', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: AppTheme.primaryBrown,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 50),
            children: [
              _buildSettingsGroup(
                title: 'AKUN',
                items: [
                  _buildSettingsItem(Icons.person_outline_rounded, 'Edit Nama', onTap: () {
                    final user = FirebaseAuth.instance.currentUser;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(username: user?.displayName ?? "", role: "Siswa")));
                  }),
                  _buildSettingsItem(Icons.camera_alt_outlined, 'Edit Foto', onTap: () {
                    final user = FirebaseAuth.instance.currentUser;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(username: user?.displayName ?? "", role: "Siswa")));
                  }),
                  _buildSettingsItem(Icons.email_outlined, 'Edit Email', onTap: _showEditEmailDialog),
                  _buildSettingsItem(Icons.lock_outline_rounded, 'Ubah Password', onTap: _showChangePasswordDialog),
                ],
              ),
              const SizedBox(height: 22),
              _buildSettingsGroup(
                title: 'PREFERENSI',
                items: [
                  _buildSettingsItem(
                    Icons.notifications_none_rounded,
                    'Notifikasi',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationScreen(),
                        ),
                      );
                    },
                  ),
                  ListenableBuilder(
                    listenable: themeManager,
                    builder: (context, child) {
                      return _buildSettingsItem(
                        themeManager.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        'Dark Mode',
                        trailing: Switch(
                          value: themeManager.isDarkMode,
                          activeColor: AppTheme.primaryBrown,
                          onChanged: (val) => themeManager.toggleTheme(val),
                        ),
                      );
                    },
                  ),
                  ListenableBuilder(
                    listenable: localizationService,
                    builder: (context, child) {
                      return _buildSettingsItem(
                        Icons.language_rounded,
                        'Bahasa',
                        subtitle: localizationService.currentLanguage == 'en' ? 'English' : 'Bahasa Indonesia',
                        onTap: _selectLanguage,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 22),
              _buildSettingsGroup(
                title: 'PEMBELAJARAN',
                items: [
                  _buildSettingsItem(
                    Icons.alarm_rounded,
                    'Pengingat Belajar',
                    subtitle: _reminderTime,
                    trailing: Switch(
                      value: _isReminderEnabled,
                      activeColor: AppTheme.primaryBrown,
                      onChanged: (val) async {
                        await _settingsService.setReminderEnabled(val);
                        setState(() => _isReminderEnabled = val);
                        if (!val) {
                          await LocalNotificationService().cancelReminder();
                        } else if (_reminderTime == 'Belum diatur' || _reminderTime == 'Not set') {
                          _selectReminderTime();
                        }
                      },
                    ),
                    onTap: _selectReminderTime,
                  ),
                  _buildSettingsItem(
                    Icons.track_changes_rounded,
                    'Target Belajar Harian',
                    subtitle: '$_dailyTarget menit per hari',
                    onTap: _setDailyTarget,
                  ),
                  _buildSettingsItem(
                    Icons.local_fire_department_rounded,
                    'Streak Belajar',
                    subtitle: '$_streakCount Hari Berturut-turut',
                    titleColor: AppTheme.accentAmber,
                  ),
                ],
              ),
              const SizedBox(height: 22),
              _buildSettingsGroup(
                title: 'KEAMANAN',
                items: [
                  _buildSettingsItem(Icons.logout_rounded, 'Keluar dari Akun', titleColor: AppTheme.accentRed, onTap: _showLogoutDialog),
                ],
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  "Netropia v1.0.0",
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsGroup({required String title, required List<Widget> items}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
            ),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, {String? subtitle, Widget? trailing, Color? titleColor, VoidCallback? onTap}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Icon(icon, color: titleColor ?? AppTheme.primaryBrown, size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w500,
          color: titleColor ?? (isDark ? Colors.white : AppTheme.textDark),
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded, size: 20, color: AppTheme.textMuted),
      onTap: onTap,
    );
  }
}
