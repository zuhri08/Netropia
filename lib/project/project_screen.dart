import 'package:flutter/material.dart';
import 'project_work_screen.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  int selectedCategory = 0;

  final List<String> categories = [
    'Semua',
    'Jaringan',
    'Komputer',
    'Troubleshooting',
  ];

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
      color: Color(0xFF1565C0),
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
      color: Color(0xFF00897B),
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
      color: Color(0xFF6A1B9A),
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
      color: Color(0xFFEF6C00),
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

    final category = categories[selectedCategory];

    return projects
        .where((project) => project.category == category)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
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
  }

  // ============================================================
  // HEADER
  // ============================================================

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
                  'Project',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF17202A),
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Belajar dengan membuat sesuatu yang nyata.',
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
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.pop(context),
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            Icons.arrow_back_rounded,
            size: 21,
            color: Color(0xFF263238),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoButton() {
    return Material(
      color: Colors.white,
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
            color: Color(0xFF1565C0),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LEARNING SUMMARY
  // ============================================================

  Widget _buildLearningSummary() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1565C0),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.18),
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
                  const Expanded(
                    child: Text(
                      'Belajar sambil berkarya',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'Project membuat kamu tidak hanya memahami teori, tetapi juga mencoba, menguji, dan menyelesaikan masalah seperti teknisi TKJ.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildSummaryItem(
                    icon: Icons.folder_copy_rounded,
                    value: '${projects.length}',
                    label: 'Project',
                  ),
                  const SizedBox(width: 28),
                  _buildSummaryItem(
                    icon: Icons.check_circle_outline_rounded,
                    value: '0',
                    label: 'Selesai',
                  ),
                  const SizedBox(width: 28),
                  _buildSummaryItem(
                    icon: Icons.trending_up_rounded,
                    value: '0%',
                    label: 'Progress',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: Colors.white.withOpacity(0.85),
        ),
        const SizedBox(width: 7),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.72),
                fontSize: 10.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // CATEGORY
  // ============================================================

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final selected = selectedCategory == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 17),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF1565C0)
                    : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF1565C0)
                      : const Color(0xFFE3E7EC),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                categories[index],
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight:
                  selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected
                      ? Colors.white
                      : const Color(0xFF54616D),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 14),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project tersedia',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1C252C),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Pilih project dan mulai tantanganmu.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7A858F),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${filteredProjects.length} project',
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1565C0),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PROJECT CARD
  // ============================================================

  Widget _buildProjectCard(ProjectData project) {
    final isStarted = project.progress > 0;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => _openProject(project),
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: project.color.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Icon(
                      project.icon,
                      color: project.color,
                      size: 27,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: project.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          project.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF202930),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F5F7),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      project.difficulty,
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF66717B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                project.description,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF68747E),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildMeta(
                    Icons.schedule_rounded,
                    project.duration,
                  ),
                  const SizedBox(width: 14),
                  _buildMeta(
                    Icons.layers_rounded,
                    '${project.steps.length} tahap',
                  ),
                ],
              ),
              const SizedBox(height: 17),
              _buildProjectProgress(project),
              const SizedBox(height: 17),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      isStarted
                          ? '${project.progress}% selesai'
                          : 'Belum dimulai',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: isStarted
                            ? project.color
                            : const Color(0xFF7A858F),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: project.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isStarted ? 'Lanjutkan' : 'Mulai Project',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeta(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: const Color(0xFF8A959E),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 10.5,
            color: Color(0xFF727E87),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProjectProgress(ProjectData project) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Progress project',
                style: TextStyle(
                  fontSize: 10.5,
                  color: Color(0xFF7A858F),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '${project.progress}%',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: project.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: project.progress / 100,
            minHeight: 6,
            backgroundColor: const Color(0xFFECEFF2),
            valueColor: AlwaysStoppedAnimation<Color>(
              project.color,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ACTIONS
  // ============================================================

  Future<void> _openProject(ProjectData project) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectPreviewScreen(
          project: project,
        ),
      ),
    );

    if (result == true) {
      setState(() {
        project.progress = 100;
      });
    }
  }
  void _showProjectInfo() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8DDE2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Tentang Project',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF202930),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Project dirancang agar kamu dapat menerapkan materi TKJ melalui sebuah tantangan nyata. Setiap project memiliki beberapa tahap yang harus diselesaikan.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF68747E),
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 18),
              _buildInfoRow(
                Icons.lightbulb_outline_rounded,
                'Pahami masalah',
              ),
              _buildInfoRow(
                Icons.edit_note_rounded,
                'Rencanakan solusi',
              ),
              _buildInfoRow(
                Icons.handyman_outlined,
                'Kerjakan project',
              ),
              _buildInfoRow(
                Icons.fact_check_outlined,
                'Uji hasilnya',
              ),
              _buildInfoRow(
                Icons.forum_outlined,
                'Lakukan refleksi',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F5FB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 18,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF45515A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PROJECT PREVIEW
// ============================================================

class ProjectPreviewScreen extends StatelessWidget {
  final ProjectData project;

  const ProjectPreviewScreen({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
          color: const Color(0xFF263238),
        ),
        title: const Text(
          'Detail Project',
          style: TextStyle(
            color: Color(0xFF202930),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(),
            const SizedBox(height: 22),
            _buildSection(
              title: 'Tantangan',
              icon: Icons.flag_rounded,
              child: Text(
                project.description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF66717B),
                  height: 1.55,
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildSection(
              title: 'Tahapan Project',
              icon: Icons.route_rounded,
              child: _buildSteps(),
            ),
            const SizedBox(height: 15),
            _buildSection(
              title: 'Yang akan kamu latih',
              icon: Icons.psychology_alt_rounded,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildSkillChip('Problem Solving'),
                  _buildSkillChip('Praktik TKJ'),
                  _buildSkillChip('Analisis'),
                  _buildSkillChip('Kreativitas'),
                  _buildSkillChip('Kerja Sistematis'),
                ],
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProjectWorkScreen(
                          projectTitle: project.title,
                        ),
                      ),
                    );
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: project.color,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_arrow_rounded,
                      size: 22,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Mulai Project',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: project.color,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(
              project.icon,
              color: Colors.white,
              size: 29,
            ),
          ),
          const SizedBox(height: 17),
          Text(
            project.category.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.72),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            project.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildHeroMeta(
                Icons.signal_cellular_alt_rounded,
                project.difficulty,
              ),
              const SizedBox(width: 18),
              _buildHeroMeta(
                Icons.schedule_rounded,
                project.duration,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroMeta(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.82),
          size: 15,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.88),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: project.color.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: project.color,
                  size: 19,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF202930),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildSteps() {
    return Column(
      children: List.generate(
        project.steps.length,
            (index) {
          final isLast = index == project.steps.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 29,
                    height: 29,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: project.color.withOpacity(0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: project.color,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 30,
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      color: project.color.withOpacity(0.12),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    project.steps[index],
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF5F6B74),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSkillChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10.5,
          color: Color(0xFF68747E),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ============================================================
// MODEL
// ============================================================

class ProjectData {
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final String duration;
  final IconData icon;
  int progress;
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