import 'package:flutter/material.dart';
import 'protokol_jaringan_screen.dart';
class TopologiJaringanScreen extends StatelessWidget {
  final VoidCallback? onNext;

  const TopologiJaringanScreen({
    super.key,
    this.onNext,
  });

  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color darkBlue = Color(0xFF123B7A);
  static const Color lightBlue = Color(0xFFEAF2FB);
  static const Color textDark = Color(0xFF263238);
  static const Color textGrey = Color(0xFF607D8B);
  static const Color borderGrey = Color(0xFFDCE3EA);

  @override
  Widget build(BuildContext context) {
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
          'Dasar Jaringan',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
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
              color: lightBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '05 / 08',
              style: TextStyle(
                color: primaryBlue,
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
              widthFactor: 0.625,
              child: Container(
                color: primaryBlue,
              ),
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
              _buildHeader(),

              const SizedBox(height: 28),

              _buildIntroduction(),

              const SizedBox(height: 30),

              _buildSectionTitle(
                number: '01',
                title: 'Topologi Star',
              ),

              const SizedBox(height: 12),

              _buildParagraph(
                'Pada topologi star, setiap perangkat terhubung '
                    'ke satu perangkat pusat. Bentuk ini banyak '
                    'digunakan pada jaringan komputer modern.',
              ),

              const SizedBox(height: 16),

              _buildStarDiagram(),

              const SizedBox(height: 12),

              _buildExampleText(
                'Contoh: jaringan komputer laboratorium yang '
                    'menggunakan switch sebagai perangkat pusat.',
              ),

              const SizedBox(height: 28),

              _buildSectionTitle(
                number: '02',
                title: 'Topologi Bus',
              ),

              const SizedBox(height: 12),

              _buildParagraph(
                'Pada topologi bus, beberapa perangkat terhubung '
                    'pada satu jalur utama yang digunakan bersama.',
              ),

              const SizedBox(height: 16),

              _buildBusDiagram(),

              const SizedBox(height: 28),

              _buildSectionTitle(
                number: '03',
                title: 'Topologi Ring',
              ),

              const SizedBox(height: 12),

              _buildParagraph(
                'Pada topologi ring, perangkat tersusun membentuk '
                    'sebuah lingkaran. Setiap perangkat terhubung '
                    'dengan perangkat di sebelahnya.',
              ),

              const SizedBox(height: 16),

              _buildRingDiagram(),

              const SizedBox(height: 28),

              _buildSectionTitle(
                number: '04',
                title: 'Topologi Mesh',
              ),

              const SizedBox(height: 12),

              _buildParagraph(
                'Pada topologi mesh, perangkat memiliki beberapa '
                    'jalur koneksi dengan perangkat lainnya. '
                    'Struktur ini menyediakan jalur komunikasi '
                    'yang lebih banyak.',
              ),

              const SizedBox(height: 16),

              _buildMeshDiagram(),

              const SizedBox(height: 28),

              _buildSectionTitle(
                number: '05',
                title: 'Topologi Tree',
              ),

              const SizedBox(height: 12),

              _buildParagraph(
                'Topologi tree memiliki struktur bertingkat '
                    'seperti cabang pohon. Jaringan dapat dibagi '
                    'menjadi beberapa bagian atau tingkatan.',
              ),

              const SizedBox(height: 16),

              _buildTreeDiagram(),

              const SizedBox(height: 28),

              _buildSectionTitle(
                number: '06',
                title: 'Topologi Hybrid',
              ),

              const SizedBox(height: 12),

              _buildParagraph(
                'Topologi hybrid merupakan gabungan dari dua '
                    'atau lebih jenis topologi jaringan. Bentuknya '
                    'dapat disesuaikan dengan kebutuhan jaringan.',
              ),

              const SizedBox(height: 16),

              _buildHybridDiagram(),

              const SizedBox(height: 30),

              _buildSummary(),

              const SizedBox(height: 28),

              _buildKeyPoint(),

              const SizedBox(height: 32),

              _buildNavigation(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: primaryBlue,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'MATERI 05',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Topologi Jaringan',
          style: TextStyle(
            color: darkBlue,
            fontSize: 29,
            fontWeight: FontWeight.w800,
            height: 1.12,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Mengenal bentuk atau pola hubungan antarperangkat '
              'dalam sebuah jaringan komputer.',
          style: TextStyle(
            color: textGrey,
            fontSize: 15,
            height: 1.55,
          ),
        ),
      ],
    );
  }

  Widget _buildIntroduction() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: lightBlue,
        border: Border.all(
          color: const Color(0xFFD1E3F5),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.account_tree_rounded,
            color: primaryBlue,
            size: 23,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Topologi menggambarkan bagaimana perangkat '
                  'dalam jaringan disusun dan dihubungkan satu '
                  'sama lain.',
              style: TextStyle(
                color: darkBlue,
                fontSize: 13,
                height: 1.55,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({
    required String number,
    required String title,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: const TextStyle(
            color: primaryBlue,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: textDark,
              fontSize: 19,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF455A64),
        fontSize: 14,
        height: 1.7,
      ),
    );
  }

  Widget _buildExampleText(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        text,
        style: const TextStyle(
          color: textGrey,
          fontSize: 12,
          height: 1.5,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _diagramContainer({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      height: 190,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: borderGrey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  Widget _node({
    required String label,
    IconData icon = Icons.computer_rounded,
    double size = 44,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: lightBlue,
            border: Border.all(
              color: const Color(0xFFB8D2EE),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: primaryBlue,
            size: size * 0.5,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: textDark,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _line({
    double width = 45,
    double height = 2,
  }) {
    return Container(
      width: width,
      height: height,
      color: primaryBlue,
    );
  }

  Widget _buildStarDiagram() {
    return _diagramContainer(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 74,
            height: 54,
            decoration: BoxDecoration(
              color: darkBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.hub_rounded,
                  color: Colors.white,
                  size: 23,
                ),
                SizedBox(height: 2),
                Text(
                  'SWITCH',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 5,
            child: _node(label: 'PC 1'),
          ),
          Positioned(
            bottom: 5,
            child: _node(label: 'PC 2'),
          ),
          Positioned(
            left: 20,
            child: _node(label: 'PC 3'),
          ),
          Positioned(
            right: 20,
            child: _node(label: 'PC 4'),
          ),
        ],
      ),
    );
  }

  Widget _buildBusDiagram() {
    return _diagramContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 2,
            width: 245,
            color: primaryBlue,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _node(label: 'PC 1', size: 38),
              _node(label: 'PC 2', size: 38),
              _node(label: 'PC 3', size: 38),
              _node(label: 'PC 4', size: 38),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Satu jalur utama digunakan bersama',
            style: TextStyle(
              color: textGrey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRingDiagram() {
    return _diagramContainer(
      child: Center(
        child: SizedBox(
          width: 200,
          height: 155,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 105,
                height: 105,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryBlue,
                    width: 2,
                  ),
                ),
              ),
              Positioned(
                top: 5,
                child: _node(label: 'PC 1', size: 38),
              ),
              Positioned(
                right: 5,
                child: _node(label: 'PC 2', size: 38),
              ),
              Positioned(
                bottom: 5,
                child: _node(label: 'PC 3', size: 38),
              ),
              Positioned(
                left: 5,
                child: _node(label: 'PC 4', size: 38),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeshDiagram() {
    return _diagramContainer(
      child: Center(
        child: SizedBox(
          width: 240,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 20,
                left: 45,
                child: _line(width: 150),
              ),
              Positioned(
                bottom: 20,
                left: 45,
                child: _line(width: 150),
              ),
              Positioned(
                left: 35,
                top: 48,
                child: Transform.rotate(
                  angle: 0.45,
                  child: _line(width: 115),
                ),
              ),
              Positioned(
                right: 35,
                top: 48,
                child: Transform.rotate(
                  angle: -0.45,
                  child: _line(width: 115),
                ),
              ),
              Positioned(
                left: 10,
                top: 50,
                child: _node(label: 'PC 1', size: 40),
              ),
              Positioned(
                right: 10,
                top: 50,
                child: _node(label: 'PC 2', size: 40),
              ),
              Positioned(
                left: 100,
                bottom: 0,
                child: _node(label: 'PC 3', size: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTreeDiagram() {
    return _diagramContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _node(
            label: 'Pusat',
            icon: Icons.hub_rounded,
            size: 42,
          ),
          Container(
            width: 2,
            height: 18,
            color: primaryBlue,
          ),
          Container(
            width: 150,
            height: 2,
            color: primaryBlue,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _node(label: 'PC 1', size: 38),
              _node(label: 'PC 2', size: 38),
              _node(label: 'PC 3', size: 38),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHybridDiagram() {
    return _diagramContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _node(
                label: 'Switch',
                icon: Icons.hub_rounded,
                size: 48,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _node(label: 'PC 1', size: 36),
                  const SizedBox(width: 8),
                  _node(label: 'PC 2', size: 36),
                ],
              ),
            ],
          ),
          const SizedBox(width: 18),
          _line(width: 35),
          const SizedBox(width: 18),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _node(
                label: 'Jaringan',
                icon: Icons.account_tree_rounded,
                size: 48,
              ),
              const SizedBox(height: 12),
              _node(label: 'PC 3', size: 36),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: borderGrey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Topologi',
            style: TextStyle(
              color: textDark,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          _summaryRow('Star', 'Memiliki perangkat pusat'),
          _summaryDivider(),
          _summaryRow('Bus', 'Menggunakan satu jalur utama'),
          _summaryDivider(),
          _summaryRow('Ring', 'Membentuk jalur melingkar'),
          _summaryDivider(),
          _summaryRow('Mesh', 'Memiliki banyak jalur koneksi'),
          _summaryDivider(),
          _summaryRow('Tree', 'Memiliki struktur bertingkat'),
          _summaryDivider(),
          _summaryRow('Hybrid', 'Gabungan beberapa topologi'),
        ],
      ),
    );
  }

  Widget _summaryRow(
      String name,
      String description,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 62,
            child: Text(
              name,
              style: const TextStyle(
                color: darkBlue,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(
                color: textGrey,
                fontSize: 11.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryDivider() {
    return const Divider(
      height: 1,
      color: borderGrey,
    );
  }

  Widget _buildKeyPoint() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: darkBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'POIN PENTING',
            style: TextStyle(
              color: Color(0xFF90CAF9),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 9),
          Text(
            'Topologi merupakan pola hubungan antarperangkat '
                'dalam jaringan. Setiap topologi memiliki bentuk '
                'dan karakteristik koneksi yang berbeda.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.55,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 18,
            ),
            label: const Text('Sebelumnya'),
            style: OutlinedButton.styleFrom(
              foregroundColor: textGrey,
              minimumSize: const Size(0, 48),
              side: const BorderSide(
                color: borderGrey,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              if (onNext != null) {
                onNext!();
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProtokolJaringanScreen(),
                  ),
                );
              }
            },
            icon: const Icon(
              Icons.arrow_forward_rounded,
              size: 18,
            ),
            label: const Text('Berikutnya'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 48),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}