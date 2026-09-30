import 'package:flutter/material.dart';
import 'project_work_screen.dart';
import '../services/localization_service.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  int selectedCategory = 0;

  List<String> get categories {
    if (localizationService.isEnglish) {
      return ['All', 'Networking', 'Computer', 'Troubleshooting'];
    }
    return ['Semua', 'Jaringan', 'Komputer', 'Troubleshooting'];
  }

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
      color: const Color(0xFFAD8B73),
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
      color: const Color(0xFF00897B),
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
      color: const Color(0xFFEF6C00),
      steps: [
        'Mengidentifikasi masalah',
        'Mencari penyebab',
        'Menentukan solusi',
        'Melakukan pengujian',
      ],
    ),
  ];

  List<ProjectData> get filteredProjects {
    if (selectedCategory == 0) {
      return projects;
    }

    final catMap = {
      1: 'Jaringan',
      2: 'Komputer',
      3: 'Troubleshooting',
    };
    final category = catMap[selectedCategory] ?? 'Jaringan';

    return projects
        .where((project) => project.category == category)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeader(),
                ),
                SliverToBoxAdapter(
                  child: _buildLearningSummary(),
                ),
                SliverToBoxAdapter(
                  child: _buildCategoryFilter(),
                ),
                SliverToBoxAdapter(
                  child: _buildSectionTitle(),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final project = filteredProjects[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildProjectCard(project),
                        );
                      },
                      childCount: filteredProjects.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
      child: Row(
        children: [
          _buildBackButton(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizationService.translate('project'),
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  localizationService.isEnglish
                      ? 'Learn by creating something real.'
                      : 'Belajar dengan membuat sesuatu yang nyata.',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Colors.grey.shade600,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          _buildInfoButton(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.pop(context),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            Icons.arrow_back_rounded,
            size: 21,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoButton() {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: _showProjectInfo,
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            Icons.info_outline_rounded,
            size: 21,
            color: Color(0xFFAD8B73),
          ),
        ),
      ),
    );
  }

  Widget _buildLearningSummary() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFAD8B73),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAD8B73).withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -25,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: -45,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.rocket_launch_rounded,
                      color: Colors.white,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      localizationService.isEnglish ? 'Learn by creating' : 'Belajar sambil berkarya',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                localizationService.isEnglish
                    ? 'Project-based learning helps you solve real-world technical challenges step by step.'
                    : 'Pembelajaran berbasis proyek membantumu memecahkan masalah nyata dan memahami konsep secara mendalam.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.92),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final cats = categories;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = selectedCategory == index;

          return ChoiceChip(
            label: Text(cats[index]),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  selectedCategory = index;
                });
              }
            },
            selectedColor: const Color(0xFFAD8B73),
            backgroundColor: Theme.of(context).cardColor,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              fontSize: 12.5,
            ),
            side: BorderSide(
              color: isSelected ? const Color(0xFFAD8B73) : Colors.grey.withOpacity(0.2),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            localizationService.isEnglish ? 'Project List' : 'Daftar Project',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          Text(
            '${filteredProjects.length} ${localizationService.isEnglish ? 'projects' : 'project'}',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(ProjectData project) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectWorkScreen(
                projectTitle: project.title,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: project.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      project.icon,
                      color: project.color,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).textTheme.titleMedium?.color,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _badge(
                              text: project.category,
                              color: project.color,
                            ),
                            const SizedBox(width: 6),
                            _badge(
                              text: project.difficulty,
                              color: Colors.grey.shade600,
                              isOutlined: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                project.description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 15,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        project.duration,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        localizationService.isEnglish ? 'Start Project' : 'Mulai Project',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFAD8B73),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: Color(0xFFAD8B73),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge({
    required String text,
    required Color color,
    bool isOutlined = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: isOutlined ? Border.all(color: color.withOpacity(0.3)) : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  void _showProjectInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          localizationService.isEnglish ? 'About Projects' : 'Tentang Project',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          localizationService.isEnglish
              ? 'Projects contain practical tasks that you can complete step by step. Complete each task to increase your understanding!'
              : 'Project berisi tugas praktik yang dapat kamu selesaikan secara bertahap. Selesaikan setiap tugas untuk meningkatkan pemahamanmu!',
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
