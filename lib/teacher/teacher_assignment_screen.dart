import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TeacherAssignmentScreen extends StatefulWidget {
  const TeacherAssignmentScreen({super.key});

  @override
  State<TeacherAssignmentScreen> createState() => _TeacherAssignmentScreenState();
}

class _TeacherAssignmentScreenState extends State<TeacherAssignmentScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _assignmentTitleController = TextEditingController();
  final _assignmentDescController = TextEditingController();
  String _selectedMateriForAssignment = 'Dasar Jaringan';

  final List<String> _materiOptions = [
    'Dasar Jaringan',
    'K3',
    'Komponen Komputer',
    'Perangkat Jaringan',
    'IP Address',
    'Kabel Jaringan',
  ];

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadCustomMateriOptions();
  }

  Future<void> _loadCustomMateriOptions() async {
    try {
      final snapshot = await _firestore.collection('custom_materials').get();
      final customTitles = snapshot.docs
          .map((doc) => doc.data()['judul']?.toString().trim())
          .whereType<String>()
          .where((title) => title.isNotEmpty)
          .toList();

      if (mounted) {
        setState(() {
          for (final title in customTitles) {
            if (!_materiOptions.contains(title)) {
              _materiOptions.add(title);
            }
          }
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _assignmentTitleController.dispose();
    _assignmentDescController.dispose();
    super.dispose();
  }

  void _showMessage(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppTheme.accentRed : const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _createAssignment() async {
    final title = _assignmentTitleController.text.trim();
    final desc = _assignmentDescController.text.trim();

    if (title.isEmpty || desc.isEmpty) {
      _showMessage('Judul dan instruksi tugas tidak boleh kosong.', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = _auth.currentUser;
      final docRef = _firestore.collection('assignments').doc();

      await docRef.set({
        'id': docRef.id,
        'judul': title,
        'materiTitle': _selectedMateriForAssignment,
        'deskripsi': desc,
        'deadline': Timestamp.fromDate(DateTime.now().add(const Duration(days: 7))),
        'guruId': user?.uid ?? '',
        'guruName': user?.displayName ?? user?.email ?? 'Guru Netropia',
        'createdAt': FieldValue.serverTimestamp(),
      });

      _assignmentTitleController.clear();
      _assignmentDescController.clear();

      _showMessage('Tugas baru berhasil dipublikasikan ke siswa!');
    } catch (e) {
      _showMessage('Gagal membuat tugas: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSubmissionsDialog(String assignmentId, String assignmentTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.assignment_turned_in_rounded, color: AppTheme.primaryTeal),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pengumpulkan Siswa: $assignmentTitle',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('assignment_submissions')
                      .where('assignmentId', isEqualTo: assignmentId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = snapshot.data?.docs ?? [];
                    if (docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'Belum ada siswa yang mengumpulkan tugas ini.',
                          style: TextStyle(color: AppTheme.textMuted),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        final subDocId = docs[index].id;
                        final siswaName = data['siswaName'] ?? 'Siswa';
                        final jawaban = data['jawaban'] ?? '';
                        final nilai = data['nilai'];
                        final catatanGuru = data['catatanGuru'] ?? '';
                        final fileUrl = data['fileUrl']?.toString();

                        final nilaiController = TextEditingController(text: nilai?.toString() ?? '');
                        final catatanController = TextEditingController(text: catatanGuru);

                        Uint8List? imageBytes;
                        if (fileUrl != null && fileUrl.contains('data:image')) {
                          try {
                            final base64String = fileUrl.split(',').last;
                            imageBytes = base64Decode(base64String);
                          } catch (_) {}
                        }

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: AppTheme.primaryTeal,
                                      child: const Icon(Icons.person_rounded, size: 16, color: Colors.white),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        siswaName,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                    ),
                                    if (nilai != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade100,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Nilai: $nilai/100',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900, fontSize: 12),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text('Jawaban Siswa:\n"$jawaban"', style: const TextStyle(fontSize: 13, height: 1.4)),
                                if (imageBytes != null) ...[
                                  const SizedBox(height: 10),
                                  Text('Foto Bukti Jawaban:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryTeal)),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.memory(
                                      imageBytes,
                                      height: 160,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: TextField(
                                        controller: nilaiController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: 'Nilai (0-100)',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        controller: catatanController,
                                        decoration: const InputDecoration(
                                          labelText: 'Catatan Guru (Opsional)',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      final gradeVal = int.tryParse(nilaiController.text.trim());
                                      final noteVal = catatanController.text.trim();

                                      await _firestore.collection('assignment_submissions').doc(subDocId).update({
                                        'nilai': gradeVal,
                                        'catatanGuru': noteVal,
                                      });

                                      if (mounted) {
                                        _showMessage('Nilai berhasil disimpan untuk $siswaName!');
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryTeal,
                                      foregroundColor: Colors.white,
                                    ),
                                    icon: const Icon(Icons.check_rounded, size: 16),
                                    label: const Text('Simpan Nilai'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Kelola Penugasan Siswa', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryTeal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.add_task_rounded, color: AppTheme.primaryTeal),
                        SizedBox(width: 8),
                        Text(
                          'Buat Penugasan Baru',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Topik Materi', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedMateriForAssignment,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      items: _materiOptions.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedMateriForAssignment = val);
                      },
                    ),
                    const SizedBox(height: 14),
                    const Text('Judul Tugas', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _assignmentTitleController,
                      decoration: InputDecoration(
                        hintText: 'Misal: Analisis Topologi Jaringan Lab',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text('Instruksi & Deskripsi Tugas', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _assignmentDescController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Tuliskan langkah pengerjaan, soal, dan format pengumpulan...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : _createAssignment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryTeal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: _isSubmitting
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.send_rounded),
                        label: Text(_isSubmitting ? 'Menerbitkan...' : 'Terbitkan Tugas ke Siswa'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'DAFTAR TUGAS DIBERIKAN GURU',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('assignments').orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: Text('Belum ada tugas buatan guru.', style: TextStyle(color: Colors.grey))),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final assignmentId = docs[index].id;
                    final judul = data['judul'] ?? 'Tugas';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: AppTheme.tealTint,
                                child: const Icon(Icons.assignment_ind_rounded, color: AppTheme.primaryTeal),
                              ),
                              title: Text(judul, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('${data['materiTitle']} • ${data['deskripsi']}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppTheme.accentRed),
                                onPressed: () async {
                                  await _firestore.collection('assignments').doc(assignmentId).delete();
                                  _showMessage('Tugas dihapus.');
                                },
                              ),
                            ),
                            const Divider(height: 1),
                            const SizedBox(height: 6),
                            Align(
                              alignment: Alignment.centerRight,
                              child: OutlinedButton.icon(
                                onPressed: () => _showSubmissionsDialog(assignmentId, judul),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.primaryTeal,
                                  side: BorderSide(color: AppTheme.primaryTeal),
                                ),
                                icon: const Icon(Icons.rate_review_rounded, size: 16),
                                label: const Text('Lihat Jawaban & Beri Nilai Siswa'),
                              ),
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
