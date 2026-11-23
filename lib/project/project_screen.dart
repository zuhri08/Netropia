import 'package:flutter/material.dart';
import 'project_work_screen.dart';
import '../services/localization_service.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_pressable.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  int selectedCategory = 0;

  List<String> get categories => ['Semua', 'Jaringan', 'Komputer', 'Troubleshooting'];

  final List<ProjectData> projects = [
    ProjectData(
      title: 'Membangun LAN Sederhana',
      description:
          'Rancang dan bangun jaringan LAN sederhana yang dapat menghubungkan beberapa komputer.',
      category: 'Jaringan',
      difficulty: 'Dasar',
      duration: '2–3 Pertemuan',
      icon: Icons.lan_rounded,
      progress: 0,
      color: AppTheme.primaryTeal,
      steps: [
        'Memahami masalah',
        'Membuat perencanaan',
        'Melakukan praktik',
        'Menguji jaringan',
        'Membuat refleksi',
      ],
    ),
    ProjectData(
      title: 'Membuat Kabel UTP',
      description:
          'Buat kabel jaringan menggunakan konektor RJ45 dan lakukan pengujian koneksi.',
      category: 'Jaringan',
      difficulty: 'Dasar',
      duration: '1–2 Pertemuan',
      icon: Icons.cable_rounded,
      progress: 0,
      color: AppTheme.primaryTeal,
      steps: [
        'Mengenal kabel',
        'Menentukan susunan warna',
        'Terminasi RJ45',
        'Pengujian kabel',
      ],
    ),
    ProjectData(
      title: 'Merakit PC',
      description:
          'Kenali komponen komputer dan lakukan proses perakitan hingga komputer siap digunakan.',
      category: 'Komputer',
      difficulty: 'Menengah',
      duration: '2–3 Pertemuan',
      icon: Icons.computer_rounded,
      progress: 0,
      color: const Color(0xFF6A1B9A),
      steps: [
        'Mengenal komponen',
        'Mempersiapkan alat',
        'Merakit komputer',
        'Pengujian',
      ],
    ),
    ProjectData(
      title: 'Mencari Penyebab Gangguan Jaringan',
      description:
          'Analisis sebuah masalah jaringan dan tentukan langkah perbaikannya.',
      category: 'Troubleshooting',
      difficulty: 'Menengah',
      duration: '1–2 Pertemuan',
      icon: Icons.build_circle_rounded,
      progress: 0,
      color: AppTheme.accentAmber,
      steps: [
        'Mengidentifikasi masalah',
        'Mencari penyebab',
        'Menentukan solusi',
        'Melakukan pengujian',
      ],
    ),
  ];

  List<ProjectData> get filteredProjects {
    if (selectedCategory == 0) return projects;
    final catMap = {1: 'Jaringan', 2: 'Komputer', 3: 'Troubleshooting'};
    final category = catMap[selectedCategory] ?? 'Jaringan';
    return projects.where((p) => p.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text('Project', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: AppTheme.primaryTeal,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 50),
              children: [
                _buildHeroBanner(),
                const SizedBox(height: 20),
                _buildCategoryFilter(isDark),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DAFTAR PROJECT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                        color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
                      ),
                    ),
                    Text(
                      '${filteredProjects.length} project',
                      style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...filteredProjects.map((p) => _buildProjectCard(p, isDark)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryTeal, AppTheme.darkTeal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 14),
          const Text(
            'Belajar sambil berkarya',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Belajar dengan membuat sesuatu yang nyata. Pembelajaran berbasis proyek membantumu memecahkan masalah nyata dan memahami konsep secara mendalam.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(bool isDark) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = selectedCategory == index;
          return ChoiceChip(
            label: Text(categories[index]),
            selected: isSelected,
            onSelected: (_) => setState(() => selectedCategory = index),
            selectedColor: AppTheme.primaryTeal,
            backgroundColor: isDark ? const Color(0xFF162522) : AppTheme.surfaceCream,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : (isDark ? Colors.white : AppTheme.textDark),
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          );
        },
      ),
    );
  }

  Widget _buildProjectCard(ProjectData project, bool isDark) {
    return AnimatedPressable(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectWorkScreen(projectTitle: project.title),
          ),
        );
      },
      scaleFactor: 0.96,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: AppTheme.tealTint, borderRadius: BorderRadius.circular(12)),
                  child: Icon(project.icon, color: AppTheme.primaryTeal, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(project.title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.textDark)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppTheme.tealTint, borderRadius: BorderRadius.circular(6)),
                            child: Text(project.category, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryTeal)),
                          ),
                          const SizedBox(width: 6),
                          Text(project.difficulty, style: const TextStyle(fontSize: 10.5, color: AppTheme.textMuted)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(project.description, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted, height: 1.4)),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(project.duration, style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryTeal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('Mulai Project', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectData {
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final String duration;
  final IconData icon;
  final int progress;
  final Color color;
  final List<String> steps;

  ProjectData({
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.duration,
    required this.icon,
    required this.progress,
    required this.color,
    required this.steps,
  });
}
