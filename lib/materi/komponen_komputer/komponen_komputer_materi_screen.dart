import 'package:flutter/material.dart';

class KomponenKomputerMateriScreen extends StatefulWidget {
  final int index;
  const KomponenKomputerMateriScreen({super.key, this.index = 0});

  @override
  State<KomponenKomputerMateriScreen> createState() =>
      _KomponenKomputerMateriScreenState();
}

class _KomponenKomputerMateriScreenState
    extends State<KomponenKomputerMateriScreen> {
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
        title: const Text('Komponen Komputer & Arsitektur Hardware'),
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
            Icons.computer_rounded,
            color: Colors.white,
            size: 44,
          ),
          SizedBox(height: 12),
          Text(
            'Arsitektur Hardware & Komponen Sistem PC',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Eksplorasi mendalam mengenai Central Processing Unit (CPU), Motherboard chipset, '
            'hierarki memori RAM & NVMe SSD, manajemen daya PSU, dan sistem pendingin.',
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
          'Alur Pembelajaran Komponen Komputer',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Pahami perangkat keras secara profesional dan komprehensif.',
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
      title: 'Observasi Mendalam: Komponen Fisik dalam Casing PC',
      icon: Icons.visibility_rounded,
      color: const Color(0xFFCEAB93),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Amati 5 komponen utama yang membentuk arsitektur sistem komputer modern di dalam casing:',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 16),
          _detailedObservationItem(
            '1. Socket & Chipset Processor (CPU)',
            'Perhatikan soket LGA/PGA pada motherboard tempat CPU diletakkan dengan presisi tinggi. Chipset (PCH) mengatur jalur komunikasi data antara CPU dengan memori dan perangkat I/O.',
            Icons.memory_rounded,
          ),
          const SizedBox(height: 12),
          _detailedObservationItem(
            '2. Slot RAM (DIMM) & Konfigurasi Dual Channel',
            'Slot memori DDR4/DDR5 dengan kancing pengunci di kedua sisi. Penggunaan dua keping RAM identik pada slot warna berselang-seling mengaktifkan mode dual-channel untuk bandwidth data dua kali lipat.',
            Icons.developer_board_rounded,
          ),
          const SizedBox(height: 12),
          _detailedObservationItem(
            '3. Form Factor Motherboard & Slot Ekspansi PCIe',
            'Papan sirkuit (ATX, Micro-ATX) yang dilengkapi slot PCIe x16 untuk kartu grafis (GPU) berkecepatan tinggi serta slot M.2 NVMe untuk SSD berukuran kecil langsung menempel di PCB.',
            Icons.extension_rounded,
          ),
          const SizedBox(height: 12),
          _detailedObservationItem(
            '4. Storage Modern (SSD SATA vs M.2 NVMe)',
            'Perbedaan evolusi penyimpanan dari HDD mekanis berputar ke SSD SATA 2.5 inci hingga M.2 NVMe berbasis protokol PCIe yang mampu menembus kecepatan baca/tulis hingga ribuan MB per detik.',
            Icons.sd_storage_rounded,
          ),
          const SizedBox(height: 12),
          _detailedObservationItem(
            '5. Power Supply Unit (PSU) & Manajemen Kabel',
            'Catu daya yang mengubah arus AC PLN menjadi DC (+12V, +5V, +3.3V). PSU berkualitas tinggi dilengkapi sertifikasi 80+ Bronze/Gold serta sistem kabel modular untuk kerapian airflow casing.',
            Icons.power_rounded,
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
      title: 'Konseptualisasi Mendalam: Teori Arsitektur Komputer',
      icon: Icons.lightbulb_rounded,
      color: const Color(0xFFFF9800),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sistem komputer bekerja berdasarkan Arsitektur Von Neumann, di mana data dan instruksi program disimpan dalam memori yang sama dan dieksekusi secara sekuensial oleh unit pemrosesan.',
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
          SizedBox(height: 16),
          Text(
            'Pilar Teori Hardware Komputer:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(height: 12),
          _ConceptItem(
            icon: Icons.memory_rounded,
            title: '1. Siklus Instruksi CPU (Fetch, Decode, Execute)',
            description: 'CPU mengambil instruksi dari memori (Fetch), menerjemahkannya di Control Unit (Decode), lalu memprosesnya melalui Arithmetic Logic Unit / ALU (Execute).',
          ),
          _ConceptItem(
            icon: Icons.layers_rounded,
            title: '2. Hierarki Memori (Speed vs Capacity)',
            description: 'Mulai dari Register CPU (tercepat, kapasitas terkecil) -> Cache L1/L2/L3 -> RAM (Volatile) -> SSD/HDD (Non-volatile, kapasitas besar, kecepatan lebih rendah).',
          ),
          _ConceptItem(
            icon: Icons.hub_rounded,
            title: '3. Bus Sistem & Jalur Komunikasi PCIe Lanes',
            description: 'Jalur komunikasi digital berkecepatan tinggi yang menghubungkan CPU dengan GPU, SSD NVMe, dan perangkat ekspansi tanpa bottleneck.',
          ),
          _ConceptItem(
            icon: Icons.ac_unit_rounded,
            title: '4. Manajemen Termal (Thermal Management)',
            description: 'Disipasi panas menggunakan pasta termal, heatsink tembaga/aluminium, dan kipas PWM / pendingin cairan (liquid cooling) untuk mencegah fenomena thermal throttling.',
          ),
        ],
      ),
    );
  }

  Widget _buildTry() {
    return _contentCard(
      title: 'Prosedur Praktis (TRY): Simulasi Perakitan Hardware',
      icon: Icons.handyman_rounded,
      color: const Color(0xFF43A047),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Studi Kasus: Anda sedang melakukan perakitan unit PC baru di lab TKJ. Langkah manakah yang merupakan prosedur benar saat memasang Processor (CPU) Intel/AMD ke soket Motherboard?',
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
                Icon(Icons.handyman_rounded, color: Color(0xFF43A047), size: 30),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pilih prosedur pemasangan CPU yang paling tepat:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _tryOptionItem(0, 'A. Menekan CPU dengan kuat menggunakan obeng agar pin soket cepat masuk.'),
          _tryOptionItem(1, 'B. Membuka tuas soket, menyelaraskan tanda segitiga emas CPU dengan segitiga di soket tanpa tekanan, lalu mengunci kembali.'),
          _tryOptionItem(2, 'C. Mengoleskan lem Korea di bawah CPU agar menempel permanen pada motherboard.'),
          _tryOptionItem(3, 'D. Memasang CPU terbalik menghadap ke bawah agar bagian pin terlindungi.'),
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
            child: const Text('Periksa Prosedur Perakitan'),
          ),
          if (_trySubmitted) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _selectedTryAnswer == 1
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _selectedTryAnswer == 1
                    ? 'Sempurna! Pemasangan CPU harus selalu memperhatikan tanda segitiga (pin 1 alignment) dan diletakkan secara presisi tanpa tekanan berlebih sebelum tuas dikunci.'
                    : 'Belum tepat. Prosedur tersebut dapat merusak pin pada soket motherboard atau merusak CPU.',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _selectedTryAnswer == 1
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
      title: 'Uji Evaluasi (CHECK): Kuis Kompetensi Hardware',
      icon: Icons.fact_check_rounded,
      color: const Color(0xFF8E24AA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pertanyaan 1 dari 2:\nManakah jenis komponen penyimpanan di bawah ini yang bersifat non-volatile (data tidak hilang saat komputer dimatikan) dan memiliki kecepatan baca/tulis tercepat berbasis slot PCIe?',
            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, height: 1.5),
          ),
          const SizedBox(height: 14),
          _checkOptionItem(0, 'A. RAM (Random Access Memory) DDR4'),
          _checkOptionItem(1, 'B. Cache L3 Processor'),
          _checkOptionItem(2, 'C. SSD M.2 NVMe'),
          _checkOptionItem(3, 'D. Virtual Memory Pagefile'),
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
                color: _selectedCheckAnswer == 2
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _selectedCheckAnswer == 2
                    ? 'Luar biasa! Jawaban Anda tepat. SSD M.2 NVMe menggunakan jalur PCIe berkecepatan tinggi dan menyimpan data secara permanen (non-volatile).'
                    : 'Belum tepat. Perhatikan kembali perbedaan sifat volatile (RAM/Cache) dan non-volatile (Storage SSD).',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _selectedCheckAnswer == 2
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
      title: 'Refleksi Analitis (REFLECT): Pemikiran Kritis Hardware',
      icon: Icons.psychology_rounded,
      color: const Color(0xFFE53935),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Renungkan dan jawab pertanyaan analitis berikut untuk memperdalam penguasaan perangkat keras komputer:',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 16),
          _reflectionPrompt(
            '1. Bagaimana sinergi kecepatan antara CPU, RAM berkapasitas besar, dan SSD NVMe menentukan performa keseluruhan sebuah sistem komputer saat menjalankan aplikasi berat?',
          ),
          const SizedBox(height: 14),
          _reflectionPrompt(
            '2. Mengapa pemilihan Power Supply Unit (PSU) dengan sertifikasi daya yang tepat sangat krusial dalam menjaga umur panjang (durability) seluruh komponen mahal di dalam PC?',
          ),
          const SizedBox(height: 14),
          _reflectionPrompt(
            '3. Apa tantangan utama dalam melakukan troubleshooting ketika komputer gagal booting (No Display) dan bagaimana langkah sistematis Anda mengatasinya?',
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
