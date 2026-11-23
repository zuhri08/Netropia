import 'package:flutter/material.dart';
import '../services/progress_service.dart';
import '../services/settings_service.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_pressable.dart';
import '../absensi/attendance_screen.dart';
import '../materi/materi_screen.dart';
import '../kalkulator_subnet/subnet_calculator_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../absensi/teacher_attendance_screen.dart';
import '../peminjaman/borrowing_screen.dart';
import '../devices_3d/device_3d_list_screen.dart';
import '../peminjaman/teacher_borrowing_screen.dart';
import '../project/project_screen.dart';
import '../services/localization_service.dart';
import '../teacher/teacher_panel_screen.dart';
import 'notification_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String username;
  final String role;

  const DashboardScreen({
    super.key,
    required this.username,
    required this.role,
  });

  void _openMateri(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MateriScreen(),
      ),
    );
  }

  void _openSubnetCalculator(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SubnetCalculatorScreen(),
      ),
    );
  }

  void _showStreakDialog(BuildContext context, int streak) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(
              Icons.local_fire_department_rounded,
              color: AppTheme.accentAmber,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(localizationService.translate('streak')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$streak ${localizationService.translate('streak_days')} 🔥',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.accentAmber,
              ),
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

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature ${localizationService.translate('coming_soon')}',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        final bool isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: AppTheme.primaryTeal,
            foregroundColor: Colors.white,
            elevation: 0,
            titleSpacing: 20,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  localizationService.translate('netropia'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            actions: [
              FutureBuilder<int>(
                future: SettingsService().getStreak(),
                builder: (context, snapshot) {
                  final streak = snapshot.data ?? 1;
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _showStreakDialog(context, streak),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.local_fire_department_rounded,
                                  color: AppTheme.accentAmber,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Streak $streak',
                                  style: const TextStyle(
                                    color: AppTheme.darkTeal,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 4),
              FutureBuilder<int>(
                future: NotificationService().getUnreadCount(),
                builder: (context, snapshot) {
                  final unreadCount = snapshot.data ?? 0;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.white,
                        ),
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.accentRed,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${localizationService.translate('welcome_halo')}$username',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role.toLowerCase() == 'guru'
                        ? (localizationService.isEnglish ? 'Welcome to Netropia.' : 'Selamat datang di Netropia.')
                        : 'Semangat belajar, masa depanmu dimulai dari sini.',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (role.toLowerCase() == 'guru') ...[
                    _buildTeacherManagementPanel(context),
                    _buildTeacherMonitoringCard(context),
                  ] else ...[
                    _buildAnnouncementsCard(context),
                    _buildContinueLearning(context),
                  ],
                  const SizedBox(height: 24),
                  Text(
                    'JELAJAHI NETROPIA',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.25,
                    children: [
                      _buildMenuCard(
                        context,
                        title: localizationService.translate('study_materials'),
                        subtitle: 'Pilih modul',
                        icon: Icons.menu_book_rounded,
                        iconColor: AppTheme.primaryTeal,
                        backgroundColor: AppTheme.tealTint,
                        onTap: () => _openMateri(context),
                      ),
                      _buildMenuCard(
                        context,
                        title: localizationService.translate('device_3d'),
                        subtitle: 'Eksplorasi 3D',
                        icon: Icons.view_in_ar_rounded,
                        iconColor: const Color(0xFF00897B),
                        backgroundColor: const Color(0xFFE0F2F1),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Device3DListScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuCard(
                        context,
                        title: localizationService.translate('subnet_calculator'),
                        subtitle: 'Hitung IP',
                        icon: Icons.calculate_rounded,
                        iconColor: AppTheme.accentAmber,
                        backgroundColor: const Color(0xFFFFF3E0),
                        onTap: () => _openSubnetCalculator(context),
                      ),
                      _buildMenuCard(
                        context,
                        title: localizationService.translate('attendance'),
                        subtitle: 'Presensi digital',
                        icon: Icons.fact_check_rounded,
                        iconColor: const Color(0xFF7B1FA2),
                        backgroundColor: const Color(0xFFF3E8FF),
                        onTap: () async {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user == null) return;
                          try {
                            final userDoc = await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .get();
                            final role = userDoc.data()?['role'];
                            if (!context.mounted) return;
                            if (role == 'guru') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TeacherAttendanceScreen(),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AttendanceScreen(),
                                ),
                              );
                            }
                          } catch (e) {
                            debugPrint('ERROR CEK ROLE ABSENSI: $e');
                          }
                        },
                      ),
                      _buildMenuCard(
                        context,
                        title: localizationService.translate('borrowing'),
                        subtitle: role.toLowerCase() == 'guru'
                            ? 'Kelola alat'
                            : 'Pinjam alat TKJ',
                        icon: Icons.inventory_2_rounded,
                        iconColor: const Color(0xFF0277BD),
                        backgroundColor: const Color(0xFFE3F2FD),
                        onTap: () async {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user == null) return;
                          try {
                            final userDoc = await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .get();
                            final userRole = userDoc.data()?['role'];
                            if (!context.mounted) return;
                            if (userRole == 'guru') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TeacherBorrowingScreen(),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BorrowingScreen(),
                                ),
                              );
                            }
                          } catch (e) {
                            debugPrint('ERROR CEK ROLE PEMINJAMAN: $e');
                          }
                        },
                      ),
                      _buildMenuCard(
                        context,
                        title: localizationService.translate('project'),
                        subtitle: 'Proyek praktik',
                        icon: Icons.assignment_rounded,
                        iconColor: const Color(0xFF2E7D32),
                        backgroundColor: const Color(0xFFE8F5E9),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProjectScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'AKTIVITAS TERBARU',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                          color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _showComingSoon(context, localizationService.translate('recent_activities'));
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primaryTeal,
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(localizationService.translate('see_all')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildActivityCard(
                    context,
                    icon: Icons.health_and_safety_rounded,
                    iconColor: AppTheme.primaryTeal,
                    title: 'K3LH',
                    subtitle: 'Pelajari materi TKJ',
                    time: localizationService.isEnglish ? 'Today' : 'Hari ini',
                  ),
                  const SizedBox(height: 10),
                  _buildActivityCard(
                    context,
                    icon: Icons.calculate_rounded,
                    iconColor: AppTheme.accentAmber,
                    title: localizationService.translate('subnet_calculator'),
                    subtitle: 'Hitung subnet',
                    time: localizationService.isEnglish ? 'Not used' : 'Belum digunakan',
                  ),
                  const SizedBox(height: 10),
                  _buildActivityCard(
                    context,
                    icon: Icons.fact_check_rounded,
                    iconColor: const Color(0xFF7B1FA2),
                    title: localizationService.translate('attendance'),
                    subtitle: 'Kehadiran belajar',
                    time: localizationService.isEnglish ? 'Not checked in' : 'Belum absen',
                  ),
                  const SizedBox(height: 24),
                  _buildProgressCard(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContinueLearning(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppTheme.primaryTeal,
            AppTheme.darkTeal,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryTeal.withOpacity(0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'LANJUTKAN BELAJAR',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'K3LH',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Keselamatan & Kesehatan Kerja',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                '66% selesai',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.66,
              minHeight: 6,
              backgroundColor: Color(0x44FFFFFF),
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentAmber),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () {
                _openMateri(context);
              },
              icon: const Icon(
                Icons.play_arrow_rounded,
                size: 22,
              ),
              label: const Text(
                'Lanjutkan Pembelajaran',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.darkTeal,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedPressable(
      onTap: onTap,
      scaleFactor: 0.94,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark ? iconColor.withOpacity(0.18) : backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 22,
                  ),
                ),
                const Spacer(),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.grey.shade500 : AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return FutureBuilder<int>(
      future: ProgressService().getOverallProgress(),
      builder: (context, snapshot) {
        final progress = snapshot.data ?? 0;
        final progressVal = progress / 100.0;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progress Belajar',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: CircularProgressIndicator(
                            value: progressVal,
                            strokeWidth: 7,
                            backgroundColor: isDark ? Colors.grey.shade800 : AppTheme.borderCream,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryTeal,
                            ),
                          ),
                        ),
                        Text(
                          '$progress%',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppTheme.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      'Terus tingkatkan belajarmu! Selesaikan materi dan praktik untuk meningkatkan progres belajar.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTeacherManagementPanel(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppTheme.primaryTeal,
            AppTheme.darkTeal,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.admin_panel_settings_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Panel Utama Guru',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Pusat Kelola Pembelajaran & Fasilitas TKJ',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'KELOLA PEMBELAJARAN',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _teacherActionButton(
                context,
                icon: Icons.assignment_add,
                label: 'Kelola Tugas',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeacherPanelScreen(initialTab: 'tugas'),
                    ),
                  );
                },
              ),
              _teacherActionButton(
                context,
                icon: Icons.quiz_rounded,
                label: 'Kelola Kuis',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeacherPanelScreen(initialTab: 'quiz'),
                    ),
                  );
                },
              ),
              _teacherActionButton(
                context,
                icon: Icons.note_add_rounded,
                label: 'Buat Materi',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeacherPanelScreen(initialTab: 'materi'),
                    ),
                  );
                },
              ),
              _teacherActionButton(
                context,
                icon: Icons.campaign_rounded,
                label: 'Pengumuman',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeacherPanelScreen(initialTab: 'pengumuman'),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'KELOLA KELAS & LAB TKJ',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _teacherActionButton(
                context,
                icon: Icons.rate_review_rounded,
                label: 'Ulasan & Refleksi',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeacherPanelScreen(initialTab: 'refleksi'),
                    ),
                  );
                },
              ),
              _teacherActionButton(
                context,
                icon: Icons.assessment_rounded,
                label: 'Rekap & Apresiasi',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeacherPanelScreen(initialTab: 'rekap'),
                    ),
                  );
                },
              ),
              _teacherActionButton(
                context,
                icon: Icons.fact_check_rounded,
                label: 'Sesi Absensi QR',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeacherAttendanceScreen(),
                    ),
                  );
                },
              ),
              _teacherActionButton(
                context,
                icon: Icons.inventory_2_rounded,
                label: 'Persetujuan Alat',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeacherBorrowingScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherMonitoringCard(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.borderCream),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.analytics_rounded,
                color: AppTheme.primaryTeal,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Ringkasan Monitoring Kelas Guru',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('loans')
                .where('status', isEqualTo: 'menunggu')
                .snapshots(),
            builder: (context, snapshot) {
              final pendingCount = snapshot.data?.docs.length ?? 0;
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TeacherBorrowingScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: pendingCount > 0 ? const Color(0xFFFFF3E0) : AppTheme.tealTint,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          size: 20,
                          color: pendingCount > 0 ? AppTheme.accentAmber : AppTheme.primaryTeal,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Peminjaman Alat Menunggu',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            ),
                            Text(
                              pendingCount > 0
                                  ? '$pendingCount pengajuan alat perlu disetujui Guru'
                                  : 'Tidak ada pengajuan peminjaman baru',
                              style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted),
                            ),
                          ],
                        ),
                      ),
                      if (pendingCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.accentAmber,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$pendingCount Baru',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsCard(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('announcements').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox();
        }

        final docs = List<QueryDocumentSnapshot>.from(snapshot.data!.docs);
        docs.sort((a, b) {
          final dataA = a.data() as Map<String, dynamic>;
          final dataB = b.data() as Map<String, dynamic>;
          final tsA = dataA['createdAt'];
          final tsB = dataB['createdAt'];
          DateTime dtA = (tsA is Timestamp) ? tsA.toDate() : DateTime.now();
          DateTime dtB = (tsB is Timestamp) ? tsB.toDate() : DateTime.now();
          return dtB.compareTo(dtA);
        });

        final displayDocs = docs.take(2).toList();

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppTheme.accentAmber,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.campaign_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Pengumuman Dari Guru',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF92400E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...displayDocs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['judul'] ?? 'Pengumuman',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data['isi'] ?? '',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppTheme.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _teacherActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: AppTheme.primaryTeal),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
