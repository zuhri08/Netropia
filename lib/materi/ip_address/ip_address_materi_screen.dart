import 'package:flutter/material.dart';

class IpAddressMateriScreen extends StatefulWidget {
  final int index;
  const IpAddressMateriScreen({super.key, this.index = 0});

  @override
  State<IpAddressMateriScreen> createState() => _IpAddressMateriScreenState();
}

class _IpAddressMateriScreenState extends State<IpAddressMateriScreen> {
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
        title: const Text('IP Address & Pengalamatan Jaringan'),
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
            Icons.lan_rounded,
            color: Colors.white,
            size: 44,
          ),
          SizedBox(height: 12),
          Text(
            'Konsep IPv4, Subnetting & Pengalamatan Jaringan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Modul profesional TKJ mengenai struktur alamat logis IPv4, pembagian Network/Host ID, '
            'notasi CIDR, teknik subnetting, serta konfigurasi TCP/IP.',
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
          'Alur Pembelajaran IP Address',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Kuasai protokol pengalamatan jaringan secara bertahap dan mendalam.',
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
      title: 'Observasi Mendalam: Anatomi & Parameter IP Address',
      icon: Icons.visibility_rounded,
      color: const Color(0xFFCEAB93),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Amati 5 komponen esensial dalam konfigurasi protokol TCP/IP pada sistem operasi:',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 16),
          _detailedObservationItem(
            '1. Alamat IPv4 (Contoh: 192.168.1.10)',
            'Terdiri dari 4 blok bilangan desimal (oktet) yang dipisahkan titik. Setiap oktet merepresentasikan nilai biner 8-bit dengan rentang angka 0 hingga 255.',
            Icons.numbers_rounded,
          ),
          const SizedBox(height: 12),
          _detailedObservationItem(
            '2. Subnet Mask & Prefix (Contoh: 255.255.255.0 /24)',
            'Berfungsi sebagai penentu batasan porsi Network ID dan Host ID. Notasi CIDR /24 berarti 24 bit pertama digunakan untuk jaringan dan 8 bit terakhir untuk host.',
            Icons.grid_3x3_rounded,
          ),
          const SizedBox(height: 12),
          _detailedObservationItem(
            '3. Default Gateway (Contoh: 192.168.1.1)',
            'Alamat IP milik Router yang bertindak sebagai "pintu gerbang" bagi komputer lokal untuk berkomunikasi dengan jaringan luar atau internet.',
            Icons.router_rounded,
          ),
          const SizedBox(height: 12),
          _detailedObservationItem(
            '4. IP Private vs IP Public',
            'IP Private digunakan secara eksklusif dalam jaringan lokal (LAN) tanpa koneksi internet langsung, sementara IP Public bersifat routable secara global di internet.',
            Icons.public_rounded,
          ),
          const SizedBox(height: 12),
          _detailedObservationItem(
            '5. Uji Latensi via Command Ping & TTL',
            'Perintah ping menampilkan waktu round-trip (ms) dan Time to Live (TTL) paket data saat melintasi router menuju tujuan.',
            Icons.speed_rounded,
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
      title: 'Konseptualisasi Mendalam: Teori Pengalamatan TCP/IP',
      icon: Icons.lightbulb_rounded,
      color: const Color(0xFFFF9800),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'IP Address adalah alamat logis berbasis perangkat lunak yang diberikan kepada setiap perangkat network interface card (NIC) agar dapat saling mengenali dan bertukar paket data dalam arsitektur internetworking.',
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
          SizedBox(height: 16),
          Text(
            'Pilar Teori IPv4 & Subnetting:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(height: 12),
          _ConceptItem(
            icon: Icons.account_tree_rounded,
            title: '1. Struktur 32-bit & Pembagian Oktet',
            description: 'IPv4 terdiri dari total 32 bit biner yang dibagi menjadi 4 oktet. Nilai maksimum per oktet adalah 2^8 - 1 = 255.',
          ),
          _ConceptItem(
            icon: Icons.domain_rounded,
            title: '2. Network ID dan Host ID',
            description: 'Network ID mengidentifikasi segmen jaringan tempat perangkat berada, sedangkan Host ID mengidentifikasi perangkat unik dalam segmen tersebut.',
          ),
          _ConceptItem(
            icon: Icons.grid_view_rounded,
            title: '3. Subnetting & CIDR (Classless Inter-Domain Routing)',
            description: 'Metodologi pemecahan blok IP besar menjadi subnet-subnet yang lebih efisien dengan menggeser bit subnet mask ke kanan.',
          ),
          _ConceptItem(
            icon: Icons.bookmark_added_rounded,
            title: '4. Alamat Khusus (Loopback & Broadcast)',
            description: 'IP 127.0.0.1 (Loopback) untuk uji internal stack TCP/IP, Host ber-bit 0 sebagai Network Address, dan Host ber-bit 1 sebagai Broadcast Address.',
          ),
        ],
      ),
    );
  }

  Widget _buildTry() {
    return _contentCard(
      title: 'Prosedur Praktis (TRY): Simulasi Analisis Network ID',
      icon: Icons.handyman_rounded,
      color: const Color(0xFF43A047),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Studi Kasus: Sebuah komputer dalam jaringan lokal dikonfigurasi dengan IP Address `192.168.10.45` dan Subnet Mask `255.255.255.0` (Prefix /24). '
            'Berdasarkan aturan operasi logika AND antara IP dan Subnet Mask, berapakah alamat Network ID dari komputer tersebut?',
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
                Icon(Icons.lan_rounded, color: Color(0xFF43A047), size: 30),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pilih hasil perhitungan Network ID yang benar:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _tryOptionItem(0, 'A. 192.168.10.0'),
          _tryOptionItem(1, 'B. 192.168.0.0'),
          _tryOptionItem(2, 'C. 192.168.10.45'),
          _tryOptionItem(3, 'D. 255.255.255.0'),
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
            child: const Text('Periksa Perhitungan Network ID'),
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
                    ? 'Tepat sekali! Dengan prefix /24 (255.255.255.0), 3 oktet pertama menjadi Network ID (`192.168.10.0`) dan oktet terakhir untuk host.'
                    : 'Belum tepat. Pada subnet mask /24, oktet terakhir diset menjadi 0 untuk menentukan Network ID.',
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
      title: 'Uji Evaluasi (CHECK): Kuis Kompetensi IP Address',
      icon: Icons.fact_check_rounded,
      color: const Color(0xFF8E24AA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pertanyaan 1 dari 2:\nBerapakah jumlah total bit yang menyusun satu alamat IPv4 secara keseluruhan dalam format standar?',
            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, height: 1.5),
          ),
          const SizedBox(height: 14),
          _checkOptionItem(0, 'A. 8 bit'),
          _checkOptionItem(1, 'B. 16 bit'),
          _checkOptionItem(2, 'C. 32 bit'),
          _checkOptionItem(3, 'D. 128 bit'),
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
                    ? 'Luar biasa! Jawaban Anda tepat. IPv4 terdiri dari 32 bit yang dibagi ke dalam 4 oktet (masing-masing 8 bit).'
                    : 'Belum tepat. Ingat bahwa 128 bit adalah ukuran untuk IPv6, sedangkan IPv4 berukuran 32 bit.',
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
      title: 'Refleksi Analitis (REFLECT): Pemikiran Kritis IP Address',
      icon: Icons.psychology_rounded,
      color: const Color(0xFFE53935),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Renungkan dan jawab pertanyaan analitis berikut untuk memperdalam penguasaan pengalamatan jaringan:',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 16),
          _reflectionPrompt(
            '1. Mengapa keterbatasan jumlah alamat IPv4 di dunia mendorong adopsi teknologi NAT (Network Address Translation) dan migrasi bertahap ke IPv6?',
          ),
          const SizedBox(height: 14),
          _reflectionPrompt(
            '2. Bagaimana teknik subnetting membantu administrator jaringan dalam meningkatkan efisiensi alokasi IP dan memperkuat keamanan segmen jaringan perusahaan?',
          ),
          const SizedBox(height: 14),
          _reflectionPrompt(
            '3. Apa kendala operasional yang akan terjadi jika dua perangkat dalam satu segmen LAN memiliki alamat IP statis yang identik (IP Conflict), dan bagaimana cara mendeteksinya?',
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
