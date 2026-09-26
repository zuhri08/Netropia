import 'package:flutter/material.dart';

class IpAddressMateriScreen extends StatelessWidget {
  final int index;
  const IpAddressMateriScreen({super.key, required this.index});

  static const Color primary = Color(0xFF1565C0);
  static const Color dark = Color(0xFF123B7A);
  static const Color light = Color(0xFFEAF2FB);
  static const Color textDark = Color(0xFF263238);
  static const Color textGrey = Color(0xFF607D8B);
  static const Color border = Color(0xFFDCE3EA);
  static const Color soft = Color(0xFFF1F5F8);

  static const List<String> titles = [
    'Pengenalan IP Address',
    'IPv4 dan Struktur Alamat',
    'Public, Private, dan Loopback',
    'Subnet Mask dan Prefix',
    'Konsep Subnetting',
    'Static dan DHCP',
    'IPv6 Secara Singkat',
    'Troubleshooting IP Address',
  ];

  static const List<String> subtitles = [
    'Memahami fungsi IP Address sebagai identitas logis perangkat dalam jaringan.',
    'Mengenal empat oktet IPv4, network ID, dan host ID.',
    'Membedakan alamat yang digunakan pada internet, jaringan lokal, dan pengujian lokal.',
    'Menentukan bagian network dan host menggunakan subnet mask atau CIDR.',
    'Membagi satu jaringan menjadi beberapa subnet sesuai kebutuhan perangkat.',
    'Membandingkan konfigurasi alamat IP manual dengan pemberian otomatis oleh DHCP.',
    'Mengenal format alamat IPv6 dan alasan penggunaannya untuk jaringan modern.',
    'Melacak masalah konektivitas dari konfigurasi IP sampai gateway dan DNS.',
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('IP Address', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
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
          child: Container(
            height: 3,
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: (c + 1) / titles.length,
              child: Container(color: primary),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(c),
              const SizedBox(height: 26),
              _visual(c),
              const SizedBox(height: 28),
              ..._sections(c),
              const SizedBox(height: 22),
              _keyPoint(c),
              const SizedBox(height: 32),
              _navigation(context, c),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(int c) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _materialBadge(c + 1),
          const SizedBox(height: 14),
          Text(
            _titleWithBreak(c),
            style: const TextStyle(color: dark, fontSize: 29, fontWeight: FontWeight.w800, height: 1.12, letterSpacing: -.5),
          ),
          const SizedBox(height: 12),
          Text(subtitles[c], style: const TextStyle(color: textGrey, fontSize: 15, height: 1.55)),
        ],
      );

  Widget _materialBadge(int number) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(6)),
        child: Text(
          'MATERI ${_two(number)}',
          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: .5),
        ),
      );

  String _titleWithBreak(int c) {
    const values = [
      'Pengenalan IP\nAddress',
      'IPv4 dan Struktur\nAlamat',
      'Public, Private,\ndan Loopback',
      'Subnet Mask\ndan Prefix',
      'Konsep\nSubnetting',
      'Static dan\nDHCP',
      'IPv6 Secara\nSingkat',
      'Troubleshooting\nIP Address',
    ];
    return values[c];
  }

  Widget _visual(int c) {
    switch (c) {
      case 0:
        return _diagramCard('Perangkat → IP Address → Jaringan', _ipFlow(), Icons.lan_rounded);
      case 1:
        return _diagramCard('Struktur IPv4', _ipv4Diagram(), Icons.numbers_rounded);
      case 2:
        return _diagramCard('Contoh Kategori Alamat', _addressTypes(), Icons.category_rounded);
      case 3:
        return _diagramCard('Contoh 192.168.10.25 / 24', _prefixDiagram(), Icons.account_tree_rounded);
      case 4:
        return _diagramCard('Alur Subnetting', _subnetDiagram(), Icons.call_split_rounded);
      case 5:
        return _diagramCard('Cara IP Diperoleh', _dhcpDiagram(), Icons.settings_ethernet_rounded);
      case 6:
        return _diagramCard('IPv6 Menggunakan Notasi Heksadesimal', _ipv6Diagram(), Icons.language_rounded);
      default:
        return _diagramCard('Urutan Pemeriksaan', _troubleshootDiagram(), Icons.rule_rounded);
    }
  }

  Widget _diagramCard(String title, Widget child, IconData icon) => Container(
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
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: light, borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: primary, size: 19),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(title, style: const TextStyle(color: textDark, fontSize: 13, fontWeight: FontWeight.w700))),
              ],
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      );

  Widget _iconNode(String label, IconData icon, {bool main = false}) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 56,
            decoration: BoxDecoration(
              color: main ? dark : light,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: main ? dark : const Color(0xFFB8D2EE)),
            ),
            child: Icon(icon, color: main ? Colors.white : primary, size: 27),
          ),
          const SizedBox(height: 7),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(color: textDark, fontSize: 10.5, fontWeight: FontWeight.w700)),
        ],
      );

  Widget _ipChip(String text, {bool main = false}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        decoration: BoxDecoration(
          color: main ? primary : light,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: main ? primary : const Color(0xFFB8D2EE)),
        ),
        child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: main ? Colors.white : dark, fontSize: 12, fontWeight: FontWeight.w700)),
      );

  Widget _horizontalFlow(Widget left, Widget middle, Widget right) => LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 390) {
            return Column(
              children: [
                left,
                const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Icon(Icons.arrow_downward_rounded, color: primary, size: 21)),
                middle,
                const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Icon(Icons.arrow_downward_rounded, color: primary, size: 21)),
                right,
              ],
            );
          }
          return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [left, const Icon(Icons.arrow_forward_rounded, color: primary, size: 21), middle, const Icon(Icons.arrow_forward_rounded, color: primary, size: 21), right]);
        },
      );

  Widget _ipFlow() => _horizontalFlow(
        _iconNode('PC / Laptop', Icons.computer_rounded),
        _ipChip('192.168.1.10', main: true),
        _iconNode('LAN', Icons.hub_rounded),
      );

  Widget _ipv4Diagram() => Column(
        children: [
          Row(children: [for (final x in ['192', '168', '1', '10']) Expanded(child: Container(margin: const EdgeInsets.all(3), padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: light, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFB8D2EE))), child: Text(x, textAlign: TextAlign.center, style: const TextStyle(color: dark, fontSize: 19, fontWeight: FontWeight.w800))))]),
          const SizedBox(height: 8),
          const Row(children: [Expanded(child: Text('Oktet 1', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: textGrey))), Expanded(child: Text('Oktet 2', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: textGrey))), Expanded(child: Text('Oktet 3', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: textGrey))), Expanded(child: Text('Oktet 4', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: textGrey)))]),
          const SizedBox(height: 15),
          _info('IPv4 terdiri dari 32 bit dan umumnya ditulis sebagai 4 oktet desimal yang dipisahkan titik.'),
        ],
      );

  Widget _addressTypes() => Column(
        children: [
          _typeRow(Icons.lock_outline_rounded, 'Private', '10.0.0.0/8', 'Jaringan lokal'),
          _typeRow(Icons.lock_outline_rounded, 'Private', '172.16.0.0/12', 'Jaringan lokal'),
          _typeRow(Icons.lock_outline_rounded, 'Private', '192.168.0.0/16', 'Jaringan lokal'),
          _typeRow(Icons.loop_rounded, 'Loopback', '127.0.0.1', 'Uji perangkat sendiri'),
          _typeRow(Icons.public_rounded, 'Public', 'Contoh: alamat dari ISP', 'Dapat dirutekan di internet'),
        ],
      );

  Widget _typeRow(IconData icon, String a, String b, String c) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(color: soft, border: Border.all(color: border), borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Container(width: 34, height: 34, decoration: BoxDecoration(color: light, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: primary, size: 18)),
            const SizedBox(width: 10),
            SizedBox(width: 66, child: Text(a, style: const TextStyle(color: dark, fontSize: 10.5, fontWeight: FontWeight.w800))),
            Expanded(child: Text(b, style: const TextStyle(color: textDark, fontSize: 11.5, fontWeight: FontWeight.w700))),
            const SizedBox(width: 8),
            Flexible(child: Text(c, textAlign: TextAlign.right, style: const TextStyle(color: textGrey, fontSize: 9.5))),
          ],
        ),
      );

  Widget _prefixDiagram() => Column(
        children: [
          _ipChip('192.168.10.25', main: true),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _statCard('255.255.255.0', 'Subnet Mask', Icons.grid_3x3_rounded)),
            const SizedBox(width: 10),
            Expanded(child: _statCard('/24', 'CIDR / Prefix', Icons.tag_rounded, accent: true)),
          ]),
        ],
      );

  Widget _statCard(String value, String label, IconData icon, {bool accent = false}) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: light, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Icon(icon, color: primary, size: 18),
            const SizedBox(height: 6),
            Text(value, textAlign: TextAlign.center, style: TextStyle(fontSize: accent ? 19 : 14, fontWeight: FontWeight.w800, color: accent ? primary : dark)),
            const SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: textGrey)),
          ],
        ),
      );

  Widget _subnetDiagram() => Column(
        children: [
          _ipChip('Jaringan 192.168.10.0/24', main: true),
          const Padding(padding: EdgeInsets.symmetric(vertical: 7), child: Icon(Icons.arrow_downward_rounded, color: primary, size: 21)),
          Row(children: [
            Expanded(child: _branch('Subnet A', '192.168.10.0/26', 'Host 1–62')),
            const SizedBox(width: 10),
            Expanded(child: _branch('Subnet B', '192.168.10.64/26', 'Host 65–126')),
          ]),
        ],
      );

  Widget _branch(String a, String b, String c) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: soft, border: Border.all(color: border), borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          Container(width: 34, height: 34, decoration: BoxDecoration(color: light, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.account_tree_rounded, color: primary, size: 18)),
          const SizedBox(height: 7),
          Text(a, style: const TextStyle(color: dark, fontWeight: FontWeight.w800, fontSize: 11)),
          const SizedBox(height: 4),
          Text(b, textAlign: TextAlign.center, style: const TextStyle(color: textDark, fontSize: 10.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(c, textAlign: TextAlign.center, style: const TextStyle(color: textGrey, fontSize: 9.5)),
        ]),
      );

  Widget _dhcpDiagram() => _horizontalFlow(
        _iconNode('Client', Icons.laptop_rounded),
        _chipWithIcon('DHCP', Icons.settings_suggest_rounded, primary),
        _iconNode('Server / Router', Icons.router_rounded),
      );

  Widget _chipWithIcon(String title, IconData icon, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: light, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFB8D2EE))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: color, size: 20), const SizedBox(width: 7), Text(title, style: const TextStyle(color: dark, fontSize: 12, fontWeight: FontWeight.w800))]),
      );

  Widget _ipv6Diagram() => Column(
        children: [
          Container(width: double.infinity, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: dark, borderRadius: BorderRadius.circular(10)), child: const Text('2001:db8:1234:0000:0000:8a2e:0370:7334', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w800, height: 1.45))),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _miniLabel(Icons.looks_one_rounded, '128 bit', 'Panjang alamat')),
            const SizedBox(width: 10),
            Expanded(child: _miniLabel(Icons.grid_4x4_rounded, '8 kelompok', 'Heksadesimal')),
            const SizedBox(width: 10),
            Expanded(child: _miniLabel(Icons.compress_rounded, 'Bisa disingkat', 'Aturan khusus')),
          ]),
        ],
      );

  Widget _miniLabel(IconData icon, String value, String label) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: soft, border: Border.all(color: border), borderRadius: BorderRadius.circular(9)),
        child: Column(children: [Icon(icon, color: primary, size: 18), const SizedBox(height: 5), Text(value, textAlign: TextAlign.center, style: const TextStyle(color: dark, fontSize: 10.5, fontWeight: FontWeight.w800)), const SizedBox(height: 2), Text(label, textAlign: TextAlign.center, style: const TextStyle(color: textGrey, fontSize: 9))]),
      );

  Widget _troubleshootDiagram() => Column(children: [
        _check('1', 'Cek alamat IP', Icons.numbers_rounded),
        _line(),
        _check('2', 'Cek subnet mask', Icons.grid_3x3_rounded),
        _line(),
        _check('3', 'Cek default gateway', Icons.router_rounded),
        _line(),
        _check('4', 'Cek DNS / koneksi internet', Icons.public_rounded),
      ]);

  Widget _check(String n, String t, IconData icon) => Row(children: [
        Container(width: 30, height: 30, alignment: Alignment.center, decoration: BoxDecoration(color: light, shape: BoxShape.circle), child: Text(n, style: const TextStyle(color: primary, fontWeight: FontWeight.w800, fontSize: 11))),
        const SizedBox(width: 10),
        Container(width: 34, height: 34, decoration: BoxDecoration(color: soft, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: primary, size: 18)),
        const SizedBox(width: 10),
        Text(t, style: const TextStyle(color: textDark, fontWeight: FontWeight.w700, fontSize: 12)),
      ]);

  Widget _line() => Container(margin: const EdgeInsets.only(left: 14), width: 2, height: 18, color: const Color(0xFFB8D2EE));

  List<Widget> _sections(int c) {
    final data = <List<Map<String, String>>>[
      [
        {'t': 'Apa itu IP Address?', 'd': 'IP Address adalah alamat logis yang digunakan untuk mengenali perangkat dan menentukan tujuan pengiriman data dalam jaringan.'},
        {'t': 'Mengapa dibutuhkan?', 'd': 'Tanpa alamat tujuan yang jelas, perangkat akan kesulitan menentukan ke mana paket data harus dikirim.'},
        {'t': 'Contoh', 'd': 'Dalam LAN, komputer dapat menggunakan 192.168.1.10 sedangkan router lokal dapat menggunakan 192.168.1.1.'},
      ],
      [
        {'t': '32 bit', 'd': 'IPv4 memiliki panjang 32 bit yang dibagi menjadi empat bagian, masing-masing 8 bit.'},
        {'t': 'Network dan Host', 'd': 'Sebagian bit digunakan untuk mengidentifikasi jaringan, sedangkan sisanya mengidentifikasi host di dalam jaringan.'},
        {'t': 'Aturan dasar', 'd': 'Setiap perangkat pada satu subnet perlu memiliki alamat host yang tidak bentrok dengan perangkat lain.'},
      ],
      [
        {'t': 'Private', 'd': 'Digunakan di jaringan lokal seperti rumah, sekolah, dan laboratorium. Rentang private IPv4 ditetapkan untuk penggunaan internal.'},
        {'t': 'Public', 'd': 'Dapat digunakan untuk komunikasi melalui jaringan internet dan biasanya diperoleh dari penyedia layanan.'},
        {'t': 'Loopback', 'd': '127.0.0.1 digunakan untuk menguji layanan jaringan pada perangkat itu sendiri.'},
      ],
      [
        {'t': 'Subnet Mask', 'd': 'Menunjukkan bagian alamat yang termasuk network dan bagian yang dapat digunakan oleh host.'},
        {'t': 'CIDR', 'd': 'Notasi seperti /24 menunjukkan jumlah bit network pada alamat IPv4.'},
        {'t': 'Contoh', 'd': '192.168.10.25/24 memiliki subnet mask 255.255.255.0 dan jaringan 192.168.10.0 secara umum.'},
      ],
      [
        {'t': 'Tujuan', 'd': 'Subnetting membagi sebuah jaringan menjadi bagian yang lebih kecil agar penggunaan alamat dan pengelolaan jaringan lebih teratur.'},
        {'t': 'Langkah ringkas', 'd': 'Tentukan jumlah subnet atau host, pilih prefix yang sesuai, lalu tentukan network, host yang tersedia, dan broadcast.'},
        {'t': 'Manfaat', 'd': 'Membantu segmentasi jaringan, mengurangi broadcast, dan menyesuaikan alokasi alamat dengan kebutuhan.'},
      ],
      [
        {'t': 'Static IP', 'd': 'Alamat diatur manual dan cocok untuk perangkat yang perlu alamat tetap, misalnya server, printer tertentu, atau perangkat jaringan.'},
        {'t': 'DHCP', 'd': 'Server DHCP dapat memberikan IP, subnet mask, gateway, dan DNS secara otomatis kepada client.'},
        {'t': 'Perhatian', 'd': 'Pastikan rentang DHCP tidak bentrok dengan alamat statis yang sudah digunakan.'},
      ],
      [
        {'t': '128 bit', 'd': 'IPv6 menggunakan 128 bit sehingga menyediakan ruang alamat yang jauh lebih besar dibanding IPv4.'},
        {'t': 'Format', 'd': 'IPv6 ditulis dengan kelompok angka heksadesimal yang dipisahkan tanda titik dua (:).'},
        {'t': 'Peran', 'd': 'IPv6 dirancang untuk memenuhi kebutuhan jumlah alamat yang besar pada jaringan modern.'},
      ],
      [
        {'t': 'Periksa konfigurasi', 'd': 'Pastikan IP, subnet mask, gateway, dan DNS sesuai dengan jaringan yang digunakan.'},
        {'t': 'Uji koneksi', 'd': 'Gunakan ping ke gateway, lalu ke alamat lain yang diketahui untuk melihat titik gangguan.'},
        {'t': 'Pisahkan masalah', 'd': 'Bedakan apakah gangguan berasal dari perangkat, kabel/Wi-Fi, gateway, DNS, atau akses internet.'},
      ],
    ];

    final icons = <IconData>[
      Icons.numbers_rounded,
      Icons.account_tree_rounded,
      Icons.public_rounded,
      Icons.grid_3x3_rounded,
      Icons.call_split_rounded,
      Icons.settings_ethernet_rounded,
      Icons.language_rounded,
      Icons.rule_rounded,
    ];

    return data[c].asMap().entries.map((entry) {
      final item = entry.value;
      return _section(_two(entry.key + 1), item['t']!, item['d']!, icons[c]);
    }).toList();
  }

  Widget _section(String number, String title, String desc, IconData icon) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(number, style: const TextStyle(color: primary, fontSize: 13, fontWeight: FontWeight.w800)),
                const SizedBox(width: 10),
                Container(width: 32, height: 32, decoration: BoxDecoration(color: light, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: primary, size: 17)),
                const SizedBox(width: 10),
                Expanded(child: Text(title, style: const TextStyle(color: textDark, fontSize: 19, fontWeight: FontWeight.w800, height: 1.25))),
              ],
            ),
            const SizedBox(height: 12),
            Text(desc, style: const TextStyle(color: Color(0xFF455A64), fontSize: 14, height: 1.7)),
          ],
        ),
      );

  Widget _info(String text) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(color: light, border: Border(left: BorderSide(color: primary, width: 4))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.lightbulb_outline_rounded, color: primary, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(color: dark, fontSize: 13, height: 1.55, fontWeight: FontWeight.w600))),
        ]),
      );

  Widget _keyPoint(int c) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: dark, borderRadius: BorderRadius.circular(10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [const Icon(Icons.push_pin_rounded, color: Color(0xFF90CAF9), size: 17), const SizedBox(width: 7), const Text('POIN PENTING', style: TextStyle(color: Color(0xFF90CAF9), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1))]),
          const SizedBox(height: 9),
          Text(_keyTexts[c], style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.55, fontWeight: FontWeight.w600)),
        ]),
      );

  static const List<String> _keyTexts = [
    'IP Address memberi identitas logis dan membantu menentukan tujuan paket pada jaringan.',
    'IPv4 terdiri dari 32 bit dan dibagi menjadi empat oktet desimal.',
    'Private digunakan untuk jaringan lokal, public untuk komunikasi yang dapat dirutekan di internet, dan loopback untuk pengujian lokal.',
    'Subnet mask dan prefix menentukan bagian network dan host pada sebuah alamat.',
    'Subnetting membagi jaringan besar menjadi subnet yang lebih terkelola.',
    'DHCP mempermudah pemberian konfigurasi IP secara otomatis, sedangkan static IP diatur manual.',
    'IPv6 memakai 128 bit untuk menyediakan ruang alamat yang jauh lebih besar.',
    'Troubleshooting IP dilakukan bertahap dari konfigurasi lokal menuju gateway, DNS, dan koneksi internet.',
  ];

  Widget _navigation(BuildContext context, int c) => Row(children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: c == 0 ? null : () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => IpAddressMateriScreen(index: c - 1))),
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            label: const Text('Sebelumnya'),
            style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48), foregroundColor: textGrey, side: const BorderSide(color: border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: c == titles.length - 1 ? () => Navigator.pop(context) : () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => IpAddressMateriScreen(index: c + 1))),
            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
            label: Text(c == titles.length - 1 ? 'Selesai' : 'Berikutnya'),
            style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48), backgroundColor: primary, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          ),
        ),
      ]);

  String _two(int n) => n.toString().padLeft(2, '0');
}
