import 'package:flutter/material.dart';

class K3MateriScreen extends StatefulWidget {
  final int index;
  const K3MateriScreen({super.key, this.index = 0});

  @override
  State<K3MateriScreen> createState() => _K3MateriScreenState();
}

class _K3MateriScreenState extends State<K3MateriScreen> {
  int _activeStep = 0;
  int? _selectedTryAnswer;
  int? _selectedCheckAnswer;
  bool _trySubmitted = false;
  bool _checkSubmitted = false;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'OBSERVE',
      'subtitle': 'Amati',
      'icon': Icons.visibility_rounded,
      'color': Color(0xFFCEAB93),
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
        title: const Text('Keselamatan dan Kesehatan Kerja (K3LH)'),
        backgroundColor: const Color(0xFFAD8B73),
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
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFAD8B73),
            Color(0xFFCEAB93),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.health_and_safety_rounded,
            color: Colors.white,
            size: 44,
          ),
          SizedBox(height: 12),
          Text(
            'Standar K3LH & Prosedur Laboratorium TKJ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Modul profesional Teknik Komputer dan Jaringan mengenai keselamatan kelistrikan, '
            'pencegahan ESD, ergonomi workstation, dan mitigasi risiko kecelakaan kerja.',
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
          'Alur Pembelajaran Interaktif K3',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Eksplorasi materi dari pengamatan hingga refleksi mendalam.',
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
                    color: active ? step['color'] as Color : Colors.white,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        step['icon'] as IconData,
                        color: active ? Colors.white : step['color'] as Color,
                        size: 25,
                      ),
                      const SizedBox(height: 7),
                      Text(
                        step['title'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: active ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        step['subtitle'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: active ? Colors.white70 : Colors.grey.shade600,
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
      title: 'Observasi Mendalam: Potensi Bahaya Lab TKJ',
      icon: Icons.visibility_rounded,
      color: const Color(0xFFCEAB93),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Amati secara teliti 5 titik kritis kondisi lingkungan kerja dan perangkat keras di laboratorium TKJ berikut:',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 16),
          _detailedObservationItem(
            '1. Inspeksi Kabel Power & Grounding',
            'Periksa kabel power CPU, monitor, dan switch dari isolator yang terkelupas atau serabut tembaga yang terbuka. Pastikan stopkontak terhubung ke jalur pembumian (grounding) yang baik untuk mencegah sengatan listrik.',
            Icons.bolt_rounded,
          ),
          const SizedBox(height: 12),
          _detailedObservationItem(
            '2. Beban Berlebih pada Stopkontak (Overloading)',
            'Hindari penggunaan T-adapter atau colokan bertumpuk yang melebihi kapasitas arus maksimal (Ampere). Hal ini sering memicu panas berlebih, korsleting, hingga lelehnya soket listrik.',
            Icons.electrical_services_rounded,
          ),
          const SizedBox(height: 12),
          _detailedObservationItem(
            '3. Ergonomi Workstation (Posisi Duduk & Layar)',
            'Amati ketinggian meja dan kursi praktikum. Posisi monitor yang ideal adalah bagian atas layar sejajar dengan mata, sudut siku membentuk 90-100 derajat saat mengetik untuk mencegah kelelahan otot (MSDs).',
            Icons.accessibility_new_rounded,
          ),
          const SizedBox(height: 12),
          _detailedObservationItem(
            '4. Sirkulasi Udara & Akumulasi Debu',
            'Perhatikan ventilasi ruangan dan kebersihan kipas (fan) casing serta heatsink CPU. Debu yang menumpuk menghambat disipasi panas dan memicu thermal shutdown.',
            Icons.air_rounded,
          ),
          const SizedBox(height: 12),
          _detailedObservationItem(
            '5. Kesiapan Alat Pemadam Api Ringan (APAR)',
            'Pastikan lokasi penempatan tabung APAR (khususnya jenis serbuk kimia kering / dry chemical powder atau CO2 untuk perangkat elektronik) mudah dijangkau dan tekanan tabung dalam kondisi normal.',
            Icons.fire_extinguisher_rounded,
          ),
        ],
      ),
    );
  }

  Widget _detailedObservationItem(String title, String desc, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFAD8B73).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFAD8B73), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12.5,
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

  Widget _buildThink() {
    return _contentCard(
      title: 'Konseptualisasi Mendalam: Prinsip & Teori K3LH',
      icon: Icons.lightbulb_rounded,
      color: const Color(0xFFFF9800),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kesehatan, Keselamatan Kerja, dan Lingkungan Hidup (K3LH) dalam konteks Teknik Komputer dan Jaringan merupakan seperangkat prinsip ilmiah dan operasional yang dirancang untuk menciptakan ekosistem kerja yang nihil kecelakaan (zero accident) dan bebas penyakit akibat kerja.',
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
          SizedBox(height: 16),
          Text(
            'Pilar Utama Teori K3LH di Bidang TIK:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(height: 12),
          _ConceptItem(
            icon: Icons.shield_rounded,
            title: '1. Pencegahan Electrostatic Discharge (ESD)',
            description: 'Tubuh manusia dapat menyimpan muatan statis hingga ribuan volt yang tak terasa namun sangat mematikan bagi chip IC semikonduktor di motherboard. Penggunaan gelang antistatis (ESD wrist strap) dan alas kaki isolator adalah kewajiban mutlak.',
          ),
          _ConceptItem(
            icon: Icons.power_rounded,
            title: '2. Mitigasi Bahaya Elektrik (Electric Shock & Short Circuit)',
            description: 'Arus listrik AC 220V pada instalasi lab memiliki risiko fibrilasi ventrikel jantung jika mengalir melalui tubuh. Prosedur LOTO (Lockout/Tagout) dan pemeriksaan kondisi kabel sebelum praktik mutlak dipahami.',
          ),
          _ConceptItem(
            icon: Icons.event_seat_rounded,
            title: '3. Ergonomi Terapan & Kesehatan Vokasional',
            description: 'Pencegahan gangguan muskuloskeletal (RSI, Carpal Tunnel Syndrome) serta Computer Vision Syndrome (CVS) melalui pengaturan jarak pandang layar 50-70 cm dan pencahayaan ruangan yang memadai.',
          ),
          _ConceptItem(
            icon: Icons.emergency_rounded,
            title: '4. Manajemen Tanggap Darurat & Evakuasi',
            description: 'Pemahaman protokol evakuasi kebakaran akibat korsleting listrik, pemutusan MCB utama laboratorium, serta teknik dasar pertolongan pertama pada kecelakaan (P3K) tersetrum.',
          ),
        ],
      ),
    );
  }

  Widget _buildTry() {
    return _contentCard(
      title: 'Prosedur Praktis (TRY): Simulasi Penanganan Insiden',
      icon: Icons.handyman_rounded,
      color: const Color(0xFF43A047),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Studi Kasus: Saat Anda sedang merakit PC di meja praktikum, tiba-tiba tercium bau komponen terbakar (hangus) dan terlihat sedikit kepulan asap putih dari area Power Supply Unit (PSU). '
            'Berdasarkan SOP K3LH lab TKJ, urutan tindakan manakah yang paling tepat dan aman untuk dieksekusi?',
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Color(0xFF43A047), size: 30),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pilih langkah penanganan darurat yang benar di bawah ini:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _tryOptionItem(0, 'A. Mencabut kabel power utama dari stopkontak / mematikan MCB meja, lalu lapor instruktur.'),
          _tryOptionItem(1, 'B. Menyiram komponen yang berasap dengan air mineral agar suhunya cepat turun.'),
          _tryOptionItem(2, 'C. Membiarkan komputer tetap menyala sambil merekam video untuk dokumentasi tugas.'),
          _tryOptionItem(3, 'D. Mencabut komponen RAM dan Processor dengan tangan kosong saat komputer masih menyala.'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _trySubmitted = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF43A047),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Periksa Jawaban Praktikum'),
          ),
          if (_trySubmitted) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _selectedTryAnswer == 0
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _selectedTryAnswer == 0
                    ? 'Benar sekali! Langkah pertama penanganan korsleting adalah memutus sumber listrik (cabut steker/matikan MCB) untuk mencegah kebakaran atau sengatan susulan, kemudian laporkan kepada instruktur lab.'
                    : 'Belum tepat. Tindakan tersebut sangat berbahaya dan melanggar SOP K3LH kelistrikan lab.',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _selectedTryAnswer == 0
                      ? Colors.green.shade800
                      : Colors.red.shade800,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _tryOptionItem(int index, String text) {
    bool isSelected = _selectedTryAnswer == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTryAnswer = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF43A047).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF43A047) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? const Color(0xFF43A047) : Colors.grey,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
          ],
        ),
      ),
    );
  }

  Widget _buildCheck() {
    return _contentCard(
      title: 'Uji Evaluasi (CHECK): Kuis Kompetensi K3LH',
      icon: Icons.fact_check_rounded,
      color: const Color(0xFF8E24AA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pertanyaan 1 dari 2:\nMengapa penggunaan gelang antistatis (ESD Wrist Strap) sangat krusial saat teknisi melakukan perakitan atau perawatan komponen internal PC?',
            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, height: 1.5),
          ),
          const SizedBox(height: 14),
          _checkOptionItem(0, 'A. Untuk mempercepat koneksi internet pada motherboard.'),
          _checkOptionItem(1, 'B. Untuk mencegah aliran muatan listrik statis dari tubuh merusak komponen IC semikonduktor yang sensitif.'),
          _checkOptionItem(2, 'C. Agar teknisi terhindar dari sengatan arus listrik AC 220V dari PLN.'),
          _checkOptionItem(3, 'D. Untuk mengunci posisi baut casing agar tidak mudah lepas.'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _checkSubmitted = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8E24AA),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Kirim Jawaban Kuis'),
          ),
          if (_checkSubmitted) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _selectedCheckAnswer == 1
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _selectedCheckAnswer == 1
                    ? 'Luar biasa! Jawaban Anda tepat. ESD (Electrostatic Discharge) dapat menghasilkan tegangan ribuan volt yang merusak chip mikrokontroler secara permanen tanpa disadari.'
                    : 'Belum tepat. Ingat bahwa ESD wrist strap dirancang khusus untuk menyamakan potensial listrik tubuh dengan perangkat guna mencegah loncatan muatan statis.',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _selectedCheckAnswer == 1
                      ? Colors.green.shade800
                      : Colors.red.shade800,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _checkOptionItem(int index, String text) {
    bool isSelected = _selectedCheckAnswer == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCheckAnswer = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8E24AA).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF8E24AA) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? const Color(0xFF8E24AA) : Colors.grey,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
          ],
        ),
      ),
    );
  }

  Widget _buildReflect() {
    return _contentCard(
      title: 'Refleksi Analitis (REFLECT): Pemikiran Kritis K3LH',
      icon: Icons.psychology_rounded,
      color: const Color(0xFFE53935),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Renungkan dan jawab pertanyaan analitis berikut untuk memperkuat profesionalisme Anda sebagai tenaga TKJ:',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 16),
          _reflectionPrompt(
            '1. Mengapa kedisiplinan dalam menerapkan standar K3LH sering kali dianggap sepele oleh pemula, dan bagaimana cara menumbuhkan budaya keselamatan kerja di lingkungan lab?',
          ),
          const SizedBox(height: 14),
          _reflectionPrompt(
            '2. Analisis dampak jangka panjang terhadap kesehatan fisik dan mental apabila seorang Network Engineer mengabaikan prinsip ergonomi workstation selama bertahun-tahun.',
          ),
          const SizedBox(height: 14),
          _reflectionPrompt(
            '3. Buatlah komitmen pribadi (3 poin utama) mengenai tindakan preventif K3 yang akan konsisten Anda terapkan setiap kali bekerja dengan perangkat keras maupun jaringan.',
          ),
        ],
      ),
    );
  }

  Widget _reflectionPrompt(String prompt) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            prompt,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Tuliskan analisis dan refleksi Anda di sini...',
              filled: true,
              fillColor: Color(0xFFF9FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide.none,
              ),
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
      padding: const EdgeInsets.all(22),
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
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
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
                backgroundColor: const Color(0xFFAD8B73),
                foregroundColor: Colors.white,
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
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 22,
            color: const Color(0xFFAD8B73),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12.5,
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
}
