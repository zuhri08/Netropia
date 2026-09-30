import 'package:flutter/material.dart';

class RefleksiScreen extends StatefulWidget {
  final String materiId;
  final String materiTitle;

  const RefleksiScreen({
    super.key,
    this.materiId = 'dasar_jaringan',
    this.materiTitle = 'Dasar Jaringan',
  });

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

  final TextEditingController _newThingController = TextEditingController();
  final TextEditingController _challengeController = TextEditingController();
  final TextEditingController _planController = TextEditingController();

  static const Color primary = Color(0xFFAD8B73);
  static const Color dark = Color(0xFF172B4D);
  static const Color muted = Color(0xFF718096);
  static const Color background = Color(0xFFF4F7FB);

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

  late final List<String> _topics = [
    'Konsep dasar ${widget.materiTitle}',
    'Fungsi dan penerapan ${widget.materiTitle}',
    'Langkah-langkah praktik',
    'Troubleshooting dan penanganan masalah',
    'Penggunaan perangkat & tools',
    'Istilah penting dalam ${widget.materiTitle}',
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
        return _understoodTopics.isNotEmpty || _difficultTopics.isNotEmpty;
      case 3:
        return _newThingController.text.trim().isNotEmpty;
      case 4:
        return _selectedNextAction != null;
      case 5:
        return true;
      default:
        return true;
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

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
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

  void _saveReflection() {
    setState(() {
      _isSaved = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Refleksi belajarmu berhasil disimpan!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Refleksi Diri - ${widget.materiTitle}',
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
                  _buildMoodStep(),
                  _buildUnderstandingStep(),
                  _buildTopicsStep(),
                  _buildReflectionTextStep(),
                  _buildPlanStep(),
                  _buildSummaryStep(),
                ],
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderProgress() {
    final step = _steps[_currentStep];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  step['icon'] as IconData,
                  color: primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['title'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: dark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      step['subtitle'] as String,
                      style: const TextStyle(fontSize: 12, color: muted),
                    ),
                  ],
                ),
              ),
              Text(
                '${_currentStep + 1}/$_totalSteps',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 6,
              backgroundColor: const Color(0xFFE8EDF5),
              valueColor: const AlwaysStoppedAnimation<Color>(primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bagaimana perasaanmu setelah mempelajari ${widget.materiTitle}?',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: dark,
            ),
          ),
          const SizedBox(height: 16),
          ..._moods.map((mood) {
            final label = mood['label'] as String;
            final isSelected = _selectedMood == label;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMood = label;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? primary.withOpacity(0.12) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? primary : const Color(0xFFE8EDF5),
                    width: isSelected ? 2 : 1,
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
                            label,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? primary : dark,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            mood['description'] as String,
                            style: const TextStyle(fontSize: 12, color: muted),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle_rounded, color: primary),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildUnderstandingStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE8EDF5)),
            ),
            child: Column(
              children: [
                Text(
                  'Tingkat pemahaman materi ${widget.materiTitle}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: dark,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '$_understanding/5',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
                Text(
                  _understandingLabel,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: dark,
                  ),
                ),
                const SizedBox(height: 24),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: primary,
                    inactiveTrackColor: const Color(0xFFE8EDF5),
                    thumbColor: primary,
                    overlayColor: primary.withOpacity(0.18),
                  ),
                  child: Slider(
                    value: _understanding.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    onChanged: (val) {
                      setState(() {
                        _understanding = val.round();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bagian yang sudah kamu pahami',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: dark,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _topics.map((topic) {
              final isSelected = _understoodTopics.contains(topic);

              return FilterChip(
                label: Text(topic),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _understoodTopics.add(topic);
                      _difficultTopics.remove(topic);
                    } else {
                      _understoodTopics.remove(topic);
                    }
                  });
                },
                selectedColor: primary.withOpacity(0.15),
                checkmarkColor: primary,
                labelStyle: TextStyle(
                  color: isSelected ? primary : dark,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? primary : const Color(0xFFE8EDF5),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            'Bagian yang masih membuatmu bingung/kesulitan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: dark,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _topics.map((topic) {
              final isSelected = _difficultTopics.contains(topic);

              return FilterChip(
                label: Text(topic),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _difficultTopics.add(topic);
                      _understoodTopics.remove(topic);
                    } else {
                      _difficultTopics.remove(topic);
                    }
                  });
                },
                selectedColor: const Color(0xFFFFE9E7),
                checkmarkColor: Colors.red,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.red : dark,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? Colors.red : const Color(0xFFE8EDF5),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionTextStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hal baru apa yang kamu pelajari dari ${widget.materiTitle}?',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: dark,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _newThingController,
            maxLines: 4,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Tuliskan pemahaman atau hal paling berkesan...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE8EDF5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE8EDF5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Tantangan terbesarmu saat belajar?',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: dark,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _challengeController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Tuliskan bagian yang membuatmu tertantang...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE8EDF5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE8EDF5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanStep() {
    final plans = [
      'Membaca kembali materi ${widget.materiTitle}',
      'Mencoba latihan atau simulasi kembali',
      'Bertanya kepada guru/teman',
      'Mencari referensi tambahan',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Langkahmu selanjutnya:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: dark,
            ),
          ),
          const SizedBox(height: 12),
          ...plans.map((plan) {
            final isSelected = _selectedNextAction == plan;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedNextAction = plan;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? primary.withOpacity(0.12) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? primary : const Color(0xFFE8EDF5),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        plan,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? primary : dark,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle_rounded, color: primary),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSummaryStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rangkuman Refleksi Belajar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: dark,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE8EDF5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _summaryItem('Modul Materi', widget.materiTitle),
                const Divider(height: 20),
                _summaryItem('Perasaan', _selectedMood ?? '-'),
                const Divider(height: 20),
                _summaryItem('Pemahaman', '$_understanding/5 ($_understandingLabel)'),
                if (_understoodTopics.isNotEmpty) ...[
                  const Divider(height: 20),
                  _summaryItem('Paham', _understoodTopics.join(', ')),
                ],
                if (_difficultTopics.isNotEmpty) ...[
                  const Divider(height: 20),
                  _summaryItem('Sulit', _difficultTopics.join(', ')),
                ],
                if (_newThingController.text.isNotEmpty) ...[
                  const Divider(height: 20),
                  _summaryItem('Hal Baru', '"${_newThingController.text}"'),
                ],
                if (_selectedNextAction != null) ...[
                  const Divider(height: 20),
                  _summaryItem('Rencana', _selectedNextAction!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: muted,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: dark,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    final isLastStep = _currentStep == _totalSteps - 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE8EDF5))),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  foregroundColor: dark,
                  side: const BorderSide(color: Color(0xFFE8EDF5)),
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
              onPressed: _canContinue()
                  ? (isLastStep ? _saveReflection : _nextStep)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(_isSaved
                  ? 'Tersimpan'
                  : (isLastStep ? 'Simpan Refleksi' : 'Lanjut')),
            ),
          ),
        ],
      ),
    );
  }
}
