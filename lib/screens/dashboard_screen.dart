import 'package:flutter/material.dart';
import '../absensi/attendance_screen.dart';
import '../materi/materi_screen.dart';
import '../kalkulator_subnet/subnet_calculator_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../absensi/teacher_attendance_screen.dart';
import '../virtual_lab/virtual_lab_screen.dart';
import '../peminjaman/borrowing_screen.dart';
import '../virtual_lab/device_3d_viewer_screen.dart';
import '../devices_3d/device_3d_list_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String username;
  final String role;

  const DashboardScreen({
    super.key,
    required this.username,
    required this.role,
  });

  // ============================================================
  // NAVIGASI KE MATERI
  // ============================================================

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

  // ============================================================
  // FITUR YANG BELUM DIBUAT
  // ============================================================

  void _showComingSoon(
      BuildContext context,
      String feature,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature sedang dalam pengembangan.',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,

        title: const Row(
          children: [
            Icon(
              Icons.school_rounded,
              size: 28,
            ),
            SizedBox(width: 10),
            Text(
              'Netropia',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {
              _showComingSoon(
                context,
                'Notifikasi',
              );
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            16,
            18,
            16,
            30,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              // ==================================================
              // SAPAAN
              // ==================================================

              Text(
                'Halo, $username 👋',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                role.toLowerCase() == 'guru'
                    ? 'Selamat datang di Netropia.'
                    : 'Semangat belajar, masa depanmu dimulai dari sini.',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // LANJUTKAN BELAJAR
              // ==================================================

              _buildContinueLearning(context),

              const SizedBox(height: 25),

              // ==================================================
              // MENU UTAMA
              // ==================================================

              Text(
                'Menu Utama',
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
                physics:
                const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.18,
                children: [

                  // ------------------------------------------
                  // MATERI TKJ
                  // ------------------------------------------

                  _buildMenuCard(
                    context,
                    title: 'Materi TKJ',
                    subtitle: 'Pelajari materi TKJ',
                    icon: Icons.menu_book_rounded,
                    iconColor:
                    const Color(0xFF1565C0),
                    backgroundColor:
                    const Color(0xFFE8F1FF),
                    onTap: () {
                      _openMateri(context);
                    },
                  ),

                  // ------------------------------------------
                  // VIRTUAL LAB
                  // ------------------------------------------

                  _buildMenuCard(
                    context,
                    title: 'Perangkat 3D',
                    subtitle: 'Eksplorasi alat TKJ',
                    icon: Icons.view_in_ar_rounded,
                    iconColor:
                    const Color(0xFF00897B),
                    backgroundColor:
                    const Color(0xFFE5F7F4),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Device3DListScreen(),
                        ),
                      );
                    },
                  ),

                  // ------------------------------------------
                  // KALKULATOR SUBNET
                  // ------------------------------------------

                  _buildMenuCard(
                    context,
                    title: 'Kalkulator Subnet',
                    subtitle: 'Hitung subnet',
                    icon: Icons.calculate_rounded,
                    iconColor:
                    const Color(0xFFE65100),
                    backgroundColor:
                    const Color(0xFFFFF0E6),
                    onTap: () {
                      _openSubnetCalculator(context);
                    },
                  ),

                  // ------------------------------------------
                  // ABSEN
                  // ------------------------------------------

                  _buildMenuCard(
                    context,
                    title: 'Absen',
                    subtitle: 'Kehadiran belajar',
                    icon: Icons.fact_check_rounded,
                    iconColor: const Color(0xFF7B1FA2),
                    backgroundColor: const Color(0xFFF3E8FF),
                    onTap: () async {
                      final user = FirebaseAuth.instance.currentUser;

                      if (user == null) {
                        return;
                      }

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
                              builder: (context) =>
                              const TeacherAttendanceScreen(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const AttendanceScreen(),
                            ),
                          );
                        }
                      } catch (e) {
                        debugPrint('ERROR CEK ROLE ABSENSI: $e');

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Gagal membuka halaman absensi.',
                            ),
                          ),
                        );
                      }
                    },
                  ),

                  // ------------------------------------------
                  // PEMINJAMAN
                  // ------------------------------------------
                  _buildMenuCard(
                    context,
                    title: 'Peminjaman',
                    subtitle: 'Pinjam alat TKJ',
                    icon: Icons.inventory_2_rounded,
                    iconColor: const Color(0xFF0277BD),
                    backgroundColor: const Color(0xFFE3F2FD),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BorrowingScreen(),
                        ),
                      );
                    },
                  ),

                  // ------------------------------------------
                  // PROJECT
                  // ------------------------------------------

                  _buildMenuCard(
                    context,
                    title: 'Project',
                    subtitle: 'Proyek pembelajaran',
                    icon: Icons.folder_copy_rounded,
                    iconColor:
                    const Color(0xFF2E7D32),
                    backgroundColor:
                    const Color(0xFFE8F5E9),
                    onTap: () {
                      _showComingSoon(
                        context,
                        'Project',
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // ==================================================
              // PROGRESS BELAJAR
              // ==================================================

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Aktivitas Terbaru',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      _showComingSoon(
                        context,
                        'Semua aktivitas',
                      );
                    },
                    child: const Text(
                      'Lihat Semua',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ------------------------------------------
              // AKTIVITAS 1
              // ------------------------------------------

              _buildActivityCard(
                context,
                icon: Icons.menu_book_rounded,
                iconColor:
                const Color(0xFF1565C0),
                title: 'Dasar TKJ',
                subtitle:
                'Materi terakhir dipelajari',
                time: 'Hari ini',
              ),

              const SizedBox(height: 10),

              // ------------------------------------------
              // AKTIVITAS 2
              // ------------------------------------------

              _buildActivityCard(
                context,
                icon: Icons.calculate_rounded,
                iconColor:
                const Color(0xFFE65100),
                title: 'Kalkulator Subnet',
                subtitle:
                'Fitur perhitungan jaringan',
                time: 'Belum digunakan',
              ),

              const SizedBox(height: 10),

              // ------------------------------------------
              // AKTIVITAS 3
              // ------------------------------------------

              _buildActivityCard(
                context,
                icon: Icons.fact_check_rounded,
                iconColor:
                const Color(0xFF7B1FA2),
                title: 'Absensi',
                subtitle:
                'Status kehadiran',
                time: 'Belum absen',
              ),

              const SizedBox(height: 28),

              // ==================================================
              // PROGRESS BELAJAR
              // ==================================================

              _buildProgressCard(context),
            ],
          ),
        ),
      ),

      // ========================================================
      // PENTING
      // ========================================================
      //
      // BottomNavigationBar TIDAK ditulis di sini.
      //
      // Navigasi bawah yang sudah ada pada halaman induk aplikasi
      // akan menjadi satu-satunya navigasi.
      //
    );
  }

  // ============================================================
  // CARD LANJUTKAN BELAJAR
  // ============================================================

  Widget _buildContinueLearning(
      BuildContext context,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1565C0),
            Color(0xFF1976D2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:
        BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
            Colors.blue.withOpacity(0.18),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          const Text(
            'Lanjutkan Belajar',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [

              // ICON
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color:
                  Colors.white.withOpacity(
                    0.18,
                  ),
                  borderRadius:
                  BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),

              const SizedBox(width: 14),

              // TEXT
              const Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dasar TKJ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Modul 1 • Jaringan Komputer',
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

          // PROGRESS
          Row(
            children: [

              Expanded(
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(10),
                  child:
                  const LinearProgressIndicator(
                    value: 0.66,
                    minHeight: 7,
                    backgroundColor:
                    Color(0x55FFFFFF),
                    valueColor:
                    AlwaysStoppedAnimation<
                        Color>(
                      Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              const Text(
                '66%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _openMateri(context);
              },
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                Colors.white,
                foregroundColor:
                const Color(0xFF1565C0),
                elevation: 0,
                padding:
                const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Lanjutkan Belajar',
                style: TextStyle(
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MENU CARD
  // ============================================================

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
                    // ICON
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

                    // TITLE
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

                    // SUBTITLE
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

  // ============================================================
  // AKTIVITAS TERBARU CARD
  // ============================================================

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
      padding:
      const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:
        BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(
              0.035,
            ),
            blurRadius: 8,
            offset:
            const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [

          // ICON
          Container(
            width: 44,
            height: 44,

            decoration: BoxDecoration(
              color:
              iconColor.withOpacity(
                0.10,
              ),
              borderRadius:
              BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),

          const SizedBox(width: 13),

          // CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.bold,
                    color:
                    Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color:
                    Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),

          // TIME
          Text(
            time,
            style: TextStyle(
              fontSize: 10,
              color:
              Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PROGRESS BELAJAR
  // ============================================================

  Widget _buildProgressCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:
        BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(
              0.04,
            ),
            blurRadius: 8,
            offset:
            const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(
            'Progress Belajar',
            style: TextStyle(
              fontSize: 16,
              fontWeight:
              FontWeight.bold,
              color:
              Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [

              // CIRCULAR PROGRESS
              SizedBox(
                width: 75,
                height: 75,

                child: Stack(
                  alignment:
                  Alignment.center,

                  children: [

                    SizedBox(
                      width: 75,
                      height: 75,

                      child:
                      CircularProgressIndicator(
                        value: 0.25,
                        strokeWidth: 8,

                        backgroundColor:
                        const Color(
                          0xFFE8EDF3,
                        ),

                        valueColor:
                        const AlwaysStoppedAnimation<
                            Color>(
                          Color(0xFF1565C0),
                        ),
                      ),
                    ),

                    Text(
                      '25%',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // DESCRIPTION
              const Expanded(
                child: Text(
                  'Terus tingkatkan belajarmu! Selesaikan materi dan praktik untuk meningkatkan progress belajar.',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                    Color(0xFF7B8494),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
