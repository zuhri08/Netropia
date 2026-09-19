import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/theme_manager.dart';
import '../screens/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
        title: const Text('Keluar Akun'),
        content: const Text('Apakah kamu yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Pengaturan', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSettingsGroup(
            title: 'Akun',
            items: [
              _buildSettingsItem(Icons.person_outline_rounded, 'Edit Nama', onTap: () {}),
              _buildSettingsItem(Icons.camera_alt_outlined, 'Edit Foto', onTap: () {}),
              _buildSettingsItem(Icons.email_outlined, 'Edit Email', onTap: () {}),
              _buildSettingsItem(Icons.lock_outline_rounded, 'Ubah Password', onTap: () {}),
            ],
          ),
          const SizedBox(height: 25),
          _buildSettingsGroup(
            title: 'Preferensi',
            items: [
              _buildSettingsItem(Icons.notifications_none_rounded, 'Notifikasi', onTap: () {}),
              ListenableBuilder(
                listenable: themeManager,
                builder: (context, child) {
                  return _buildSettingsItem(
                    themeManager.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    'Dark Mode',
                    trailing: Switch(
                      value: themeManager.isDarkMode,
                      onChanged: (val) => themeManager.toggleTheme(val),
                    ),
                  );
                },
              ),
              _buildSettingsItem(Icons.language_rounded, 'Bahasa', subtitle: 'Bahasa Indonesia', onTap: () {}),
            ],
          ),
          const SizedBox(height: 25),
          _buildSettingsGroup(
            title: 'Pembelajaran',
            items: [
              _buildSettingsItem(Icons.alarm_rounded, 'Pengingat Belajar', onTap: () {}),
              _buildSettingsItem(Icons.track_changes_rounded, 'Target Belajar Harian', onTap: () {}),
            ],
          ),
          const SizedBox(height: 25),
          _buildSettingsGroup(
            title: 'Keamanan',
            items: [
              _buildSettingsItem(Icons.devices_rounded, 'Login Session', onTap: () {}),
              _buildSettingsItem(Icons.logout_rounded, 'Keluar', titleColor: Colors.red, onTap: _showLogoutDialog),
            ],
          ),
          const SizedBox(height: 40),
          const Center(
            child: Text(
              "Netropia v1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
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
      leading: Icon(icon, color: titleColor ?? const Color(0xFF1565C0), size: 22),
      title: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: titleColor)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: onTap,
    );
  }
}
