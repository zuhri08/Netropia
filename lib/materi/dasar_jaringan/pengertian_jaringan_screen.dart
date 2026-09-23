import 'package:flutter/material.dart';
import 'tujuan_manfaat_screen.dart';
class PengertianJaringanScreen extends StatelessWidget {
  final VoidCallback? onNext;

  const PengertianJaringanScreen({
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
              '01 / 08',
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
              widthFactor: 0.125,
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

              _buildNetworkDiagram(),

              const SizedBox(height: 30),

              _buildSectionTitle(
                number: '01',
                title: 'Apa Itu Jaringan Komputer?',
              ),

              const SizedBox(height: 12),

              _buildParagraph(
                'Jaringan komputer adalah sekumpulan dua atau lebih '
                    'perangkat yang saling terhubung sehingga dapat '
                    'berkomunikasi dan bertukar data.',
              ),

              const SizedBox(height: 14),

              _buildInfoBox(),

              const SizedBox(height: 30),

              _buildSectionTitle(
                number: '02',
                title: 'Contoh Sederhana',
              ),

              const SizedBox(height: 12),

              _buildParagraph(
                'Di laboratorium komputer sekolah, beberapa komputer '
                    'dapat dihubungkan menggunakan perangkat jaringan. '
                    'Dengan adanya hubungan tersebut, komputer dapat '
                    'berkomunikasi dan menggunakan sumber daya jaringan.',
              ),

              const SizedBox(height: 18),

              _buildSimpleExample(),

              const SizedBox(height: 30),

              _buildSectionTitle(
                number: '03',
                title: 'Mengapa Jaringan Dibutuhkan?',
              ),

              const SizedBox(height: 14),

              _buildPoint(
                icon: Icons.swap_horiz_rounded,
                title: 'Berbagi data',
                description:
                'Data dapat dikirim dari satu perangkat ke perangkat lain.',
              ),

              _buildPoint(
                icon: Icons.devices_rounded,
                title: 'Menghubungkan perangkat',
                description:
                'Beberapa komputer dan perangkat dapat saling terhubung.',
              ),

              _buildPoint(
                icon: Icons.share_rounded,
                title: 'Berbagi sumber daya',
                description:
                'Perangkat seperti printer atau penyimpanan dapat digunakan bersama.',
              ),

              const SizedBox(height: 30),

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
        Row(
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
                'MATERI 01',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        const Text(
          'Pengertian Jaringan\nKomputer',
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
          'Memahami konsep dasar jaringan komputer '
              'dan bagaimana perangkat dapat saling terhubung.',
          style: TextStyle(
            color: textGrey,
            fontSize: 15,
            height: 1.55,
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkDiagram() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: borderGrey,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Gambaran sederhana jaringan',
              style: TextStyle(
                color: textDark,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _device(
                icon: Icons.computer_rounded,
                label: 'PC 1',
              ),
              _connectionLine(),
              _networkCenter(),
              _connectionLine(),
              _device(
                icon: Icons.computer_rounded,
                label: 'PC 2',
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            width: 150,
            height: 1,
            color: borderGrey,
          ),

          const SizedBox(height: 12),

          const Text(
            'Perangkat terhubung melalui jaringan',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textGrey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _device({
    required IconData icon,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: lightBlue,
            border: Border.all(
              color: const Color(0xFFB8D2EE),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.computer_rounded,
            color: primaryBlue,
            size: 28,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          label,
          style: const TextStyle(
            color: textDark,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _connectionLine() {
    return Container(
      width: 24,
      height: 2,
      color: primaryBlue,
    );
  }

  Widget _networkCenter() {
    return Column(
      children: [
        Container(
          width: 66,
          height: 52,
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
      ],
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

  Widget _buildInfoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightBlue,
        border: const Border(
          left: BorderSide(
            color: primaryBlue,
            width: 4,
          ),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: primaryBlue,
            size: 22,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Intinya, jaringan komputer memungkinkan '
                  'perangkat yang berbeda untuk saling berkomunikasi.',
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

  Widget _buildSimpleExample() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: borderGrey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _smallDevice('PC A'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: primaryBlue,
                  size: 20,
                ),
              ),
              _smallDevice('Switch'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: primaryBlue,
                  size: 20,
                ),
              ),
              _smallDevice('PC B'),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Contoh hubungan sederhana antarperangkat',
            style: TextStyle(
              color: textGrey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallDevice(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F8),
        border: Border.all(
          color: borderGrey,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: textDark,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildPoint({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: primaryBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: textGrey,
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
            'Jaringan komputer menghubungkan '
                'dua atau lebih perangkat agar dapat '
                'saling berkomunikasi dan bertukar data.',
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
            onPressed: null,
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
                    builder: (context) => const TujuanManfaatScreen(),
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