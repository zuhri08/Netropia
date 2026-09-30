import 'package:flutter/material.dart';

class EvaluasiScreen extends StatefulWidget {
  final String materiId;
  final String materiTitle;

  const EvaluasiScreen({
    super.key,
    this.materiId = 'dasar_jaringan',
    this.materiTitle = 'Dasar Jaringan',
  });

  @override
  State<EvaluasiScreen> createState() => _EvaluasiScreenState();
}

class _EvaluasiScreenState extends State<EvaluasiScreen> {
  // ============================================================
  // KONSTANTA TAMPILAN
  // ============================================================

  static const Color _primary = Color(0xFFAD8B73);
  static const Color _primaryDark = Color(0xFF8E6F5B);
  static const Color _dark = Color(0xFF202A44);
  static const Color _lightBlue = Color(0xFFFFF8E8);
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

  @override
  void dispose() {
    _pageController.dispose();
    _suggestionController.dispose();
    for (final controller in _comments.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // ============================================================
  // NAVIGASI LANGKAH
  // ============================================================

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitEvaluasi() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Kirim evaluasi?'),
          content: const Text(
            'Terima kasih atas penilaian dan masukan yang kamu berikan. '
                'Evaluasimu sangat berharga untuk pengembangan Netropia.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Evaluasi berhasil dikirim. Terima kasih!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Kirim'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Evaluasi - ${widget.materiTitle}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderProgress(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                children: [
                  _buildRatingStep('Materi'),
                  _buildRatingStep('Media'),
                  _buildRatingStep('Proses'),
                  _buildSaranStep(),
                  _buildSummaryStep(),
                ],
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER PROGRESS
  // ============================================================

  Widget _buildHeaderProgress() {
    final current = _steps[_currentStep];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  current['icon'] as IconData,
                  color: _primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      current['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _dark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      current['subtitle'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Langkah ${_currentStep + 1}/${_steps.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 6,
              backgroundColor: _border,
              valueColor: const AlwaysStoppedAnimation<Color>(_primary),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STEP PENILAIAN
  // ============================================================

  Widget _buildRatingStep(String category) {
    final currentRating = _ratings[category] ?? 0;
    final reasons = _reasonOptions[category] ?? [];
    final selectedReasons = _selectedReasons[category] ?? {};
    final commentController = _comments[category]!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _border),
            ),
            child: Column(
              children: [
                Text(
                  'Seberapa baik $category dalam materi ${widget.materiTitle}?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _ratingLabel(currentRating),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: currentRating > 0 ? _primary : Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    final ratingValue = index + 1;
                    final isSelected = currentRating >= ratingValue;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _ratings[category] = ratingValue;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _primary.withOpacity(0.12)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isSelected
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 36,
                          color: isSelected ? _primary : Colors.grey.shade400,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (currentRating > 0) ...[
            const Text(
              'Apa alasan penilaiamu?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _dark,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: reasons.map((reason) {
                final isSelected = selectedReasons.contains(reason);

                return FilterChip(
                  label: Text(reason),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedReasons.add(reason);
                      } else {
                        selectedReasons.remove(reason);
                      }
                    });
                  },
                  selectedColor: _primary.withOpacity(0.15),
                  checkmarkColor: _primary,
                  labelStyle: TextStyle(
                    color: isSelected ? _primary : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? _primary : _border,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
          const Text(
            'Catatan tambahan (Opsional)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _dark,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: commentController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Tulis tanggapanmu tentang $category di modul ${widget.materiTitle}...',
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
                borderSide: const BorderSide(color: _primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STEP SARAN
  // ============================================================

  Widget _buildSaranStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _border),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline_rounded, color: _primary, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Masukanmu sangat berarti bagi kami untuk meningkatkan kualitas modul ${widget.materiTitle}.',
                    style: const TextStyle(fontSize: 13, height: 1.4, color: _dark),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Saran & Masukan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _dark,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _suggestionController,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'Berikan ide atau masukan untuk pengembangan modul ${widget.materiTitle}...',
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
                borderSide: const BorderSide(color: _primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STEP RINGKASAN
  // ============================================================

  Widget _buildSummaryStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Evaluasi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _dark,
            ),
          ),
          const SizedBox(height: 12),
          ..._ratings.entries.map((entry) {
            final category = entry.key;
            final rating = entry.value;
            final reasons = _selectedReasons[category] ?? {};
            final comment = _comments[category]?.text ?? '';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _dark,
                        ),
                      ),
                      Row(
                        children: [
                          Text(_ratingEmoji(rating)),
                          const SizedBox(width: 4),
                          Text(
                            _ratingLabel(rating),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (reasons.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Alasan: ${reasons.join(', ')}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                  if (comment.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Catatan: "$comment"',
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: _dark,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
          if (_suggestionController.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saran & Masukan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _dark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '"${_suggestionController.text}"',
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: _dark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigation() {
    final isLastStep = _currentStep == _steps.length - 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _border)),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  foregroundColor: _dark,
                  side: const BorderSide(color: _border),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Sebelumnya'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: isLastStep ? _submitEvaluasi : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(isLastStep ? 'Kirim Evaluasi' : 'Lanjut'),
            ),
          ),
        ],
      ),
    );
  }
}
