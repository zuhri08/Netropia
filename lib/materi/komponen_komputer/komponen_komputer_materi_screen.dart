import 'package:flutter/material.dart';

class KomponenKomputerMateriScreen extends StatelessWidget {
  final int index;
  const KomponenKomputerMateriScreen({super.key, required this.index});

  static const Color primary = Color(0xFF6A1B9A);
  static const Color dark = Color(0xFF4A148C);
  static const Color light = Color(0xFFF3E5F5);
  static const Color textDark = Color(0xFF263238);
  static const Color textGrey = Color(0xFF607D8B);
  static const Color border = Color(0xFFDCE3EA);
  static const Color soft = Color(0xFFF1F5F8);

  static const List<String> titles = [
    'Pengenalan Komponen Komputer',
    'CPU / Processor',
    'Motherboard',
    'RAM dan Penyimpanan',
    'Power Supply dan Casing',
    'GPU dan Grafis',
    'Input, Output, dan Port',
    'Pendinginan dan Perawatan',
  ];

  static const List<String> subtitles = [
    'Mengenal kelompok komponen utama yang bekerja bersama membentuk sebuah sistem komputer.',
    'Memahami fungsi CPU sebagai pusat pengolah instruksi dan data.',
    'Mengenal papan utama yang menghubungkan processor, memori, penyimpanan, dan perangkat lain.',
    'Membedakan memori sementara dengan media penyimpanan data jangka panjang.',
    'Memahami fungsi PSU dan casing untuk catu daya, perlindungan, dan pengelolaan komponen.',
    'Mengenal GPU dan perannya dalam pengolahan grafis, visual, dan beban komputasi tertentu.',
    'Membedakan perangkat input, output, serta port yang digunakan untuk koneksi.',
    'Menjaga suhu komponen dan melakukan perawatan agar komputer tetap stabil dan awet.',
  ];

  int get current => index.clamp(0, titles.length - 1);

  @override
  Widget build(BuildContext context) {
    final c = current;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: textDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: const Text('Komponen Komputer', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: light, borderRadius: BorderRadius.circular(8)),
            child: Text('${c + 1} / ${titles.length}', style: const TextStyle(color: primary, fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(height: 3, alignment: Alignment.centerLeft, child: FractionallySizedBox(widthFactor: (c + 1) / titles.length, child: Container(color: primary))),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _header(c),
            const SizedBox(height: 26),
            _visual(c),
            const SizedBox(height: 28),
            ..._sections(c),
            const SizedBox(height: 22),
            _keyPoint(c),
            const SizedBox(height: 32),
            _navigation(context, c),
          ]),
        ),
      ),
    );
  }

  Widget _header(int c) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _materialBadge(c + 1),
        const SizedBox(height: 14),
        Text(_titleWithBreak(c), style: const TextStyle(color: dark, fontSize: 29, fontWeight: FontWeight.w800, height: 1.12, letterSpacing: -.5)),
        const SizedBox(height: 12),
        Text(subtitles[c], style: const TextStyle(color: textGrey, fontSize: 15, height: 1.55)),
      ]);

  Widget _materialBadge(int number) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(6)),
        child: Text('MATERI ${_two(number)}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: .5)),
      );

  String _titleWithBreak(int c) => const [
        'Pengenalan Komponen\nKomputer',
        'CPU dan\nProcessor',
        'Motherboard dan\nKonektor',
        'RAM dan\nStorage',
        'PSU dan\nCasing',
        'GPU /\nKartu Grafis',
        'Input, Output,\ndan Port',
        'Pendinginan dan\nPerawatan',
      ][c];

  Widget _visual(int c) {
    switch (c) {
      case 0: return _diagramCard('Hubungan Komponen', _overview(), Icons.computer_rounded);
      case 1: return _diagramCard('Alur Kerja CPU', _cpu(), Icons.memory_rounded);
      case 2: return _diagramCard('Motherboard Sebagai Penghubung', _motherboard(), Icons.developer_board_rounded);
      case 3: return _diagramCard('RAM vs Storage', _memory(), Icons.sd_storage_rounded);
      case 4: return _diagramCard('Alur Daya', _power(), Icons.power_rounded);
      case 5: return _diagramCard('Peran GPU', _gpu(), Icons.graphic_eq_rounded);
      case 6: return _diagramCard('Input → Proses → Output', _io(), Icons.swap_horiz_rounded);
      default: return _diagramCard('Perawatan Sistem', _cooling(), Icons.ac_unit_rounded);
    }
  }

  Widget _diagramCard(String title, Widget child, IconData icon) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: border), borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(color: light, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: primary, size: 19)),
            const SizedBox(width: 10),
            Expanded(child: Text(title, style: const TextStyle(color: textDark, fontSize: 13, fontWeight: FontWeight.w700))),
          ]),
          const SizedBox(height: 20),
          child,
        ]),
      );

  Widget _node(String t, IconData i, {bool main = false}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(color: main ? primary : light, borderRadius: BorderRadius.circular(10), border: Border.all(color: main ? primary : const Color(0xFFD7BCE2))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(i, color: main ? Colors.white : primary, size: 19), const SizedBox(width: 8), Text(t, style: TextStyle(color: main ? Colors.white : dark, fontSize: 11, fontWeight: FontWeight.w800))]),
      );

  Widget _flow3(Widget left, Widget middle, Widget right) => LayoutBuilder(builder: (context, constraints) {
    if (constraints.maxWidth < 410) {
      return Column(children: [left, const Padding(padding: EdgeInsets.symmetric(vertical: 7), child: Icon(Icons.arrow_downward_rounded, color: primary, size: 21)), middle, const Padding(padding: EdgeInsets.symmetric(vertical: 7), child: Icon(Icons.arrow_downward_rounded, color: primary, size: 21)), right]);
    }
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [left, const Icon(Icons.arrow_forward_rounded, color: primary, size: 21), middle, const Icon(Icons.arrow_forward_rounded, color: primary, size: 21), right]);
  });

  Widget _overview() => Column(children: [
        _node('CPU / Processor', Icons.memory_rounded, main: true),
        const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Icon(Icons.arrow_downward_rounded, color: primary, size: 21)),
        Wrap(alignment: WrapAlignment.center, spacing: 8, runSpacing: 8, children: [_node('RAM', Icons.sd_storage_rounded), _node('Motherboard', Icons.developer_board_rounded), _node('Storage', Icons.storage_rounded), _node('GPU', Icons.graphic_eq_rounded), _node('PSU', Icons.power_rounded)]),
      ]);

  Widget _cpu() => _flow3(_node('Instruksi', Icons.menu_book_outlined), _node('CPU', Icons.memory_rounded, main: true), _node('Hasil', Icons.check_circle_outline_rounded));

  Widget _motherboard() => Column(children: [
        _node('Motherboard', Icons.developer_board_rounded, main: true),
        const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Icon(Icons.arrow_downward_rounded, color: primary, size: 21)),
        Wrap(alignment: WrapAlignment.center, spacing: 8, runSpacing: 8, children: [_node('CPU', Icons.memory_rounded), _node('RAM', Icons.sd_storage_rounded), _node('Storage', Icons.storage_rounded), _node('GPU / PCIe', Icons.graphic_eq_rounded), _node('Port I/O', Icons.usb_rounded)]),
      ]);

  Widget _memory() => Row(children: [
        Expanded(child: _memoryCard(Icons.memory_rounded, 'RAM', 'Sementara', 'Data kerja yang sedang digunakan program dan CPU.')),
        const SizedBox(width: 10),
        Expanded(child: _memoryCard(Icons.storage_rounded, 'Storage', 'Jangka panjang', 'Menyimpan sistem operasi, aplikasi, dan file.')),
      ]);

  Widget _memoryCard(IconData icon, String title, String badge, String desc) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: soft, border: Border.all(color: border), borderRadius: BorderRadius.circular(10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 34, height: 34, decoration: BoxDecoration(color: light, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: primary, size: 18)),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: dark, fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(badge, style: const TextStyle(color: primary, fontSize: 10, fontWeight: FontWeight.w700)),
          const SizedBox(height: 7),
          Text(desc, style: const TextStyle(color: textGrey, fontSize: 10.5, height: 1.4)),
        ]),
      );

  Widget _power() => _flow3(_node('Listrik AC', Icons.electrical_services_rounded), _node('PSU', Icons.power_rounded, main: true), _node('Komponen', Icons.computer_rounded));

  Widget _gpu() => Column(children: [
        _node('GPU / Kartu Grafis', Icons.graphic_eq_rounded, main: true),
        const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Icon(Icons.arrow_downward_rounded, color: primary, size: 21)),
        Wrap(alignment: WrapAlignment.center, spacing: 8, runSpacing: 8, children: [_node('Monitor', Icons.monitor_rounded), _node('Game / 3D', Icons.videogame_asset_outlined), _node('Video', Icons.movie_outlined)]),
      ]);

  Widget _io() => _flow3(_node('Input', Icons.keyboard_rounded), _node('Proses', Icons.memory_rounded, main: true), _node('Output', Icons.monitor_rounded));

  Widget _cooling() => Column(children: [
        _care(Icons.air_rounded, 'Airflow', 'Pastikan jalur masuk dan keluar udara tidak tertutup.'),
        _care(Icons.toys_rounded, 'Kipas', 'Bersihkan debu dan periksa kipas berputar normal.'),
        _care(Icons.thermostat_rounded, 'Suhu', 'Perhatikan tanda panas berlebih atau penurunan performa.'),
        _care(Icons.cleaning_services_rounded, 'Kebersihan', 'Bersihkan area kerja dan bagian dalam komputer secara berkala.'),
      ]);

  Widget _care(IconData icon, String title, String desc) => Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(color: soft, border: Border.all(color: border), borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: light, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: primary, size: 19)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: dark, fontSize: 11.5, fontWeight: FontWeight.w800)), const SizedBox(height: 3), Text(desc, style: const TextStyle(color: textGrey, fontSize: 10.5, height: 1.4))])),
        ]),
      );

  List<Widget> _sections(int c) {
    const data = <List<Map<String, String>>>[
      [
        {'t': 'Komponen utama', 'd': 'Komputer terdiri dari komponen pemrosesan, memori, penyimpanan, catu daya, perangkat input-output, dan komponen pendukung lainnya.'},
        {'t': 'Saling bergantung', 'd': 'Kinerja sistem tidak hanya ditentukan oleh satu komponen. CPU, RAM, storage, motherboard, PSU, dan perangkat lain bekerja sebagai satu sistem.'},
        {'t': 'Perbedaan fungsi', 'd': 'Setiap komponen memiliki tugas berbeda sehingga identifikasi komponen menjadi dasar penting saat merakit dan melakukan perawatan komputer.'},
      ],
      [
        {'t': 'Fungsi CPU', 'd': 'CPU menjalankan instruksi program dan melakukan operasi logika maupun aritmetika yang dibutuhkan sistem.'},
        {'t': 'Clock dan core', 'd': 'Kecepatan clock dan jumlah core merupakan beberapa karakteristik CPU, tetapi performa nyata juga dipengaruhi arsitektur dan beban kerja.'},
        {'t': 'Perawatan', 'd': 'Pastikan pendinginan baik dan hindari kondisi suhu yang terlalu tinggi.'},
      ],
      [
        {'t': 'Pusat koneksi', 'd': 'Motherboard menyediakan jalur dan konektor untuk menghubungkan processor, RAM, storage, kartu ekspansi, serta perangkat I/O.'},
        {'t': 'Slot dan port', 'd': 'Contohnya slot RAM, PCIe, konektor storage, USB header, serta konektor daya.'},
        {'t': 'Kompatibilitas', 'd': 'Saat memilih komponen, periksa socket CPU, tipe RAM, slot ekspansi, form factor, dan konektor daya.'},
      ],
      [
        {'t': 'RAM', 'd': 'RAM digunakan menyimpan data dan instruksi yang sedang aktif sehingga dapat diakses dengan cepat oleh sistem.'},
        {'t': 'Storage', 'd': 'HDD dan SSD menyimpan data secara lebih permanen dibanding RAM.'},
        {'t': 'Contoh penggunaan', 'd': 'RAM membantu multitasking, sedangkan storage menyimpan sistem operasi, aplikasi, dan file pengguna.'},
      ],
      [
        {'t': 'PSU', 'd': 'Power Supply Unit mengubah dan menyediakan daya yang dibutuhkan berbagai komponen komputer.'},
        {'t': 'Casing', 'd': 'Casing melindungi komponen, mengatur tata letak, dan membantu aliran udara.'},
        {'t': 'Keseimbangan sistem', 'd': 'PSU harus sesuai kebutuhan sistem dan memiliki konektor yang dibutuhkan oleh komponen.'},
      ],
      [
        {'t': 'Pengolah grafis', 'd': 'GPU menangani pengolahan grafis sehingga membantu rendering tampilan, video, 3D, dan beban kerja komputasi tertentu.'},
        {'t': 'Terintegrasi vs diskrit', 'd': 'GPU dapat terintegrasi dengan CPU atau chipset, atau menggunakan kartu grafis terpisah dengan memori khusus.'},
        {'t': 'Kebutuhan', 'd': 'Pemilihan GPU sebaiknya mengikuti kebutuhan, resolusi, aplikasi, dan batas daya serta pendinginan sistem.'},
      ],
      [
        {'t': 'Input', 'd': 'Keyboard, mouse, scanner, dan mikrofon menerima data atau perintah dari pengguna.'},
        {'t': 'Output', 'd': 'Monitor, printer, dan speaker menyajikan hasil pemrosesan kepada pengguna.'},
        {'t': 'Port', 'd': 'USB, HDMI, DisplayPort, audio, dan Ethernet adalah contoh antarmuka koneksi yang sering dijumpai.'},
      ],
      [
        {'t': 'Debu dan airflow', 'd': 'Debu yang menumpuk dapat menghambat aliran udara dan mengurangi efisiensi pendinginan.'},
        {'t': 'Pasta termal', 'd': 'Pada sistem tertentu, pasta termal membantu perpindahan panas dari chip ke heatsink dan dapat perlu diperbarui saat perawatan.'},
        {'t': 'Perawatan berkala', 'd': 'Matikan dan lepaskan sumber daya sebelum membersihkan bagian internal, lalu pasang kembali komponen dengan benar.'},
      ],
    ];

    const icons = [Icons.computer_rounded, Icons.memory_rounded, Icons.developer_board_rounded, Icons.sd_storage_rounded, Icons.power_rounded, Icons.graphic_eq_rounded, Icons.usb_rounded, Icons.ac_unit_rounded];
    return data[c].asMap().entries.map((entry) => _section(_two(entry.key + 1), entry.value['t']!, entry.value['d']!, icons[c])).toList();
  }

  Widget _section(String number, String title, String desc, IconData icon) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(number, style: const TextStyle(color: primary, fontSize: 13, fontWeight: FontWeight.w800)),
            const SizedBox(width: 10),
            Container(width: 32, height: 32, decoration: BoxDecoration(color: light, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: primary, size: 17)),
            const SizedBox(width: 10),
            Expanded(child: Text(title, style: const TextStyle(color: textDark, fontSize: 19, fontWeight: FontWeight.w800, height: 1.25))),
          ]),
          const SizedBox(height: 12),
          Text(desc, style: const TextStyle(color: Color(0xFF455A64), fontSize: 14, height: 1.7)),
        ]),
      );

  Widget _keyPoint(int c) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: dark, borderRadius: BorderRadius.circular(10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.push_pin_rounded, color: Color(0xFFCE93D8), size: 17), SizedBox(width: 7), Text('POIN PENTING', style: TextStyle(color: Color(0xFFCE93D8), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1))]),
          const SizedBox(height: 9),
          Text(_keyTexts[c], style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.55, fontWeight: FontWeight.w600)),
        ]),
      );

  static const List<String> _keyTexts = [
    'Komponen komputer memiliki fungsi berbeda tetapi bekerja sebagai satu sistem.',
    'CPU memproses instruksi dan data yang dijalankan oleh sistem.',
    'Motherboard menjadi pusat koneksi antar-komponen utama.',
    'RAM digunakan untuk kerja sementara, sedangkan storage menyimpan data lebih permanen.',
    'PSU menyuplai daya dan casing membantu perlindungan serta pengaturan airflow.',
    'GPU memproses grafis dan dapat berupa grafis terintegrasi maupun kartu terpisah.',
    'Perangkat input memberi data, komponen memproses, dan output menampilkan hasil.',
    'Pendinginan, kebersihan, dan perawatan berkala membantu menjaga kestabilan komputer.',
  ];

  Widget _navigation(BuildContext context, int c) => Row(children: [
        Expanded(child: OutlinedButton.icon(onPressed: c == 0 ? null : () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => KomponenKomputerMateriScreen(index: c - 1))), icon: const Icon(Icons.arrow_back_rounded, size: 18), label: const Text('Sebelumnya'), style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48), foregroundColor: textGrey, side: const BorderSide(color: border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))))),
        const SizedBox(width: 12),
        Expanded(child: ElevatedButton.icon(onPressed: c == titles.length - 1 ? () => Navigator.pop(context) : () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => KomponenKomputerMateriScreen(index: c + 1))), icon: const Icon(Icons.arrow_forward_rounded, size: 18), label: Text(c == titles.length - 1 ? 'Selesai' : 'Berikutnya'), style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48), backgroundColor: primary, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))))),
      ]);

  String _two(int n) => n.toString().padLeft(2, '0');
}
