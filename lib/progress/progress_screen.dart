import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulasi data
    final bool hasActivity = true;

    if (!hasActivity) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Progress Belajar'),
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.analytics_outlined, size: 100, color: Colors.grey.shade300),
              const SizedBox(height: 20),
              const Text(
                'Belum Ada Aktivitas Belajar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              const Text(
                'Mulai belajar untuk melihat perkembanganmu di sini.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainStatsCard(context),
                  const SizedBox(height: 35),
                  _buildSectionHeader(context, "Progress per Materi", Icons.auto_awesome_motion_rounded),
                  const SizedBox(height: 15),
                  _buildMateriProgressList(context),
                  const SizedBox(height: 35),
                  _buildSectionHeader(context, "Pencapaian Kamu", Icons.emoji_events_rounded),
                  const SizedBox(height: 15),
                  _buildAchievementsGrid(context),
                  const SizedBox(height: 35),
                  _buildSectionHeader(context, "Statistik Mingguan", Icons.bar_chart_rounded),
                  const SizedBox(height: 15),
                  _buildWeeklyActivityCard(context),
                  const SizedBox(height: 35),
                  _buildSectionHeader(context, "Aktivitas Terbaru", Icons.history_toggle_off_rounded),
                  const SizedBox(height: 15),
                  _buildRecentActivityCard(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SliverAppBar(
      expandedHeight: 140.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF1565C0),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 20, bottom: 20),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Progress Belajar',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.blue.shade200 : Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Dashboard perkembangan akademikmu',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white70 : Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
        background: Stack(
          children: [
            Positioned(
              right: -50,
              top: -20,
              child: Icon(
                Icons.insights_rounded,
                size: 200,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15, bottom: 5),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_rounded, color: Colors.white, size: 24),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF1565C0)),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).textTheme.titleLarge?.color,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildMainStatsCard(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
            ? [const Color(0xFF2C2C2C), const Color(0xFF1E1E1E)]
            : [const Color(0xFF1565C0), const Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(isDark ? 0.1 : 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(Icons.auto_graph_rounded, size: 150, color: Colors.white.withOpacity(0.05)),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Keseluruhan",
                        style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "35.5%",
                        style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: -1),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _buildMiniStat(Icons.check_circle_outline_rounded, "8", "Selesai"),
                          const SizedBox(width: 20),
                          _buildMiniStat(Icons.pending_actions_rounded, "4", "Proses"),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: 0.355,
                          strokeWidth: 10,
                          backgroundColor: Colors.white.withOpacity(0.15),
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeCap: StrokeCap.round,
                        ),
                        const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.white70),
            const SizedBox(width: 4),
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _buildMateriProgressList(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'name': 'Dasar TKJ', 'done': 6, 'total': 10, 'percent': 0.6, 'color': Colors.blue},
      {'name': 'Jaringan Komputer', 'done': 4, 'total': 12, 'percent': 0.33, 'color': Colors.green},
      {'name': 'Keamanan Jaringan', 'done': 1, 'total': 8, 'percent': 0.12, 'color': Colors.orange},
    ];

    return Column(
      children: items.map((item) => _buildMateriCard(context, item)).toList(),
    );
  }

  Widget _buildMateriCard(BuildContext context, Map<String, dynamic> item) {
    final Color color = item['color'];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.03)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "${(item['percent'] * 100).toInt()}%",
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text("${item['done']}/${item['total']} Modul", style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const Spacer(),
              const Text("Terus belajar!", style: TextStyle(color: Colors.grey, fontSize: 11, fontStyle: FontStyle.italic)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: item['percent'],
              minHeight: 10,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsGrid(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'name': 'Early Bird', 'icon': Icons.wb_twilight_rounded, 'color': Colors.amber},
      {'name': 'Quiz Master', 'icon': Icons.psychology_rounded, 'color': Colors.purple},
      {'name': 'Social Star', 'icon': Icons.groups_rounded, 'color': Colors.blue},
      {'name': 'Lab King', 'icon': Icons.science_rounded, 'color': Colors.green},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.5,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.black.withOpacity(0.03)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: item['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(item['icon'], color: item['color'], size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeeklyActivityCard(BuildContext context) {
    final List<double> values = [0.4, 0.7, 0.5, 0.9, 0.6, 0.3, 0.8];
    final List<String> days = ['S', 'S', 'R', 'K', 'J', 'S', 'M'];

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rata-rata Harian", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text("2.5 Jam", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text("+15% Minggu ini", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 18,
                      height: values[index] * 100,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1565C0), Color(0xFF64B5F6)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(days[index], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: 3,
        separatorBuilder: (context, index) => const Divider(indent: 75, endIndent: 25, height: 1),
        itemBuilder: (context, index) {
          final List<Map<String, dynamic>> acts = [
            {'title': 'Selesai Modul 4', 'sub': 'Dasar TKJ • Jaringan', 'time': '12m ago', 'icon': Icons.check_circle_rounded, 'color': Colors.green},
            {'title': 'Mengerjakan Kuis', 'sub': 'Keamanan • Enkripsi', 'time': '2h ago', 'icon': Icons.quiz_rounded, 'color': Colors.orange},
            {'title': 'Masuk Rank Top 10', 'sub': 'Mingguan • Siswa', 'time': 'Yesterday', 'icon': Icons.leaderboard_rounded, 'color': Colors.blue},
          ];
          final act = acts[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: act['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(act['icon'], color: act['color'], size: 24),
            ),
            title: Text(act['title'], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
            subtitle: Text(act['sub'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
            trailing: Text(act['time'], style: const TextStyle(fontSize: 10, color: Colors.grey)),
          );
        },
      ),
    );
  }
}
