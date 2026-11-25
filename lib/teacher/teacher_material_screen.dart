import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TeacherMaterialScreen extends StatefulWidget {
  const TeacherMaterialScreen({super.key});

  @override
  State<TeacherMaterialScreen> createState() => _TeacherMaterialScreenState();
}

class _TeacherMaterialScreenState extends State<TeacherMaterialScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _materialTitleController = TextEditingController();
  final _materialCategoryController = TextEditingController();
  final _materialContentController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _materialTitleController.dispose();
    _materialCategoryController.dispose();
    _materialContentController.dispose();
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

  Future<void> _createMaterial() async {
    final title = _materialTitleController.text.trim();
    final category = _materialCategoryController.text.trim();
    final content = _materialContentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      _showMessage('Judul dan isi materi tidak boleh kosong.', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = _auth.currentUser;
      final docRef = _firestore.collection('custom_materials').doc();

      await docRef.set({
        'id': docRef.id,
        'judul': title,
        'kategori': category.isEmpty ? 'Umum' : category,
        'isi': content,
        'guruId': user?.uid ?? '',
        'guruName': user?.displayName ?? user?.email ?? 'Guru Netropia',
        'createdAt': FieldValue.serverTimestamp(),
      });

      _materialTitleController.clear();
      _materialCategoryController.clear();
      _materialContentController.clear();

      _showMessage('Materi baru berhasil dipublikasikan ke siswa!');
    } catch (e) {
      _showMessage('Gagal menerbitkan materi: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Buat & Terbitkan Materi', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    const Row(
                      children: [
                        Icon(Icons.note_add_rounded, color: AppTheme.primaryTeal),
                        SizedBox(width: 8),
                        Text(
                          'Terbitkan Materi Pembelajaran',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Judul Materi', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _materialTitleController,
                      decoration: InputDecoration(
                        hintText: 'Misal: Panduan Konfigurasi Mikrotik RouterOS',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text('Kategori / Topik', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _materialCategoryController,
                      decoration: InputDecoration(
                        hintText: 'Misal: Jaringan Lanjut / Mikrotik',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text('Isi Lengkap Materi', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _materialContentController,
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText: 'Tuliskan isi materi, konsep, dan langkah-langkah praktikum secara detail...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : _createMaterial,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryTeal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.publish_rounded),
                        label: Text(_isSubmitting ? 'Menerbitkan...' : 'Terbitkan Materi Ke Siswa'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'DAFTAR MATERI BUATAN GURU',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('custom_materials').orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: Text('Belum ada materi buatan guru.', style: TextStyle(color: Colors.grey))),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppTheme.tealTint,
                          child: Icon(Icons.note_alt_rounded, color: AppTheme.primaryTeal),
                        ),
                        title: Text(data['judul'] ?? 'Materi', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Kategori: ${data['kategori']} • Oleh: ${data['guruName']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppTheme.accentRed),
                          onPressed: () async {
                            await _firestore.collection('custom_materials').doc(docs[index].id).delete();
                            _showMessage('Materi dihapus.');
                          },
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
