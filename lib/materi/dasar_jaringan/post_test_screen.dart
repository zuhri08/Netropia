import 'package:flutter/material.dart';

class PostTestScreen extends StatefulWidget {
  const PostTestScreen({super.key});

  @override
  State<PostTestScreen> createState() => _PostTestScreenState();
}

class _PostTestScreenState extends State<PostTestScreen> {
  int _currentQuestion = 0;

  final List<int?> _answers = List<int?>.filled(20, null);

  final List<Map<String, dynamic>> _questions = [
    {
      'question':
      'Sebuah laboratorium memiliki 20 komputer yang berada dalam satu ruangan dan saling terhubung untuk berbagi printer. Jenis jaringan yang paling sesuai adalah...',
      'options': [
        'LAN',
        'MAN',
        'WAN',
        'Internet',
      ],
      'answer': 0,
    },
    {
      'question':
      'Sebuah sekolah menghubungkan jaringan komputer dari beberapa gedung yang masih berada dalam satu wilayah sekolah. Tujuan utama jaringan tersebut adalah...',
      'options': [
        'Membatasi pertukaran data antarperangkat',
        'Memungkinkan perangkat berbagi data dan sumber daya',
        'Menghilangkan kebutuhan perangkat jaringan',
        'Membuat setiap komputer bekerja secara terpisah',
      ],
      'answer': 1,
    },
    {
      'question':
      'Dalam sebuah jaringan, beberapa komputer perlu menggunakan satu printer secara bersama-sama. Fungsi jaringan yang dimanfaatkan adalah...',
      'options': [
        'Berbagi sumber daya',
        'Mengganti sistem operasi',
        'Meningkatkan kapasitas RAM',
        'Mengubah jenis prosesor',
      ],
      'answer': 0,
    },
    {
      'question':
      'Sebuah perusahaan memiliki kantor di Surabaya, Jakarta, dan Bandung yang perlu saling terhubung melalui jaringan. Jenis jaringan yang sesuai adalah...',
      'options': [
        'LAN',
        'PAN',
        'WAN',
        'CAN',
      ],
      'answer': 2,
    },
    {
      'question':
      'Jaringan yang digunakan untuk menghubungkan perangkat dalam wilayah satu kota disebut...',
      'options': [
        'LAN',
        'MAN',
        'WAN',
        'PAN',
      ],
      'answer': 1,
    },
    {
      'question':
      'Jika sebuah jaringan hanya mencakup area laboratorium komputer dalam satu ruangan atau gedung, jaringan tersebut termasuk...',
      'options': [
        'WAN',
        'MAN',
        'LAN',
        'Internet',
      ],
      'answer': 2,
    },
    {
      'question':
      'Pada jaringan dengan topologi star, beberapa komputer terhubung ke satu perangkat pusat. Perangkat pusat yang umum digunakan adalah...',
      'options': [
        'Switch',
        'Monitor',
        'Keyboard',
        'Printer',
      ],
      'answer': 0,
    },
    {
      'question':
      'Jika salah satu kabel menuju sebuah komputer pada topologi star mengalami kerusakan, dampak yang paling mungkin terjadi adalah...',
      'options': [
        'Seluruh jaringan pasti mati',
        'Hanya komputer yang terhubung melalui kabel tersebut yang terganggu',
        'Semua komputer kehilangan sistem operasi',
        'Switch otomatis berubah menjadi router',
      ],
      'answer': 1,
    },
    {
      'question':
      'Sebuah jaringan menggunakan satu kabel utama sebagai jalur komunikasi beberapa perangkat. Topologi tersebut adalah...',
      'options': [
        'Ring',
        'Mesh',
        'Star',
        'Bus',
      ],
      'answer': 3,
    },
    {
      'question':
      'Pada topologi mesh, perangkat memiliki banyak koneksi langsung. Salah satu karakteristik dari topologi ini adalah...',
      'options': [
        'Memiliki banyak jalur komunikasi antarperangkat',
        'Hanya menggunakan satu kabel utama',
        'Seluruh perangkat bergantung pada satu perangkat pusat',
        'Tidak membutuhkan media transmisi',
      ],
      'answer': 0,
    },
    {
      'question':
      'Sebuah komputer mengakses website menggunakan protokol HTTP. Fungsi utama HTTP adalah...',
      'options': [
        'Mengatur komunikasi untuk pertukaran data halaman web',
        'Menghubungkan kabel jaringan secara fisik',
        'Mengatur kapasitas penyimpanan komputer',
        'Menggantikan fungsi sistem operasi',
      ],
      'answer': 0,
    },
    {
      'question':
      'Ketika sebuah website menggunakan HTTPS, salah satu keuntungan utamanya adalah...',
      'options': [
        'Data komunikasi web mendapatkan perlindungan enkripsi',
        'Komputer tidak membutuhkan jaringan',
        'Website hanya dapat dibuka secara offline',
        'Semua perangkat otomatis menjadi server',
      ],
      'answer': 0,
    },
    {
      'question':
      'Dalam komunikasi jaringan, TCP/IP berperan sebagai...',
      'options': [
        'Kumpulan protokol untuk mengatur komunikasi data dalam jaringan',
        'Jenis kabel jaringan',
        'Perangkat keras untuk memperkuat sinyal',
        'Sistem operasi khusus untuk router',
      ],
      'answer': 0,
    },
    {
      'question':
      'Seorang siswa ingin melindungi akun jaringan sekolah. Tindakan yang paling tepat adalah...',
      'options': [
        'Menggunakan password kuat dan tidak membagikannya',
        'Menggunakan password yang sama untuk semua akun',
        'Memberikan password kepada teman',
        'Menuliskan password di meja laboratorium',
      ],
      'answer': 0,
    },
    {
      'question':
      'Sebuah jaringan menggunakan firewall untuk mengontrol lalu lintas yang masuk dan keluar. Tujuan penggunaan firewall adalah...',
      'options': [
        'Mengontrol akses jaringan berdasarkan aturan keamanan',
        'Menambah kapasitas penyimpanan komputer',
        'Mengganti kabel jaringan secara otomatis',
        'Meningkatkan ukuran layar komputer',
      ],
      'answer': 0,
    },
    {
      'question':
      'Dalam sebuah laboratorium, hanya siswa tertentu yang diperbolehkan mengakses folder berisi data administrasi. Konsep keamanan yang diterapkan adalah...',
      'options': [
        'Pengaturan hak akses',
        'Penggantian topologi',
        'Pembagian bandwidth',
        'Penggantian alamat IP',
      ],
      'answer': 0,
    },
    {
      'question':
      'Seorang teknisi menemukan bahwa komputer dapat terhubung ke jaringan lokal tetapi tidak dapat mengakses internet. Langkah awal yang paling tepat adalah...',
      'options': [
        'Memeriksa konfigurasi jaringan dan koneksi menuju gateway',
        'Mengganti monitor komputer',
        'Menghapus semua file pengguna',
        'Mengganti keyboard',
      ],
      'answer': 0,
    },
    {
      'question':
      'Sebuah sekolah ingin menyediakan koneksi internet untuk komputer di laboratorium dan beberapa perangkat lain. Perangkat jaringan yang digunakan untuk menghubungkan banyak perangkat dalam jaringan lokal adalah...',
      'options': [
        'Switch',
        'Monitor',
        'Scanner',
        'Keyboard',
      ],
      'answer': 0,
    },
    {
      'question':
      'Jaringan komputer di sekolah dapat membantu proses pembelajaran karena...',
      'options': [
        'Memungkinkan berbagi informasi dan sumber daya pembelajaran',
        'Membuat komputer tidak membutuhkan listrik',
        'Menghilangkan kebutuhan akan perangkat lunak',
        'Membatasi komunikasi antarperangkat',
      ],
      'answer': 0,
    },
    {
      'question':
      'Dalam kehidupan sehari-hari, penggunaan jaringan komputer dapat ditemukan pada kondisi...',
      'options': [
        'Beberapa perangkat terhubung untuk berbagi koneksi internet',
        'Komputer digunakan tanpa sistem operasi',
        'Printer digunakan tanpa sumber listrik',
        'Monitor digunakan sebagai pengganti router',
      ],
      'answer': 0,
    },
  ];

  bool get _isLastQuestion =>
      _currentQuestion == _questions.length - 1;

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
        builder: (context) => PostTestResultScreen(
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
          'Post Test',
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
              Color(0xFFAD8B73),
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
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DASAR JARINGAN',
                    style: TextStyle(
                      color: Color(0xFFAD8B73),
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
                        selected:
                        selectedAnswer == index,
                        onTap: () =>
                            _selectAnswer(index),
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
                    const Color(0xFFAD8B73),
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
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _isLastQuestion
                            ? Icons.check_rounded
                            : Icons
                            .arrow_forward_rounded,
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
            duration:
            const Duration(milliseconds: 150),
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFFF5EBE6)
                  : Colors.white,
              borderRadius:
              BorderRadius.circular(14),
              border: Border.all(
                color: selected
                    ? const Color(0xFFAD8B73)
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
                        ? const Color(0xFFAD8B73)
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
                      fontWeight:
                      FontWeight.w700,
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
                    color: Color(0xFFAD8B73),
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

class PostTestResultScreen extends StatelessWidget {
  final int score;
  final int correct;
  final int wrong;
  final List<Map<String, dynamic>> questions;
  final List<int?> answers;

  const PostTestResultScreen({
    super.key,
    required this.score,
    required this.correct,
    required this.wrong,
    required this.questions,
    required this.answers,
  });

  String get _message {
    if (score >= 80) {
      return 'Pemahaman kamu terhadap materi Dasar Jaringan sudah terlihat baik.';
    }

    if (score >= 60) {
      return 'Pemahaman dasar sudah terbentuk. Beberapa konsep masih dapat diperdalam kembali.';
    }

    return 'Beberapa konsep masih perlu dipelajari kembali. Gunakan materi Dasar Jaringan sebagai bahan penguatan.';
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
          'Hasil Post Test',
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
              padding:
              const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 28,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Post Test Selesai',
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
                          child:
                          CircularProgressIndicator(
                            value: score / 100,
                            strokeWidth: 9,
                            backgroundColor:
                            const Color(0xFFE9EDF2),
                            valueColor:
                            const AlwaysStoppedAnimation<
                                Color>(
                              Color(0xFFAD8B73),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize:
                          MainAxisSize.min,
                          children: [
                            Text(
                              '$score',
                              style: const TextStyle(
                                color:
                                Color(0xFF172B4D),
                                fontSize: 32,
                                fontWeight:
                                FontWeight.w800,
                              ),
                            ),
                            const Text(
                              '/ 100',
                              style: TextStyle(
                                color:
                                Color(0xFF98A2B3),
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
                          icon:
                          Icons.check_rounded,
                          color:
                          const Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ResultItem(
                          value: '$wrong',
                          label: 'Salah',
                          icon:
                          Icons.close_rounded,
                          color:
                          const Color(0xFFC62828),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ResultItem(
                          value: '${questions.length}',
                          label: 'Soal',
                          icon: Icons
                              .assignment_outlined,
                          color:
                          const Color(0xFFAD8B73),
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
                color: const Color(0xFFF5EBE6),
                borderRadius:
                BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFFAD8B73),
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
                  const Color(0xFFAD8B73),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Kembali ke Dasar Jaringan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w700,
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
                      const PostTestScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                  const Color(0xFFAD8B73),
                  side: const BorderSide(
                    color: Color(0xFFB9D1F2),
                  ),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Kerjakan Lagi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w600,
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
        borderRadius:
        BorderRadius.circular(12),
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
}// TODO Implement this library.