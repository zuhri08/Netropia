import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'settings_screen.dart';
import 'edit_profile_screen.dart';
import '../progress/progress_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String username;
  final String role;

  const ProfileScreen({
    super.key,
    required this.username,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? "No Email";

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, email),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildStatsSection(context),
                  const SizedBox(height: 30),
                  _buildAchievementsSection(context),
                  const SizedBox(height: 30),
                  _buildMenuSection(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String email) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
            ? [const Color(0xFF2C2C2C), const Color(0xFF1E1E1E)]
            : [const Color(0xFF1565C0), const Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person_rounded, size: 60, color: Color(0xFF1565C0)),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit_rounded, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            username,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            email,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              role.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(username: username, role: role)));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1565C0),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            ),
            child: const Text("Edit Profil", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("Materi", "12"),
          _buildStatDivider(),
          _buildStatItem("Lab", "8"),
          _buildStatDivider(),
          _buildStatItem("Jam", "14h"),
          _buildStatDivider(),
          _buildStatItem("XP", "850"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(height: 30, width: 1, color: Colors.grey.withOpacity(0.2));
  }

  Widget _buildAchievementsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 5, bottom: 15),
          child: Text("Pencapaian", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildBadge("Network Beginner", Icons.lan_rounded, Colors.blue, true),
              _buildBadge("First Lesson", Icons.school_rounded, Colors.green, true),
              _buildBadge("Subnet Master", Icons.calculate_rounded, Colors.orange, false),
              _buildBadge("Lab Explorer", Icons.science_rounded, Colors.purple, true),
              _buildBadge("7 Day Streak", Icons.local_fire_department_rounded, Colors.red, false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String label, IconData icon, Color color, bool unlocked) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: unlocked ? color.withOpacity(0.08) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: unlocked ? color.withOpacity(0.2) : Colors.transparent),
      ),
      child: Column(
        children: [
          Icon(unlocked ? icon : Icons.lock_outline_rounded, color: unlocked ? color : Colors.grey, size: 30),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10, 
              fontWeight: FontWeight.bold, 
              color: unlocked ? Colors.black87 : Colors.grey
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          _buildMenuItem(context, Icons.person_outline_rounded, "Edit Profil", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(username: username, role: role)));
          }),
          _buildMenuItem(context, Icons.trending_up_rounded, "Progress Belajar", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProgressScreen()));
          }),
          _buildMenuItem(context, Icons.emoji_events_outlined, "Achievement", () {}),
          _buildMenuItem(context, Icons.history_rounded, "Riwayat Aktivitas", () {}),
          _buildMenuItem(context, Icons.settings_outlined, "Pengaturan", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
          }),
          _buildMenuItem(context, Icons.help_outline_rounded, "Bantuan", () {}),
          _buildMenuItem(context, Icons.info_outline_rounded, "Tentang Netropia", () {}),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1565C0)),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: onTap,
    );
  }
}
