import 'package:flutter/material.dart';
import 'lab_detail_screen.dart';

class VirtualLabScreen extends StatelessWidget {
  const VirtualLabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsSection(context),
                  const SizedBox(height: 30),
                  _buildSectionHeader(context, "Kategori Lab", Icons.category_rounded),
                  const SizedBox(height: 15),
                  _buildCategories(context),
                  const SizedBox(height: 30),
                  _buildSectionHeader(context, "Daftar Lab Praktik", Icons.science_rounded),
                  const SizedBox(height: 15),
                  _buildLabList(context),
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
        titlePadding: const EdgeInsets.only(left: 20, bottom: 20),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Virtual Lab',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.blue.shade200 : Colors.white,
              ),
            ),
            const Text(
              'Praktik jaringan secara virtual',
              style: TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Row(
      children: [
        _buildStatCard(context, "Total Lab", "24", Icons.folder_rounded, Colors.blue),
        const SizedBox(width: 12),
        _buildStatCard(context, "Selesai", "8", Icons.check_circle_rounded, Colors.green),
        const SizedBox(width: 12),
        _buildStatCard(context, "XP", "450", Icons.bolt_rounded, Colors.orange),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF1565C0)),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCategories(BuildContext context) {
    final categories = ["Semua", "Dasar Jaringan", "IP Address", "Subnetting", "Routing", "Switching"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          bool isFirst = cat == "Semua";
          return Container(
            margin: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(cat, style: TextStyle(fontSize: 12, color: isFirst ? Colors.white : null)),
              selected: isFirst,
              selectedColor: const Color(0xFF1565C0),
              onSelected: (val) {},
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLabList(BuildContext context) {
    final labs = [
      {'name': 'Konfigurasi IP Address', 'level': 'Beginner', 'duration': '15 menit', 'progress': 0.6, 'icon': Icons.language_rounded},
      {'name': 'Routing Dasar Static', 'level': 'Intermediate', 'duration': '30 menit', 'progress': 0.0, 'icon': Icons.router_rounded},
      {'name': 'VLAN & Trunking', 'level': 'Advanced', 'duration': '45 menit', 'progress': 0.0, 'icon': Icons.lan_rounded},
    ];

    return Column(
      children: labs.map((lab) => _buildLabCard(context, lab)).toList(),
    );
  }

  Widget _buildLabCard(BuildContext context, Map<String, dynamic> lab) {
    final Color levelColor = lab['level'] == 'Beginner' ? Colors.green : (lab['level'] == 'Intermediate' ? Colors.orange : Colors.red);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFF1565C0).withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
                child: Icon(lab['icon'] as IconData, color: const Color(0xFF1565C0), size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lab['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildBadge(lab['level'] as String, levelColor),
                        const SizedBox(width: 10),
                        Icon(Icons.timer_outlined, size: 12, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(lab['duration'] as String, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: lab['progress'] as double,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade100,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1565C0)),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Text("${((lab['progress'] as double) * 100).toInt()}%", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LabDetailScreen(labName: lab['name'] as String)));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Mulai Lab", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
