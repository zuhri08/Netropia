import 'package:flutter/material.dart';

class IpAddressMateriScreen extends StatefulWidget {
  final int index;

  const IpAddressMateriScreen({
    super.key,
    this.index = 0,
  });

  @override
  State<IpAddressMateriScreen> createState() =>
      _IpAddressMateriScreenState();
}

class _IpAddressMateriScreenState extends State<IpAddressMateriScreen> {
  static const Color _primary = Color(0xFFAD8B73);
  static const Color _background = Color(0xFFF5F7FA);

  late final PageController _pageController;
  int _currentPage = 0;

  final List<_LessonPage> _pages = [
    // ============================================================
    // MATERI 01
    // ============================================================
    _LessonPage(
      number: 'MATERI 01',
      title: 'Pengertian IP Address',
      subtitle:
      'Memahami alamat IP sebagai identitas perangkat agar dapat saling berkomunikasi dalam jaringan komputer.',
      visualTitle: 'Gambaran sederhana jaringan',
      visualItems: [
        _VisualItem(Icons.laptop_mac_rounded, 'PC 1'),
        _VisualItem(Icons.hub_rounded, 'Switch'),
        _VisualItem(Icons.laptop_mac_rounded, 'PC 2'),
      ],
      sections: [
        _LessonSection(
          title: 'Apa itu IP Address?',
          body:
          'IP Address (Internet Protocol Address) adalah alamat logis yang digunakan untuk mengidentifikasi perangkat dalam jaringan komputer. Alamat ini membantu perangkat mengirim dan menerima data ke tujuan yang tepat.',
        ),
        _LessonSection(
          title: 'Mengapa perangkat membutuhkan IP Address?',
          body:
          'Bayangkan sebuah jaringan yang memiliki banyak komputer. Tanpa alamat yang membedakan setiap perangkat, data akan sulit dikirimkan ke tujuan yang benar.',
          bullets: [
            'Mengenali perangkat yang terhubung ke jaringan.',
            'Membantu proses pengiriman dan penerimaan data.',
            'Memungkinkan perangkat berkomunikasi melalui jaringan.',
          ],
        ),
        _LessonSection(
          title: 'Contoh penggunaan',
          body:
          'Ketika laptop terhubung ke Wi-Fi sekolah, laptop tersebut memperoleh alamat IP. Alamat tersebut digunakan dalam komunikasi dengan perangkat lain di jaringan.',
        ),
      ],
      takeaway:
      'IP Address merupakan alamat logis yang membantu perangkat dikenali dan berkomunikasi dalam jaringan komputer.',
    ),

    // ============================================================
    // MATERI 02
    // ============================================================
    _LessonPage(
      number: 'MATERI 02',
      title: 'Fungsi IP Address',
      subtitle:
      'Mengenal peran alamat IP dalam proses komunikasi dan pengelolaan jaringan komputer.',
      visualTitle: 'Peran IP Address dalam jaringan',
      visualItems: [
        _VisualItem(Icons.fingerprint_rounded, 'Identitas'),
        _VisualItem(Icons.send_rounded, 'Pengiriman'),
        _VisualItem(Icons.route_rounded, 'Tujuan'),
      ],
      sections: [
        _LessonSection(
          title: 'Sebagai identitas perangkat',
          body:
          'IP Address digunakan untuk membedakan satu perangkat dengan perangkat lainnya dalam jaringan. Setiap perangkat yang berkomunikasi membutuhkan alamat yang sesuai.',
        ),
        _LessonSection(
          title: 'Menentukan tujuan pengiriman data',
          body:
          'Ketika data dikirim melalui jaringan, alamat IP membantu menentukan perangkat atau jaringan yang menjadi tujuan komunikasi.',
        ),
        _LessonSection(
          title: 'Mendukung pengelolaan jaringan',
          body:
          'Administrator jaringan dapat menggunakan informasi IP Address untuk mengatur perangkat, memeriksa koneksi, dan membantu proses troubleshooting.',
        ),
        _LessonSection(
          title: 'Contoh dalam kehidupan sehari-hari',
          body:
          'Saat komputer mengakses server sekolah, komputer menggunakan alamat IP untuk berkomunikasi dengan server tersebut melalui jaringan.',
        ),
      ],
      takeaway:
      'IP Address berfungsi sebagai identitas dan alamat tujuan agar komunikasi data dapat berlangsung dengan tepat.',
    ),

    // ============================================================
    // MATERI 03
    // ============================================================
    _LessonPage(
      number: 'MATERI 03',
      title: 'Mengenal IPv4',
      subtitle:
      'Memahami format alamat IPv4, bagian-bagiannya, serta contoh penggunaannya dalam jaringan lokal.',
      visualTitle: 'Contoh format alamat IPv4',
      visualItems: [
        _VisualItem(Icons.looks_one_rounded, '192'),
        _VisualItem(Icons.looks_two_rounded, '168'),
        _VisualItem(Icons.looks_3_rounded, '1'),
        _VisualItem(Icons.looks_4_rounded, '10'),
      ],
      sections: [
        _LessonSection(
          title: 'Apa itu IPv4?',
          body:
          'IPv4 (Internet Protocol version 4) merupakan versi IP yang menggunakan panjang alamat 32 bit. IPv4 ditulis dalam empat kelompok angka desimal yang dipisahkan oleh tanda titik.',
        ),
        _LessonSection(
          title: 'Struktur alamat IPv4',
          body:
          'Setiap kelompok angka pada IPv4 disebut oktet. Satu alamat IPv4 terdiri dari empat oktet.',
          bullets: [
            'Contoh: 192.168.1.10.',
            'Terdiri dari empat oktet.',
            'Setiap oktet memiliki nilai 0 sampai 255.',
            'Panjang keseluruhan alamat adalah 32 bit.',
          ],
        ),
        _LessonSection(
          title: 'Contoh alamat IPv4',
          body:
          'Alamat 192.168.1.10 merupakan contoh alamat IPv4 yang umum digunakan pada jaringan lokal.',
        ),
        _LessonSection(
          title: 'Hal yang perlu diperhatikan',
          body:
          'Tidak semua alamat IPv4 dapat diberikan secara bebas kepada perangkat. Beberapa alamat memiliki fungsi khusus, seperti alamat network dan broadcast.',
        ),
      ],
      takeaway:
      'IPv4 memiliki panjang 32 bit dan ditulis dalam empat oktet desimal yang dipisahkan oleh tanda titik.',
    ),

    // ============================================================
    // MATERI 04
    // ============================================================
    _LessonPage(
      number: 'MATERI 04',
      title: 'Mengenal IPv6',
      subtitle:
      'Memahami IPv6 sebagai versi protokol internet dengan ruang alamat yang lebih luas dibandingkan IPv4.',
      visualTitle: 'Contoh format alamat IPv6',
      visualItems: [
        _VisualItem(Icons.numbers_rounded, '2001'),
        _VisualItem(Icons.numbers_rounded, '0db8'),
        _VisualItem(Icons.more_horiz_rounded, '...'),
        _VisualItem(Icons.language_rounded, '0001'),
      ],
      sections: [
        _LessonSection(
          title: 'Apa itu IPv6?',
          body:
          'IPv6 (Internet Protocol version 6) adalah versi protokol internet yang menggunakan panjang alamat 128 bit. IPv6 dikembangkan untuk menyediakan ruang alamat yang jauh lebih besar.',
        ),
        _LessonSection(
          title: 'Format alamat IPv6',
          body:
          'IPv6 ditulis menggunakan kelompok bilangan heksadesimal yang dipisahkan oleh tanda titik dua.',
          bullets: [
            'Menggunakan angka 0 sampai 9.',
            'Menggunakan huruf a sampai f.',
            'Panjang alamat adalah 128 bit.',
            'Contoh: 2001:db8::1.',
          ],
        ),
        _LessonSection(
          title: 'Mengapa IPv6 diperlukan?',
          body:
          'Jumlah perangkat yang terhubung ke internet terus bertambah. IPv6 menyediakan ruang alamat yang lebih besar untuk mendukung kebutuhan pengalamatan tersebut.',
        ),
        _LessonSection(
          title: 'Perbedaan IPv4 dan IPv6',
          body:
          'IPv4 menggunakan alamat 32 bit dengan format desimal bertitik, sedangkan IPv6 menggunakan alamat 128 bit dengan format heksadesimal bertitik dua.',
        ),
      ],
      takeaway:
      'IPv6 menggunakan panjang alamat 128 bit dan menyediakan ruang alamat yang jauh lebih besar dibandingkan IPv4.',
    ),

    // ============================================================
    // MATERI 05
    // ============================================================
    _LessonPage(
      number: 'MATERI 05',
      title: 'IP Public dan IP Private',
      subtitle:
      'Membedakan alamat IP berdasarkan penggunaannya pada jaringan lokal dan jaringan internet.',
      visualTitle: 'Dua penggunaan alamat IP',
      visualItems: [
        _VisualItem(Icons.home_work_rounded, 'Jaringan lokal'),
        _VisualItem(Icons.router_rounded, 'Router'),
        _VisualItem(Icons.public_rounded, 'Internet'),
      ],
      sections: [
        _LessonSection(
          title: 'Apa itu IP Private?',
          body:
          'IP Private adalah alamat IP yang digunakan dalam jaringan lokal, seperti jaringan rumah, sekolah, atau laboratorium. Alamat ini tidak dirutekan secara langsung melalui internet publik.',
        ),
        _LessonSection(
          title: 'Rentang alamat IPv4 Private',
          bullets: [
            '10.0.0.0 sampai 10.255.255.255.',
            '172.16.0.0 sampai 172.31.255.255.',
            '192.168.0.0 sampai 192.168.255.255.',
          ],
        ),
        _LessonSection(
          title: 'Apa itu IP Public?',
          body:
          'IP Public adalah alamat IP yang digunakan untuk komunikasi melalui internet publik. Alamat ini dialokasikan melalui pengelolaan alamat IP oleh pihak yang berwenang atau penyedia layanan.',
        ),
        _LessonSection(
          title: 'Contoh penerapan',
          body:
          'Komputer di laboratorium dapat menggunakan IP Private untuk berkomunikasi dengan komputer lain. Router kemudian dapat menjadi penghubung menuju jaringan luar.',
        ),
      ],
      takeaway:
      'IP Private digunakan untuk jaringan lokal, sedangkan IP Public digunakan dalam komunikasi melalui internet publik.',
    ),

    // ============================================================
    // MATERI 06
    // ============================================================
    _LessonPage(
      number: 'MATERI 06',
      title: 'IP Static dan Dynamic',
      subtitle:
      'Mengenal dua cara perangkat memperoleh alamat IP dalam jaringan komputer.',
      visualTitle: 'Cara memperoleh alamat IP',
      visualItems: [
        _VisualItem(Icons.settings_rounded, 'Static'),
        _VisualItem(Icons.autorenew_rounded, 'Dynamic'),
      ],
      sections: [
        _LessonSection(
          title: 'Apa itu IP Static?',
          body:
          'IP Static adalah alamat IP yang ditetapkan secara manual pada perangkat. Alamat tersebut tidak berubah kecuali dilakukan perubahan konfigurasi.',
          bullets: [
            'Dikonfigurasi secara manual.',
            'Cocok untuk perangkat yang membutuhkan alamat tetap.',
            'Administrator perlu memastikan tidak terjadi konflik alamat IP.',
          ],
        ),
        _LessonSection(
          title: 'Apa itu IP Dynamic?',
          body:
          'IP Dynamic adalah alamat IP yang diberikan secara otomatis oleh layanan DHCP. Alamat yang diperoleh perangkat dapat berubah sesuai pengaturan jaringan.',
          bullets: [
            'Diberikan secara otomatis oleh DHCP.',
            'Mengurangi kebutuhan konfigurasi manual.',
            'Umum digunakan pada jaringan sekolah, rumah, dan kantor.',
          ],
        ),
        _LessonSection(
          title: 'Perbedaan Static dan Dynamic',
          body:
          'Perbedaan utama terletak pada cara memperoleh alamat. IP Static diatur secara manual, sedangkan IP Dynamic diperoleh secara otomatis melalui layanan DHCP.',
        ),
        _LessonSection(
          title: 'Contoh penerapan',
          body:
          'Komputer server lokal dapat menggunakan IP Static agar alamatnya tetap. Sementara itu, laptop siswa dapat memperoleh IP Dynamic ketika terhubung ke jaringan Wi-Fi.',
        ),
      ],
      takeaway:
      'IP Static ditetapkan secara manual, sedangkan IP Dynamic diberikan secara otomatis melalui DHCP.',
    ),

    // ============================================================
    // MATERI 07
    // ============================================================
    _LessonPage(
      number: 'MATERI 07',
      title: 'Subnet Mask dan Gateway',
      subtitle:
      'Memahami dua komponen penting dalam konfigurasi IPv4 pada jaringan komputer.',
      visualTitle: 'Contoh konfigurasi jaringan',
      visualItems: [
        _VisualItem(Icons.computer_rounded, 'IP Address'),
        _VisualItem(Icons.grid_view_rounded, 'Subnet Mask'),
        _VisualItem(Icons.router_rounded, 'Gateway'),
      ],
      sections: [
        _LessonSection(
          title: 'Apa itu Subnet Mask?',
          body:
          'Subnet Mask digunakan untuk membedakan bagian network dan host pada alamat IPv4. Informasi ini membantu perangkat menentukan apakah tujuan komunikasi berada dalam jaringan yang sama atau jaringan lain.',
        ),
        _LessonSection(
          title: 'Contoh Subnet Mask',
          body:
          'Salah satu subnet mask yang sering digunakan pada jaringan lokal adalah 255.255.255.0 atau dikenal juga dengan prefix /24.',
        ),
        _LessonSection(
          title: 'Apa itu Default Gateway?',
          body:
          'Default Gateway adalah alamat perangkat yang menjadi jalur keluar menuju jaringan lain. Pada jaringan lokal, perangkat yang berperan sebagai gateway umumnya adalah router.',
        ),
        _LessonSection(
          title: 'Contoh konfigurasi',
          body:
          'Sebuah komputer dapat memiliki konfigurasi seperti berikut:',
          bullets: [
            'IP Address: 192.168.1.10.',
            'Subnet Mask: 255.255.255.0.',
            'Default Gateway: 192.168.1.1.',
          ],
        ),
        _LessonSection(
          title: 'Mengapa ketiganya penting?',
          body:
          'IP Address menunjukkan alamat perangkat, Subnet Mask membantu menentukan jaringan, sedangkan Default Gateway menjadi jalur menuju jaringan lain.',
        ),
      ],
      takeaway:
      'IP Address, Subnet Mask, dan Default Gateway bekerja bersama agar perangkat dapat berkomunikasi dalam jaringan.',
    ),

    // ============================================================
    // MATERI 08
    // ============================================================
    _LessonPage(
      number: 'MATERI 08',
      title: 'Konfigurasi dan Studi Kasus',
      subtitle:
      'Menerapkan pemahaman IP Address melalui contoh konfigurasi jaringan dan analisis masalah sederhana.',
      visualTitle: 'Contoh jaringan laboratorium',
      visualItems: [
        _VisualItem(Icons.router_rounded, 'Router'),
        _VisualItem(Icons.computer_rounded, 'PC 1'),
        _VisualItem(Icons.computer_rounded, 'PC 2'),
        _VisualItem(Icons.print_rounded, 'Printer'),
      ],
      sections: [
        _LessonSection(
          title: 'Contoh konfigurasi jaringan',
          body:
          'Sebuah laboratorium memiliki router dengan alamat 192.168.10.1 dan subnet mask 255.255.255.0. Beberapa perangkat menggunakan alamat IP dalam jaringan yang sama.',
          bullets: [
            'Router: 192.168.10.1.',
            'Laptop 1: 192.168.10.2.',
            'Laptop 2: 192.168.10.3.',
            'Printer: 192.168.10.4.',
            'Subnet Mask: 255.255.255.0.',
          ],
        ),
        _LessonSection(
          title: 'Studi kasus: komputer tidak terhubung',
          body:
          'Saat praktik, sebuah komputer tidak dapat berkomunikasi dengan perangkat lain dalam jaringan lokal. Salah satu hal yang perlu diperiksa adalah konfigurasi IP Address.',
        ),
        _LessonSection(
          title: 'Langkah pemeriksaan',
          bullets: [
            'Periksa apakah komputer memperoleh alamat IP.',
            'Pastikan alamat IP sesuai dengan jaringan yang digunakan.',
            'Periksa Subnet Mask dan Default Gateway.',
            'Pastikan tidak ada alamat IP yang digunakan oleh dua perangkat dalam jaringan yang sama.',
            'Periksa koneksi kabel atau Wi-Fi.',
            'Lakukan pengujian koneksi sesuai arahan guru.',
          ],
        ),
        _LessonSection(
          title: 'Refleksi pembelajaran',
          body:
          'Setelah mempelajari IP Address, pikirkan kembali bagaimana alamat IP membantu perangkat berkomunikasi. Perhatikan juga mengapa konfigurasi yang tidak sesuai dapat menyebabkan masalah jaringan.',
          bullets: [
            'Apa perbedaan IPv4 dan IPv6?',
            'Mengapa perangkat membutuhkan alamat IP?',
            'Apa fungsi Subnet Mask dan Default Gateway?',
            'Apa yang akan kamu periksa ketika komputer tidak terhubung ke jaringan?',
          ],
        ),
      ],
      takeaway:
      'Konfigurasi IP Address harus sesuai dengan jaringan. Pemeriksaan IP, Subnet Mask, Gateway, dan koneksi fisik merupakan bagian dari troubleshooting dasar.',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _currentPage = widget.index.clamp(0, _pages.length - 1).toInt();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    if (page < 0 || page >= _pages.length) return;

    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF263238),
        elevation: 0,
        title: const Text(
          'IP Address',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF4EDE8),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              '${(_currentPage + 1).toString().padLeft(2, '0')} / ${_pages.length.toString().padLeft(2, '0')}',
              style: const TextStyle(
                color: _primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: LinearProgressIndicator(
            value: (_currentPage + 1) / _pages.length,
            backgroundColor: const Color(0xFFECEFF1),
            valueColor: const AlwaysStoppedAnimation<Color>(_primary),
            minHeight: 3,
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return _buildLessonContent(_pages[index], index);
        },
      ),
      bottomNavigationBar: _buildBottomNavigation(page),
    );
  }

  Widget _buildLessonContent(_LessonPage page, int index) {
    return SingleChildScrollView(
      key: PageStorageKey('ip-address-page-$index'),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLessonHeading(page),
          const SizedBox(height: 22),
          _buildVisualCard(page),
          const SizedBox(height: 24),
          ...page.sections.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 22),
              child: _buildSection(entry.key + 1, entry.value),
            );
          }),
          _buildTakeaway(page.takeaway),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildLessonHeading(_LessonPage page) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: _primary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            page.number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 13),
        Text(
          page.title,
          style: const TextStyle(
            color: Color(0xFF17447E),
            fontSize: 27,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          page.subtitle,
          style: const TextStyle(
            color: Color(0xFF607D8B),
            fontSize: 14,
            height: 1.55,
          ),
        ),
      ],
    );
  }

  Widget _buildVisualCard(_LessonPage page) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDCE3E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            page.visualTitle,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF455A64),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 12,
            children: page.visualItems.map((item) {
              return SizedBox(
                width: page.visualItems.length >= 5 ? 75 : 82,
                child: Column(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5EDE7),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: const Color(0xFFE6D4C7),
                        ),
                      ),
                      child: Icon(
                        item.icon,
                        color: _primary,
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      item.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF455A64),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFE7ECEF)),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Pahami konsep • Amati jaringan • Terapkan dengan tepat',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF78909C),
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(int number, _LessonSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number.toString().padLeft(2, '0'),
              style: const TextStyle(
                color: _primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                section.title,
                style: const TextStyle(
                  color: Color(0xFF263238),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (section.body != null)
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              section.body!,
              style: const TextStyle(
                color: Color(0xFF546E7A),
                fontSize: 13.5,
                height: 1.65,
              ),
            ),
          ),
        if (section.bullets.isNotEmpty) ...[
          const SizedBox(height: 9),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Column(
              children: section.bullets.map((bullet) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 7, right: 9),
                        decoration: const BoxDecoration(
                          color: _primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          bullet,
                          style: const TextStyle(
                            color: Color(0xFF546E7A),
                            fontSize: 13,
                            height: 1.55,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTakeaway(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4EDE8),
        border: const Border(
          left: BorderSide(
            color: _primary,
            width: 4,
          ),
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            color: _primary,
            size: 21,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Intinya',
                  style: TextStyle(
                    color: Color(0xFF17447E),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xFF37474F),
                    fontSize: 12.5,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(_LessonPage page) {
    final isFirst = _currentPage == 0;
    final isLast = _currentPage == _pages.length - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE7ECEF)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (!isFirst)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _goToPage(_currentPage - 1),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    size: 17,
                  ),
                  label: const Text('Sebelumnya'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _primary,
                    side: const BorderSide(color: _primary),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
              ),
            if (!isFirst) const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isLast
                    ? () => Navigator.pop(context)
                    : () => _goToPage(_currentPage + 1),
                icon: Icon(
                  isLast
                      ? Icons.check_circle_outline_rounded
                      : Icons.arrow_forward_rounded,
                  size: 17,
                ),
                label: Text(isLast ? 'Selesai' : 'Berikutnya'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
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

// ============================================================
// MODEL DATA MATERI
// ============================================================

class _LessonPage {
  final String number;
  final String title;
  final String subtitle;
  final String visualTitle;
  final List<_VisualItem> visualItems;
  final List<_LessonSection> sections;
  final String takeaway;

  const _LessonPage({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.visualTitle,
    required this.visualItems,
    required this.sections,
    required this.takeaway,
  });
}

class _VisualItem {
  final IconData icon;
  final String label;

  const _VisualItem(this.icon, this.label);
}

class _LessonSection {
  final String title;
  final String? body;
  final List<String> bullets;

  const _LessonSection({
    required this.title,
    this.body,
    this.bullets = const [],
  });
}