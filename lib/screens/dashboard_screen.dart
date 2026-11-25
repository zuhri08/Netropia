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
import '../materi/dasar_jaringan/portofolio_screen.dart';
import '../services/localization_service.dart';
import '../teacher/teacher_assignment_screen.dart';
import '../teacher/teacher_quiz_screen.dart';
import '../teacher/teacher_material_screen.dart';
import '../teacher/teacher_announcement_screen.dart';
import '../teacher/teacher_reflection_screen.dart';
import '../teacher/teacher_gradebook_screen.dart';
import '../teacher/teacher_results_screen.dart';
import 'notification_screen.dart';
import '../widgets/home_effects.dart';

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
            title: FadeSlideIn(
              offset: const Offset(-24, 0),
              child: Row(
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
                                const Pulse(
                                  child: Icon(
                                    Icons.local_fire_department_rounded,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
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
                        icon: unreadCount > 0
                            ? const RingingBell(
                                child: Icon(Icons.notifications_none_rounded),
                              )
                            : const Icon(Icons.notifications_none_rounded),
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Pulse(
                            minScale: 0.75,
                            maxScale: 1.3,
                            child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
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
          body: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: MediaQuery.of(context).padding.bottom,
                child: const AnimatedBackdrop(),
              ),
              SafeArea(
                child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeSlideIn(
                    offset: const Offset(0, 18),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${localizationService.translate('welcome_halo')}$username ',
                          ),
                          const WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: WavingHand(fontSize: 25),
                          ),
                        ],
                      ),
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 120),
                    offset: const Offset(0, 14),
                    child: Text(
                    role.toLowerCase() == 'guru'
                        ? (localizationService.isEnglish ? 'Welcome to Netropia.' : 'Selamat datang di Netropia.')
                        : localizationService.translate('welcome_subtitle'),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  ),
                  const SizedBox(height: 20),
                  if (role.toLowerCase() == 'guru') ...[
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 150),
                      child: _buildTeacherManagementPanel(context),
                    ),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 320),
                      child: _buildTeacherMonitoringCard(context),
                    ),
                  ] else ...[
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 150),
                      child: _buildAnnouncementsCard(context),
                    ),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 280),
                      child: _buildContinueLearning(context),
                    ),
                  ],
                  const SizedBox(height: 25),
                  _buildSectionLabel(
                    context,
                    localizationService.isEnglish ? 'Learn & Practice' : 'Belajar & Praktik',
                    0,
                  ),
                  const SizedBox(height: 12),
                      _buildFeaturedMenuCard(
                        context,
                        index: 0,
                        title: localizationService.translate('study_materials'),
                        subtitle: localizationService.translate('study_materials_desc'),
                        icon: Icons.menu_book_rounded,
                        iconColor: const Color(0xFFAD8B73),
                        backgroundColor: const Color(0xFFF4EBE8),
                        onTap: () {
                          _openMateri(context);
                        },
                      ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.08,
                    children: [
                      _buildMenuCard(
                        context,
                        index: 1,
                        title: localizationService.translate('device_3d'),
                        subtitle: localizationService.translate('device_3d_desc'),
                        icon: Icons.view_in_ar_rounded,
                        iconColor: const Color(0xFFB08968),
                        backgroundColor: const Color(0xFFF5EBE6),
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
                        index: 2,
                        title: localizationService.translate('subnet_calculator'),
                        subtitle: localizationService.translate('subnet_desc'),
                        icon: Icons.calculate_rounded,
                        iconColor: const Color(0xFF8E6F5B),
                        backgroundColor: const Color(0xFFF0EBE1),
                        onTap: () {
                          _openSubnetCalculator(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSectionLabel(
                    context,
                    localizationService.isEnglish ? 'Class Activities' : 'Aktivitas Kelas',
                    3,
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.08,
                    children: [
                      _buildMenuCard(
                        context,
                        index: 3,
                        title: localizationService.translate('attendance'),
                        subtitle: localizationService.translate('attendance_desc'),
                        icon: Icons.fact_check_rounded,
                        iconColor: const Color(0xFF5C3D2E),
                        backgroundColor: const Color(0xFFEAE0D5),
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
                        index: 4,
                        title: localizationService.translate('borrowing'),
                        subtitle: role.toLowerCase() == 'guru'
                            ? (localizationService.isEnglish ? 'Manage tool borrowing' : 'Kelola peminjaman alat')
                            : localizationService.translate('borrowing_desc'),
                        icon: Icons.inventory_2_rounded,
                        iconColor: const Color(0xFF9C6644),
                        backgroundColor: const Color(0xFFF3ECE4),
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
                        index: 5,
                        title: localizationService.translate('project'),
                        subtitle: localizationService.translate('project_desc'),
                        icon: Icons.assignment_rounded,
                        iconColor: const Color(0xFF7F5539),
                        backgroundColor: const Color(0xFFEFECE6),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProjectScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuCard(
                        context,
                        index: 6,
                        title: localizationService.translate('portofolio'),
                        subtitle: localizationService.isEnglish
                            ? 'Your work & results'
                            : 'Karya & hasil belajarmu',
                        icon: Icons.workspace_premium_rounded,
                        iconColor: const Color(0xFF6F4E37),
                        backgroundColor: const Color(0xFFF1E6DC),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PortofolioScreen(),
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
                    index: 0,
                    icon: Icons.health_and_safety_rounded,
                    iconColor: const Color(0xFFAD8B73),
                    title: 'K3LH',
                    subtitle: localizationService.translate('study_materials_desc'),
                    time: localizationService.isEnglish ? 'Today' : 'Hari ini',
                  ),
                  const SizedBox(height: 10),
                  _buildActivityCard(
                    context,
                    index: 1,
                    icon: Icons.calculate_rounded,
                    iconColor: const Color(0xFFB08968),
                    title: localizationService.translate('subnet_calculator'),
                    subtitle: localizationService.translate('subnet_desc'),
                    time: localizationService.isEnglish ? 'Not used' : 'Belum digunakan',
                  ),
                  const SizedBox(height: 10),
                  _buildActivityCard(
                    context,
                    index: 2,
                    icon: Icons.fact_check_rounded,
                    iconColor: const Color(0xFF8E6F5B),
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildContinueLearning(BuildContext context) {
    return AnimatedHeroCard(
      colors: const [
        Color(0xFFAD8B73),
        Color(0xFFCEAB93),
      ],
      borderRadius: 20,
      padding: const EdgeInsets.all(18),
      shadowColor: const Color(0xFFAD8B73),
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
                child: const Floating(
                  amplitude: 3,
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
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
              const Floating(
                axis: Axis.horizontal,
                amplitude: 3,
                duration: Duration(milliseconds: 1400),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 17,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 0.66),
                    duration: const Duration(milliseconds: 2200),
                    curve: const Interval(0.35, 1.0, curve: Curves.easeOutCubic),
                    builder: (context, value, _) => LinearProgressIndicator(
                      value: value,
                      minHeight: 7,
                      backgroundColor: const Color(0x55FFFFFF),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const CountUpText(
                value: 66,
                suffix: '%',
                duration: Duration(milliseconds: 2200),
                curve: Interval(0.35, 1.0, curve: Curves.easeOutCubic),
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

  Widget _buildSectionLabel(BuildContext context, String text, int index) {
    return FadeSlideIn(
      delay: Duration(milliseconds: 380 + index * 90),
      offset: const Offset(-20, 0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0xFFAD8B73),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              color: const Color(0xFFAD8B73).withOpacity(0.18),
            ),
          ),
        ],
      ),
    );
  }

  // Gaya tiap kartu menu: latar putih -> krem pastel, aksen warna hangat.
  // (accent, accentLight, tint)
  static const List<_MenuStyle> _menuStyles = [
    _MenuStyle(Color(0xFFA9623F), Color(0xFFDB9570), Color(0xFFFBE6D8)), // 0 Materi TKJ - terakota
    _MenuStyle(Color(0xFFB07F2F), Color(0xFFD9AC57), Color(0xFFFBEFCF)), // 1 Perangkat 3D - madu
    _MenuStyle(Color(0xFFAE6A66), Color(0xFFDA9E98), Color(0xFFF9E0DC)), // 2 Subnet - rose
    _MenuStyle(Color(0xFF8C6D5A), Color(0xFFBC9C86), Color(0xFFF1E5DC)), // 3 Absensi - mocha
    _MenuStyle(Color(0xFF9B7A4A), Color(0xFFC9AA7A), Color(0xFFF4EAD5)), // 4 Peminjaman - emas pasir
    _MenuStyle(Color(0xFF7E5C47), Color(0xFFAB8770), Color(0xFFEFE2D9)), // 5 Projek - kopi
    _MenuStyle(Color(0xFFA67C57), Color(0xFFD2AC85), Color(0xFFF6E8D8)), // 6 Portofolio - latte
  ];

  List<Color> _cardBg(BuildContext context, _MenuStyle st) {
    if (Theme.of(context).brightness == Brightness.dark) {
      final base = Theme.of(context).cardColor;
      return [
        Color.alphaBlend(st.accent.withOpacity(0.10), base),
        Color.alphaBlend(st.accent.withOpacity(0.22), base),
      ];
    }
    return [Colors.white, st.tint];
  }

  Color _cardTitle(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : const Color(0xFF4A3428);

  Color _cardSub(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white70
          : const Color(0xFF8A7366);

  Widget _decorCircle(double size, double opacity, [Color color = Colors.white]) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(opacity),
      ),
    );
  }

  Widget _decorRing(double size, double opacity, [Color color = Colors.white]) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(opacity), width: 12),
      ),
    );
  }

  /// Kartu lebar untuk menu utama (Materi TKJ).
  Widget _buildFeaturedMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required VoidCallback onTap,
    int index = 0,
  }) {
    final st = _menuStyles[index % _menuStyles.length];
    final delay = Duration(milliseconds: 420 + index * 90);

    return FadeSlideIn(
      delay: delay,
      offset: const Offset(0, 30),
      scaleFrom: 0.94,
      duration: const Duration(milliseconds: 650),
      child: PressScale(
        pressedScale: 0.97,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: _cardBg(context, st),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: st.accent.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: st.accent.withOpacity(0.2),
                blurRadius: 18,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                splashColor: st.accent.withOpacity(0.15),
                highlightColor: st.accent.withOpacity(0.06),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -40,
                      child: _decorCircle(140, 0.10, st.accent),
                    ),
                    Positioned(
                      right: 70,
                      bottom: -34,
                      child: _decorCircle(70, 0.07, st.accentLight),
                    ),
                    Positioned(
                      right: -8,
                      bottom: -26,
                      child: Floating(
                        amplitude: 4,
                        duration: const Duration(milliseconds: 3400),
                        child: Icon(
                          icon,
                          size: 128,
                          color: st.accent.withOpacity(0.11),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          FadeSlideIn(
                            delay: delay + const Duration(milliseconds: 250),
                            offset: Offset.zero,
                            scaleFrom: 0.2,
                            curve: Curves.elasticOut,
                            duration: const Duration(milliseconds: 900),
                            child: Container(
                              width: 66,
                              height: 66,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [st.accentLight, st.accent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: st.accent.withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Icon(icon, color: Colors.white, size: 36),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: _cardTitle(context),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  subtitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    height: 1.25,
                                    color: _cardSub(context),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [st.accentLight, st.accent],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: st.accent.withOpacity(0.35),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        localizationService.isEnglish
                                            ? 'Start learning'
                                            : 'Mulai belajar',
                                        style: const TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Floating(
                                        axis: Axis.horizontal,
                                        amplitude: 2,
                                        duration: Duration(milliseconds: 1200),
                                        child: Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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

  /// Kartu kecil terang (grid 2 kolom).
  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required VoidCallback onTap,
    int index = 0,
  }) {
    final st = _menuStyles[index % _menuStyles.length];
    final delay = Duration(milliseconds: 420 + index * 90);

    return FadeSlideIn(
      delay: delay,
      offset: const Offset(0, 34),
      scaleFrom: 0.88,
      duration: const Duration(milliseconds: 650),
      child: PressScale(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              colors: _cardBg(context, st),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: st.accent.withOpacity(0.18)),
            boxShadow: [
              BoxShadow(
                color: st.accent.withOpacity(0.18),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                splashColor: st.accent.withOpacity(0.15),
                highlightColor: st.accent.withOpacity(0.06),
                child: Stack(
                  children: [
                    Positioned(
                      right: -24,
                      top: -26,
                      child: index.isEven
                          ? _decorCircle(96, 0.10, st.accent)
                          : _decorRing(96, 0.10, st.accent),
                    ),
                    Positioned(
                      right: 34,
                      top: 52,
                      child: _decorCircle(24, 0.09, st.accentLight),
                    ),
                    Positioned(
                      right: -14,
                      bottom: -16,
                      child: Floating(
                        amplitude: 3,
                        duration: Duration(milliseconds: 2800 + index * 350),
                        child: Icon(
                          icon,
                          size: 72,
                          color: st.accent.withOpacity(0.11),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FadeSlideIn(
                                delay: delay + const Duration(milliseconds: 250),
                                offset: Offset.zero,
                                scaleFrom: 0.2,
                                curve: Curves.elasticOut,
                                duration: const Duration(milliseconds: 900),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                      colors: [st.accentLight, st.accent],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: st.accent.withOpacity(0.35),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    icon,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: st.accent.withOpacity(0.14),
                                ),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 16,
                                  color: st.accent,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: _cardTitle(context),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5,
                              height: 1.25,
                              color: _cardSub(context),
                            ),
                          ),
                        ],
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
    int index = 0,
  }) {
    return FadeSlideIn(
      delay: Duration(milliseconds: 1000 + index * 110),
      offset: const Offset(40, 0),
      child: Container(
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
    ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return FutureBuilder<int>(
      future: ProgressService().getOverallProgress(),
      builder: (context, snapshot) {
        final progress = snapshot.data ?? 0;
        final progressVal = progress / 100.0;

        return FadeSlideIn(
          delay: const Duration(milliseconds: 1350),
          child: Container(
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
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: progressVal),
                          duration: const Duration(milliseconds: 2000),
                          curve: const Interval(0.35, 1.0, curve: Curves.easeOutCubic),
                          builder: (context, animatedValue, _) => SizedBox(
                          width: 75,
                          height: 75,
                          child: CircularProgressIndicator(
                            value: animatedValue,
                            strokeWidth: 8,
                            backgroundColor: const Color(0xFFE8EDF3),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFAD8B73),
                            ),
                          ),
                        ),
                        ),
                        CountUpText(
                          value: progress,
                          suffix: '%',
                          duration: const Duration(milliseconds: 2000),
                          curve: const Interval(0.35, 1.0, curve: Curves.easeOutCubic),
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
        ),
        );
      },
    );
  }

  Widget _buildTeacherManagementPanel(BuildContext context) {
    final learning = <_TeacherAction>[
      _TeacherAction(Icons.assignment_add, 'Kelola Tugas', 0,
          () => const TeacherAssignmentScreen()),
      _TeacherAction(Icons.quiz_rounded, 'Kelola Kuis', 1,
          () => const TeacherQuizScreen()),
      _TeacherAction(Icons.note_add_rounded, 'Buat Materi', 2,
          () => const TeacherMaterialScreen()),
      _TeacherAction(Icons.campaign_rounded, 'Pengumuman', 4,
          () => const TeacherAnnouncementScreen()),
      _TeacherAction(Icons.assignment_turned_in_rounded, 'Hasil Kuis & Tugas', 0,
          () => const TeacherResultsScreen()),
    ];
    final lab = <_TeacherAction>[
      _TeacherAction(Icons.rate_review_rounded, 'Ulasan & Refleksi', 3,
          () => const TeacherReflectionScreen()),
      _TeacherAction(Icons.assessment_rounded, 'Rekap & Apresiasi', 6,
          () => const TeacherGradebookScreen()),
      _TeacherAction(Icons.fact_check_rounded, 'Sesi Absensi QR', 5,
          () => const TeacherAttendanceScreen()),
      _TeacherAction(Icons.inventory_2_rounded, 'Persetujuan Alat', 0,
          () => const TeacherBorrowingScreen()),
    ];

    return Column(
      children: [
        // Header banner
        AnimatedHeroCard(
          colors: const [
            Color(0xFFAD8B73),
            Color(0xFFC4A58C),
          ],
          borderRadius: 24,
          padding: const EdgeInsets.all(18),
          shadowColor: const Color(0xFFAD8B73),
          shadowOpacity: 0.3,
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.35)),
                ),
                child: const Floating(
                  amplitude: 2.5,
                  child: Icon(
                    Icons.admin_panel_settings_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Panel Utama Guru',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Pusat Kelola Pembelajaran & Fasilitas TKJ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _teacherGroup(
          context,
          title: 'KELOLA PEMBELAJARAN',
          icon: Icons.menu_book_rounded,
          actions: learning,
          order: 0,
        ),
        const SizedBox(height: 12),
        _teacherGroup(
          context,
          title: 'KELOLA KELAS & LAB TKJ',
          icon: Icons.science_rounded,
          actions: lab,
          order: 1,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// Satu kelompok menu guru: judul kecil + grid 2 kolom yang rata.
  Widget _teacherGroup(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<_TeacherAction> actions,
    required int order,
  }) {
    return FadeSlideIn(
      delay: Duration(milliseconds: 220 + order * 130),
      offset: const Offset(0, 24),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFAD8B73).withOpacity(0.18),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFAD8B73).withOpacity(0.12),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFCEAB93), Color(0xFFAD8B73)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(icon, size: 15, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                    color: _cardSub(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 1,
                    color: const Color(0xFFAD8B73).withOpacity(0.18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.35,
              children: [
                for (int i = 0; i < actions.length; i++)
                  _teacherTile(context, actions[i], order * 4 + i),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherMonitoringCard(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFAD8B73).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.analytics_rounded,
                color: Color(0xFFAD8B73),
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Ringkasan Monitoring Kelas Guru',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Stat 1: Peminjaman Alat Menunggu Persetujuan
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
                          color: pendingCount > 0 ? Colors.orange.shade50 : const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          size: 20,
                          color: pendingCount > 0 ? Colors.orange.shade800 : Colors.green.shade700,
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
                              style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      if (pendingCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange,
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
          const Divider(height: 18),

          // Stat 2: Refleksi Siswa Belum Ditanggapi
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('reflections')
                .orderBy('createdAt', descending: true)
                .limit(10)
                .snapshots(),
            builder: (context, snapshot) {
              final docs = snapshot.data?.docs ?? [];
              final pendingFeedback = docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final fb = data['feedbackGuru']?.toString() ?? '';
                return fb.isEmpty;
              }).length;

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeacherReflectionScreen(),
                    ),
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
                          color: const Color(0xFFAD8B73).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.rate_review_rounded,
                          size: 20,
                          color: Color(0xFFAD8B73),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Refleksi Belajar Siswa',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            ),
                            Text(
                              pendingFeedback > 0
                                  ? '$pendingFeedback refleksi siswa belum ditanggapi'
                                  : 'Seluruh refleksi siswa sudah ditanggapi',
                              style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey),
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
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.amber.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Pulse(
                    minScale: 0.92,
                    maxScale: 1.12,
                    child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.campaign_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Pengumuman Dari Guru',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7A4B00),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...displayDocs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['judul'] ?? 'Pengumuman',
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data['isi'] ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade800,
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

  /// Tile menu guru: ikon berwarna di kiri + label, latar putih -> krem.
  Widget _teacherTile(BuildContext context, _TeacherAction action, int order) {
    final st = _menuStyles[action.style % _menuStyles.length];

    return FadeSlideIn(
      delay: Duration(milliseconds: 380 + order * 70),
      offset: const Offset(0, 20),
      scaleFrom: 0.9,
      duration: const Duration(milliseconds: 520),
      child: PressScale(
        pressedScale: 0.94,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: _cardBg(context, st),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: st.accent.withOpacity(0.2)),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              splashColor: st.accent.withOpacity(0.15),
              highlightColor: st.accent.withOpacity(0.06),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => action.page()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        gradient: LinearGradient(
                          colors: [st.accentLight, st.accent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: st.accent.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(action.icon, size: 19, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        action.label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.15,
                          fontWeight: FontWeight.w700,
                          color: _cardTitle(context),
                        ),
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
}

class _MenuStyle {
  final Color accent;
  final Color accentLight;
  final Color tint;

  const _MenuStyle(this.accent, this.accentLight, this.tint);
}

class _TeacherAction {
  final IconData icon;
  final String label;
  final int style;
  final Widget Function() page;

  _TeacherAction(this.icon, this.label, this.style, this.page);
}
