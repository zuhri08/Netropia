import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';

class TeacherReflectionScreen extends StatefulWidget {
  const TeacherReflectionScreen({super.key});

  @override
  State<TeacherReflectionScreen> createState() => _TeacherReflectionScreenState();
}

class _TeacherReflectionScreenState extends State<TeacherReflectionScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _showMessage(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  void _showAwardBadgeDialog(String siswaUid, String namaSiswa) {
    String selectedBadge = '⭐ Siswa Paling Aktif';
    final noteController = TextEditingController();

    final badgeOptions = [
      '⭐ Siswa Paling Aktif',
      '💡 Solusi & Jawaban Terbaik',
      '🚀 Kemajuan Tercepat',
      '🥇 Nilai Sempurna',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Beri Apresiasi Kepada $namaSiswa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih Jenis Lencana Apresiasi:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            StatefulBuilder(
              builder: (context, setDialogState) {
                return DropdownButtonFormField<String>(
                  initialValue: selectedBadge,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                  items: badgeOptions.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                  onChanged: (val) {
                    if (val != null) setDialogState(() => selectedBadge = val);
                  },
                );
              },
            ),
            const SizedBox(height: 14),
            const Text('Catatan Pujian Guru (Opsional):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: noteController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Misal: Selamat atas kerja kerasmu di kelas!',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton.icon(
            onPressed: () async {
              final user = _auth.currentUser;
              final award = {
                'badge': selectedBadge,
                'catatan': noteController.text.trim(),
                'guruName': user?.displayName ?? user?.email ?? 'Guru Netropia',
                'createdAt': DateTime.now().toIso8601String(),
              };

              if (siswaUid.isNotEmpty) {
                await _firestore.collection('users').doc(siswaUid).update({
                  'awards': FieldValue.arrayUnion([award]),
                });
              }

              await NotificationService().addNotification(
                title: 'Selamat! Kamu Mendapat Apresiasi Guru 🎉',
                message: 'Guru memberi kamu lencana "$selectedBadge". Buka profil untuk melihat!',
                type: NotificationType.system,
              );

              if (mounted) {
                Navigator.pop(context);
                _showMessage('Apresiasi berhasil diberikan ke $namaSiswa!');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryTeal,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.star_rounded, color: AppTheme.accentAmber),
            label: const Text('Kirim Lencana'),
          ),
        ],
      ),
    );
  }

  void _showGiveFeedbackDialog(String docId, String namaSiswa, String currentFeedback) {
    final controller = TextEditingController(text: currentFeedback);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Umpan Balik Guru untuk $namaSiswa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Berikan evaluasi, pujian, atau saran langsung untuk siswa ini:',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Misal: Penjelasanmu sangat baik! Pertahankan semangat belajarmu.',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              final text = controller.text.trim();
              await _firestore.collection('reflections').doc(docId).update({
                'feedbackGuru': text,
              });
              if (mounted) {
                Navigator.pop(context);
                _showMessage('Tanggapan berhasil dikirim ke siswa!');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryTeal,
              foregroundColor: Colors.white,
            ),
            child: const Text('Kirim Tanggapan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Ulasan & Refleksi Siswa', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryTeal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Refleksi & Evaluasi Belajar Siswa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tinjau hasil refleksi belajar siswa dan berikan umpan balik atau lencana apresiasi.',
              style: TextStyle(fontSize: 12.5, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('reflections').orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'Belum ada refleksi yang dikirim oleh siswa.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final docId = docs[index].id;
                    final namaSiswa = data['namaSiswa'] ?? 'Siswa';
                    final kelas = data['kelas'] ?? '-';
                    final materiTitle = data['materiTitle'] ?? 'Materi';
                    final mood = data['mood'] ?? '🙂';
                    final score = data['understanding'] ?? 3;
                    final newThing = data['newThing'] ?? '-';
                    final challenge = data['challenge'] ?? '-';
                    final feedbackGuru = data['feedbackGuru'] ?? '';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppTheme.primaryTeal.withValues(alpha: 0.15),
                                  child: Text(
                                    mood,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$namaSiswa ($kelas)',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      Text(
                                        'Materi: $materiTitle • Pemahaman: $score/5',
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20),
                            if (newThing != '-') ...[
                              Text(
                                'Hal Baru Dipelajari:',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 2),
                              Text('"$newThing"', style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic)),
                              const SizedBox(height: 8),
                            ],
                            if (challenge != '-') ...[
                              Text(
                                'Tantangan Siswa:',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 2),
                              Text(challenge, style: const TextStyle(fontSize: 13)),
                              const SizedBox(height: 8),
                            ],
                            if (feedbackGuru.toString().isNotEmpty) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0F2F1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFF00897B).withValues(alpha: 0.3)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF00897B)),
                                        SizedBox(width: 6),
                                        Text(
                                          'Tanggapan / Catatan Guru:',
                                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF00897B)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      feedbackGuru.toString(),
                                      style: const TextStyle(fontSize: 13, color: AppTheme.textDark),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () {
                                    final siswaUid = data['siswaUid']?.toString() ?? '';
                                    _showAwardBadgeDialog(siswaUid, namaSiswa);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppTheme.accentAmber,
                                    side: const BorderSide(color: AppTheme.accentAmber),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  icon: const Icon(Icons.star_rounded, size: 16, color: AppTheme.accentAmber),
                                  label: const Text('Beri Lencana'),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  onPressed: () => _showGiveFeedbackDialog(docId, namaSiswa, feedbackGuru.toString()),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF00897B),
                                    side: const BorderSide(color: Color(0xFF00897B)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  icon: const Icon(Icons.rate_review_rounded, size: 16),
                                  label: Text(feedbackGuru.toString().isEmpty ? 'Beri Tanggapan' : 'Edit Tanggapan'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
