import 'package:flutter/material.dart';

class PerangkatJaringanMateriScreen extends StatefulWidget {
  final int index;

  const PerangkatJaringanMateriScreen({
    super.key,
    this.index = 0,
  });

  @override
  State<PerangkatJaringanMateriScreen> createState() =>
      _PerangkatJaringanMateriScreenState();
}

class _PerangkatJaringanMateriScreenState
    extends State<PerangkatJaringanMateriScreen> {
  static const Color _primary = Color(0xFFAD8B73);
  static const Color _background = Color(0xFFF5F7FA);

  late final PageController _pageController;
  int _currentPage = 0;

  final List<_LessonPage> _pages = [
    _LessonPage(
      number: 'MATERI 01',
      title: 'Mengenal Perangkat Jaringan',
      subtitle:
      'Memahami pengertian, fungsi, dan peran perangkat jaringan dalam menghubungkan komputer serta perangkat lainnya.',
      icon: Icons.devices_rounded,
      visualTitle: 'Perangkat yang umum ditemukan dalam jaringan',
      visualItems: [
        _VisualItem(Icons.router_rounded, 'Router'),
        _VisualItem(Icons.hub_rounded, 'Switch'),
        _VisualItem(Icons.wifi_rounded, 'Access Point'),
        _VisualItem(Icons.settings_input_antenna_rounded, 'Modem'),
      ],
      sections: [
        _LessonSection(
          title: 'Apa itu perangkat jaringan?',
          body:
          'Perangkat jaringan adalah perangkat keras yang digunakan untuk membangun, menghubungkan, mengatur, dan mendukung komunikasi antarperangkat dalam suatu jaringan komputer.',
        ),
        _LessonSection(
          title: 'Mengapa perangkat jaringan dibutuhkan?',
          body:
          'Komputer dan perangkat lain membutuhkan media serta perangkat pendukung agar dapat saling bertukar data. Perangkat jaringan membantu proses pengiriman data, pengaturan lalu lintas, dan penghubungan antarjaringan.',
        ),
        _LessonSection(
          title: 'Contoh penggunaan di lingkungan sekolah',
          bullets: [
            'Switch menghubungkan beberapa komputer di laboratorium.',
            'Access Point menyediakan koneksi Wi-Fi bagi perangkat siswa.',
            'Router menghubungkan jaringan lokal dengan jaringan lain.',
            'Modem membantu menyediakan koneksi dari penyedia layanan internet.',
          ],
        ),
        _LessonSection(
          title: 'Perangkat aktif dan pasif',
          body:
          'Perangkat aktif membutuhkan sumber daya listrik dan dapat memproses atau meneruskan sinyal, seperti router dan switch. Perangkat pasif umumnya berfungsi sebagai media atau penghubung fisik, seperti kabel UTP dan konektor RJ45.',
        ),
      ],
      takeaway:
      'Perangkat jaringan memiliki fungsi yang berbeda, tetapi bekerja sama agar komunikasi data dapat berlangsung dengan baik.',
    ),
    _LessonPage(
      number: 'MATERI 02',
      title: 'Network Interface Card (NIC)',
      subtitle:
      'Mengenal kartu jaringan sebagai antarmuka yang memungkinkan perangkat terhubung ke jaringan komputer.',
      icon: Icons.network_wifi_rounded,
      visualTitle: 'Jenis antarmuka jaringan',
      visualItems: [
        _VisualItem(Icons.cable_rounded, 'Ethernet'),
        _VisualItem(Icons.wifi_rounded, 'Wireless'),
        _VisualItem(Icons.fingerprint_rounded, 'MAC Address'),
      ],
      sections: [
        _LessonSection(
          title: 'Pengertian NIC',
          body:
          'Network Interface Card (NIC) adalah perangkat keras atau antarmuka jaringan yang memungkinkan komputer terhubung dan berkomunikasi melalui jaringan.',
        ),
        _LessonSection(
          title: 'NIC kabel (Ethernet)',
          body:
          'NIC Ethernet menghubungkan komputer ke jaringan menggunakan kabel jaringan, umumnya kabel UTP dengan konektor RJ45. Antarmuka ini banyak digunakan pada komputer desktop dan perangkat jaringan.',
        ),
        _LessonSection(
          title: 'NIC nirkabel (Wireless)',
          body:
          'Wireless NIC memungkinkan perangkat terhubung ke jaringan tanpa kabel melalui gelombang radio, misalnya menggunakan teknologi Wi-Fi.',
        ),
        _LessonSection(
          title: 'MAC Address',
          body:
          'MAC Address merupakan alamat fisik atau alamat perangkat jaringan yang digunakan pada komunikasi di lapisan data link. Alamat ini biasanya ditetapkan pada antarmuka jaringan.',
        ),
        _LessonSection(
          title: 'Contoh penerapan',
          bullets: [
            'Komputer laboratorium menggunakan NIC Ethernet untuk terhubung ke switch.',
            'Laptop dapat menggunakan NIC wireless untuk terhubung ke Access Point.',
            'Satu perangkat dapat memiliki lebih dari satu antarmuka jaringan.',
          ],
        ),
      ],
      takeaway:
      'NIC menjadi penghubung antara perangkat komputer dan media jaringan, baik menggunakan kabel maupun koneksi nirkabel.',
    ),
    _LessonPage(
      number: 'MATERI 03',
      title: 'Hub dan Switch',
      subtitle:
      'Memahami perangkat yang digunakan untuk menghubungkan beberapa perangkat dalam jaringan lokal.',
      icon: Icons.hub_rounded,
      visualTitle: 'Perbedaan cara kerja',
      visualItems: [
        _VisualItem(Icons.device_hub_rounded, 'Hub'),
        _VisualItem(Icons.account_tree_rounded, 'Switch'),
        _VisualItem(Icons.devices_rounded, 'Perangkat'),
      ],
      sections: [
        _LessonSection(
          title: 'Pengertian Hub',
          body:
          'Hub adalah perangkat jaringan yang menghubungkan beberapa perangkat dalam satu jaringan lokal. Ketika menerima data, hub meneruskan sinyal ke seluruh port selain port asal.',
        ),
        _LessonSection(
          title: 'Pengertian Switch',
          body:
          'Switch adalah perangkat yang menghubungkan beberapa perangkat dalam jaringan lokal. Switch mempelajari alamat MAC untuk meneruskan frame ke port tujuan yang sesuai.',
        ),
        _LessonSection(
          title: 'Perbedaan Hub dan Switch',
          bullets: [
            'Hub meneruskan sinyal ke banyak port, sedangkan switch dapat meneruskan frame berdasarkan alamat MAC.',
            'Hub tidak mempelajari tabel alamat MAC seperti switch.',
            'Switch umumnya lebih efisien untuk jaringan lokal modern.',
            'Keduanya dapat digunakan untuk menghubungkan beberapa perangkat melalui kabel jaringan.',
          ],
        ),
        _LessonSection(
          title: 'Contoh penggunaan switch',
          body:
          'Di laboratorium TKJ, beberapa komputer dapat dihubungkan ke satu switch. Setiap komputer menggunakan kabel jaringan yang terhubung ke port switch sehingga dapat berkomunikasi dalam jaringan lokal.',
        ),
        _LessonSection(
          title: 'Hal yang perlu diperhatikan',
          bullets: [
            'Pastikan kabel terpasang pada port yang sesuai.',
            'Perhatikan indikator lampu port untuk mengetahui status koneksi.',
            'Gunakan switch dengan jumlah port yang sesuai kebutuhan.',
            'Hindari melepas kabel saat perangkat sedang digunakan tanpa prosedur yang tepat.',
          ],
        ),
      ],
      takeaway:
      'Hub dan switch sama-sama menghubungkan perangkat, tetapi switch meneruskan data dengan mempertimbangkan alamat MAC tujuan.',
    ),
    _LessonPage(
      number: 'MATERI 04',
      title: 'Router',
      subtitle:
      'Mengenal router dan perannya dalam menghubungkan jaringan yang berbeda serta menentukan jalur pengiriman paket data.',
      icon: Icons.router_rounded,
      visualTitle: 'Peran router dalam jaringan',
      visualItems: [
        _VisualItem(Icons.laptop_rounded, 'LAN'),
        _VisualItem(Icons.router_rounded, 'Router'),
        _VisualItem(Icons.public_rounded, 'Jaringan lain'),
      ],
      sections: [
        _LessonSection(
          title: 'Pengertian router',
          body:
          'Router adalah perangkat jaringan yang menghubungkan dua atau lebih jaringan dan meneruskan paket data berdasarkan informasi alamat IP serta tabel routing.',
        ),
        _LessonSection(
          title: 'Fungsi router',
          bullets: [
            'Menghubungkan jaringan yang berbeda.',
            'Menentukan jalur pengiriman paket data.',
            'Menjadi penghubung antara jaringan lokal dan jaringan lain.',
            'Pada router tertentu, menyediakan layanan tambahan seperti DHCP, NAT, dan firewall.',
          ],
        ),
        _LessonSection(
          title: 'Router sebagai Default Gateway',
          body:
          'Dalam jaringan lokal, router sering berfungsi sebagai Default Gateway. Perangkat menggunakan alamat gateway ketika akan mengirim data menuju jaringan di luar jaringan lokalnya.',
        ),
        _LessonSection(
          title: 'Contoh konfigurasi sederhana',
          body:
          'Sebuah jaringan memiliki router dengan alamat 192.168.1.1. Komputer dalam jaringan tersebut dapat menggunakan alamat 192.168.1.10 dengan subnet mask 255.255.255.0 dan gateway 192.168.1.1.',
        ),
        _LessonSection(
          title: 'Router kabel dan wireless router',
          body:
          'Router kabel menghubungkan jaringan melalui antarmuka kabel. Wireless router umumnya menggabungkan fungsi router dengan Access Point sehingga perangkat dapat terhubung melalui kabel maupun Wi-Fi.',
        ),
      ],
      takeaway:
      'Router berperan menghubungkan jaringan yang berbeda dan membantu menentukan ke mana paket data harus diteruskan.',
    ),
    _LessonPage(
      number: 'MATERI 05',
      title: 'Modem',
      subtitle:
      'Memahami modem sebagai perangkat yang membantu menghubungkan jaringan pengguna dengan layanan komunikasi dari penyedia layanan.',
      icon: Icons.settings_input_antenna_rounded,
      visualTitle: 'Hubungan jaringan dengan penyedia layanan',
      visualItems: [
        _VisualItem(Icons.devices_rounded, 'Pengguna'),
        _VisualItem(Icons.settings_input_antenna_rounded, 'Modem'),
        _VisualItem(Icons.cloud_rounded, 'ISP'),
      ],
      sections: [
        _LessonSection(
          title: 'Pengertian modem',
          body:
          'Modem merupakan perangkat yang melakukan modulasi dan demodulasi sinyal agar data dapat dikirim melalui media komunikasi tertentu.',
        ),
        _LessonSection(
          title: 'Fungsi modem',
          body:
          'Modem membantu perangkat atau jaringan pengguna berkomunikasi melalui jaringan akses yang disediakan oleh penyedia layanan internet atau ISP.',
        ),
        _LessonSection(
          title: 'Jenis modem berdasarkan media',
          bullets: [
            'Modem DSL menggunakan jalur telepon.',
            'Modem kabel menggunakan jaringan kabel koaksial.',
            'Modem seluler menggunakan jaringan komunikasi seluler.',
            'Modem fiber atau ONT digunakan pada layanan berbasis serat optik untuk mengubah sinyal optik menjadi antarmuka yang dapat digunakan perangkat jaringan.',
          ],
        ),
        _LessonSection(
          title: 'Modem dan router',
          body:
          'Modem dan router memiliki fungsi yang berbeda. Modem menangani koneksi pada media akses, sedangkan router menghubungkan jaringan dan meneruskan paket data. Pada perangkat tertentu, fungsi modem dan router dapat digabung dalam satu perangkat.',
        ),
        _LessonSection(
          title: 'Contoh penggunaan',
          body:
          'Pada jaringan rumah, perangkat dari ISP dapat menerima koneksi internet dan menyediakan antarmuka Ethernet. Router kemudian digunakan untuk membagikan koneksi tersebut ke beberapa perangkat.',
        ),
      ],
      takeaway:
      'Modem membantu menyediakan koneksi melalui media komunikasi, sedangkan router mengatur komunikasi antarjaringan.',
    ),
    _LessonPage(
      number: 'MATERI 06',
      title: 'Access Point',
      subtitle:
      'Mengenal perangkat yang menyediakan akses jaringan nirkabel bagi laptop, smartphone, dan perangkat Wi-Fi lainnya.',
      icon: Icons.wifi_rounded,
      visualTitle: 'Koneksi perangkat melalui Wi-Fi',
      visualItems: [
        _VisualItem(Icons.laptop_rounded, 'Laptop'),
        _VisualItem(Icons.wifi_rounded, 'Access Point'),
        _VisualItem(Icons.phone_android_rounded, 'Smartphone'),
      ],
      sections: [
        _LessonSection(
          title: 'Pengertian Access Point',
          body:
          'Access Point (AP) adalah perangkat yang menyediakan akses jaringan nirkabel dan menghubungkan perangkat Wi-Fi ke jaringan lokal.',
        ),
        _LessonSection(
          title: 'Fungsi Access Point',
          bullets: [
            'Menyediakan koneksi Wi-Fi.',
            'Menghubungkan perangkat nirkabel ke jaringan lokal.',
            'Memperluas jangkauan akses nirkabel sesuai kemampuan perangkat dan kondisi lingkungan.',
            'Mengatur nama jaringan (SSID) dan keamanan Wi-Fi.',
          ],
        ),
        _LessonSection(
          title: 'SSID dan keamanan Wi-Fi',
          body:
          'SSID adalah nama jaringan nirkabel yang terlihat ketika pengguna mencari jaringan Wi-Fi. Keamanan jaringan dapat menggunakan mekanisme autentikasi dan enkripsi, misalnya WPA2 atau WPA3 sesuai dukungan perangkat.',
        ),
        _LessonSection(
          title: 'Access Point dan router wireless',
          body:
          'Access Point berfokus menyediakan akses nirkabel ke jaringan. Router wireless biasanya menggabungkan fungsi router dan Access Point dalam satu perangkat.',
        ),
        _LessonSection(
          title: 'Contoh penerapan di sekolah',
          body:
          'Access Point dapat dipasang di area sekolah agar siswa dan guru dapat terhubung ke jaringan melalui laptop atau smartphone. Penempatan AP perlu mempertimbangkan luas ruangan, penghalang, dan jumlah pengguna.',
        ),
      ],
      takeaway:
      'Access Point memungkinkan perangkat nirkabel terhubung ke jaringan lokal melalui Wi-Fi.',
    ),
    _LessonPage(
      number: 'MATERI 07',
      title: 'Repeater dan Bridge',
      subtitle:
      'Mengenal perangkat yang membantu memperluas jangkauan atau menghubungkan segmen jaringan.',
      icon: Icons.settings_ethernet_rounded,
      visualTitle: 'Peran perangkat penghubung',
      visualItems: [
        _VisualItem(Icons.wifi_tethering_rounded, 'Repeater'),
        _VisualItem(Icons.compare_arrows_rounded, 'Bridge'),
        _VisualItem(Icons.cable_rounded, 'Media'),
      ],
      sections: [
        _LessonSection(
          title: 'Pengertian Repeater',
          body:
          'Repeater adalah perangkat yang menerima dan membangun kembali sinyal agar dapat menjangkau jarak yang lebih jauh. Repeater digunakan ketika kualitas sinyal melemah karena jarak atau kondisi media.',
        ),
        _LessonSection(
          title: 'Fungsi Repeater',
          bullets: [
            'Membantu memperluas jangkauan sinyal.',
            'Menerima dan meneruskan kembali sinyal.',
            'Digunakan pada jaringan kabel maupun nirkabel sesuai jenis perangkatnya.',
          ],
        ),
        _LessonSection(
          title: 'Pengertian Bridge',
          body:
          'Bridge adalah perangkat yang menghubungkan segmen jaringan pada lapisan data link. Bridge dapat meneruskan atau menyaring frame berdasarkan alamat MAC.',
        ),
        _LessonSection(
          title: 'Perbedaan Repeater dan Bridge',
          bullets: [
            'Repeater berfokus membangun kembali sinyal.',
            'Bridge menghubungkan segmen jaringan dan dapat menyaring frame.',
            'Repeater tidak melakukan penyaringan frame berdasarkan alamat MAC seperti bridge.',
          ],
        ),
        _LessonSection(
          title: 'Contoh penerapan',
          body:
          'Repeater Wi-Fi dapat digunakan untuk membantu menjangkau area yang sinyalnya lemah. Bridge dapat digunakan untuk menghubungkan dua segmen jaringan sesuai kebutuhan desain jaringan.',
        ),
      ],
      takeaway:
      'Repeater membantu memperluas jangkauan sinyal, sedangkan bridge menghubungkan segmen jaringan pada lapisan data link.',
    ),
    _LessonPage(
      number: 'MATERI 08',
      title: 'Kabel dan Konektor Jaringan',
      subtitle:
      'Mengenal media fisik yang digunakan untuk menghubungkan perangkat jaringan dan membawa data.',
      icon: Icons.cable_rounded,
      visualTitle: 'Media transmisi jaringan',
      visualItems: [
        _VisualItem(Icons.cable_rounded, 'UTP'),
        _VisualItem(Icons.settings_ethernet_rounded, 'RJ45'),
        _VisualItem(Icons.waves_rounded, 'Fiber Optik'),
      ],
      sections: [
        _LessonSection(
          title: 'Kabel UTP',
          body:
          'Unshielded Twisted Pair (UTP) merupakan kabel jaringan yang terdiri dari pasangan kawat tembaga yang dipilin. Kabel ini banyak digunakan pada jaringan Ethernet.',
        ),
        _LessonSection(
          title: 'Konektor RJ45',
          body:
          'Konektor 8P8C yang umum disebut RJ45 digunakan untuk menghubungkan kabel Ethernet twisted pair ke perangkat jaringan seperti komputer dan switch.',
        ),
        _LessonSection(
          title: 'Kabel straight dan crossover',
          body:
          'Kabel straight menggunakan susunan standar yang sama pada kedua ujung kabel, sedangkan kabel crossover menggunakan susunan berbeda pada kedua ujungnya. Perangkat Ethernet modern umumnya mendukung Auto MDI-X sehingga kebutuhan kabel crossover lebih jarang ditemukan.',
        ),
        _LessonSection(
          title: 'Kabel fiber optik',
          body:
          'Fiber optik menggunakan cahaya untuk mengirimkan data melalui serat kaca atau plastik. Media ini banyak digunakan untuk koneksi berkecepatan tinggi dan jarak yang lebih jauh.',
        ),
        _LessonSection(
          title: 'Memilih media jaringan',
          bullets: [
            'Pertimbangkan jarak antarperangkat.',
            'Perhatikan kebutuhan kecepatan dan kapasitas jaringan.',
            'Sesuaikan jenis kabel dengan port perangkat.',
            'Perhatikan lingkungan pemasangan dan biaya.',
          ],
        ),
      ],
      takeaway:
      'Pemilihan kabel dan konektor harus disesuaikan dengan jenis perangkat, kebutuhan jaringan, dan kondisi pemasangan.',
    ),
    _LessonPage(
      number: 'MATERI 09',
      title: 'Studi Kasus Perangkat Jaringan',
      subtitle:
      'Menerapkan pemahaman tentang perangkat jaringan untuk menganalisis kebutuhan jaringan sederhana di laboratorium TKJ.',
      icon: Icons.psychology_rounded,
      visualTitle: 'Contoh jaringan laboratorium',
      visualItems: [
        _VisualItem(Icons.computer_rounded, 'Komputer'),
        _VisualItem(Icons.hub_rounded, 'Switch'),
        _VisualItem(Icons.router_rounded, 'Router'),
        _VisualItem(Icons.wifi_rounded, 'Access Point'),
      ],
      sections: [
        _LessonSection(
          title: 'Studi kasus: jaringan laboratorium TKJ',
          body:
          'Sebuah laboratorium memiliki 20 komputer yang perlu terhubung dalam satu jaringan lokal. Guru juga membutuhkan koneksi Wi-Fi untuk laptop dan smartphone. Jaringan tersebut perlu terhubung ke internet.',
        ),
        _LessonSection(
          title: 'Menentukan perangkat yang dibutuhkan',
          bullets: [
            'Switch untuk menghubungkan komputer melalui kabel jaringan.',
            'Router untuk menghubungkan jaringan lokal dengan jaringan lain.',
            'Access Point untuk menyediakan koneksi Wi-Fi.',
            'Kabel UTP dan konektor yang sesuai untuk koneksi Ethernet.',
            'Modem atau perangkat terminasi dari ISP sesuai jenis layanan internet yang digunakan.',
          ],
        ),
        _LessonSection(
          title: 'Memahami hubungan antarperangkat',
          body:
          'Komputer dapat dihubungkan ke switch menggunakan kabel UTP. Access Point juga dapat dihubungkan ke jaringan lokal melalui switch. Router menjadi penghubung jaringan lokal dengan jaringan lain, sedangkan koneksi dari ISP diterima melalui perangkat akses yang sesuai.',
        ),
        _LessonSection(
          title: 'Pertanyaan analisis',
          bullets: [
            'Mengapa laboratorium membutuhkan switch?',
            'Apa peran router dalam rancangan jaringan tersebut?',
            'Mengapa Access Point diperlukan?',
            'Apa yang perlu diperiksa jika satu komputer tidak dapat terhubung ke jaringan?',
          ],
        ),
        _LessonSection(
          title: 'Refleksi',
          body:
          'Bayangkan kamu diminta membantu guru menyiapkan jaringan laboratorium. Tuliskan perangkat yang akan digunakan, fungsi masing-masing perangkat, dan alasan pemilihannya.',
        ),
      ],
      takeaway:
      'Rancangan jaringan yang baik dimulai dengan memahami kebutuhan, memilih perangkat sesuai fungsi, dan menghubungkannya dengan susunan yang tepat.',
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
          'Perangkat Jaringan',
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
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildLessonContent(_LessonPage page, int index) {
    return SingleChildScrollView(
      key: PageStorageKey('perangkat-jaringan-page-$index'),
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
              'Kenali perangkat • Pahami fungsi • Terapkan sesuai kebutuhan',
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

  Widget _buildBottomNavigation() {
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
                  icon: const Icon(Icons.arrow_back_rounded, size: 17),
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
  final IconData icon;
  final String visualTitle;
  final List<_VisualItem> visualItems;
  final List<_LessonSection> sections;
  final String takeaway;

  const _LessonPage({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.icon,
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