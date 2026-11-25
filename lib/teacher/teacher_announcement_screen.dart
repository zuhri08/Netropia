import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';

class TeacherAnnouncementScreen extends StatefulWidget {
  const TeacherAnnouncementScreen({super.key});

  @override
  State<TeacherAnnouncementScreen> createState() => _TeacherAnnouncementScreenState();
}

class _TeacherAnnouncementScreenState extends State<TeacherAnnouncementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _announcementTitleController = TextEditingController();
  final _announcementContentController = TextEditingController();
  String _selectedClassForAnnouncement = 'Semua Kelas';

  final List<String> _classOptions = [
    'Semua Kelas',
    'X TKJ 1',
    'X TKJ 2',
    'X TKJ 3',
    'XI TKJ 1',
    'XI TKJ 2',
    'XI TKJ 3',
    'XII TKJ 1',
    'XII TKJ 2',
    'XII TKJ 3',
  ];

  bool _isSubmitting = false;

  @override
  void dispose() {
    _announcementTitleController.dispose();
    _announcementContentController.dispose();
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

  Future<void> _createAnnouncement() async {
    final title = _announcementTitleController.text.trim();
    final content = _announcementContentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      _showMessage('Judul dan isi pengumuman tidak boleh kosong.', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = _auth.currentUser;
      final docRef = _firestore.collection('announcements').doc();

      await docRef.set({
        'id': docRef.id,
        'judul': title,
        'isi': content,
        'kelas': _selectedClassForAnnouncement,
        'guruId': user?.uid ?? '',
        'guruName': user?.displayName ?? user?.email ?? 'Guru Netropia',
        'createdAt': FieldValue.serverTimestamp(),
      });

      await NotificationService().addNotification(
        title: 'Pengumuman Baru: $title 📢',
        message: content,
        type: NotificationType.system,
      );

      _announcementTitleController.clear();
      _announcementContentController.clear();

      _showMessage('Pengumuman berhasil dikirim ke siswa!');
    } catch (e) {
      _showMessage('Gagal mengirim pengumuman: $e', isError: true);
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
        title: const Text('Pengumuman Kelas', style: TextStyle(fontWeight: FontWeight.bold)),
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
                        Icon(Icons.campaign_rounded, color: AppTheme.primaryTeal),
                        SizedBox(width: 8),
                        Text(
                          'Buat Pengumuman Kelas Baru',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Target Kelas', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedClassForAnnouncement,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      items: _classOptions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedClassForAnnouncement = val);
                      },
                    ),
                    const SizedBox(height: 14),
                    const Text('Judul Pengumuman', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _announcementTitleController,
                      decoration: InputDecoration(
                        hintText: 'Misal: Informasi Praktikum Kabel UTP Besok',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text('Isi Pengumuman', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _announcementContentController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Tuliskan instruksi atau pesan penting untuk siswa...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : _createAnnouncement,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryTeal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.campaign_rounded),
                        label: Text(_isSubmitting ? 'Menerbitkan...' : 'Kirim Pengumuman Ke Siswa'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'DAFTAR PENGUMUMAN AKTIF',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('announcements').orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: Text('Belum ada pengumuman kelas.', style: TextStyle(color: Colors.grey))),
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
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.campaign_rounded, color: Colors.white),
                        ),
                        title: Text(data['judul'] ?? 'Pengumuman', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Target: ${data['kelas']} • ${data['isi']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppTheme.accentRed),
                          onPressed: () async {
                            await _firestore.collection('announcements').doc(docs[index].id).delete();
                            _showMessage('Pengumuman dihapus.');
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
