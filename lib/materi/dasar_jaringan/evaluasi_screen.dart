
import 'package:flutter/material.dart';

class EvaluasiScreen extends StatefulWidget {
  const EvaluasiScreen({super.key});

  @override
  State<EvaluasiScreen> createState() => _EvaluasiScreenState();
}

class _EvaluasiScreenState extends State<EvaluasiScreen> {
  // ============================================================
  // KONSTANTA TAMPILAN
  // ============================================================

  static const Color _primary = Color(0xFF4169E1);
  static const Color _primaryDark = Color(0xFF3159C9);
  static const Color _dark = Color(0xFF202A44);
  static const Color _lightBlue = Color(0xFFEAF0FF);
  static const Color _border = Color(0xFFE8ECF4);
  static const Color _background = Color(0xFFF6F7FB);

  // ============================================================
  // STATE DAN CONTROLLER
  // ============================================================

  final PageController _pageController = PageController();

  int _currentStep = 0;

  final TextEditingController _suggestionController =
  TextEditingController();

  final Map<String, TextEditingController> _comments = {
    'Materi': TextEditingController(),
    'Media': TextEditingController(),
    'Proses': TextEditingController(),
  };

  final Map<String, int> _ratings = {
    'Materi': 0,
    'Media': 0,
    'Proses': 0,
  };

  final Map<String, Set<String>> _selectedReasons = {
    'Materi': {},
    'Media': {},
    'Proses': {},
  };

  // ============================================================
  // DATA LANGKAH EVALUASI
  // ============================================================

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Materi',
      'subtitle': 'Nilai kualitas materi pembelajaran.',
      'icon': Icons.menu_book_rounded,
    },
    {
      'title': 'Media',
      'subtitle': 'Nilai tampilan dan fitur pembelajaran.',
      'icon': Icons.devices_rounded,
    },
    {
      'title': 'Proses',
      'subtitle': 'Nilai pengalamanmu selama belajar.',
      'icon': Icons.school_rounded,
    },
    {
      'title': 'Saran',
      'subtitle': 'Berikan masukan untuk pengembangan Netropia.',
      'icon': Icons.chat_bubble_outline_rounded,
    },
    {
      'title': 'Ringkasan',
      'subtitle': 'Periksa evaluasimu sebelum dikirim.',
      'icon': Icons.fact_check_rounded,
    },
  ];

  final Map<String, List<String>> _reasonOptions = {
    'Materi': [
      'Mudah dipahami',
      'Penjelasan jelas',
      'Contoh membantu',
      'Materi relevan',
      'Masih terlalu sulit',
      'Perlu lebih banyak contoh',
    ],
    'Media': [
      'Tampilan menarik',
      'Mudah digunakan',
      'Fitur membantu belajar',
      'Teks mudah dibaca',
      'Tampilan perlu diperbaiki',
      'Perlu fitur tambahan',
    ],
    'Proses': [
      'Urutan belajar jelas',
      'Aktivitas menarik',
      'Belajar terasa nyaman',
      'Mudah mengikuti langkah',
      'Waktu belajar kurang',
      'Instruksi perlu diperjelas',
    ],
  };

  // ============================================================
  // HELPER
  // ============================================================

  double get _progress => (_currentStep + 1) / _steps.length;

  String _ratingEmoji(int rating) {
    switch (rating) {
      case 1:
        return '😞';
      case 2:
        return '😕';
      case 3:
        return '😐';
      case 4:
        return '😊';
      case 5:
        return '🤩';
      default:
        return '⭐';
    }
  }

  String _ratingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Sangat kurang';
      case 2:
        return 'Kurang';
      case 3:
        return 'Cukup';
      case 4:
        return 'Baik';
      case 5:
        return 'Sangat baik';
      default:
        return 'Belum dinilai';
    }
  }

  String _ratingMessage(int rating) {
    switch (rating) {
      case 1:
        return 'Kami akan berusaha memperbaikinya.';
      case 2:
        return 'Terima kasih, masukanmu sangat berarti.';
      case 3:
        return 'Masih ada ruang untuk menjadi lebih baik.';
      case 4:
        return 'Senang mengetahui pengalaman belajarmu baik!';
      case 5:
        return 'Wah, berarti pengalaman belajarmu sangat baik!';
      default:
        return 'Pilih emoji yang paling menggambarkan penilaianmu.';
    }
  }

  bool _canContinue() {
    if (_currentStep <= 2) {
      final category = ['Materi', 'Media', 'Proses'][_currentStep];
      return (_ratings[category] ?? 0) > 0;
    }

    return true;
  }

  // ============================================================
  // NAVIGASI
  // ============================================================

  void _nextStep() {
    if (!_canContinue()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berikan penilaian terlebih dahulu.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });

      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _submitEvaluation();
    }
  }

  void _previousStep() {
    if (_currentStep == 0) return;

    setState(() {
      _currentStep--;
    });

    _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  // ============================================================
  // KIRIM EVALUASI
  // ============================================================

  void _submitEvaluation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F7EE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 42,
                  color: Color(0xFF269653),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Evaluasi Selesai!',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: _dark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Terima kasih atas penilaian dan masukanmu. '
                    'Pendapatmu membantu pengembangan pembelajaran Netropia.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Selesai'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // HEADER DAN PROGRESS
  // ============================================================

  Widget _buildHeader() {
    final step = _steps[_currentStep];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _primaryDark,
            Color(0xFF6387F0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  step['icon'] as IconData,
                  color: Colors.white,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LANGKAH ${_currentStep + 1} DARI ${_steps.length}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      step['title'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(_progress * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 7,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 11),
          Text(
            step['subtitle'] as String,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KARTU PENILAIAN EMOJI INTERAKTIF
  // ============================================================

  Widget _buildEmojiRating(String category, int rating) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          const Text(
            'Bagaimana penilaianmu?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _dark,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: List.generate(5, (index) {
              final value = index + 1;
              final selected = rating == value;

              return Expanded(
                child: Semantics(
                  button: true,
                  label: 'Nilai $value, ${_ratingLabel(value)}',
                  selected: selected,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _ratings[category] = value;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 2,
                      ),
                      decoration: BoxDecoration(
                        color: selected ? _lightBlue : Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: selected
                              ? _primary
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          AnimatedScale(
                            scale: selected ? 1.25 : 1,
                            duration: const Duration(milliseconds: 220),
                            child: Text(
                              _ratingEmoji(value),
                              style: const TextStyle(fontSize: 27),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$value',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selected ? _primary : Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 18),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Column(
              key: ValueKey(rating),
              children: [
                Text(
                  _ratingLabel(rating),
                  style: const TextStyle(
                    color: _primary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _ratingMessage(rating),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
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

  // ============================================================
  // HALAMAN PENILAIAN MATERI, MEDIA, DAN PROSES
  // ============================================================

  Widget _buildRatingStep({
    required String category,
    required String question,
    required String description,
  }) {
    final rating = _ratings[category] ?? 0;
    final reasons = _selectedReasons[category]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _dark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(
            color: Colors.black54,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 22),

        _buildEmojiRating(category, rating),

        const SizedBox(height: 24),

        const Text(
          'Apa alasan penilaianmu?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _dark,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Pilih satu atau beberapa hal yang sesuai.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 12),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _reasonOptions[category]!.map((reason) {
            final selected = reasons.contains(reason);

            return FilterChip(
              label: Text(reason),
              selected: selected,
              showCheckmark: true,
              selectedColor: _lightBlue,
              checkmarkColor: _primary,
              labelStyle: TextStyle(
                fontSize: 12,
                color: selected
                    ? _primaryDark
                    : const Color(0xFF414B61),
                fontWeight:
                selected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: selected ? _primary : const Color(0xFFE1E5ED),
              ),
              onSelected: (value) {
                setState(() {
                  if (value) {
                    reasons.add(reason);
                  } else {
                    reasons.remove(reason);
                  }
                });
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 23),

        const Text(
          'Komentar tambahan (opsional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _dark,
          ),
        ),
        const SizedBox(height: 10),

        TextField(
          controller: _comments[category],
          minLines: 3,
          maxLines: 5,
          maxLength: 300,
          decoration: InputDecoration(
            hintText: 'Tuliskan pendapatmu di sini...',
            hintStyle: const TextStyle(
              fontSize: 12,
              color: Colors.black38,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: _border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: _border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: _primary),
            ),
          ),
        ),

        _buildInfo(
          'Penilaianmu digunakan sebagai masukan untuk memperbaiki pengalaman belajar.',
        ),
      ],
    );
  }

  // ============================================================
  // HALAMAN SARAN
  // ============================================================

  Widget _buildSuggestionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Apa yang ingin kamu sampaikan?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _dark,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Masukanmu dapat membantu materi, media, dan proses '
              'pembelajaran menjadi lebih baik.',
          style: TextStyle(
            color: Colors.black54,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 22),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _lightBlue,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.volunteer_activism_rounded,
                color: _primary,
                size: 25,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tidak ada jawaban benar atau salah. Sampaikan '
                      'pendapatmu dengan jujur dan sopan.',
                  style: TextStyle(
                    color: Color(0xFF3455A4),
                    height: 1.5,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        const Text(
          'Saran untuk pembelajaran berikutnya',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _dark,
          ),
        ),
        const SizedBox(height: 10),

        TextField(
          controller: _suggestionController,
          minLines: 6,
          maxLines: 8,
          maxLength: 500,
          decoration: InputDecoration(
            hintText:
            'Contoh: Saya berharap materi dilengkapi lebih banyak simulasi...',
            hintStyle: const TextStyle(
              fontSize: 12,
              color: Colors.black38,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: _border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: _border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: _primary),
            ),
          ),
        ),

        _buildInfo(
          'Bagian saran boleh dikosongkan jika kamu tidak memiliki masukan tambahan.',
        ),
      ],
    );
  }

  // ============================================================
  // KARTU RINGKASAN
  // ============================================================

  Widget _buildSummaryCard(String category) {
    final rating = _ratings[category] ?? 0;
    final reasons = _selectedReasons[category]!;
    final comment = _comments[category]!.text.trim();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  category,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _dark,
                  ),
                ),
              ),
              Text(
                _ratingEmoji(rating),
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(width: 6),
              Text(
                '$rating/5',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            _ratingLabel(rating),
            style: const TextStyle(
              color: _primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),

          if (reasons.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: reasons.map((reason) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _lightBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    reason,
                    style: const TextStyle(
                      color: _primaryDark,
                      fontSize: 11,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          if (comment.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              comment,
              style: const TextStyle(
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // HALAMAN RINGKASAN
  // ============================================================

  Widget _buildSummaryStep() {
    final suggestion = _suggestionController.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Periksa evaluasimu',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _dark,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Pastikan penilaian sudah sesuai sebelum kamu mengirimkannya.',
          style: TextStyle(
            color: Colors.black54,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),

        _buildSummaryCard('Materi'),
        _buildSummaryCard('Media'),
        _buildSummaryCard('Proses'),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: _border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Saran dan masukan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _dark,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                suggestion.isEmpty
                    ? 'Tidak ada saran tambahan.'
                    : suggestion,
                style: const TextStyle(
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _buildInfo(
          'Terima kasih sudah memberikan penilaian. '
              'Masukanmu berarti bagi pengembangan Netropia.',
        ),
      ],
    );
  }

  // ============================================================
  // KOMPONEN INFORMASI
  // ============================================================

  Widget _buildInfo(String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _lightBlue,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            color: _primary,
            size: 20,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFF3455A4),
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PEMILIH HALAMAN
  // ============================================================

  Widget _buildCurrentPageFor(int index) {
    switch (index) {
      case 0:
        return _buildRatingStep(
          category: 'Materi',
          question: 'Bagaimana kualitas materi yang kamu pelajari?',
          description:
          'Nilai kejelasan penjelasan, kemudahan memahami materi, '
              'dan kesesuaian contoh dengan pembelajaran.',
        );

      case 1:
        return _buildRatingStep(
          category: 'Media',
          question: 'Bagaimana media pembelajaran Netropia?',
          description:
          'Nilai tampilan aplikasi, kemudahan penggunaan, '
              'serta fitur yang membantu kegiatan belajarmu.',
        );

      case 2:
        return _buildRatingStep(
          category: 'Proses',
          question: 'Bagaimana pengalamanmu selama belajar?',
          description:
          'Nilai alur pembelajaran, instruksi kegiatan, '
              'dan kenyamanan mengikuti setiap aktivitas.',
        );

      case 3:
        return _buildSuggestionStep();

      default:
        return _buildSummaryStep();
    }
  }

  // ============================================================
  // NAVIGASI BAWAH
  // ============================================================

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 13, 18, 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: _border),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  foregroundColor: _primary,
                  side: const BorderSide(color: _primary),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Kembali'),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentStep == _steps.length - 1
                        ? 'Kirim Evaluasi'
                        : 'Lanjut',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _currentStep == _steps.length - 1
                        ? Icons.send_rounded
                        : Icons.arrow_forward_rounded,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _pageController.dispose();

    for (final controller in _comments.values) {
      controller.dispose();
    }

    _suggestionController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD UTAMA
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text(
          'Evaluasi Pembelajaran',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _dark,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: _dark,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _steps.length,
              onPageChanged: (index) {
                if (_currentStep != index) {
                  setState(() {
                    _currentStep = index;
                  });
                }
              },
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildCurrentPageFor(index),
                );
              },
            ),
          ),
          _buildBottomNavigation(),
        ],
      ),
    );
  }
}