import 'package:flutter/material.dart';

class PenugasanScreen extends StatefulWidget {
  const PenugasanScreen({super.key});

  @override
  State<PenugasanScreen> createState() => _PenugasanScreenState();
}

class _PenugasanScreenState extends State<PenugasanScreen> {
  bool _isCompleted = false;
  final TextEditingController _answerController = TextEditingController();

  final List<String> _steps = [
    'Tentukan kebutuhan jaringan untuk minimal 10 komputer.',
    'Pilih topologi dan jelaskan alasan pemilihannya.',
    'Tentukan perangkat jaringan yang diperlukan.',
    'Buat diagram rancangan jaringan.',
    'Jelaskan cara komputer saling berkomunikasi.',
  ];

  final List<bool> _checkedSteps = List.filled(5, false);

  static const Color primary = Color(0xFF2563EB);
  static const Color dark = Color(0xFF172B4D);
  static const Color muted = Color(0xFF718096);
  static const Color background = Color(0xFFF4F7FB);

  int get _completedSteps => _checkedSteps.where((e) => e).length;

  double get _progress => _completedSteps / _steps.length;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: dark,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Ruang Penugasan',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(),
            const SizedBox(height: 20),
            _buildProgress(),
            const SizedBox(height: 26),
            _buildSectionHeading('Kenali tugasmu', 'Pahami tujuan sebelum mulai.'),
            const SizedBox(height: 12),
            _buildOverview(),
            const SizedBox(height: 26),
            _buildSectionHeading('Misi pengerjaan', 'Centang setiap langkah yang selesai.'),
            const SizedBox(height: 12),
            _buildChecklist(),
            const SizedBox(height: 26),
            _buildSectionHeading('Perlengkapan', 'Siapkan sebelum mulai mengerjakan.'),
            const SizedBox(height: 12),
            _buildMaterials(),
            const SizedBox(height: 26),
            _buildSectionHeading('Lembar jawaban', 'Ceritakan hasil rancanganmu.'),
            const SizedBox(height: 12),
            _buildAnswer(),
            const SizedBox(height: 18),
            _buildSubmissionInfo(),
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
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF3984F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -8,
            top: 4,
            child: Icon(
              Icons.hub_rounded,
              size: 112,
              color: Colors.white.withOpacity(0.12),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'TUGAS PRAKTIK • DASAR JARINGAN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Rancang jaringan\nLAN versimu!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  height: 1.15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Saatnya menerapkan konsep jaringan komputer '
                    'ke dalam sebuah laboratorium sekolah.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _heroTag(Icons.schedule_rounded, '60 menit'),
                  const SizedBox(width: 8),
                  _heroTag(Icons.category_rounded, 'Praktik'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroTag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.17),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EDF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Progress pengerjaan',
                  style: TextStyle(
                    color: dark,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                '$_completedSteps/${_steps.length} langkah',
                style: const TextStyle(
                  color: primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 9,
              backgroundColor: const Color(0xFFEAF0FA),
              valueColor: const AlwaysStoppedAnimation(primary),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _completedSteps == 0
                ? 'Belum mulai. Yuk, kerjakan langkah pertamamu!'
                : _completedSteps == _steps.length
                ? 'Semua langkah selesai. Saatnya kumpulkan jawaban!'
                : 'Bagus! Kamu sudah menyelesaikan $_completedSteps langkah.',
            style: const TextStyle(
              color: muted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeading(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: dark,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: muted, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildOverview() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EDF5)),
      ),
      child: Column(
        children: [
          _overviewItem(
            icon: Icons.flag_rounded,
            title: 'Tujuan pembelajaran',
            description:
            'Menerapkan konsep dasar jaringan komputer melalui rancangan LAN sederhana.',
            color: const Color(0xFF2563EB),
          ),
          const Divider(height: 1, indent: 18, endIndent: 18),
          _overviewItem(
            icon: Icons.assignment_rounded,
            title: 'Tantanganmu',
            description:
            'Rancang jaringan LAN untuk laboratorium sekolah dengan minimal 10 komputer.',
            color: const Color(0xFF0D9488),
          ),
          const Divider(height: 1, indent: 18, endIndent: 18),
          _overviewItem(
            icon: Icons.task_alt_rounded,
            title: 'Hasil akhir',
            description:
            'Diagram jaringan yang jelas, lengkap, dan sesuai kebutuhan laboratorium.',
            color: const Color(0xFFEA8A18),
          ),
        ],
      ),
    );
  }

  Widget _overviewItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: dark,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklist() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EDF5)),
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 29,
                    height: 29,
                    decoration: BoxDecoration(
                      color: checked ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      checked ? Icons.check_rounded : Icons.circle_outlined,
                      size: 19,
                      color: checked ? const Color(0xFF16A34A) : muted,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _steps[index],
                      style: TextStyle(
                        color: checked ? muted : dark,
                        fontSize: 13,
                        height: 1.45,
                        decoration: checked ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    checked ? Icons.check_circle_rounded : Icons.chevron_right_rounded,
                    color: checked ? const Color(0xFF16A34A) : const Color(0xFFB5C0CE),
                    size: 20,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMaterials() {
    final materials = [
      (Icons.draw_rounded, 'Kertas atau aplikasi diagram'),
      (Icons.menu_book_rounded, 'Referensi materi Dasar Jaringan'),
      (Icons.devices_rounded, 'Daftar perangkat jaringan'),
    ];

    return Wrap(
      spacing: 9,
      runSpacing: 9,
      children: materials.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0xFFE8EDF5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.$1, color: primary, size: 17),
              const SizedBox(width: 8),
              Text(
                item.$2,
                style: const TextStyle(
                  color: dark,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAnswer() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EDF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_note_rounded, color: primary, size: 23),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Tuliskan hasil rancanganmu',
                  style: TextStyle(
                    color: dark,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                '${_answerController.text.length} karakter',
                style: const TextStyle(color: muted, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Jelaskan perangkat, topologi, dan cara kerja jaringan yang kamu rancang.',
            style: TextStyle(color: muted, fontSize: 12, height: 1.5),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _answerController,
            enabled: !_isCompleted,
            minLines: 6,
            maxLines: 10,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(
              color: dark,
              fontSize: 13,
              height: 1.5,
            ),
            decoration: InputDecoration(
              hintText: 'Mulai tulis ide dan rancanganmu di sini...',
              hintStyle: const TextStyle(color: Color(0xFFA0AAB8), fontSize: 12),
              filled: true,
              fillColor: const Color(0xFFF8FAFD),
              contentPadding: const EdgeInsets.all(15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE3EAF3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE3EAF3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: primary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline_rounded, color: primary, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tips: Susun jawaban secara berurutan agar rancanganmu mudah dipahami.',
                    style: TextStyle(color: Color(0xFF315B9D), fontSize: 11, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionInfo() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _isCompleted ? const Color(0xFFECFDF3) : const Color(0xFFFFF8E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isCompleted ? const Color(0xFFBBF7D0) : const Color(0xFFFDE2A7),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isCompleted ? Icons.check_circle_rounded : Icons.info_outline_rounded,
            color: _isCompleted ? const Color(0xFF16A34A) : const Color(0xFFD97706),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _isCompleted
                  ? 'Jawaban telah dikumpulkan pada sesi ini.'
                  : 'Sebelum mengumpulkan, pastikan jawabanmu sudah lengkap.',
              style: const TextStyle(
                color: dark,
                fontSize: 12,
                height: 1.4,
                fontWeight: FontWeight.w600,
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
      height: 54,
      child: ElevatedButton(
        onPressed: _isCompleted ? null : _submitAssignment,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          disabledBackgroundColor: const Color(0xFF9CAFCB),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_isCompleted ? Icons.check_circle_rounded : Icons.send_rounded, size: 19),
            const SizedBox(width: 9),
            Text(
              _isCompleted ? 'Tugas sudah dikumpulkan' : 'Kumpulkan tugas',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  void _submitAssignment() {
    if (_answerController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Isi jawabanmu terlebih dahulu sebelum mengumpulkan.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Siap mengumpulkan?',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: const Text(
            'Pastikan jawabanmu sudah sesuai dengan instruksi. '
                'Setelah dikumpulkan, jawaban tidak dapat diubah.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Periksa lagi'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isCompleted = true;
                });
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tugas berhasil dikumpulkan.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Ya, kumpulkan'),
            ),
          ],
        );
      },
    );
  }
}