import 'package:flutter/material.dart';

class PerangkatMateriScreen extends StatelessWidget {
  final int index;

  const PerangkatMateriScreen({super.key, required this.index});

  static const Color primary = Color(0xFFEF6C00);
  static const Color dark = Color(0xFF7A3A00);
  static const Color light = Color(0xFFFFF3E8);
  static const Color textDark = Color(0xFF263238);
  static const Color textGrey = Color(0xFF607D8B);
  static const Color border = Color(0xFFE4E9ED);

  static const List<String> titles = [
    'Pengenalan Perangkat Jaringan',
    'NIC / Network Interface Card',
    'Hub dan Switch',
    'Router dan Gateway',
    'Modem dan Access Point',
    'Repeater, Bridge, dan Extender',
    'Firewall dan Perangkat Keamanan',
    'Memilih Perangkat Jaringan',
  ];

  static const List<String> subtitles = [
    'Mengenal fungsi dan peran perangkat dalam sebuah jaringan komputer.',
    'Memahami kartu antarmuka yang menghubungkan perangkat ke jaringan.',
    'Membedakan cara kerja hub dan switch dalam meneruskan data.',
    'Memahami cara router menghubungkan jaringan yang berbeda.',
    'Mengenal modem dan access point pada koneksi jaringan modern.',
    'Mempelajari perangkat yang membantu memperluas atau menjembatani jaringan.',
    'Mengenal fungsi firewall untuk mengontrol dan melindungi lalu lintas jaringan.',
    'Menentukan perangkat yang sesuai berdasarkan kebutuhan jaringan.',
  ];

  static const List<IconData> icons = [
    Icons.devices_other_rounded,
    Icons.network_check_rounded,
    Icons.hub_rounded,
    Icons.router_rounded,
    Icons.wifi_rounded,
    Icons.settings_ethernet_rounded,
    Icons.security_rounded,
    Icons.fact_check_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final current = index.clamp(0, titles.length - 1);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: textDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Perangkat Jaringan',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: light,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${current + 1} / ${titles.length}',
              style: const TextStyle(
                color: primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(
            height: 3,
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: (current + 1) / titles.length,
              child: Container(color: primary),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: _buildPage(context, current),
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, int current) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(current),
        const SizedBox(height: 26),
        _diagram(current),
        const SizedBox(height: 28),
        ..._sections(current),
        const SizedBox(height: 22),
        _keyPoint(current),
        const SizedBox(height: 32),
        _navigation(context, current),
      ],
    );
  }

  Widget _header(int current) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(6)),
          child: Text(
            'MATERI ${_twoDigits(current + 1)}',
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          _titleWithBreak(current),
          style: const TextStyle(color: dark, fontSize: 29, fontWeight: FontWeight.w800, height: 1.12, letterSpacing: -0.5),
        ),
        const SizedBox(height: 12),
        Text(
          subtitles[current],
          style: const TextStyle(color: textGrey, fontSize: 15, height: 1.55),
        ),
      ],
    );
  }

  String _titleWithBreak(int current) {
    const values = [
      'Pengenalan Perangkat\nJaringan',
      'NIC / Network\nInterface Card',
      'Hub dan Switch',
      'Router dan\nGateway',
      'Modem dan\nAccess Point',
      'Repeater, Bridge,\ndan Extender',
      'Firewall dan\nKeamanan Jaringan',
      'Memilih Perangkat\nJaringan',
    ];
    return values[current];
  }

  Widget _diagram(int current) {
    switch (current) {
      case 0:
        return _deviceFlow();
      case 1:
        return _nicDiagram();
      case 2:
        return _switchDiagram();
      case 3:
        return _routerDiagram();
      case 4:
        return _wifiDiagram();
      case 5:
        return _extendDiagram();
      case 6:
        return _firewallDiagram();
      default:
        return _selectionDiagram();
    }
  }

  Widget _diagramCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: textDark, fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 22),
          child,
        ],
      ),
    );
  }

  Widget _deviceBox(String label, IconData icon, {bool darkFill = false}) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 58,
          decoration: BoxDecoration(
            color: darkFill ? dark : light,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: darkFill ? dark : const Color(0xFFFFCC9A)),
          ),
          child: Icon(icon, color: darkFill ? Colors.white : primary, size: 28),
        ),
        const SizedBox(height: 7),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(color: textDark, fontSize: 10.5, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _arrow({bool vertical = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: vertical ? 0 : 8, vertical: vertical ? 6 : 0),
      child: Icon(vertical ? Icons.arrow_downward_rounded : Icons.arrow_forward_rounded, color: primary, size: 21),
    );
  }

  Widget _deviceFlow() {
    return _diagramCard(
      title: 'Contoh alur perangkat jaringan',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _deviceBox('PC', Icons.computer_rounded),
          _arrow(),
          _deviceBox('Switch', Icons.hub_rounded, darkFill: true),
          _arrow(),
          _deviceBox('Router', Icons.router_rounded),
        ],
      ),
    );
  }

  Widget _nicDiagram() {
    return _diagramCard(
      title: 'Posisi NIC pada perangkat',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _deviceBox('Komputer', Icons.laptop_rounded),
          _arrow(),
          _deviceBox('NIC', Icons.dns_rounded, darkFill: true),
          _arrow(),
          _deviceBox('Jaringan', Icons.account_tree_rounded),
        ],
      ),
    );
  }

  Widget _switchDiagram() {
    return _diagramCard(
      title: 'Switch meneruskan data ke tujuan',
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _deviceBox('PC 1', Icons.computer_rounded),
            _deviceBox('PC 2', Icons.computer_rounded),
            _deviceBox('PC 3', Icons.computer_rounded),
          ]),
          _arrow(vertical: true),
          _deviceBox('SWITCH', Icons.hub_rounded, darkFill: true),
        ],
      ),
    );
  }

  Widget _routerDiagram() {
    return _diagramCard(
      title: 'Router menghubungkan jaringan yang berbeda',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _deviceBox('LAN', Icons.lan_rounded),
          _arrow(),
          _deviceBox('ROUTER', Icons.router_rounded, darkFill: true),
          _arrow(),
          _deviceBox('Internet', Icons.public_rounded),
        ],
      ),
    );
  }

  Widget _wifiDiagram() {
    return _diagramCard(
      title: 'Koneksi nirkabel dengan access point',
      child: Column(
        children: [
          _deviceBox('Access Point', Icons.wifi_tethering_rounded, darkFill: true),
          _arrow(vertical: true),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _deviceBox('Laptop', Icons.laptop_rounded),
            _deviceBox('HP', Icons.smartphone_rounded),
            _deviceBox('Tablet', Icons.tablet_rounded),
          ]),
        ],
      ),
    );
  }

  Widget _extendDiagram() {
    return _diagramCard(
      title: 'Contoh perluasan jangkauan jaringan',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _deviceBox('Sinyal Awal', Icons.wifi_rounded),
          _arrow(),
          _deviceBox('Repeater', Icons.sync_alt_rounded, darkFill: true),
          _arrow(),
          _deviceBox('Area Lebih Luas', Icons.wifi_find_rounded),
        ],
      ),
    );
  }

  Widget _firewallDiagram() {
    return _diagramCard(
      title: 'Firewall menyaring lalu lintas jaringan',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _deviceBox('Internet', Icons.public_rounded),
          _arrow(),
          _deviceBox('Firewall', Icons.shield_rounded, darkFill: true),
          _arrow(),
          _deviceBox('LAN', Icons.lan_rounded),
        ],
      ),
    );
  }

  Widget _selectionDiagram() {
    return _diagramCard(
      title: 'Kebutuhan menentukan perangkat yang digunakan',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _deviceBox('LAN', Icons.hub_rounded),
          _deviceBox('Antarjaringan', Icons.router_rounded),
          _deviceBox('Wi-Fi', Icons.wifi_rounded),
          _deviceBox('Keamanan', Icons.security_rounded),
        ],
      ),
    );
  }

  List<Widget> _sections(int current) {
    switch (current) {
      case 0:
        return [
          _section('01', 'Apa Itu Perangkat Jaringan?', 'Perangkat jaringan adalah hardware yang digunakan untuk menghubungkan, mengatur, meneruskan, atau mengamankan komunikasi antarperangkat dalam jaringan komputer.'),
          _info('Setiap perangkat memiliki fungsi berbeda. Pada jaringan sederhana, sebuah komputer dapat terhubung ke switch, kemudian router menghubungkan jaringan lokal dengan jaringan lain atau internet.'),
          _section('02', 'Peran Utama', ''),
          _point(Icons.link_rounded, 'Menghubungkan', 'Menyediakan jalur komunikasi antarperangkat.'),
          _point(Icons.alt_route_rounded, 'Meneruskan data', 'Mengatur ke mana paket data harus dikirim.'),
          _point(Icons.tune_rounded, 'Mengelola jaringan', 'Membantu konfigurasi, pembagian koneksi, dan akses pengguna.'),
        ];
      case 1:
        return [
          _section('01', 'Apa Itu NIC?', 'NIC atau Network Interface Card adalah antarmuka yang memungkinkan komputer atau perangkat lain terhubung ke jaringan. NIC dapat menggunakan koneksi kabel Ethernet maupun koneksi nirkabel.'),
          _point(Icons.settings_ethernet_rounded, 'NIC Ethernet', 'Menggunakan port RJ45 dan kabel jaringan untuk koneksi kabel.'),
          _point(Icons.wifi_rounded, 'NIC Wireless', 'Menggunakan gelombang radio untuk terhubung ke jaringan Wi-Fi.'),
          _section('02', 'Fungsi NIC', ''),
          _point(Icons.perm_data_setting_rounded, 'Alamat jaringan', 'NIC memiliki identitas MAC Address yang digunakan pada komunikasi jaringan tingkat data link.'),
          _point(Icons.swap_horiz_rounded, 'Kirim dan terima data', 'NIC mengubah data menjadi sinyal yang dapat dikirim melalui media jaringan.'),
        ];
      case 2:
        return [
          _section('01', 'Hub', 'Hub adalah perangkat yang meneruskan data yang diterima ke seluruh port. Hub bekerja secara sederhana sehingga setiap perangkat pada segmen dapat menerima trafik yang sama.'),
          _section('02', 'Switch', 'Switch meneruskan frame ke port tujuan berdasarkan informasi alamat MAC. Karena pengiriman lebih terarah, switch umumnya lebih efisien untuk jaringan lokal modern.'),
          _point(Icons.hub_rounded, 'Hub', 'Meneruskan ke semua port dan tidak mempelajari tabel MAC seperti switch.'),
          _point(Icons.switch_access_shortcut_rounded, 'Switch', 'Memilih port tujuan sesuai tabel MAC yang dipelajari.'),
          _info('Catatan belajar: di jaringan sekolah atau kantor saat ini, switch lebih sering digunakan sebagai penghubung perangkat dalam LAN dibandingkan hub.'),
        ];
      case 3:
        return [
          _section('01', 'Router', 'Router adalah perangkat yang menghubungkan dua atau lebih jaringan yang berbeda dan menentukan jalur pengiriman paket berdasarkan informasi alamat jaringan.'),
          _point(Icons.alt_route_rounded, 'Routing', 'Menentukan rute terbaik atau rute yang tersedia untuk mencapai jaringan tujuan.'),
          _point(Icons.public_rounded, 'Akses internet', 'Pada jaringan rumah, router sering menjadi penghubung antara LAN dan internet.'),
          _section('02', 'Gateway', 'Gateway adalah titik keluar atau masuk dari sebuah jaringan menuju jaringan lain. Dalam jaringan IP, router dapat berfungsi sebagai default gateway bagi host.'),
          _info('Contoh: komputer dengan alamat 192.168.1.x biasanya mengirim trafik menuju jaringan lain melalui alamat default gateway pada jaringan tersebut.'),
        ];
      case 4:
        return [
          _section('01', 'Modem', 'Modem merupakan perangkat yang mengubah atau mengelola sinyal komunikasi agar koneksi data dapat berlangsung melalui media akses tertentu dari penyedia layanan.'),
          _section('02', 'Access Point', 'Access point menyediakan akses jaringan nirkabel sehingga perangkat seperti laptop dan smartphone dapat terhubung ke jaringan menggunakan Wi-Fi.'),
          _point(Icons.settings_input_antenna_rounded, 'Modem', 'Berkaitan dengan koneksi dari jaringan pelanggan ke layanan akses penyedia.'),
          _point(Icons.wifi_rounded, 'Access Point', 'Membuat area layanan Wi-Fi dan menghubungkan klien wireless ke jaringan lokal.'),
          _info('Pada perangkat rumahan modern, fungsi modem/ONT, router, switch, dan access point dapat digabung dalam satu unit perangkat.'),
        ];
      case 5:
        return [
          _section('01', 'Repeater', 'Repeater menerima dan mengirim ulang sinyal untuk membantu memperluas jangkauan komunikasi jaringan. Dalam Wi-Fi, perangkat sejenis sering disebut range extender.'),
          _section('02', 'Bridge', 'Bridge menghubungkan dua segmen jaringan pada lapisan data link dan dapat membantu memisahkan atau menyatukan segmen berdasarkan kebutuhan desain jaringan.'),
          _section('03', 'Extender', 'Extender digunakan untuk memperluas jangkauan jaringan, terutama jaringan nirkabel, ketika area layanan dari perangkat utama belum mencukupi.'),
          _info('Perluasan jangkauan tidak selalu berarti menambah bandwidth. Penempatan perangkat, kualitas sinyal, interferensi, dan media transmisi tetap memengaruhi performa.'),
        ];
      case 6:
        return [
          _section('01', 'Apa Itu Firewall?', 'Firewall adalah mekanisme keamanan yang memantau dan mengendalikan lalu lintas jaringan berdasarkan aturan yang telah ditentukan.'),
          _point(Icons.rule_rounded, 'Menyaring trafik', 'Aturan firewall dapat mengizinkan atau menolak koneksi tertentu.'),
          _point(Icons.visibility_rounded, 'Mengawasi akses', 'Membantu administrator mengontrol layanan dan arah komunikasi jaringan.'),
          _point(Icons.shield_rounded, 'Mengurangi risiko', 'Dapat membantu membatasi akses yang tidak diinginkan sesuai kebijakan keamanan.'),
          _section('02', 'Contoh Perangkat Keamanan', ''),
          _point(Icons.security_rounded, 'Firewall appliance', 'Perangkat khusus yang menangani fungsi keamanan jaringan.'),
          _point(Icons.lock_rounded, 'Gateway security', 'Perangkat atau layanan gateway dapat menggabungkan fungsi keamanan dan kontrol akses.'),
        ];
      default:
        return [
          _section('01', 'Pertanyaan Dasar Sebelum Memilih', 'Pilih perangkat berdasarkan kebutuhan jumlah pengguna, luas area, jenis koneksi, kecepatan, jumlah port, dan kebutuhan keamanan.'),
          _point(Icons.people_alt_rounded, 'Berapa banyak perangkat?', 'Jumlah klien menentukan kebutuhan kapasitas dan jumlah port.'),
          _point(Icons.square_foot_rounded, 'Seberapa luas area?', 'Area dan hambatan fisik memengaruhi kebutuhan access point atau extender.'),
          _point(Icons.speed_rounded, 'Berapa kapasitas yang dibutuhkan?', 'Perhatikan kecepatan port, kemampuan wireless, dan kapasitas pemrosesan perangkat.'),
          _section('02', 'Contoh Sederhana', ''),
          _comparison('Kebutuhan', 'Perangkat umum', [
            ['LAN beberapa PC', 'Switch'],
            ['Menghubungkan LAN ke internet', 'Router'],
            ['Akses Wi-Fi', 'Access Point'],
            ['Memperluas jangkauan', 'Repeater / Extender'],
            ['Menyaring trafik', 'Firewall'],
          ]),
          _info('Tidak semua perangkat harus berdiri sendiri. Banyak perangkat jaringan modern menggabungkan beberapa fungsi dalam satu perangkat.'),
        ];
    }
  }

  Widget _section(String number, String title, String paragraph) {
    final children = <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(number, style: const TextStyle(color: primary, fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: const TextStyle(color: textDark, fontSize: 19, fontWeight: FontWeight.w800, height: 1.25))),
        ],
      ),
    ];
    if (paragraph.isNotEmpty) {
      children.add(const SizedBox(height: 12));
      children.add(Text(paragraph, style: const TextStyle(color: Color(0xFF455A64), fontSize: 14, height: 1.7)));
    }
    children.add(const SizedBox(height: 24));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }

  Widget _point(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: light, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: textDark, fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(description, style: const TextStyle(color: textGrey, fontSize: 12.5, height: 1.5)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _info(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: light,
        border: const Border(left: BorderSide(color: primary, width: 4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline_rounded, color: primary, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(color: dark, fontSize: 13, height: 1.55, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _comparison(String left, String right, List<List<String>> rows) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: border), borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: const BoxDecoration(color: light, borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
          child: Row(children: [
            Expanded(child: Text(left, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: dark))),
            Expanded(child: Text(right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: dark))),
          ]),
        ),
        ...rows.map((row) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: border))),
          child: Row(children: [
            Expanded(child: Text(row[0], style: const TextStyle(fontSize: 11.5, color: textGrey, height: 1.35))),
            Expanded(child: Text(row[1], style: const TextStyle(fontSize: 11.5, color: textDark, fontWeight: FontWeight.w700, height: 1.35))),
          ]),
        )),
      ]),
    );
  }

  Widget _keyPoint(int current) {
    const points = [
      'Kenali fungsi setiap perangkat sebelum menyusun jaringan. Perangkat yang berbeda memiliki tugas yang berbeda.',
      'NIC adalah antarmuka perangkat untuk berkomunikasi pada jaringan, baik melalui kabel maupun wireless.',
      'Switch meneruskan data berdasarkan alamat MAC, sedangkan hub bekerja dengan meneruskan trafik ke banyak port.',
      'Router menghubungkan jaringan yang berbeda dan menjadi jalur menuju jaringan lain melalui proses routing.',
      'Access point menyediakan akses Wi-Fi, sedangkan modem berkaitan dengan koneksi akses dari penyedia layanan.',
      'Repeater dan extender membantu memperluas jangkauan, tetapi kualitas sinyal dan penempatan perangkat tetap penting.',
      'Firewall menerapkan aturan untuk mengontrol lalu lintas dan membantu membatasi akses yang tidak diinginkan.',
      'Perangkat jaringan harus dipilih berdasarkan kebutuhan, kapasitas, area, media, dan keamanan.',
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: dark, borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('POIN PENTING', style: TextStyle(color: Color(0xFFFFCC80), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)),
        const SizedBox(height: 9),
        Text(points[current], style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.55, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _navigation(BuildContext context, int current) {
    final isFirst = current == 0;
    final isLast = current == titles.length - 1;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isFirst ? null : () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PerangkatMateriScreen(index: current - 1)));
            },
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            label: const Text('Sebelumnya'),
            style: OutlinedButton.styleFrom(
              foregroundColor: textGrey,
              minimumSize: const Size(0, 48),
              side: const BorderSide(color: border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              if (isLast) {
                Navigator.pop(context);
                return;
              }
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PerangkatMateriScreen(index: current + 1)));
            },
            icon: Icon(isLast ? Icons.check_rounded : Icons.arrow_forward_rounded, size: 18),
            label: Text(isLast ? 'Selesai' : 'Berikutnya'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 48),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');
}
