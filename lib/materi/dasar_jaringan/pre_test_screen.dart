import 'package:flutter/material.dart';

class PreTestScreen extends StatefulWidget {
  const PreTestScreen({super.key});

  @override
  State<PreTestScreen> createState() => _PreTestScreenState();
}

class _PreTestScreenState extends State<PreTestScreen> {
  int _currentQuestion = 0;

  final List<int?> _answers = List<int?>.filled(20, null);

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Apa yang dimaksud dengan jaringan komputer?',
      'options': [
        'Kumpulan komputer yang saling terhubung untuk berbagi data dan sumber daya',
        'Perangkat yang digunakan untuk menghubungkan komputer ke internet',
        'Sistem operasi yang digunakan untuk mengelola komputer',
        'Kabel yang digunakan untuk menghubungkan perangkat',
      ],
      'answer': 0,
    },
    {
      'question': 'Salah satu manfaat utama jaringan komputer adalah...',
      'options': [
        'Membuat komputer bekerja tanpa sistem operasi',
        'Memungkinkan berbagi data dan sumber daya',
        'Menghilangkan kebutuhan akan perangkat jaringan',
        'Membatasi komunikasi antar komputer',
      ],
      'answer': 1,
    },
    {
      'question': 'Contoh sumber daya yang dapat dibagikan melalui jaringan adalah...',
      'options': [
        'Printer',
        'Keyboard internal',
        'Baterai laptop',
        'Layar monitor',
      ],
      'answer': 0,
    },
    {
      'question': 'Jaringan komputer dengan cakupan wilayah kecil seperti laboratorium sekolah disebut...',
      'options': [
        'WAN',
        'MAN',
        'LAN',
        'Internet',
      ],
      'answer': 2,
    },
    {
      'question': 'Jaringan yang mencakup wilayah metropolitan atau satu kota disebut...',
      'options': [
        'LAN',
        'MAN',
        'WAN',
        'PAN',
      ],
      'answer': 1,
    },
    {
      'question': 'Jaringan yang dapat mencakup wilayah geografis yang sangat luas disebut...',
      'options': [
        'LAN',
        'PAN',
        'WAN',
        'CAN',
      ],
      'answer': 2,
    },
    {
      'question': 'Dalam komunikasi jaringan, perangkat pengirim mengirimkan data melalui...',
      'options': [
        'Media transmisi dan perangkat jaringan',
        'Sistem pendingin komputer',
        'Perangkat input saja',
        'Layar monitor',
      ],
      'answer': 0,
    },
    {
      'question': 'Perangkat yang menerima data dari perangkat lain dalam jaringan disebut...',
      'options': [
        'Receiver',
        'Processor',
        'Scanner',
        'Compiler',
      ],
      'answer': 0,
    },
    {
      'question': 'Topologi jaringan yang menggunakan satu perangkat pusat seperti switch disebut...',
      'options': [
        'Bus',
        'Ring',
        'Star',
        'Mesh',
      ],
      'answer': 2,
    },
    {
      'question': 'Pada topologi bus, perangkat-perangkat jaringan terhubung melalui...',
      'options': [
        'Satu kabel utama',
        'Beberapa server pusat',
        'Satu access point',
        'Jaringan tanpa media transmisi',
      ],
      'answer': 0,
    },
    {
      'question': 'Topologi yang menghubungkan perangkat membentuk suatu jalur melingkar disebut...',
      'options': [
        'Star',
        'Ring',
        'Tree',
        'Bus',
      ],
      'answer': 1,
    },
    {
      'question': 'Topologi mesh memiliki karakteristik utama berupa...',
      'options': [
        'Semua perangkat hanya terhubung ke satu kabel utama',
        'Perangkat terhubung melalui satu perangkat pusat saja',
        'Terdapat banyak koneksi langsung antarperangkat',
        'Semua perangkat tidak membutuhkan koneksi',
      ],
      'answer': 2,
    },
    {
      'question': 'Protokol yang menjadi dasar komunikasi data pada internet adalah...',
      'options': [
        'TCP/IP',
        'HTML',
        'USB',
        'HDMI',
      ],
      'answer': 0,
    },
    {
      'question': 'Protokol yang digunakan untuk mengakses halaman web adalah...',
      'options': [
        'FTP',
        'HTTP',
        'SMTP',
        'DHCP',
      ],
      'answer': 1,
    },
    {
      'question': 'HTTPS digunakan untuk komunikasi web yang...',
      'options': [
        'Tidak menggunakan jaringan',
        'Lebih aman karena menggunakan enkripsi',
        'Hanya dapat digunakan tanpa internet',
        'Hanya digunakan untuk mencetak dokumen',
      ],
      'answer': 1,
    },
    {
      'question': 'Salah satu cara sederhana untuk menjaga keamanan akun adalah...',
      'options': [
        'Menggunakan password yang kuat dan tidak mudah ditebak',
        'Membagikan password kepada teman',
        'Menggunakan password yang sama untuk semua akun',
        'Menuliskan password di tempat yang mudah terlihat',
      ],
      'answer': 0,
    },
    {
      'question': 'Firewall pada jaringan berfungsi untuk...',
      'options': [
        'Meningkatkan ukuran hard disk',
        'Membatasi atau mengontrol akses jaringan berdasarkan aturan tertentu',
        'Mengganti sistem operasi komputer',
        'Menambah kapasitas RAM',
      ],
      'answer': 1,
    },
    {
      'question': 'Hak akses dalam keamanan jaringan digunakan untuk...',
      'options': [
        'Mengatur siapa yang boleh mengakses sumber daya tertentu',
        'Menambah kecepatan prosesor',
        'Mengubah ukuran layar',
        'Menghapus seluruh jaringan',
      ],
      'answer': 0,
    },
    {
      'question': 'Contoh penerapan jaringan komputer di sekolah adalah...',
      'options': [
        'Menghubungkan komputer laboratorium agar dapat berbagi data dan printer',
        'Menggunakan komputer tanpa koneksi apa pun',
        'Mengganti keyboard setiap hari',
        'Menggunakan monitor sebagai media penyimpanan',
      ],
      'answer': 0,
    },
    {
      'question': 'Contoh penerapan jaringan dalam kehidupan sehari-hari adalah...',
      'options': [
        'Menghubungkan beberapa perangkat untuk berbagi koneksi internet',
        'Menggunakan komputer tanpa perangkat lunak',
        'Menggunakan printer tanpa sumber daya listrik',
        'Menghapus seluruh koneksi antarperangkat',
      ],
      'answer': 0,
    },
  ];

  bool get _isLastQuestion => _currentQuestion == _questions.length - 1;

  int get _answeredCount {
    return _answers.where((answer) => answer != null).length;
  }

  int get _correctCount {
    int correct = 0;

    for (int i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i]['answer']) {
        correct++;
      }
    }

    return correct;
  }

  int get _wrongCount {
    return _questions.length - _correctCount;
  }

  int get _score {
    return ((_correctCount / _questions.length) * 100).round();
  }

  void _selectAnswer(int index) {
    setState(() {
      _answers[_currentQuestion] = index;
    });
  }

  void _nextQuestion() {
    if (_answers[_currentQuestion] == null) {
      _showMessage('Pilih salah satu jawaban terlebih dahulu.');
      return;
    }

    if (_isLastQuestion) {
      _showResult();
      return;
    }

    setState(() {
      _currentQuestion++;
    });
  }

  void _previousQuestion() {
    if (_currentQuestion == 0) return;

    setState(() {
      _currentQuestion--;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showResult() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PreTestResultScreen(
          score: _score,
          correct: _correctCount,
          wrong: _wrongCount,
          questions: _questions,
          answers: _answers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestion];
    final options = question['options'] as List<String>;
    final selectedAnswer = _answers[_currentQuestion];

    final progress =
        (_currentQuestion + 1) / _questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF172B4D),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 20,
        title: const Text(
          'Pre Test',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: Text(
                '${_currentQuestion + 1} / ${_questions.length}',
                style: const TextStyle(
                  color: Color(0xFF667085),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: progress,
            minHeight: 3,
            backgroundColor: const Color(0xFFE9EDF2),
            valueColor:
            const AlwaysStoppedAnimation<Color>(
              Color(0xFF1565C0),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                24,
                20,
                20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DASAR JARINGAN',
                    style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    question['question'],
                    style: const TextStyle(
                      color: Color(0xFF172B4D),
                      fontSize: 21,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 28),
                  ...List.generate(
                    options.length,
                        (index) {
                      return _AnswerOption(
                        label: String.fromCharCode(
                          65 + index,
                        ),
                        text: options[index],
                        selected: selectedAnswer == index,
                        onTap: () => _selectAnswer(index),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE9EDF2),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (_currentQuestion > 0) ...[
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: _previousQuestion,
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                    const Color(0xFF475467),
                    side: const BorderSide(
                      color: Color(0xFFD0D5DD),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 18,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    size: 19,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLastQuestion
                            ? 'Selesai'
                            : 'Berikutnya',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _isLastQuestion
                            ? Icons.check_rounded
                            : Icons.arrow_forward_rounded,
                        size: 19,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  final String label;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _AnswerOption({
    required this.label,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFFEAF2FF)
                  : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected
                    ? const Color(0xFF1565C0)
                    : const Color(0xFFE1E6EC),
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration:
                  const Duration(milliseconds: 150),
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF1565C0)
                        : const Color(0xFFF2F4F7),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : const Color(0xFF667085),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.only(top: 3),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: selected
                            ? const Color(0xFF173B72)
                            : const Color(0xFF344054),
                        fontSize: 13,
                        height: 1.45,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                if (selected) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF1565C0),
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PreTestResultScreen extends StatelessWidget {
  final int score;
  final int correct;
  final int wrong;
  final List<Map<String, dynamic>> questions;
  final List<int?> answers;

  const PreTestResultScreen({
    super.key,
    required this.score,
    required this.correct,
    required this.wrong,
    required this.questions,
    required this.answers,
  });

  String get _message {
    if (score >= 80) {
      return 'Kamu sudah memiliki pemahaman awal yang cukup baik.';
    }

    if (score >= 60) {
      return 'Kamu sudah memiliki beberapa pengetahuan dasar. Mari perdalam lagi melalui materi.';
    }

    return 'Tidak masalah. Gunakan hasil ini sebagai gambaran awal sebelum mempelajari materi.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF172B4D),
        elevation: 0,
        titleSpacing: 20,
        title: const Text(
          'Hasil Pre Test',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 28,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Pre Test Selesai',
                    style: TextStyle(
                      color: Color(0xFF172B4D),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Dasar Jaringan',
                    style: TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 28),

                  SizedBox(
                    width: 130,
                    height: 130,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 130,
                          height: 130,
                          child: CircularProgressIndicator(
                            value: score / 100,
                            strokeWidth: 9,
                            backgroundColor:
                            const Color(0xFFE9EDF2),
                            valueColor:
                            const AlwaysStoppedAnimation<
                                Color>(
                              Color(0xFF1565C0),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$score',
                              style: const TextStyle(
                                color: Color(0xFF172B4D),
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Text(
                              '/ 100',
                              style: TextStyle(
                                color: Color(0xFF98A2B3),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  Row(
                    children: [
                      Expanded(
                        child: _ResultItem(
                          value: '$correct',
                          label: 'Benar',
                          icon: Icons.check_rounded,
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ResultItem(
                          value: '$wrong',
                          label: 'Salah',
                          icon: Icons.close_rounded,
                          color: const Color(0xFFC62828),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ResultItem(
                          value: '${questions.length}',
                          label: 'Soal',
                          icon: Icons.assignment_outlined,
                          color: const Color(0xFF1565C0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFF1565C0),
                    size: 21,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _message,
                      style: const TextStyle(
                        color: Color(0xFF344054),
                        fontSize: 12.5,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Kembali ke Dasar Jaringan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PreTestScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                  const Color(0xFF1565C0),
                  side: const BorderSide(
                    color: Color(0xFFB9D1F2),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Kerjakan Lagi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ResultItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _ResultItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 19,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF172B4D),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF667085),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}