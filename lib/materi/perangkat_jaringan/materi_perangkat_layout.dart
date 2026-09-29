import 'package:flutter/material.dart';

class PerangkatMateriScreen extends StatefulWidget {
  final int index;
  const PerangkatMateriScreen({super.key, this.index = 0});

  @override
  State<PerangkatMateriScreen> createState() => _PerangkatMateriScreenState();
}

class _PerangkatMateriScreenState extends State<PerangkatMateriScreen> {
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
        title: const Text('Perangkat Jaringan Komputer'),
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
            Icons.router_rounded,
            color: Colors.white,
            size: 44,
          ),
          SizedBox(height: 12),
          Text(
            'Infrastruktur & Perangkat Keras Jaringan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Modul profesional TKJ mengenai fungsi Switch, Router Layer 3, Access Point nirkabel, '
            'Modem fiber optik (ONT), dan Firewall pengaman lalu lintas data.',
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
          'Alur Pembelajaran Perangkat Jaringan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Pelajari fungsi dan peran perangkat jaringan secara mendalam.',
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
      title: 'Observasi Mendalam: Perangkat Keras di Lapangan',
      icon: Icons.visibility_rounded,
      color: const Color(0xFFCEAB93),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Amati 5 perangkat keras networking utama yang menyusun topologi jaringan komputer:',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 16),
          _detailedObservationItem(
            '1. Port RJ-45 & Indikator LED Switch LAN',
            'Perhatikan port Ethernet dan lampu indikator Link/Act pada Switch. Kedipan lampu menunjukkan aktivitas transmisi data paket frame antar perangkat dalam jaringan lokal.',
            Icons.hub_rounded,
          ),
          const SizedBox(height: 12),
          _detailedObservationItem(
            '2. Wi-Fi Router & Access Point Nirkabel',
            'Perangkat dengan antena eksternal (omni-directional) yang memancarkan gelombang radio frekuensi 2.4 GHz dan 5 GHz untuk koneksi klien tanpa kabel.',
            Icons.wifi_tethering_rounded,
          ),
          const SizedBox(height: 12),
          _detailedObservationItem(
            '3. Enterprise Router (Cisco / MikroTik)',
            'Dilengkapi port WAN/LAN, port konsol manajemen, serta slot SFP untuk modul fiber optik guna menghubungkan jaringan lokal ke jaringan global (Internet).',
            Icons.router_rounded,
          ),
          const SizedBox(height: 12),
          _detailedObservationItem(
            '4. Modem Serat Optik (ONT / ONU)',
            'Perangkat pembatas penyedia layanan internet (ISP) yang mengubah sinyal optik dari kabel fiber menjadi sinyal elektrik ethernet untuk didistribusikan ke router.',
            Icons.settings_ethernet_rounded,
          ),
          const SizedBox(height: 12),
          _detailedObservationItem(
            '5. Rack Server & Patch Panel',
            'Lemari rack besi terstandarisasi yang menampung switch, router, server, dan patch panel dengan manajemen kabel terstruktur rapi.',
            Icons.dns_rounded,
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
      title: 'Konseptualisasi Mendalam: Peran & Lapisan OSI Perangkat',
      icon: Icons.lightbulb_rounded,
      color: const Color(0xFFFF9800),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Perangkat jaringan adalah komponen hardware yang berfungsi untuk menghubungkan, mentransmisikan, dan mengatur lalu lintas data berdasarkan model referensi OSI (Open Systems Interconnection).',
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
          SizedBox(height: 16),
          Text(
            'Pilar Fungsi Perangkat Jaringan:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(height: 12),
          _ConceptItem(
            icon: Icons.layers_rounded,
            title: '1. Hub vs Switch (Layer 1 vs Layer 2)',
            description: 'Hub bekerja di Layer 1 (Physical) dengan menyebar sinyal ke semua port. Switch bekerja di Layer 2 (Data Link) dengan membaca MAC Address dan meneruskan data secara cerdas ke port tujuan spesifik.',
          ),
          _ConceptItem(
            icon: Icons.router_rounded,
            title: '2. Routing & Logical Addressing (Layer 3)',
            description: 'Router bekerja di Layer 3 (Network) dengan menganalisis IP Address tujuan dan memilih jalur terbaik (best path) antar jaringan berbeda.',
          ),
          _ConceptItem(
            icon: Icons.wifi_rounded,
            title: '3. Wireless Access Point & Mobility',
            description: 'Menyediakan titik akses nirkabel yang menjembatani perangkat client berbasis gelombang radio dengan jaringan kabel LAN.',
          ),
          _ConceptItem(
            icon: Icons.security_rounded,
            title: '4. Firewall & Packet Inspection',
            description: 'Sistem pengamanan yang menyaring lalu lintas paket masuk dan keluar berdasarkan aturan (security rules) yang telah ditetapkan.',
          ),
        ],
      ),
    );
  }

  Widget _buildTry() {
    return _contentCard(
      title: 'Prosedur Praktis (TRY): Simulasi Pemilihan Perangkat',
      icon: Icons.handyman_rounded,
      color: const Color(0xFF43A047),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Studi Kasus: Anda ditugaskan membangun jaringan Local Area Network (LAN) untuk 20 unit komputer di ruang laboratorium sekolah agar dapat saling berkomunikasi secara efisien tanpa collision domain yang tinggi. '
            'Perangkat manakah yang paling tepat dipasang di tengah topologi tersebut?',
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
                Icon(Icons.hub_rounded, color: Color(0xFF43A047), size: 30),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pilih perangkat penghubung LAN yang paling tepat:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _tryOptionItem(0, 'A. Network Switch (Layer 2)'),
          _tryOptionItem(1, 'B. Passive Hub (Layer 1)'),
          _tryOptionItem(2, 'C. Analog Telephone Repeater'),
          _tryOptionItem(3, 'D. External Hard Disk Drive'),
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
            child: const Text('Periksa Pemilihan Perangkat'),
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
                    ? 'Benar sekali! Switch menggunakan tabel MAC Address untuk meneruskan frame data secara langsung ke port tujuan, sehingga efisiensi tinggi dan bebas collision domain.'
                    : 'Belum tepat. Hub sudah ditinggalkan karena menyebarkan data ke semua port dan rentan tabrakan data (collision).',
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
      title: 'Uji Evaluasi (CHECK): Kuis Kompetensi Perangkat Jaringan',
      icon: Icons.fact_check_rounded,
      color: const Color(0xFF8E24AA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pertanyaan 1 dari 2:\nPerangkat jaringan manakah yang beroperasi pada OSI Layer 3 (Network Layer) dan memiliki fungsi utama menghubungkan dua atau lebih jaringan berbeda serta melakukan routing paket data?',
            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, height: 1.5),
          ),
          const SizedBox(height: 14),
          _checkOptionItem(0, 'A. Network Switch'),
          _checkOptionItem(1, 'B. Router'),
          _checkOptionItem(2, 'C. Hub'),
          _checkOptionItem(3, 'D. Network Interface Card (NIC)'),
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
                    ? 'Luar biasa! Jawaban Anda tepat. Router beroperasi pada Layer 3 dan bertanggung jawab meneruskan paket data antar-network yang berbeda.'
                    : 'Belum tepat. Ingat bahwa Switch bekerja di Layer 2, sedangkan Router bekerja di Layer 3 (Network).',
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
      title: 'Refleksi Analitis (REFLECT): Pemikiran Kritis Perangkat',
      icon: Icons.psychology_rounded,
      color: const Color(0xFFE53935),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Renungkan dan jawab pertanyaan analitis berikut untuk memperdalam penguasaan infrastruktur jaringan:',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 16),
          _reflectionPrompt(
            '1. Mengapa penggunaan Network Switch jauh lebih superior dalam hal efisiensi bandwidth dan keamanan dibandingkan Hub konvensional dalam sebuah LAN?',
          ),
          const SizedBox(height: 14),
          _reflectionPrompt(
            '2. Bagaimana peran router dalam mengelola tabel routing (routing table) dan mencegah terjadinya broadcast storm antar segmen jaringan yang besar?',
          ),
          const SizedBox(height: 14),
          _reflectionPrompt(
            '3. Apa pentingnya penerapan konfigurasi keamanan nirkabel (seperti enkripsi WPA3 dan pemisahan Guest Wi-Fi) pada Access Point modern?',
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
