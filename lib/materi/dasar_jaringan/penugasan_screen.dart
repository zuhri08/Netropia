import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_theme.dart';

class PenugasanScreen extends StatefulWidget {
  final String materiId;
  final String materiTitle;

  const PenugasanScreen({
    super.key,
    this.materiId = 'dasar_jaringan',
    this.materiTitle = 'Dasar Jaringan',
  });

  @override
  State<PenugasanScreen> createState() => _PenugasanScreenState();
}

class _PenugasanScreenState extends State<PenugasanScreen> {
  bool _isCompleted = false;
  bool _isSubmitting = false;
  final TextEditingController _answerController = TextEditingController();

  XFile? _pickedFile;
  String? _base64File;
  String? _fileName;

  final List<String> _steps = [
    'Tentukan kebutuhan dan pemahaman terkait materi.',
    'Pilih metode atau komponen yang sesuai dan jelaskan alasannya.',
    'Tentukan langkah-langkah pengerjaan yang diperlukan.',
    'Buat ringkasan atau diagram rancangan.',
    'Jelaskan kesimpulan dan hasil pengerjaan.',
  ];

  final List<bool> _checkedSteps = List.filled(5, false);

  int get _completedSteps => _checkedSteps.where((e) => e).length;
  double get _progress => _completedSteps / _steps.length;

  Future<void> _pickFile() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      final bytes = await image.readAsBytes();
      final base64Str = base64Encode(bytes);
      setState(() {
        _pickedFile = image;
        _fileName = image.name;
        _base64File = 'data:image/jpeg;base64,$base64Str';
      });
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBrown,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Ruang Penugasan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(),
            const SizedBox(height: 18),
            _buildProgress(isDark),
            const SizedBox(height: 22),
            _buildSectionHeading('KENALI TUGASMU', 'Pahami tujuan sebelum mulai.', isDark),
            const SizedBox(height: 10),
            _buildOverview(isDark),
            const SizedBox(height: 22),
            _buildSectionHeading('LOKASI & LANGKAH PENGERJAAN', 'Centang setiap langkah yang selesai.', isDark),
            const SizedBox(height: 10),
            _buildChecklist(isDark),
            const SizedBox(height: 22),
            _buildSectionHeading('LEMBAR JAWABAN & BUKTI FOTO/FILE', 'Ceritakan hasil pengerjaanmu dan lampirkan bukti.', isDark),
            const SizedBox(height: 10),
            _buildAnswer(isDark),
            const SizedBox(height: 18),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [AppTheme.primaryBrown, AppTheme.darkBrown],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'TUGAS PRAKTIK · ${widget.materiTitle.toUpperCase()}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Penugasan Praktik\n${widget.materiTitle}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              height: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Saatnya menerapkan pemahaman modul ${widget.materiTitle} dalam tugas praktik interaktif.',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Progress pengerjaan',
                  style: TextStyle(
                    color: isDark ? Colors.white : AppTheme.textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
              ),
              Text(
                '$_completedSteps/${_steps.length} langkah',
                style: const TextStyle(
                  color: AppTheme.primaryBrown,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 8,
              backgroundColor: isDark ? Colors.grey.shade800 : AppTheme.borderCream,
              valueColor: const AlwaysStoppedAnimation(AppTheme.primaryBrown),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeading(String title, String subtitle, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildOverview(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
        ),
      ),
      child: Column(
        children: [
          _overviewItem(
            icon: Icons.flag_rounded,
            title: 'Tujuan pembelajaran',
            description: 'Menerapkan konsep ${widget.materiTitle} dalam penyelesaian studi kasus atau tugas praktik.',
            isDark: isDark,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _overviewItem(
            icon: Icons.task_alt_rounded,
            title: 'Hasil akhir',
            description: 'Kumpulkan hasil tugas praktikmu dan lampirkan foto/file pendukung.',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _overviewItem({
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppTheme.brownTint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primaryBrown, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white : AppTheme.textDark,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklist(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
        ),
      ),
      child: Column(
        children: List.generate(_steps.length, (index) {
          final checked = _checkedSteps[index];

          return InkWell(
            onTap: _isCompleted
                ? null
                : () {
                    setState(() {
                      _checkedSteps[index] = !_checkedSteps[index];
                    });
                  },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    checked ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                    size: 20,
                    color: checked ? AppTheme.primaryBrown : AppTheme.textMuted,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _steps[index],
                      style: TextStyle(
                        color: checked ? AppTheme.textMuted : (isDark ? Colors.white : AppTheme.textDark),
                        fontSize: 12.5,
                        decoration: checked ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAnswer(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jelaskan solusi dan jawabanmu terkait materi ${widget.materiTitle}.',
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _answerController,
            enabled: !_isCompleted,
            minLines: 4,
            maxLines: 7,
            style: TextStyle(
              color: isDark ? Colors.white : AppTheme.textDark,
              fontSize: 13,
            ),
            decoration: InputDecoration(
              hintText: 'Tuliskan jawaban di sini...',
              filled: true,
              fillColor: isDark ? const Color(0xFF2E241E) : AppTheme.surfaceCream,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'LAMPIRKAN FOTO / BUKTI PRAKTIK (OPSIONAL):',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 8),
          if (_base64File != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.tealTint,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryTeal.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.image_rounded, color: AppTheme.primaryTeal, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _fileName ?? 'foto_praktik.jpg',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppTheme.textDark,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!_isCompleted)
                    IconButton(
                      icon: const Icon(Icons.close, size: 18, color: AppTheme.accentRed),
                      onPressed: () => setState(() {
                        _pickedFile = null;
                        _base64File = null;
                        _fileName = null;
                      }),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          if (!_isCompleted)
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.attach_file_rounded, size: 18),
                label: Text(_base64File == null ? 'Unggah Foto Bukti / File' : 'Ganti Foto / File'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryTeal,
                  side: const BorderSide(color: AppTheme.primaryTeal),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: (_isCompleted || _isSubmitting) ? null : _submitAssignment,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryBrown,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(
                _isCompleted ? 'Tugas Sudah Dikumpulkan' : 'Kumpulkan Tugas Ke Guru',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
      ),
    );
  }

  Future<void> _submitAssignment() async {
    final answerText = _answerController.text.trim();
    if (answerText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Isi jawabanmu terlebih dahulu sebelum mengumpulkan.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final userData = userDoc.data() ?? {};
        final namaSiswa = userData['nama']?.toString() ?? 'Siswa';
        final kelasSiswa = userData['kelas']?.toString() ?? 'X TKJ 1';

        final docRef = FirebaseFirestore.instance.collection('assignment_submissions').doc();

        await docRef.set({
          'id': docRef.id,
          'assignmentId': widget.materiId,
          'materiTitle': widget.materiTitle,
          'siswaId': user.uid,
          'siswaName': namaSiswa,
          'kelas': kelasSiswa,
          'jawaban': answerText,
          'fileUrl': _base64File,
          'fileName': _fileName,
          'nilai': null,
          'catatanGuru': null,
          'submittedAt': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      if (mounted) {
        setState(() {
          _isCompleted = true;
          _isSubmitting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tugas berhasil dikumpulkan dan dikirim ke Dasbor Guru!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengirim tugas: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
