import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/theme_manager.dart';
import '../screens/login_screen.dart';
import '../screens/notification_screen.dart';
import '../services/settings_service.dart';
import '../services/localization_service.dart';
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
  int _streakCount = 3;

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
              primary: Color(0xFFAD8B73),
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
      setState(() {
        _reminderTime = formattedTime;
        _isReminderEnabled = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizationService.isEnglish ? 'Reminder set to $_reminderTime' : 'Pengingat diatur ke $_reminderTime')),
        );
      }
    }
  }

  Future<void> _setDailyTarget() async {
    final TextEditingController controller = TextEditingController(text: _dailyTarget.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(localizationService.translate('daily_target_title')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(localizationService.translate('daily_target_desc')),
            const SizedBox(height: 15),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(localizationService.translate('logout_title')),
        content: Text(localizationService.translate('logout_desc')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(localizationService.translate('cancel'))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            child: Text(localizationService.translate('logout'), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showStreakInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 28),
            const SizedBox(width: 8),
            Text(localizationService.translate('streak')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$_streakCount${localizationService.translate('streak_days')} 🔥',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 10),
            Text(
              localizationService.translate('streak_desc'),
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizationService.translate('close')),
          ),
        ],
      ),
    );
  }

  void _selectLanguage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(localizationService.translate('select_language')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇮🇩', style: TextStyle(fontSize: 24)),
              title: const Text('Bahasa Indonesia'),
              trailing: localizationService.currentLanguage == 'id'
                  ? const Icon(Icons.check_rounded, color: Color(0xFFAD8B73))
                  : null,
              onTap: () async {
                await localizationService.setLanguage('id');
                if (mounted) Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              leading: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
              title: const Text('English'),
              trailing: localizationService.currentLanguage == 'en'
                  ? const Icon(Icons.check_rounded, color: Color(0xFFAD8B73))
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

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(localizationService.translate('settings'), style: const TextStyle(fontWeight: FontWeight.bold)),
            elevation: 0,
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildSettingsGroup(
                title: localizationService.translate('account'),
                items: [
                  _buildSettingsItem(Icons.person_outline_rounded, localizationService.translate('edit_name'), onTap: () {
                    final user = FirebaseAuth.instance.currentUser;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(username: user?.displayName ?? "", role: "Siswa")));
                  }),
                  _buildSettingsItem(Icons.camera_alt_outlined, localizationService.translate('edit_photo'), onTap: () {
                    final user = FirebaseAuth.instance.currentUser;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(username: user?.displayName ?? "", role: "Siswa")));
                  }),
                  _buildSettingsItem(Icons.email_outlined, localizationService.translate('edit_email'), onTap: () {}),
                  _buildSettingsItem(Icons.lock_outline_rounded, localizationService.translate('change_password'), onTap: () {}),
                ],
              ),
              const SizedBox(height: 25),
              _buildSettingsGroup(
                title: localizationService.translate('preferences'),
                items: [
                  _buildSettingsItem(
                    Icons.notifications_none_rounded,
                    localizationService.translate('notifications'),
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
                        localizationService.translate('dark_mode'),
                        trailing: Switch(
                          value: themeManager.isDarkMode,
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
                        localizationService.translate('language'),
                        subtitle: localizationService.currentLanguage == 'en' ? 'English' : 'Bahasa Indonesia',
                        onTap: _selectLanguage,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 25),
              _buildSettingsGroup(
                title: localizationService.translate('learning'),
                items: [
                  _buildSettingsItem(
                    Icons.alarm_rounded,
                    localizationService.translate('learning_reminder'),
                    subtitle: _reminderTime,
                    trailing: Switch(
                      value: _isReminderEnabled,
                      onChanged: (val) async {
                        await _settingsService.setReminderEnabled(val);
                        setState(() => _isReminderEnabled = val);
                        if (val && (_reminderTime == 'Belum diatur' || _reminderTime == 'Not set')) {
                          _selectReminderTime();
                        }
                      },
                    ),
                    onTap: _selectReminderTime,
                  ),
                  _buildSettingsItem(
                    Icons.track_changes_rounded,
                    localizationService.translate('daily_target'),
                    subtitle: '$_dailyTarget ${localizationService.isEnglish ? 'minutes per day' : 'menit per hari'}',
                    onTap: _setDailyTarget,
                  ),
                  _buildSettingsItem(
                    Icons.local_fire_department_rounded,
                    localizationService.translate('streak'),
                    subtitle: '$_streakCount${localizationService.translate('streak_days')}',
                    titleColor: Colors.orange,
                    onTap: _showStreakInfo,
                  ),
                ],
              ),
              const SizedBox(height: 25),
              _buildSettingsGroup(
                title: localizationService.translate('security'),
                items: [
                  _buildSettingsItem(Icons.devices_rounded, localizationService.translate('login_session'), onTap: () {}),
                  _buildSettingsItem(Icons.logout_rounded, localizationService.translate('logout'), titleColor: Colors.red, onTap: _showLogoutDialog),
                ],
              ),
              const SizedBox(height: 50),
              const Center(
                child: Text(
                  "Netropia v1.0.0",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsGroup({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFAD8B73))),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, {String? subtitle, Widget? trailing, Color? titleColor, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? const Color(0xFFAD8B73), size: 22),
      title: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: titleColor)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: onTap,
    );
  }
}
