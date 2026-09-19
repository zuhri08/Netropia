import 'package:flutter/material.dart';

import '../materi/materi_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String username;
  final String role;

  const DashboardScreen({
    super.key,
    required this.username,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final bool isGuru = role.toLowerCase() == 'guru';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // ============================================================
      // APP BAR
      // ============================================================

      appBar: AppBar(
        title: const Text(
          'Netropia',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Pengaturan',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.settings_rounded,
            ),
          ),
        ],
      ),

      // ============================================================
      // BODY
      // ============================================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ======================================================
            // WELCOME CARD
            // ======================================================

            _buildWelcomeCard(
              context,
              isGuru,
            ),

            const SizedBox(height: 24),

            // ======================================================
            // SECTION TITLE
            // ======================================================

            Text(
              'Menu Pembelajaran',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Pilih fitur untuk melanjutkan pembelajaran TKJ.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 18),

            // ======================================================
            // MENU GRID
            // ======================================================

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.05,
              children: [

                // MATERI TKJ
                _buildMenuCard(
                  context,
                  title: 'Materi TKJ',
                  subtitle: 'Pelajari materi TKJ',
                  icon: Icons.menu_book_rounded,
                  color: const Color(0xFF1565C0),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const MateriScreen(),
                      ),
                    );
                  },
                ),

                // VIRTUAL LAB
                _buildMenuCard(
                  context,
                  title: 'Virtual Lab',
                  subtitle: 'Simulasi praktik TKJ',
                  icon: Icons.science_rounded,
                  color: const Color(0xFF2E7D32),
                  onTap: () {
                    _showComingSoon(
                      context,
                      'Virtual Lab',
                    );
                  },
                ),

                // TROUBLESHOOTING
                _buildMenuCard(
                  context,
                  title: 'Troubleshooting',
                  subtitle: 'Diagnosa masalah jaringan',
                  icon: Icons.build_rounded,
                  color: const Color(0xFFEF6C00),
                  onTap: () {
                    _showComingSoon(
                      context,
                      'Troubleshooting',
                    );
                  },
                ),

                // STUDI KASUS
                _buildMenuCard(
                  context,
                  title: 'Studi Kasus',
                  subtitle: 'Belajar dari permasalahan nyata',
                  icon: Icons.assignment_rounded,
                  color: const Color(0xFF6A1B9A),
                  onTap: () {
                    _showComingSoon(
                      context,
                      'Studi Kasus',
                    );
                  },
                ),

                // KUIS & ASESMEN
                _buildMenuCard(
                  context,
                  title: 'Kuis & Asesmen',
                  subtitle: 'Uji pemahaman kamu',
                  icon: Icons.quiz_rounded,
                  color: const Color(0xFFC62828),
                  onTap: () {
                    _showComingSoon(
                      context,
                      'Kuis & Asesmen',
                    );
                  },
                ),

                // PROJECT
                _buildMenuCard(
                  context,
                  title: 'Project',
                  subtitle: 'Kerjakan proyek TKJ',
                  icon: Icons.folder_special_rounded,
                  color: const Color(0xFF00838F),
                  onTap: () {
                    _showComingSoon(
                      context,
                      'Project',
                    );
                  },
                ),

                // REFLEKSI
                _buildMenuCard(
                  context,
                  title: 'Refleksi',
                  subtitle: 'Refleksikan proses belajar',
                  icon: Icons.psychology_rounded,
                  color: const Color(0xFF7B1FA2),
                  onTap: () {
                    _showComingSoon(
                      context,
                      'Refleksi',
                    );
                  },
                ),

                // PROGRESS
                _buildMenuCard(
                  context,
                  title: 'Progress Saya',
                  subtitle: 'Lihat perkembangan belajar',
                  icon: Icons.trending_up_rounded,
                  color: const Color(0xFF4527A0),
                  onTap: () {
                    _showComingSoon(
                      context,
                      'Progress Saya',
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ======================================================
            // PROGRESS BELAJAR
            // ======================================================

            _buildProgressCard(context),

            const SizedBox(height: 25),

            // ======================================================
            // FOOTER
            // ======================================================

            const Center(
              child: Text(
                'Netropia • Pembelajaran TKJ SMK Kelas X',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // WELCOME CARD
  // ==============================================================

  Widget _buildWelcomeCard(
      BuildContext context,
      bool isGuru,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0D47A1),
            Color(0xFF1976D2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [

          // AVATAR
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              isGuru
                  ? Icons.person_rounded
                  : Icons.school_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(width: 15),

          // GREETING
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  isGuru
                      ? 'Selamat datang, Guru 👋'
                      : 'Selamat belajar 👋',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  isGuru
                      ? 'Mode Guru'
                      : 'Siswa • Kelas X TKJ',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // MENU CARD
  // ==============================================================

  Widget _buildMenuCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              // ICON
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.10),
                  borderRadius:
                  BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 26,
                ),
              ),

              const Spacer(),

              // TITLE
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
              ),

              const SizedBox(height: 4),

              // SUBTITLE
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // PROGRESS CARD
  // ==============================================================

  Widget _buildProgressCard(
      BuildContext context,
      ) {
    const double progress = 0.25;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color:
                  const Color(0xFFE3F2FD),
                  borderRadius:
                  BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: Color(0xFF1565C0),
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress Belajar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Terus tingkatkan kemampuan TKJ kamu.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const Text(
                '25%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor:
              const Color(0xFFE8EDF3),
              valueColor:
              const AlwaysStoppedAnimation<Color>(
                Color(0xFF1565C0),
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Progress akan diperbarui berdasarkan aktivitas belajar.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // COMING SOON
  // ==============================================================

  void _showComingSoon(
      BuildContext context,
      String feature,
      ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature sedang dalam tahap pengembangan.',
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}