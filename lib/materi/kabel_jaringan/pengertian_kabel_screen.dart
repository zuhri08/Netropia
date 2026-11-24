import 'package:flutter/material.dart';
import 'jenis_kabel_screen.dart';

class PengertianKabelScreen extends StatelessWidget {
  const PengertianKabelScreen({super.key});

  static const Color primaryBrown = Color(0xFF5D4037);
  static const Color darkBrown = Color(0xFF3E2723);
  static const Color lightBrown = Color(0xFFF3ECE9);
  static const Color textDark = Color(0xFF263238);
  static const Color textGrey = Color(0xFF607D8B);
  static const Color borderGrey = Color(0xFFDCE3EA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: _appBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 26),
              _networkDiagram(),
              const SizedBox(height: 28),
              _section('01', 'Apa Itu Kabel Jaringan?'),
              const SizedBox(height: 10),
              _paragraph('Kabel jaringan adalah media fisik yang digunakan untuk menghubungkan perangkat agar data dapat dikirim dari satu titik ke titik lainnya. Kabel masih banyak digunakan karena koneksinya stabil, mudah dipantau, dan cocok untuk lingkungan laboratorium maupun perkantoran.'),
              const SizedBox(height: 14),
              _infoBox(Icons.info_outline_rounded, 'Inti konsep', 'Kabel berfungsi sebagai jalur transmisi. Kualitas kabel, konektor, panjang instalasi, dan cara pemasangan dapat memengaruhi performa jaringan.'),
              const SizedBox(height: 28),
              _section('02', 'Bagian yang Perlu Diperhatikan'),
              const SizedBox(height: 14),
              _point(Icons.cable_rounded, 'Media', 'Kabel menjadi jalur penghantar sinyal atau cahaya.'),
              _point(Icons.settings_input_component_rounded, 'Konektor', 'Konektor menyambungkan kabel ke port perangkat.'),
              _point(Icons.speed_rounded, 'Karakteristik', 'Jenis kabel menentukan kecepatan, jarak, dan ketahanan terhadap gangguan.'),
              const SizedBox(height: 28),
              _keyPoint(),
              const SizedBox(height: 30),
              _navigation(context),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() => AppBar(
    backgroundColor: Colors.white,
    foregroundColor: textDark,
    elevation: 0,
    scrolledUnderElevation: 0,
    leading: Builder(builder: (context) => IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context))),
    title: const Text('Kabel Jaringan', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
    actions: [Container(margin: const EdgeInsets.only(right: 16), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: lightBrown, borderRadius: BorderRadius.circular(8)), child: const Text('01 / 08', style: TextStyle(color: primaryBrown, fontSize: 12, fontWeight: FontWeight.w700)))],
    bottom: PreferredSize(preferredSize: const Size.fromHeight(3), child: Container(height: 3, alignment: Alignment.centerLeft, child: FractionallySizedBox(widthFactor: .125, child: Container(color: primaryBrown)))),
  );

  Widget _header() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: primaryBrown, borderRadius: BorderRadius.circular(6)), child: const Text('MATERI 01', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: .5))),
    const SizedBox(height: 14),
    const Text('Pengertian Kabel\nJaringan', style: TextStyle(color: darkBrown, fontSize: 29, fontWeight: FontWeight.w800, height: 1.12, letterSpacing: -.5)),
    const SizedBox(height: 12),
    const Text('Memahami fungsi kabel sebagai media fisik untuk menghubungkan perangkat jaringan dan mengirimkan data.', style: TextStyle(color: textGrey, fontSize: 15, height: 1.55)),
  ]);

  Widget _networkDiagram() => Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: borderGrey), borderRadius: BorderRadius.circular(12)), child: Column(children: [
    const Align(alignment: Alignment.centerLeft, child: Text('Gambaran koneksi kabel', style: TextStyle(color: textDark, fontSize: 13, fontWeight: FontWeight.w700))),
    const SizedBox(height: 24),
    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_device(Icons.computer_rounded, 'PC'), _line(), _device(Icons.router_rounded, 'Switch'), _line(), _device(Icons.computer_rounded, 'PC')]),
    const SizedBox(height: 18),
    const Text('Data bergerak melalui jalur fisik antara perangkat.', textAlign: TextAlign.center, style: TextStyle(color: textGrey, fontSize: 11)),
  ]));

  Widget _device(IconData icon, String label) => Column(children: [Container(width: 54, height: 54, decoration: BoxDecoration(color: lightBrown, border: Border.all(color: primaryBrown.withOpacity(.22)), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: primaryBrown, size: 27)), const SizedBox(height: 7), Text(label, style: const TextStyle(color: textDark, fontSize: 11, fontWeight: FontWeight.w600))]);
  Widget _line() => Container(width: 28, height: 3, decoration: BoxDecoration(color: primaryBrown.withOpacity(.35), borderRadius: BorderRadius.circular(4)));
  Widget _section(String number, String title) => Row(children: [Container(width: 34, height: 34, alignment: Alignment.center, decoration: BoxDecoration(color: lightBrown, borderRadius: BorderRadius.circular(9)), child: Text(number, style: const TextStyle(color: primaryBrown, fontWeight: FontWeight.w800, fontSize: 12))), const SizedBox(width: 10), Expanded(child: Text(title, style: const TextStyle(color: textDark, fontSize: 17, fontWeight: FontWeight.w800)))]);
  Widget _paragraph(String text) => Text(text, style: const TextStyle(color: textGrey, fontSize: 14, height: 1.65));
  Widget _infoBox(IconData icon, String title, String text) => Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: lightBrown, borderRadius: BorderRadius.circular(12), border: Border.all(color: primaryBrown.withOpacity(.12))), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: primaryBrown, size: 21), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: darkBrown, fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text(text, style: const TextStyle(color: textGrey, fontSize: 12.5, height: 1.5))]))]));
  Widget _point(IconData icon, String title, String desc) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: borderGrey), borderRadius: BorderRadius.circular(10)), child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: lightBrown, borderRadius: BorderRadius.circular(9)), child: Icon(icon, color: primaryBrown, size: 20)), const SizedBox(width: 11), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: textDark, fontSize: 13, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(desc, style: const TextStyle(color: textGrey, fontSize: 12, height: 1.4))]))]));
  Widget _keyPoint() => Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: darkBrown, borderRadius: BorderRadius.circular(12)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('POIN PENTING', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)), SizedBox(height: 7), Text('Kenali jenis kabel sebelum memilih konektor, susunan kabel, dan teknik pemasangannya.', style: TextStyle(color: Colors.white, fontSize: 13.5, height: 1.5, fontWeight: FontWeight.w600))]));
  Widget _navigation(BuildContext context) => Row(children: [Expanded(child: OutlinedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded, size: 18), label: const Text('Kembali'), style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48), foregroundColor: textGrey, side: const BorderSide(color: borderGrey), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))))), const SizedBox(width: 12), Expanded(child: ElevatedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JenisKabelScreen())), icon: const Icon(Icons.arrow_forward_rounded, size: 18), label: const Text('Berikutnya'), style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48), backgroundColor: primaryBrown, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))))) ]);
}
