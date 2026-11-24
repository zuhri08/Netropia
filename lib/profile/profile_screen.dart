import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'settings_screen.dart';
import 'edit_profile_screen.dart';
import 'help_support_screen.dart';
import 'about_app_screen.dart';
import '../progres/progres_screen.dart';
import '../services/localization_service.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final String role;

  const ProfileScreen({
    super.key,
    required this.username,
    required this.role,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _refreshProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
      }
      if (mounted) {
        setState(() {});
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: const Center(child: Text('Silakan login terlebih dahulu.')),
      );
    }

    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
            builder: (context, snapshot) {
              final userData = snapshot.data?.data() as Map<String, dynamic>? ?? {};
              
              final String nameFromDb = userData['nama']?.toString() ?? '';
              final String displayName = nameFromDb.isNotEmpty
                  ? nameFromDb
                  : (user.displayName?.isNotEmpty == true ? user.displayName! : widget.username);

              final String roleFromDb = userData['role']?.toString() ?? '';
              final String displayRole = roleFromDb.isNotEmpty ? roleFromDb : widget.role;

              final String displayEmail = user.email ?? "No Email";
              final String? photoUrl = (userData['photoUrl']?.toString().isNotEmpty == true)
                  ? userData['photoUrl']?.toString()
                  : user.photoURL;

              final String kelas = userData['kelas']?.toString() ?? '';
              final String nisn = userData['nisn']?.toString() ?? '';

              return RefreshIndicator(
                color: AppTheme.primaryTeal,
                onRefresh: _refreshProfile,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      _buildHeader(
                        context: context,
                        displayName: displayName,
                        email: displayEmail,
                        role: displayRole,
                        photoUrl: photoUrl,
                        kelas: kelas,
                        nisn: nisn,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          children: [
                            _buildStatsSection(context, userData),
                            const SizedBox(height: 22),
                            _buildTeacherAwardsSection(context, userData),
                            _buildAchievementsSection(context),
                            const SizedBox(height: 24),
                            _buildMenuSection(context, displayName, displayRole),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHeader({
    required BuildContext context,
    required String displayName,
    required String email,
    required String role,
    required String? photoUrl,
    required String kelas,
    required String nisn,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 26),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF162522), const Color(0xFF0E1A17)]
              : [AppTheme.primaryTeal, AppTheme.darkTeal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  backgroundImage: photoUrl != null && photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                  child: (photoUrl == null || photoUrl.isEmpty)
                      ? const Icon(Icons.person_rounded, size: 55, color: AppTheme.primaryTeal)
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: AppTheme.accentAmber,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit_rounded, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            email,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 13.5,
            ),
          ),
          if (kelas.isNotEmpty || nisn.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '${nisn.isNotEmpty ? "$nisn · " : ""}$kelas',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
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
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(username: displayName, role: role),
                ),
              ).then((_) => _refreshProfile());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryTeal,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
            ),
            child: Text(
              localizationService.translate('edit_profile'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, Map<String, dynamic> userData) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final int xp = userData['xp'] ?? 850;
    final int completedLessons = userData['completedLessonsCount'] ?? 12;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : AppTheme.borderCream,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Materi', '$completedLessons'),
          _buildStatDivider(isDark),
          _buildStatItem('Lab', '8'),
          _buildStatDivider(isDark),
          _buildStatItem('Jam', '14h'),
          _buildStatDivider(isDark),
          _buildStatItem('XP', '$xp'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryTeal,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted),
        ),
      ],
    );
  }

  Widget _buildStatDivider(bool isDark) {
    return Container(
      height: 28,
      width: 1,
      color: isDark ? Colors.white12 : AppTheme.borderCream,
    );
  }

  Widget _buildAchievementsSection(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'PENCAPAIAN',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildBadge(context, "Network Beginner", Icons.lan_rounded, AppTheme.primaryTeal, true),
              _buildBadge(context, "First Lesson", Icons.school_rounded, Colors.green, true),
              _buildBadge(context, "Subnet Master", Icons.calculate_rounded, AppTheme.accentAmber, false),
              _buildBadge(context, "Lab Explorer", Icons.science_rounded, Colors.purple, true),
              _buildBadge(context, "7 Day Streak", Icons.local_fire_department_rounded, AppTheme.accentRed, false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(BuildContext context, String label, IconData icon, Color color, bool unlocked) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 98,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: unlocked
            ? AppTheme.tealTint
            : (isDark ? const Color(0xFF162522) : AppTheme.surfaceCream),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: unlocked ? color.withValues(alpha: 0.3) : AppTheme.borderCream,
        ),
      ),
      child: Column(
        children: [
          Icon(unlocked ? icon : Icons.lock_outline_rounded, color: unlocked ? color : AppTheme.textMuted, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
              color: unlocked ? (isDark ? Colors.white : AppTheme.textDark) : AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, String displayName, String displayRole) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : AppTheme.borderCream,
        ),
      ),
      child: Column(
        children: [
          _buildMenuItem(context, Icons.person_outline_rounded, localizationService.translate('edit_profile'), () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfileScreen(username: displayName, role: displayRole)),
            ).then((_) => _refreshProfile());
          }),
          const Divider(height: 1, indent: 50),
          _buildMenuItem(context, Icons.trending_up_rounded, localizationService.translate('learning_progress'), () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProgresScreen()));
          }),
          const Divider(height: 1, indent: 50),
          _buildMenuItem(context, Icons.settings_outlined, localizationService.translate('settings'), () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
          }),
          const Divider(height: 1, indent: 50),
          _buildMenuItem(context, Icons.help_outline_rounded, localizationService.translate('help'), () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen()));
          }),
          const Divider(height: 1, indent: 50),
          _buildMenuItem(context, Icons.info_outline_rounded, localizationService.translate('about_netropia'), () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutAppScreen()));
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryTeal, size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : AppTheme.textDark,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: AppTheme.textMuted),
      onTap: onTap,
    );
  }

  Widget _buildTeacherAwardsSection(BuildContext context, Map<String, dynamic> userData) {
    final awards = (userData['awards'] as List<dynamic>?) ?? [];
    if (awards.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            'Apresiasi & Bintang Dari Guru ⭐',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.primaryTeal),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: awards.map((award) {
              final badge = award['badge']?.toString() ?? '⭐ Bintang Apresiasi';
              final guruName = award['guruName']?.toString() ?? 'Guru';
              final catatan = award['catatan']?.toString() ?? '';

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.star_rounded, color: AppTheme.accentAmber, size: 26),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            badge,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: AppTheme.textDark),
                          ),
                          Text(
                            'Diberikan oleh: $guruName',
                            style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                          ),
                          if (catatan.isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Text(
                              '"$catatan"',
                              style: const TextStyle(fontSize: 11.5, fontStyle: FontStyle.italic, color: AppTheme.textDark),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 22),
      ],
    );
  }
}
