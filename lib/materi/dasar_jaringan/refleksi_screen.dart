
import 'package:flutter/material.dart';

class RefleksiScreen extends StatefulWidget {
  const RefleksiScreen({super.key});

  @override
  State<RefleksiScreen> createState() => _RefleksiScreenState();
}

class _RefleksiScreenState extends State<RefleksiScreen> {
  final PageController _pageController = PageController();

  int _currentStep = 0;
  int _understanding = 3;
  String? _selectedMood;
  String? _selectedNextAction;
  bool _isSaved = false;

  final Set<String> _understoodTopics = {};
  final Set<String> _difficultTopics = {};

  final TextEditingController _newThingController =
  TextEditingController();
  final TextEditingController _challengeController =
  TextEditingController();
  final TextEditingController _planController =
  TextEditingController();

  final List<Map<String, dynamic>> _moods = [
    {
      'emoji': '😄',
      'label': 'Senang',
      'description': 'Saya menikmati proses belajar hari ini.',
      'color': const Color(0xFFFFF0D9),
    },
    {
      'emoji': '🙂',
      'label': 'Cukup baik',
      'description': 'Saya bisa mengikuti sebagian besar materi.',
      'color': const Color(0xFFE8F5E9),
    },
    {
      'emoji': '😐',
      'label': 'Biasa saja',
      'description': 'Saya masih perlu memahami beberapa bagian.',
      'color': const Color(0xFFEAF0FF),
    },
    {
      'emoji': '😓',
      'label': 'Kesulitan',
      'description': 'Ada bagian yang membuat saya kesulitan.',
      'color': const Color(0xFFFFE9E7),
    },
  ];

  final List<String> _topics = [
    'Pengertian jaringan',
    'Jenis jaringan komputer',
    'Topologi jaringan',
    'Perangkat jaringan',
    'IP Address',
    'Kabel jaringan',
  ];

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Perasaan',
      'subtitle': 'Kenali perasaanmu setelah belajar.',
      'icon': Icons.mood_rounded,
    },
    {
      'title': 'Pemahaman',
      'subtitle': 'Seberapa jauh kamu memahami materi?',
      'icon': Icons.lightbulb_rounded,
    },
    {
      'title': 'Pengalaman',
      'subtitle': 'Kenali bagian yang sudah dan belum kamu kuasai.',
      'icon': Icons.explore_rounded,
    },
    {
      'title': 'Refleksi',
      'subtitle': 'Ceritakan pengalaman belajarmu.',
      'icon': Icons.edit_note_rounded,
    },
    {
      'title': 'Rencana',
      'subtitle': 'Tentukan langkah belajarmu selanjutnya.',
      'icon': Icons.flag_rounded,
    },
    {
      'title': 'Rangkuman',
      'subtitle': 'Periksa kembali refleksimu.',
      'icon': Icons.check_circle_rounded,
    },
  ];

  int get _totalSteps => _steps.length;

  double get _progress => (_currentStep + 1) / _totalSteps;

  String get _understandingLabel {
    switch (_understanding) {
      case 1:
        return 'Belum memahami';
      case 2:
        return 'Mulai memahami';
      case 3:
        return 'Cukup memahami';
      case 4:
        return 'Memahami dengan baik';
      case 5:
        return 'Sangat memahami';
      default:
        return 'Cukup memahami';
    }
  }

  bool _canContinue() {
    switch (_currentStep) {
      case 0:
        return _selectedMood != null;
      case 1:
        return true;
      case 2:
        return _understoodTopics.isNotEmpty ||
            _difficultTopics.isNotEmpty;
      case 3:
        return _newThingController.text.trim().isNotEmpty &&
            _challengeController.text.trim().isNotEmpty;
      case 4:
        return _selectedNextAction != null ||
            _planController.text.trim().isNotEmpty;
      default:
        return true;
    }
  }

  void _nextStep() {
    if (!_canContinue()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi bagian ini terlebih dahulu.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });

      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _saveReflection();
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

  void _saveReflection() {
    setState(() {
      _isSaved = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  color: Color(0xFFE7F7EC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF269653),
                  size: 42,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Refleksi Selesai!',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF202A44),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Kamu sudah meluangkan waktu untuk mengenali proses belajarmu. Terus berkembang dan jangan takut mencoba!',
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
                    backgroundColor: const Color(0xFF4169E1),
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

  Widget _buildHeader() {
    final step = _steps[_currentStep];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF3159C9),
            Color(0xFF6387F0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
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
                      'LANGKAH ${_currentStep + 1} DARI $_totalSteps',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
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
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 12),
          Text(
            step['subtitle'] as String,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bagaimana perasaanmu hari ini?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF202A44),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tidak ada jawaban benar atau salah. Pilih yang paling sesuai dengan dirimu.',
          style: TextStyle(
            color: Colors.black54,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        ..._moods.map((mood) {
          final selected = _selectedMood == mood['label'];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                setState(() {
                  _selectedMood = mood['label'] as String;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selected
                      ? mood['color'] as Color
                      : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF4169E1)
                        : const Color(0xFFE8ECF4),
                    width: selected ? 1.8 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      mood['emoji'] as String,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mood['label'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF202A44),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            mood['description'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      selected
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      color: selected
                          ? const Color(0xFF4169E1)
                          : Colors.black26,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        if (_selectedMood != null)
          _buildFeedback(
            'Terima kasih sudah jujur dengan perasaanmu. '
                'Mengenali perasaan adalah langkah awal untuk belajar lebih baik.',
          ),
      ],
    );
  }

  Widget _buildUnderstandingStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Seberapa paham kamu dengan materi Dasar Jaringan?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF202A44),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Geser indikator untuk menunjukkan tingkat pemahamanmu.',
          style: TextStyle(
            color: Colors.black54,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 35),
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0FF),
              borderRadius: BorderRadius.circular(35),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$_understanding',
                  style: const TextStyle(
                    color: Color(0xFF4169E1),
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'dari 5',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Slider(
          value: _understanding.toDouble(),
          min: 1,
          max: 5,
          divisions: 4,
          activeColor: const Color(0xFF4169E1),
          inactiveColor: const Color(0xFFDDE4F5),
          label: _understanding.toString(),
          onChanged: (value) {
            setState(() {
              _understanding = value.round();
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Belum paham',
              style: TextStyle(fontSize: 11, color: Colors.black54),
            ),
            Text(
              'Sangat paham',
              style: TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF0FF),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Gambaran pemahamanmu',
                style: TextStyle(
                  color: Color(0xFF4169E1),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _understandingLabel,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF202A44),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                _understanding <= 2
                    ? 'Tidak apa-apa. Kamu bisa mengulang materi dan mencoba latihan kembali.'
                    : _understanding == 3
                    ? 'Kamu sudah memiliki pemahaman awal. Terus berlatih agar semakin yakin.'
                    : 'Bagus! Pertahankan pemahamanmu dengan mencoba menerapkan materi.',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopicsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kenali bagian yang kamu kuasai',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF202A44),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Pilih topik yang sudah kamu pahami. Kamu boleh memilih lebih dari satu.',
          style: TextStyle(color: Colors.black54, height: 1.5),
        ),
        const SizedBox(height: 18),
        _buildTopicGroup(
          title: 'Sudah saya pahami',
          subtitle: 'Topik yang terasa lebih mudah bagimu.',
          selectedTopics: _understoodTopics,
          color: const Color(0xFF269653),
          background: const Color(0xFFE8F7EE),
        ),
        const SizedBox(height: 22),
        const Text(
          'Bagian yang masih menantang',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF202A44),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Pilih topik yang ingin kamu pelajari lagi.',
          style: TextStyle(color: Colors.black54, fontSize: 12),
        ),
        const SizedBox(height: 12),
        _buildTopicGroup(
          title: 'Perlu saya pelajari lagi',
          subtitle: 'Tidak masalah jika masih ada yang sulit.',
          selectedTopics: _difficultTopics,
          color: const Color(0xFFD97706),
          background: const Color(0xFFFFF3DF),
        ),
        const SizedBox(height: 16),
        _buildFeedback(
          'Setiap orang memiliki bagian yang mudah dan sulit. '
              'Mengetahuinya akan membantumu menentukan langkah berikutnya.',
        ),
      ],
    );
  }

  Widget _buildTopicGroup({
    required String title,
    required String subtitle,
    required Set<String> selectedTopics,
    required Color color,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 13),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _topics.map((topic) {
              final selected = selectedTopics.contains(topic);

              return FilterChip(
                label: Text(topic),
                selected: selected,
                showCheckmark: true,
                selectedColor: background,
                checkmarkColor: color,
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: selected ? color : const Color(0xFF414B61),
                  fontWeight:
                  selected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: selected ? color : const Color(0xFFE1E5ED),
                ),
                onSelected: (value) {
                  setState(() {
                    if (value) {
                      selectedTopics.add(topic);
                    } else {
                      selectedTopics.remove(topic);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWritingStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mari lihat kembali pengalamanmu',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF202A44),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tidak perlu jawaban panjang. Tuliskan dengan bahasamu sendiri.',
          style: TextStyle(color: Colors.black54, height: 1.5),
        ),
        const SizedBox(height: 22),
        _buildTextQuestion(
          number: '01',
          title: 'Apa hal baru yang kamu pelajari?',
          hint: 'Contoh: Saya memahami fungsi perangkat jaringan...',
          controller: _newThingController,
          icon: Icons.lightbulb_outline_rounded,
        ),
        const SizedBox(height: 16),
        _buildTextQuestion(
          number: '02',
          title: 'Apa tantangan yang kamu temui?',
          hint: 'Contoh: Saya masih kesulitan membedakan...',
          controller: _challengeController,
          icon: Icons.psychology_alt_rounded,
        ),
        const SizedBox(height: 18),
        _buildFeedback(
          'Cobalah mengingat kegiatan belajar yang baru saja kamu lakukan. '
              'Pengalaman kecil pun layak untuk direfleksikan.',
        ),
      ],
    );
  }

  Widget _buildTextQuestion({
    required String number,
    required String title,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF4169E1)),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  '$number  $title',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF202A44),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          TextField(
            controller: controller,
            minLines: 3,
            maxLines: 5,
            maxLength: 300,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 12,
                color: Colors.black38,
              ),
              filled: true,
              fillColor: const Color(0xFFF7F8FC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanStep() {
    final actions = [
      'Mengulang materi',
      'Mencoba latihan',
      'Bertanya kepada guru',
      'Belajar bersama teman',
      'Mencoba praktik langsung',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Apa langkahmu selanjutnya?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF202A44),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Pilih satu tindakan yang ingin kamu lakukan untuk meningkatkan pemahaman.',
          style: TextStyle(color: Colors.black54, height: 1.5),
        ),
        const SizedBox(height: 20),
        ...actions.map((action) {
          final selected = _selectedNextAction == action;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                setState(() {
                  _selectedNextAction = action;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFEAF0FF)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF4169E1)
                        : const Color(0xFFE8ECF4),
                    width: selected ? 1.6 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      selected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: selected
                          ? const Color(0xFF4169E1)
                          : Colors.black38,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        action,
                        style: TextStyle(
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: const Color(0xFF202A44),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 10),
        const Text(
          'Atau tuliskan rencanamu sendiri',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF202A44),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _planController,
          minLines: 3,
          maxLines: 4,
          maxLength: 200,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Saya akan mencoba untuk...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
            ),
          ),
        ),
        _buildFeedback(
          'Rencana kecil yang dilakukan secara konsisten dapat membantumu berkembang.',
        ),
      ],
    );
  }

  Widget _buildSummaryStep() {
    final mood = _moods.firstWhere(
          (item) => item['label'] == _selectedMood,
      orElse: () => _moods[0],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Perjalanan belajarmu hari ini',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF202A44),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Berikut rangkuman refleksi yang sudah kamu isi.',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 20),
        _buildSummaryCard(
          icon: Icons.mood_rounded,
          title: 'Perasaan',
          child: Row(
            children: [
              Text(
                mood['emoji'] as String,
                style: const TextStyle(fontSize: 27),
              ),
              const SizedBox(width: 10),
              Text(
                _selectedMood ?? '-',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        _buildSummaryCard(
          icon: Icons.lightbulb_rounded,
          title: 'Tingkat pemahaman',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$_understanding dari 5 — $_understandingLabel',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 9),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: _understanding / 5,
                  minHeight: 7,
                  backgroundColor: const Color(0xFFE9EDF5),
                  valueColor: const AlwaysStoppedAnimation(
                    Color(0xFF4169E1),
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildSummaryCard(
          icon: Icons.check_circle_outline_rounded,
          title: 'Topik yang dipahami',
          child: Text(
            _understoodTopics.isEmpty
                ? 'Belum memilih topik.'
                : _understoodTopics.join(', '),
            style: const TextStyle(height: 1.5),
          ),
        ),
        _buildSummaryCard(
          icon: Icons.flag_outlined,
          title: 'Topik yang perlu dipelajari lagi',
          child: Text(
            _difficultTopics.isEmpty
                ? 'Belum memilih topik.'
                : _difficultTopics.join(', '),
            style: const TextStyle(height: 1.5),
          ),
        ),
        _buildSummaryCard(
          icon: Icons.edit_note_rounded,
          title: 'Hal baru yang dipelajari',
          child: Text(
            _newThingController.text.trim().isEmpty
                ? '-'
                : _newThingController.text.trim(),
            style: const TextStyle(height: 1.5),
          ),
        ),
        _buildSummaryCard(
          icon: Icons.psychology_alt_rounded,
          title: 'Tantangan',
          child: Text(
            _challengeController.text.trim().isEmpty
                ? '-'
                : _challengeController.text.trim(),
            style: const TextStyle(height: 1.5),
          ),
        ),
        _buildSummaryCard(
          icon: Icons.flag_rounded,
          title: 'Rencana berikutnya',
          child: Text(
            [
              if (_selectedNextAction != null) _selectedNextAction!,
              if (_planController.text.trim().isNotEmpty)
                _planController.text.trim(),
            ].join('\n\n').isEmpty
                ? '-'
                : [
              if (_selectedNextAction != null)
                _selectedNextAction!,
              if (_planController.text.trim().isNotEmpty)
                _planController.text.trim(),
            ].join('\n\n'),
            style: const TextStyle(height: 1.5),
          ),
        ),
        const SizedBox(height: 12),
        _buildFeedback(
          'Periksa kembali jawabanmu. Jika sudah sesuai, tekan tombol Selesaikan Refleksi.',
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 19, color: const Color(0xFF4169E1)),
              const SizedBox(width: 9),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF202A44),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          child,
        ],
      ),
    );
  }

  Widget _buildFeedback(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0FF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: Color(0xFF4169E1),
            size: 20,
          ),
          const SizedBox(width: 10),
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

  Widget _buildCurrentPage() {
    switch (_currentStep) {
      case 0:
        return _buildMoodStep();
      case 1:
        return _buildUnderstandingStep();
      case 2:
        return _buildTopicsStep();
      case 3:
        return _buildWritingStep();
      case 4:
        return _buildPlanStep();
      default:
        return _buildSummaryStep();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _newThingController.dispose();
    _challengeController.dispose();
    _planController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text(
          'Refleksi Belajar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF202A44),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF202A44),
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildMoodStep(),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildUnderstandingStep(),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildTopicsStep(),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildWritingStep(),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildPlanStep(),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildSummaryStep(),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE8ECF4)),
              ),
            ),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF4169E1),
                        side: const BorderSide(
                          color: Color(0xFF4169E1),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Kembali'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4169E1),
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
                          _currentStep == _totalSteps - 1
                              ? 'Selesaikan Refleksi'
                              : 'Lanjut',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _currentStep == _totalSteps - 1
                              ? Icons.check_rounded
                              : Icons.arrow_forward_rounded,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}