import 'package:flutter/material.dart';

class MateriDasarTkjScreen extends StatefulWidget {
  const MateriDasarTkjScreen({super.key});

  @override
  State<MateriDasarTkjScreen> createState() =>
      _MateriDasarTkjScreenState();
}

class _MateriDasarTkjScreenState
    extends State<MateriDasarTkjScreen> {
  int _activeStep = 0;
  bool _answerSelected = false;
  bool _correctAnswer = false;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'OBSERVE',
      'subtitle': 'Amati',
      'icon': Icons.visibility_rounded,
      'color': Color(0xFF1976D2),
    },
    {
      'title': 'THINK',
      'subtitle': 'Pahami',
      'icon': Icons.lightbulb_rounded,
      'color': Color(0xFFFF9800),
    },
    {
      'title': 'TRY',
      'subtitle': 'Coba',
      'icon': Icons.handyman_rounded,
      'color': Color(0xFF43A047),
    },
    {
      'title': 'CHECK',
      'subtitle': 'Periksa',
      'icon': Icons.fact_check_rounded,
      'color': Color(0xFF8E24AA),
    },
    {
      'title': 'REFLECT',
      'subtitle': 'Refleksi',
      'icon': Icons.psychology_rounded,
      'color': Color(0xFFE53935),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Materi Dasar TKJ'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildLearningFlow(),
            const SizedBox(height: 20),
            _buildActiveLearningContent(),
            const SizedBox(height: 20),
            _buildNavigationButtons(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1565C0),
            Color(0xFF1976D2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lan_rounded,
            color: Colors.white,
            size: 42,
          ),
          SizedBox(height: 12),
          Text(
            'Dasar Teknik Komputer dan Jaringan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Kenali konsep dasar komputer, jaringan, '
                'dan teknologi yang menjadi fondasi TKJ.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningFlow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alur Pembelajaran',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Belajar secara bertahap melalui pengalaman dan praktik.',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 105,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _steps.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final step = _steps[index];
              final bool active = _activeStep == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _activeStep = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 105,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: active
                        ? step['color'] as Color
                        : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: step['color'] as Color,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Icon(
                        step['icon'] as IconData,
                        color: active
                            ? Colors.white
                            : step['color'] as Color,
                        size: 25,
                      ),
                      const SizedBox(height: 7),
                      Text(
                        step['title'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: active
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        step['subtitle'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: active
                              ? Colors.white70
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActiveLearningContent() {
    switch (_activeStep) {
      case 0:
        return _buildObserve();
      case 1:
        return _buildThink();
      case 2:
        return _buildTry();
      case 3:
        return _buildCheck();
      case 4:
        return _buildReflect();
      default:
        return const SizedBox();
    }
  }

  Widget _buildObserve() {
    return _contentCard(
      title: 'Amati Lingkungan di Sekitarmu',
      icon: Icons.visibility_rounded,
      color: const Color(0xFF1976D2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Coba perhatikan perangkat teknologi yang '
                'ada di sekitarmu.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _observationCard(
                  Icons.computer_rounded,
                  'Komputer',
                  'Mengolah data',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _observationCard(
                  Icons.router_rounded,
                  'Router',
                  'Menghubungkan jaringan',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _observationCard(
                  Icons.cable_rounded,
                  'Kabel',
                  'Media transmisi',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _observationCard(
                  Icons.wifi_rounded,
                  'Wi-Fi',
                  'Koneksi nirkabel',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _observationCard(
      IconData icon,
      String title,
      String description,
      ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF1565C0),
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThink() {
    return _contentCard(
      title: 'Apa Itu TKJ?',
      icon: Icons.lightbulb_rounded,
      color: const Color(0xFFFF9800),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Teknik Komputer dan Jaringan (TKJ) '
                'mempelajari bagaimana komputer, perangkat '
                'jaringan, sistem operasi, serta jaringan '
                'komunikasi bekerja dan saling terhubung.',
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Konsep utama yang perlu kamu pahami:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 10),
          _ConceptItem(
            icon: Icons.memory_rounded,
            title: 'Komputer',
            description: 'Perangkat untuk mengolah data.',
          ),
          _ConceptItem(
            icon: Icons.devices_other_rounded,
            title: 'Perangkat Jaringan',
            description: 'Perangkat untuk menghubungkan komputer.',
          ),
          _ConceptItem(
            icon: Icons.lan_rounded,
            title: 'Jaringan',
            description: 'Hubungan antarperangkat untuk berbagi data.',
          ),
          _ConceptItem(
            icon: Icons.public_rounded,
            title: 'Internet',
            description: 'Jaringan global yang menghubungkan banyak perangkat.',
          ),
        ],
      ),
    );
  }

  Widget _buildTry() {
    return _contentCard(
      title: 'Coba Identifikasi',
      icon: Icons.handyman_rounded,
      color: const Color(0xFF43A047),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bayangkan kamu berada di laboratorium TKJ. '
                'Kamu menemukan sebuah perangkat yang digunakan '
                'untuk menghubungkan beberapa komputer dalam satu jaringan.',
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.device_hub_rounded,
                  color: Color(0xFF43A047),
                  size: 50,
                ),
                SizedBox(height: 10),
                Text(
                  'Menurutmu perangkat apakah itu?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _choiceButton('Monitor', false),
          _choiceButton('Switch', true),
          _choiceButton('Keyboard', false),
        ],
      ),
    );
  }

  Widget _choiceButton(String answer, bool correct) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            setState(() {
              _answerSelected = true;
              _correctAnswer = correct;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  correct
                      ? 'Benar! Switch digunakan untuk menghubungkan perangkat dalam jaringan.'
                      : 'Belum tepat. Coba pikirkan kembali fungsi perangkat tersebut.',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: BorderSide(
              color: correct
                  ? const Color(0xFF43A047)
                  : Colors.grey.shade300,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(answer),
        ),
      ),
    );
  }

  Widget _buildCheck() {
    return _contentCard(
      title: 'Periksa Pemahamanmu',
      icon: Icons.fact_check_rounded,
      color: const Color(0xFF8E24AA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manakah yang termasuk perangkat jaringan?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          _checkOption('A. Monitor', false),
          _checkOption('B. Router', true),
          _checkOption('C. Keyboard', false),
          _checkOption('D. Speaker', false),
          if (_answerSelected)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _correctAnswer
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                _correctAnswer
                    ? 'Mantap! Jawabanmu benar.'
                    : 'Coba lagi dan perhatikan fungsi setiap perangkat.',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _correctAnswer
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _checkOption(String text, bool correct) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _answerSelected = true;
              _correctAnswer = correct;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            alignment: Alignment.centerLeft,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: Colors.grey.shade200,
              ),
            ),
          ),
          child: Text(text),
        ),
      ),
    );
  }

  Widget _buildReflect() {
    return _contentCard(
      title: 'Refleksi Pembelajaran',
      icon: Icons.psychology_rounded,
      color: const Color(0xFFE53935),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Setelah mempelajari Dasar TKJ, coba pikirkan:',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          _reflectionQuestion(
            'Apa konsep yang paling kamu pahami hari ini?',
          ),
          const SizedBox(height: 12),
          _reflectionQuestion(
            'Bagian mana yang masih membuatmu bingung?',
          ),
          const SizedBox(height: 12),
          _reflectionQuestion(
            'Bagaimana ilmu TKJ dapat kamu gunakan dalam kehidupan sehari-hari?',
          ),
        ],
      ),
    );
  }

  Widget _reflectionQuestion(String question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          const TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Tuliskan jawabanmu...',
              filled: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _contentCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_activeStep > 0)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _activeStep--;
                });
              },
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Sebelumnya'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        if (_activeStep > 0 && _activeStep < _steps.length - 1)
          const SizedBox(width: 10),
        if (_activeStep < _steps.length - 1)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _activeStep++;
                });
              },
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('Lanjut'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ConceptItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ConceptItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 21,
            color: const Color(0xFF1565C0),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
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