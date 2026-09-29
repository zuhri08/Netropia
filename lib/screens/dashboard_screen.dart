import 'package:flutter/material.dart';
import '../services/progress_service.dart';
import '../services/settings_service.dart';
import '../services/notification_service.dart';
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
    debugPrint('Membuka Kalkulator Subnet');
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
              color: Colors.orange,
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
              '$streak${localizationService.translate('streak_days')} 🔥',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
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
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: const Color(0xFFAD8B73),
            foregroundColor: Colors.white,
            elevation: 0,
            titleSpacing: 20,
            title: Row(
              children: [
                const Icon(
                  Icons.school_rounded,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Text(
                  localizationService.translate('netropia'),
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              FutureBuilder<int>(
                future: SettingsService().getStreak(),
                builder: (context, snapshot) {
                  final streak = snapshot.data ?? 3;
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
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$streak',
                                  style: const TextStyle(
                                    color: Color(0xFF5C3D2E),
                                    fontSize: 13.5,
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
                              color: Colors.redAccent,
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
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${localizationService.translate('welcome_halo')}$username 👋',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    role.toLowerCase() == 'guru'
                        ? (localizationService.isEnglish ? 'Welcome to Netropia.' : 'Selamat datang di Netropia.')
                        : localizationService.translate('welcome_subtitle'),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildContinueLearning(context),
                  const SizedBox(height: 25),
                  Text(
                    localizationService.translate('home'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 14),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.18,
                    children: [
                      _buildMenuCard(
                        context,
                        title: localizationService.translate('study_materials'),
                        subtitle: localizationService.translate('study_materials_desc'),
                        icon: Icons.menu_book_rounded,
                        iconColor: const Color(0xFFAD8B73),
                        backgroundColor: const Color(0xFFE8F1FF),
                        onTap: () {
                          _openMateri(context);
                        },
                      ),
                      _buildMenuCard(
                        context,
                        title: localizationService.translate('device_3d'),
                        subtitle: localizationService.translate('device_3d_desc'),
                        icon: Icons.view_in_ar_rounded,
                        iconColor: const Color(0xFF00897B),
                        backgroundColor: const Color(0xFFE5F7F4),
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
                        subtitle: localizationService.translate('subnet_desc'),
                        icon: Icons.calculate_rounded,
                        iconColor: const Color(0xFFE65100),
                        backgroundColor: const Color(0xFFFFF0E6),
                        onTap: () {
                          _openSubnetCalculator(context);
                        },
                      ),
                      _buildMenuCard(
                        context,
                        title: localizationService.translate('attendance'),
                        subtitle: localizationService.translate('attendance_desc'),
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
                            ? (localizationService.isEnglish ? 'Manage tool borrowing' : 'Kelola peminjaman alat')
                            : localizationService.translate('borrowing_desc'),
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
                        subtitle: localizationService.translate('project_desc'),
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
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localizationService.translate('recent_activities'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _showComingSoon(context, localizationService.translate('recent_activities'));
                        },
                        child: Text(localizationService.translate('see_all')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildActivityCard(
                    context,
                    icon: Icons.health_and_safety_rounded,
                    iconColor: const Color(0xFF2E7D32),
                    title: 'K3LH',
                    subtitle: localizationService.translate('study_materials_desc'),
                    time: localizationService.isEnglish ? 'Today' : 'Hari ini',
                  ),
                  const SizedBox(height: 10),
                  _buildActivityCard(
                    context,
                    icon: Icons.calculate_rounded,
                    iconColor: const Color(0xFFE65100),
                    title: localizationService.translate('subnet_calculator'),
                    subtitle: localizationService.translate('subnet_desc'),
                    time: localizationService.isEnglish ? 'Not used' : 'Belum digunakan',
                  ),
                  const SizedBox(height: 10),
                  _buildActivityCard(
                    context,
                    icon: Icons.fact_check_rounded,
                    iconColor: const Color(0xFF7B1FA2),
                    title: localizationService.translate('attendance'),
                    subtitle: localizationService.translate('attendance_desc'),
                    time: localizationService.isEnglish ? 'Not checked in' : 'Belum absen',
                  ),
                  const SizedBox(height: 28),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFAD8B73),
            Color(0xFFCEAB93),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAD8B73).withOpacity(0.18),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizationService.translate('continue_learning'),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white,
                  size: 28,
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
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Modul Pembelajaran',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 17,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const LinearProgressIndicator(
                    value: 0.66,
                    minHeight: 7,
                    backgroundColor: Color(0x55FFFFFF),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '66%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () {
                _openMateri(context);
              },
              icon: const Icon(
                Icons.play_circle_fill_rounded,
                size: 20,
              ),
              label: Text(
                localizationService.translate('continue_button'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFAD8B73),
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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? backgroundColor
                            : iconColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 24,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizationService.translate('learning_progress'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(
                    width: 75,
                    height: 75,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 75,
                          height: 75,
                          child: CircularProgressIndicator(
                            value: progressVal,
                            strokeWidth: 8,
                            backgroundColor: const Color(0xFFE8EDF3),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFAD8B73),
                            ),
                          ),
                        ),
                        Text(
                          '$progress%',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      localizationService.isEnglish
                          ? 'Keep improving your learning! Complete materials and practices to increase learning progress.'
                          : 'Terus tingkatkan belajarmu! Selesaikan materi dan praktik untuk meningkatkan progress belajar.',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7B8494),
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
}
