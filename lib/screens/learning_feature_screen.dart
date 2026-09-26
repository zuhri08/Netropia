import 'package:flutter/material.dart';
import '../services/progress_service.dart';

class LearningFeatureScreen extends StatefulWidget {
  final String materiId;
  final String materiTitle;
  final String feature;
  final Color themeColor;

  const LearningFeatureScreen({
    super.key,
    required this.materiId,
    required this.materiTitle,
    required this.feature,
    required this.themeColor,
  });

  @override
  State<LearningFeatureScreen> createState() => _LearningFeatureScreenState();
}

class _LearningFeatureScreenState extends State<LearningFeatureScreen> {
  final ProgressService _progressService = ProgressService();
  bool _isCompleted = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  String get _activityKey {
    final featureKey = widget.feature.toLowerCase().replaceAll(' ', '_');
    return '${widget.materiId}_$featureKey';
  }

  Future<void> _checkStatus() async {
    final status = await _progressService.isLessonCompleted(_activityKey);
    if (mounted) {
      setState(() {
        _isCompleted = status;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleCompleted() async {
    final newStatus = !_isCompleted;
    await _progressService.setLessonCompleted(_activityKey, newStatus);
    if (mounted) {
      setState(() {
        _isCompleted = newStatus;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus
                ? 'Aktivitas ${widget.feature} ditandai selesai!'
                : 'Status selesai dibatalkan.',
          ),
          backgroundColor: newStatus ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.feature} - ${widget.materiTitle}'),
        backgroundColor: widget.themeColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: widget.themeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: widget.themeColor.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _getFeatureIcon(widget.feature),
                          size: 48,
                          color: widget.themeColor,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.feature,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: widget.themeColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Materi: ${widget.materiTitle}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deskripsi Fitur',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.titleMedium?.color,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _getFeatureDescription(widget.feature, widget.materiTitle),
                            style: const TextStyle(fontSize: 14, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _toggleCompleted,
                      icon: Icon(
                        _isCompleted ? Icons.check_circle : Icons.circle_outlined,
                      ),
                      label: Text(
                        _isCompleted ? 'Selesai (Klik untuk Batal)' : 'Tandai Selesai',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isCompleted ? Colors.green : widget.themeColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  IconData _getFeatureIcon(String feature) {
    switch (feature) {
      case 'Peta Konsep':
        return Icons.account_tree_rounded;
      case 'Pre Test':
        return Icons.assignment_rounded;
      case 'Post Test':
        return Icons.assignment_turned_in_rounded;
      case 'Penugasan':
        return Icons.task_rounded;
      case 'Portofolio':
        return Icons.folder_shared_rounded;
      case 'Forum Diskusi':
        return Icons.forum_rounded;
      case 'Refleksi':
        return Icons.psychology_rounded;
      case 'Evaluasi':
        return Icons.assessment_rounded;
      case 'Feedback':
        return Icons.feedback_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  String _getFeatureDescription(String feature, String materi) {
    switch (feature) {
      case 'Peta Konsep':
        return 'Peta konsep memberikan gambaran visual mengenai hubungan antarkonsep dalam materi $materi.';
      case 'Pre Test':
        return 'Pre test digunakan untuk mengukur pemahaman awal Anda sebelum mempelajari materi $materi.';
      case 'Post Test':
        return 'Post test menguji sejauh mana Anda menguasai materi $materi setelah pembelajaran selesai.';
      case 'Penugasan':
        return 'Tugas mandiri atau kelompok untuk memperdalam pemahaman konsep $materi secara praktis.';
      case 'Portofolio':
        return 'Kumpulan hasil karya, laporan, atau proyek yang berhubungan dengan materi $materi.';
      case 'Forum Diskusi':
        return 'Ruang untuk berdiskusi, bertanya, dan berbagi informasi bersama teman dan guru mengenai $materi.';
      case 'Refleksi':
        return 'Renungkan apa yang telah dipelajari, kesulitan yang dihadapi, serta rencana perbaikan dalam $materi.';
      case 'Evaluasi':
        return 'Penilaian menyeluruh terhadap proses dan hasil belajar materi $materi.';
      case 'Feedback':
        return 'Berikan masukan dan tanggapan mengenai materi dan pembelajaran $materi.';
      default:
        return 'Fitur pembelajaran untuk materi $materi.';
    }
  }
}
