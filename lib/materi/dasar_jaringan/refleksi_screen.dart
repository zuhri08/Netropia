import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';

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

  final List<Map<String, dynamic>> _moods = [
    {
      'emoji': '😄',
      'label': 'Senang',
      'description': 'Saya menikmati proses belajar hari ini.',
    },
    {
      'emoji': '🙂',
      'label': 'Cukup baik',
      'description': 'Saya bisa mengikuti sebagian besar materi.',
    },
    {
      'emoji': '😐',
      'label': 'Biasa saja',
      'description': 'Saya masih perlu memahami beberapa bagian.',
    },
    {
      'emoji': '😓',
      'label': 'Kesulitan',
      'description': 'Ada bagian yang membuat saya kesulitan.',
    },
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

  Future<void> _saveReflection() async {
    setState(() {
      _isSaved = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final namaSiswa = userDoc.data()?['nama'] ?? user.displayName ?? user.email ?? 'Siswa Netropia';
        final kelas = userDoc.data()?['kelas'] ?? '-';

        final docRef = FirebaseFirestore.instance.collection('reflections').doc();
        await docRef.set({
          'id': docRef.id,
          'siswaId': user.uid,
          'namaSiswa': namaSiswa,
          'kelas': kelas,
          'materiId': widget.materiId,
          'materiTitle': widget.materiTitle,
          'mood': _selectedMood,
          'understanding': _understanding,
          'newThing': _newThingController.text.trim(),
          'challenge': _challengeController.text.trim(),
          'plan': _selectedNextAction,
          'feedbackGuru': '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (_) {}

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Refleksi belajarmu berhasil disimpan!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
        title: Text(
          'Refleksi Diri - ${widget.materiTitle}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderProgress(isDark),
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
                  _buildMoodStep(isDark),
                  _buildUnderstandingStep(isDark),
                  _buildTopicsStep(isDark),
                  _buildReflectionTextStep(isDark),
                  _buildPlanStep(isDark),
                  _buildSummaryStep(isDark),
                ],
              ),
            ),
            _buildBottomBar(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderProgress(bool isDark) {
    final step = _steps[_currentStep];
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.brownTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  step['icon'] as IconData,
                  color: AppTheme.primaryBrown,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['title'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppTheme.textDark,
                      ),
                    ),
                    Text(
                      step['subtitle'] as String,
                      style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted),
                    ),
                  ],
                ),
              ),
              Text(
                '${_currentStep + 1}/$_totalSteps',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBrown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 5,
              backgroundColor: isDark ? Colors.grey.shade800 : AppTheme.borderCream,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBrown),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodStep(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bagaimana perasaanmu setelah mempelajari ${widget.materiTitle}?',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textDark,
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
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.brownTint
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppTheme.primaryBrown : (isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      mood['emoji'] as String,
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? AppTheme.primaryBrown : (isDark ? Colors.white : AppTheme.textDark),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            mood['description'] as String,
                            style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle_rounded, color: AppTheme.primaryBrown, size: 20),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildUnderstandingStep(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Tingkat pemahaman materi ${widget.materiTitle}',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '$_understanding/5',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBrown,
                  ),
                ),
                const SizedBox(height: 16),
                Slider(
                  value: _understanding.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  activeColor: AppTheme.primaryBrown,
                  onChanged: (val) {
                    setState(() {
                      _understanding = val.round();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicsStep(bool isDark) {
    final topics = ['Konsep dasar ${widget.materiTitle}', 'Fungsi dan penerapan', 'Praktik & Simulasi'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bagian yang sudah kamu pahami',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.textDark),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: topics.map((topic) {
              final isSelected = _understoodTopics.contains(topic);
              return FilterChip(
                label: Text(topic),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) _understoodTopics.add(topic);
                    else _understoodTopics.remove(topic);
                  });
                },
                selectedColor: AppTheme.primaryBrown,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : (isDark ? Colors.white : AppTheme.textDark),
                  fontSize: 12,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionTextStep(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hal baru yang kamu pelajari:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.textDark),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _newThingController,
            maxLines: 4,
            decoration: const InputDecoration(hintText: 'Tuliskan di sini...'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanStep(bool isDark) {
    final plans = ['Membaca kembali materi', 'Mencoba simulasi kembali', 'Bertanya kepada guru'];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: plans.map((plan) {
          final isSelected = _selectedNextAction == plan;
          return ListTile(
            title: Text(plan),
            selected: isSelected,
            onTap: () => setState(() => _selectedNextAction = plan),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryStep(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderCream),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Modul: ${widget.materiTitle}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Perasaan: ${_selectedMood ?? "-"}'),
            const SizedBox(height: 8),
            Text('Pemahaman: $_understanding/5'),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(bool isDark) {
    final isLastStep = _currentStep == _totalSteps - 1;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: const Border(top: BorderSide(color: AppTheme.borderCream)),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                child: const Text('Sebelumnya'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _canContinue() ? (isLastStep ? _saveReflection : _nextStep) : null,
              child: Text(_isSaved ? 'Tersimpan' : (isLastStep ? 'Simpan' : 'Lanjut')),
            ),
          ),
        ],
      ),
    );
  }
}
