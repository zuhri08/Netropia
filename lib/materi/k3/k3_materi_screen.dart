import 'package:flutter/material.dart';

class K3MateriScreen extends StatelessWidget {
  final int index;
  const K3MateriScreen({super.key, required this.index});

  static const Color primary = Color(0xFF2E7D32);
  static const Color dark = Color(0xFF1B5E20);
  static const Color light = Color(0xFFE8F5E9);
  static const Color textDark = Color(0xFF263238);
  static const Color textGrey = Color(0xFF607D8B);
  static const Color border = Color(0xFFDCE3EA);
  static const Color soft = Color(0xFFF1F5F8);

  static const List<String> titles = [
    'Pengenalan K3',
    'Identifikasi Bahaya',
    'APD di Ruang Komputer',
    'Keselamatan Listrik',
    'Ergonomi dan Posisi Kerja',
    'ESD dan Perlindungan Komponen',
    'Tanggap Darurat',
    'Budaya Kerja Aman',
  ];

  static const List<String> subtitles = [
    'Memahami keselamatan dan kesehatan kerja sebelum melakukan aktivitas praktik TKJ.',
    'Mengenali sumber bahaya, risiko, serta cara mengendalikan risiko di laboratorium.',
    'Menentukan perlengkapan pelindung dan kondisi penggunaannya.',
    'Mengurangi risiko sengatan listrik, korsleting, dan kerusakan peralatan.',
    'Menjaga posisi tubuh agar aktivitas di depan komputer lebih aman dan nyaman.',
    'Mencegah listrik statis merusak motherboard, RAM, CPU, dan komponen sensitif lainnya.',
    'Menentukan tindakan ketika terjadi kebakaran kecil, kecelakaan, atau kondisi darurat.',
    'Membangun kebiasaan kerja disiplin, rapi, bersih, dan selalu memeriksa keselamatan.',
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
        title: const Text('K3', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
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
        'Pengenalan K3',
        'Identifikasi\nBahaya',
        'APD di Ruang\nKomputer',
        'Keselamatan\nListrik',
        'Ergonomi dan\nPosisi Kerja',
        'ESD dan Perlindungan\nKomponen',
        'Tanggap\nDarurat',
        'Budaya Kerja\nAman',
      ][c];

  Widget _visual(int c) {
    switch (c) {
      case 0: return _diagramCard('Siklus K3', _flow(['Kenali bahaya', 'Nilai risiko', 'Kendalikan risiko', 'Evaluasi']), Icons.health_and_safety_rounded);
      case 1: return _diagramCard('Contoh Pemetaan Bahaya', _hazardGrid(), Icons.warning_amber_rounded);
      case 2: return _diagramCard('Perlengkapan Dasar', _ppe(), Icons.health_and_safety_rounded);
      case 3: return _diagramCard('Pemeriksaan Sebelum Menyalakan Perangkat', _powerFlow(), Icons.power_rounded);
      case 4: return _diagramCard('Posisi Kerja yang Lebih Aman', _ergonomic(), Icons.accessibility_new_rounded);
      case 5: return _diagramCard('Alur Penanganan ESD', _esd(), Icons.bolt_rounded);
      case 6: return _diagramCard('Alur Tanggap Darurat', _emergency(), Icons.emergency_rounded);
      default: return _diagramCard('Kebiasaan Aman', _safeHabits(), Icons.checklist_rounded);
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

  Widget _flow(List<String> items) => Column(children: [for (int i = 0; i < items.length; i++) ...[
        Row(children: [
          Container(width: 30, height: 30, alignment: Alignment.center, decoration: const BoxDecoration(color: light, shape: BoxShape.circle), child: Text('${i + 1}', style: const TextStyle(color: primary, fontSize: 11, fontWeight: FontWeight.w800))),
          const SizedBox(width: 10),
          Container(width: 34, height: 34, decoration: BoxDecoration(color: soft, borderRadius: BorderRadius.circular(8)), child: Icon(_flowIcons[i], color: primary, size: 18)),
          const SizedBox(width: 10),
          Expanded(child: Text(items[i], style: const TextStyle(color: textDark, fontWeight: FontWeight.w700, fontSize: 12))),
        ]),
        if (i < items.length - 1) Container(margin: const EdgeInsets.only(left: 14), width: 2, height: 18, color: const Color(0xFFC8E6C9)),
      ]]);

  static const List<IconData> _flowIcons = [Icons.warning_amber_rounded, Icons.assessment_rounded, Icons.shield_rounded, Icons.fact_check_rounded];

  Widget _hazardGrid() => Column(children: [
        _hazard(Icons.bolt_rounded, 'Listrik', 'Kabel rusak, stopkontak berlebih'),
        _hazard(Icons.local_fire_department_outlined, 'Panas / Api', 'Komponen panas, ventilasi tertutup'),
        _hazard(Icons.cleaning_services_outlined, 'Lingkungan', 'Kabel berserakan, lantai licin'),
        _hazard(Icons.accessibility_new_rounded, 'Ergonomi', 'Posisi duduk dan monitor tidak sesuai'),
      ]);

  Widget _hazard(IconData icon, String title, String desc) => Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(color: soft, border: Border.all(color: border), borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: light, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: primary, size: 20)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: dark, fontSize: 12, fontWeight: FontWeight.w800)), const SizedBox(height: 3), Text(desc, style: const TextStyle(color: textGrey, fontSize: 10.5))])),
        ]),
      );

  Widget _ppe() => LayoutBuilder(builder: (context, constraints) {
    final compact = constraints.maxWidth < 420;
    final items = [
      _ppeBox(Icons.remove_red_eye_rounded, 'Kacamata', 'Saat ada risiko percikan'),
      _ppeBox(Icons.pan_tool_alt_rounded, 'Sarung tangan', 'Sesuai jenis pekerjaan'),
      _ppeBox(Icons.workspaces_rounded, 'Sepatu', 'Menjaga pijakan aman'),
    ];
    return compact ? Column(children: items) : Row(children: items.map((e) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: e))).toList());
  });

  Widget _ppeBox(IconData i, String t, String d) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(11),
        margin: const EdgeInsets.only(bottom: 9),
        decoration: BoxDecoration(color: soft, border: Border.all(color: border), borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: light, borderRadius: BorderRadius.circular(10)), child: Icon(i, color: primary, size: 24)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(color: dark, fontSize: 11, fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text(d, style: const TextStyle(color: textGrey, fontSize: 9.5, height: 1.35))])),
        ]),
      );

  Widget _powerFlow() => LayoutBuilder(builder: (context, constraints) {
    final nodes = [
      _safeNode('Periksa kabel', Icons.settings_ethernet_rounded),
      _safeNode('Tangan kering', Icons.pan_tool_alt_rounded),
      _safeNode('Nyalakan perangkat', Icons.power_settings_new_rounded),
    ];
    if (constraints.maxWidth < 390) {
      return Column(children: [nodes[0], _arrowDown(), nodes[1], _arrowDown(), nodes[2]]);
    }
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [nodes[0], _arrowRight(), nodes[1], _arrowRight(), nodes[2]]);
  });

  Widget _arrowDown() => const Padding(padding: EdgeInsets.symmetric(vertical: 7), child: Icon(Icons.arrow_downward_rounded, color: primary, size: 21));
  Widget _arrowRight() => const Icon(Icons.arrow_forward_rounded, color: primary, size: 21);

  Widget _safeNode(String t, IconData icon) => Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
        decoration: BoxDecoration(color: soft, border: Border.all(color: border), borderRadius: BorderRadius.circular(10)),
        child: Column(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: light, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: primary, size: 20)), const SizedBox(height: 7), Text(t, textAlign: TextAlign.center, style: const TextStyle(color: dark, fontSize: 9.5, fontWeight: FontWeight.w800))]),
      );

  Widget _ergonomic() => Column(children: [
        _ergo(Icons.monitor_rounded, 'Monitor', 'Bagian atas layar mendekati tinggi mata'),
        _ergo(Icons.event_seat_rounded, 'Punggung', 'Tegak dan mendapat dukungan sandaran'),
        _ergo(Icons.pan_tool_alt_rounded, 'Lengan', 'Siku kurang lebih 90 derajat dan bahu rileks'),
        _ergo(Icons.directions_walk_rounded, 'Kaki', 'Telapak menapak dan posisi nyaman'),
      ]);

  Widget _ergo(IconData icon, String a, String b) => Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(color: soft, border: Border.all(color: border), borderRadius: BorderRadius.circular(10)),
        child: Row(children: [Container(width: 34, height: 34, decoration: BoxDecoration(color: light, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: primary, size: 18)), const SizedBox(width: 10), Expanded(child: Text.rich(TextSpan(children: [TextSpan(text: '$a: ', style: const TextStyle(color: dark, fontWeight: FontWeight.w800, fontSize: 11)), TextSpan(text: b, style: const TextStyle(color: textGrey, fontSize: 11))])))]),
      );

  Widget _esd() => Column(children: [
        _esdStep('1', 'Matikan dan lepaskan sumber daya', Icons.power_settings_new_rounded),
        _esdStep('2', 'Gunakan gelang antistatik bila tersedia', Icons.watch_rounded),
        _esdStep('3', 'Pegang komponen pada bagian tepinya', Icons.touch_app_rounded),
        _esdStep('4', 'Simpan komponen dalam kemasan antistatik', Icons.inventory_2_rounded),
      ]);

  Widget _esdStep(String n, String t, IconData icon) => Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(color: soft, border: Border.all(color: border), borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          Container(width: 28, height: 28, alignment: Alignment.center, decoration: BoxDecoration(color: light, shape: BoxShape.circle), child: Text(n, style: const TextStyle(color: primary, fontWeight: FontWeight.w800, fontSize: 11))),
          const SizedBox(width: 10),
          Icon(icon, color: primary, size: 19),
          const SizedBox(width: 10),
          Expanded(child: Text(t, style: const TextStyle(color: textDark, fontWeight: FontWeight.w700, fontSize: 11.5))),
        ]),
      );

  Widget _emergency() => Column(children: [
        _emergencyStep(Icons.warning_amber_rounded, 'Hentikan pekerjaan dan amankan area'),
        _emergencyStep(Icons.people_alt_rounded, 'Beritahu dosen, teknisi, atau penanggung jawab'),
        _emergencyStep(Icons.call_rounded, 'Hubungi bantuan sesuai prosedur fasilitas'),
        _emergencyStep(Icons.exit_to_app_rounded, 'Evakuasi melalui jalur yang aman bila diperlukan'),
      ]);

  Widget _emergencyStep(IconData icon, String text) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [Container(width: 38, height: 38, decoration: BoxDecoration(color: light, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: primary, size: 20)), const SizedBox(width: 11), Expanded(child: Text(text, style: const TextStyle(color: textDark, fontSize: 11.5, fontWeight: FontWeight.w700, height: 1.35)))]));

  Widget _safeHabits() => Column(children: [
        _habit(Icons.cleaning_services_rounded, 'Rapi', 'Rapikan kabel dan area kerja sebelum dan sesudah praktik.'),
        _habit(Icons.search_rounded, 'Periksa', 'Cek alat, kabel, dan konektor sebelum digunakan.'),
        _habit(Icons.do_not_disturb_alt_rounded, 'Jangan ceroboh', 'Jangan menyentuh komponen listrik dengan tangan basah.'),
        _habit(Icons.assignment_turned_in_rounded, 'Ikuti prosedur', 'Gunakan SOP dan laporkan kondisi yang tidak aman.'),
      ]);

  Widget _habit(IconData icon, String title, String text) => Container(margin: const EdgeInsets.only(bottom: 9), padding: const EdgeInsets.all(11), decoration: BoxDecoration(color: soft, border: Border.all(color: border), borderRadius: BorderRadius.circular(10)), child: Row(children: [Icon(icon, color: primary, size: 20), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: dark, fontSize: 11.5, fontWeight: FontWeight.w800)), const SizedBox(height: 3), Text(text, style: const TextStyle(color: textGrey, fontSize: 10.5, height: 1.4))]))]));

  List<Widget> _sections(int c) {
    const data = <List<Map<String, String>>>[
      [
        {'t': 'Apa Itu K3?', 'd': 'K3 adalah upaya sistematis untuk menjaga keselamatan dan kesehatan selama bekerja, termasuk saat praktik jaringan dan komputer di laboratorium.'},
        {'t': 'Mengapa Penting?', 'd': 'K3 membantu mengurangi risiko kecelakaan, kerusakan peralatan, serta gangguan kesehatan akibat kebiasaan kerja yang tidak tepat.'},
        {'t': 'Penerapan', 'd': 'Mulai dari memeriksa area kerja, menggunakan alat sesuai prosedur, sampai menjaga posisi kerja dan merapikan area setelah praktik.'},
      ],
      [
        {'t': 'Bahaya Listrik', 'd': 'Sumber risiko dapat berasal dari kabel terkelupas, stopkontak berlebih, adaptor rusak, atau prosedur kerja yang tidak benar.'},
        {'t': 'Bahaya Fisik', 'd': 'Kabel berserakan, sudut meja, lantai licin, dan perangkat yang tidak stabil dapat menyebabkan cedera.'},
        {'t': 'Bahaya Ergonomi', 'd': 'Posisi duduk, monitor, dan meja yang tidak sesuai dapat menimbulkan ketidaknyamanan saat bekerja dalam waktu lama.'},
      ],
      [
        {'t': 'Fungsi APD', 'd': 'APD digunakan sesuai risiko pekerjaan untuk memberikan perlindungan tambahan, bukan untuk menggantikan prosedur keselamatan.'},
        {'t': 'Contoh', 'd': 'Kacamata, sarung tangan tertentu, dan sepatu kerja dapat digunakan sesuai aktivitas dan lingkungan laboratorium.'},
        {'t': 'Pemilihan', 'd': 'Pastikan APD dalam kondisi baik, sesuai ukuran, dan benar-benar relevan dengan jenis pekerjaan.'},
      ],
      [
        {'t': 'Sebelum Menyalakan', 'd': 'Periksa kabel, konektor, stopkontak, dan kondisi perangkat sebelum sumber daya dinyalakan.'},
        {'t': 'Saat Bekerja', 'd': 'Gunakan tangan kering dan hindari membuka atau memperbaiki bagian bertegangan listrik tanpa prosedur yang sesuai.'},
        {'t': 'Setelah Selesai', 'd': 'Matikan perangkat sesuai prosedur dan rapikan kabel atau adaptor agar area tetap aman.'},
      ],
      [
        {'t': 'Posisi Monitor', 'd': 'Tempatkan monitor pada posisi yang membantu mata melihat layar dengan nyaman tanpa menunduk atau mendongak berlebihan.'},
        {'t': 'Posisi Duduk', 'd': 'Punggung mendapat dukungan dan bahu tetap rileks. Sesuaikan tinggi kursi dan meja dengan kebutuhan.'},
        {'t': 'Istirahat', 'd': 'Berikan jeda dari layar dan ubah posisi secara berkala saat melakukan aktivitas dalam waktu lama.'},
      ],
      [
        {'t': 'Apa Itu ESD?', 'd': 'Electrostatic Discharge adalah pelepasan listrik statis yang dapat merusak komponen elektronik sensitif.'},
        {'t': 'Pencegahan', 'd': 'Matikan sumber daya, gunakan perlindungan antistatik bila tersedia, dan pegang komponen pada bagian tepinya.'},
        {'t': 'Penyimpanan', 'd': 'Simpan komponen sensitif pada kemasan antistatik dan hindari permukaan yang mudah menghasilkan muatan statis.'},
      ],
      [
        {'t': 'Prioritas Pertama', 'd': 'Hentikan aktivitas, amankan area, dan jauhi sumber bahaya yang masih aktif.'},
        {'t': 'Minta Bantuan', 'd': 'Segera beri tahu pihak yang bertanggung jawab dan ikuti prosedur kedaruratan fasilitas.'},
        {'t': 'Evakuasi', 'd': 'Gunakan jalur evakuasi yang telah ditentukan dan jangan menghambat orang lain saat meninggalkan area.'},
      ],
      [
        {'t': 'Rapi dan Bersih', 'd': 'Area kerja yang rapi memudahkan pemeriksaan alat dan mengurangi risiko tersandung atau salah koneksi.'},
        {'t': 'Disiplin', 'd': 'Lakukan pemeriksaan sebelum, saat, dan setelah bekerja sesuai SOP yang berlaku.'},
        {'t': 'Laporkan Risiko', 'd': 'Kondisi tidak aman, alat rusak, atau kejadian hampir celaka perlu segera dilaporkan agar dapat ditangani.'},
      ],
    ];

    const icons = [Icons.health_and_safety_rounded, Icons.warning_amber_rounded, Icons.shield_rounded, Icons.power_rounded, Icons.event_seat_rounded, Icons.bolt_rounded, Icons.emergency_rounded, Icons.checklist_rounded];
    return data[c].asMap().entries.map((entry) => _section(_two(entry.key + 1), entry.value['t']!, entry.value['d']!, icons[c])).toList();
  }

  Widget _section(String number, String title, String desc, IconData icon) => Padding(padding: const EdgeInsets.only(bottom: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(number, style: const TextStyle(color: primary, fontSize: 13, fontWeight: FontWeight.w800)), const SizedBox(width: 10), Container(width: 32, height: 32, decoration: BoxDecoration(color: light, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: primary, size: 17)), const SizedBox(width: 10), Expanded(child: Text(title, style: const TextStyle(color: textDark, fontSize: 19, fontWeight: FontWeight.w800, height: 1.25)))]),
    const SizedBox(height: 12),
    Text(desc, style: const TextStyle(color: Color(0xFF455A64), fontSize: 14, height: 1.7)),
  ]));

  Widget _keyPoint(int c) => Container(width: double.infinity, padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: dark, borderRadius: BorderRadius.circular(10)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Row(children: [Icon(Icons.push_pin_rounded, color: Color(0xFFA5D6A7), size: 17), SizedBox(width: 7), Text('POIN PENTING', style: TextStyle(color: Color(0xFFA5D6A7), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1))]), const SizedBox(height: 9), Text(_keyTexts[c], style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.55, fontWeight: FontWeight.w600))]));

  static const List<String> _keyTexts = [
    'K3 menjadi dasar sebelum melakukan pekerjaan praktik agar risiko dapat dikenali dan dikendalikan.',
    'Bahaya dapat berasal dari listrik, panas, lingkungan kerja, maupun posisi kerja yang tidak tepat.',
    'APD digunakan sesuai kebutuhan dan harus tetap disertai prosedur kerja yang benar.',
    'Periksa kabel dan kondisi perangkat sebelum menyalakan sumber listrik.',
    'Posisi monitor, kursi, meja, dan jeda kerja membantu menjaga kenyamanan saat bekerja di depan komputer.',
    'ESD dapat merusak komponen sensitif sehingga penanganan antistatik perlu diperhatikan.',
    'Saat darurat, utamakan keselamatan, minta bantuan, dan ikuti jalur atau prosedur evakuasi.',
    'Budaya aman dibangun dari kebiasaan rapi, disiplin, pemeriksaan rutin, dan keberanian melaporkan risiko.',
  ];

  Widget _navigation(BuildContext context, int c) => Row(children: [
        Expanded(child: OutlinedButton.icon(onPressed: c == 0 ? null : () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => K3MateriScreen(index: c - 1))), icon: const Icon(Icons.arrow_back_rounded, size: 18), label: const Text('Sebelumnya'), style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48), foregroundColor: textGrey, side: const BorderSide(color: border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))))),
        const SizedBox(width: 12),
        Expanded(child: ElevatedButton.icon(onPressed: c == titles.length - 1 ? () => Navigator.pop(context) : () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => K3MateriScreen(index: c + 1))), icon: const Icon(Icons.arrow_forward_rounded, size: 18), label: Text(c == titles.length - 1 ? 'Selesai' : 'Berikutnya'), style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48), backgroundColor: primary, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))))),
      ]);

  String _two(int n) => n.toString().padLeft(2, '0');
}
