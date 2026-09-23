import 'package:flutter/material.dart';
import 'topologi_jaringan_screen.dart';
class JenisJaringanScreen extends StatelessWidget {
  final VoidCallback? onNext;

  const JenisJaringanScreen({
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
              '04 / 08',
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
              widthFactor: 0.50,
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

              _buildScopeDiagram(),

              const SizedBox(height: 30),

              _buildSectionTitle(
                number: '01',
                title: 'LAN — Local Area Network',
              ),

              const SizedBox(height: 12),

              _buildParagraph(
                'LAN adalah jaringan yang digunakan dalam wilayah '
                    'yang relatif terbatas, misalnya ruang kelas, '
                    'laboratorium komputer, rumah, atau satu gedung.',
              ),

              const SizedBox(height: 16),

              _buildExample(
                icon: Icons.school_rounded,
                title: 'Contoh',
                description:
                'Jaringan komputer di laboratorium sekolah '
                    'yang menghubungkan beberapa komputer.',
              ),

              const SizedBox(height: 28),

              _buildSectionTitle(
                number: '02',
                title: 'MAN — Metropolitan Area Network',
              ),

              const SizedBox(height: 12),

              _buildParagraph(
                'MAN mencakup wilayah yang lebih luas dibandingkan '
                    'LAN. Jaringan ini dapat menghubungkan beberapa '
                    'jaringan dalam satu wilayah kota atau kawasan.',
              ),

              const SizedBox(height: 16),

              _buildExample(
                icon: Icons.location_city_rounded,
                title: 'Contoh',
                description:
                'Jaringan yang menghubungkan beberapa lokasi '
                    'atau gedung dalam suatu kawasan perkotaan.',
              ),

              const SizedBox(height: 28),

              _buildSectionTitle(
                number: '03',
                title: 'WAN — Wide Area Network',
              ),

              const SizedBox(height: 12),

              _buildParagraph(
                'WAN mencakup wilayah geografis yang sangat luas '
                    'dan dapat menghubungkan jaringan yang berada '
                    'di lokasi yang berjauhan.',
              ),

              const SizedBox(height: 16),

              _buildExample(
                icon: Icons.public_rounded,
                title: 'Contoh',
                description:
                'Jaringan yang menghubungkan kantor atau '
                    'cabang organisasi yang berada di kota berbeda.',
              ),

              const SizedBox(height: 28),

              _buildSectionTitle(
                number: '04',
                title: 'Internet',
              ),

              const SizedBox(height: 12),

              _buildParagraph(
                'Internet merupakan jaringan global yang '
                    'menghubungkan berbagai jaringan dan perangkat '
                    'di seluruh dunia.',
              ),

              const SizedBox(height: 16),

              _buildExample(
                icon: Icons.language_rounded,
                title: 'Contoh',
                description:
                'Saat mengakses situs web, mengirim email, '
                    'atau menggunakan layanan online melalui internet.',
              ),

              const SizedBox(height: 30),

              _buildComparison(),

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
            'MATERI 04',
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
          'Jenis-Jenis Jaringan',
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
          'Mengenal jenis jaringan berdasarkan luas wilayah '
              'yang dapat dijangkau oleh jaringan tersebut.',
          style: TextStyle(
            color: textGrey,
            fontSize: 15,
            height: 1.55,
          ),
        ),
      ],
    );
  }

  Widget _buildScopeDiagram() {
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
              'Cakupan jaringan',
              style: TextStyle(
                color: textDark,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 22),

          _scopeRow(
            label: 'LAN',
            description: 'Area kecil',
            widthFactor: 0.28,
          ),

          const SizedBox(height: 10),

          _scopeRow(
            label: 'MAN',
            description: 'Area kota',
            widthFactor: 0.48,
          ),

          const SizedBox(height: 10),

          _scopeRow(
            label: 'WAN',
            description: 'Area sangat luas',
            widthFactor: 0.70,
          ),

          const SizedBox(height: 10),

          _scopeRow(
            label: 'Internet',
            description: 'Global',
            widthFactor: 0.92,
          ),

          const SizedBox(height: 16),

          const Text(
            'Semakin luas cakupan, semakin besar wilayah '
                'yang dapat dihubungkan.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textGrey,
              fontSize: 11,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _scopeRow({
    required String label,
    required String description,
    required double widthFactor,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 58,
          child: Text(
            label,
            style: const TextStyle(
              color: darkBlue,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: widthFactor,
              child: Container(
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: lightBlue,
                  border: Border.all(
                    color: const Color(0xFFB8D2EE),
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  description,
                  style: const TextStyle(
                    color: primaryBlue,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
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

  Widget _buildExample({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F8),
        border: Border.all(
          color: borderGrey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
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
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 12,
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

  Widget _buildComparison() {
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
            'Ringkasan',
            style: TextStyle(
              color: textDark,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 14),

          _comparisonRow(
            'LAN',
            'Wilayah kecil',
          ),

          _comparisonDivider(),

          _comparisonRow(
            'MAN',
            'Wilayah kota',
          ),

          _comparisonDivider(),

          _comparisonRow(
            'WAN',
            'Wilayah luas',
          ),

          _comparisonDivider(),

          _comparisonRow(
            'Internet',
            'Jaringan global',
          ),
        ],
      ),
    );
  }

  Widget _comparisonRow(
      String type,
      String coverage,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            type,
            style: const TextStyle(
              color: darkBlue,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            coverage,
            style: const TextStyle(
              color: textGrey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _comparisonDivider() {
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
            'Jenis jaringan dapat dibedakan berdasarkan '
                'luas wilayah yang dicakup, mulai dari LAN '
                'untuk area kecil hingga jaringan global seperti internet.',
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
                    builder: (context) => const TopologiJaringanScreen(),
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