import 'dart:math';
import 'package:flutter/material.dart';
import '../ai/netropia_ai_screen.dart';

class MateriDetailLayout extends StatefulWidget {
  final String title;
  final Color themeColor;

  const MateriDetailLayout({
    super.key,
    required this.title,
    this.themeColor = const Color(0xFF1565C0),
  });

  @override
  State<MateriDetailLayout> createState() => _MateriDetailLayoutState();
}

class _MateriDetailLayoutState extends State<MateriDetailLayout> {
  final List<String> _motivations = [
    "Pendidikan adalah senjata paling mematikan di dunia, karena dengan pendidikan, Anda dapat mengubah dunia. - Nelson Mandela",
    "Hiduplah seolah-olah kamu akan mati besok. Belajarlah seolah-olah kamu akan hidup selamanya. - Mahatma Gandhi",
    "Jangan pernah berhenti belajar, karena hidup tidak pernah berhenti mengajar.",
    "Kesuksesan bukanlah kunci kebahagiaan. Kebahagiaanlah kunci kesuksesan. Jika Anda mencintai apa yang Anda kerjakan, Anda akan sukses.",
    "Masa depan adalah milik mereka yang percaya pada keindahan mimpi mereka. - Eleanor Roosevelt",
    "Jenius adalah 1% inspirasi dan 99% keringat. - Thomas Alva Edison",
    "Tetaplah lapar, tetaplah bodoh. - Steve Jobs",
    "Peluang besar biasanya disamarkan sebagai kerja keras, sehingga kebanyakan orang tidak mengenalinya.",
    "Ilmu itu seperti air. Jika ia berhenti mengalir, ia menjadi keruh. - Imam Syafi'i",
    "Barangsiapa tidak mau merasakan pahitnya belajar, ia akan merasakan hinanya kebodohan sepanjang hidupnya. - Imam Syafi'i",
  ];

  late String _currentMotivation;

  @override
  void initState() {
    super.initState();
    _currentMotivation = _motivations[Random().nextInt(_motivations.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: widget.themeColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGrid(),
            const SizedBox(height: 20),
            _buildProgressSection(),
            const SizedBox(height: 20),
            _buildMotivationSection(),
            const SizedBox(height: 15),
            _buildAiAssistantButton(context),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildAiAssistantButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NetropiaAiScreen(
                initialMessage: "Jelaskan tentang materi ${widget.title}",
              ),
            ),
          );
        },
        icon: const Icon(Icons.psychology_rounded),
        label: const Text("Jelaskan materi ini dengan AI"),
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.themeColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    final List<Map<String, dynamic>> menuItems = [
      {'name': 'Materi', 'icon': Icons.menu_book_rounded, 'color': Colors.blue},
      {'name': 'Video', 'icon': Icons.play_circle_fill_rounded, 'color': Colors.red},
      {'name': 'Peta Konsep', 'icon': Icons.account_tree_rounded, 'color': Colors.teal},
      {'name': 'Referensi', 'icon': Icons.library_books_rounded, 'color': Colors.indigo},
      {'name': 'Pre Test', 'icon': Icons.assignment_rounded, 'color': Colors.orange},
      {'name': 'Post test', 'icon': Icons.assignment_turned_in_rounded, 'color': Colors.green},
      {'name': 'Penugasan', 'icon': Icons.task_rounded, 'color': Colors.deepOrange},
      {'name': 'Portofolio', 'icon': Icons.folder_shared_rounded, 'color': Colors.purple},
      {'name': 'Forum Diskusi', 'icon': Icons.forum_rounded, 'color': Colors.lightBlue},
      {'name': 'Refleksi', 'icon': Icons.psychology_rounded, 'color': Colors.pink},
      {'name': 'Evaluasi', 'icon': Icons.assessment_rounded, 'color': Colors.cyan},
      {'name': 'Feedback', 'icon': Icons.feedback_rounded, 'color': Colors.deepPurple},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        return _buildMenuItem(
          menuItems[index]['name'],
          menuItems[index]['icon'],
          menuItems[index]['color'],
        );
      },
    );
  }

  Widget _buildMenuItem(String name, IconData icon, Color iconColor) {
    return InkWell(
      onTap: () {
        // Implement navigation or action here
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: iconColor.withOpacity(0.15),
                width: 1.0,
              ),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    double progressValue = 0.45; // Contoh nilai progres (45%)

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Progres Belajar",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
              ),
              Text(
                "${(progressValue * 100).toInt()}%",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: widget.themeColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 8,
              backgroundColor: widget.themeColor.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(widget.themeColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Lanjutkan untuk menyelesaikan materi ini!",
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.themeColor.withOpacity(0.05),
            widget.themeColor.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.themeColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: widget.themeColor.withOpacity(0.4),
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            _currentMotivation,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: widget.themeColor.withOpacity(0.8),
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "- Motivasi Hari Ini -",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: widget.themeColor.withOpacity(0.5),
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
