import 'package:flutter/material.dart';
import 'penerapan_jaringan_screen.dart';
class KeamananJaringanScreen extends StatelessWidget {
  final VoidCallback? onNext;

  const KeamananJaringanScreen({
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
              '07 / 08',
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
              widthFactor: 0.875,
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
                title: 'Apa Itu Keamanan Jaringan?',
              ),
              const SizedBox(height: 12),

              _buildParagraph(
                'Keamanan jaringan adalah upaya untuk melindungi '
                    'perangkat, data, dan komunikasi dalam jaringan '
                    'dari akses atau tindakan yang tidak diizinkan.',
              ),

              const SizedBox(height: 18),

              _buildSecurityDiagram(),

              const SizedBox(height: 30),

              _buildSectionTitle(
                number: '02',
                title: 'Mengapa Keamanan Jaringan Penting?',
              ),
              const SizedBox(height: 12),

              _buildParagraph(
                'Jaringan digunakan untuk bertukar informasi dan '
                    'mengakses berbagai sumber daya. Jika tidak '
                    'dilindungi dengan baik, data dan perangkat dapat '
                    'mengalami berbagai risiko.',
              ),

              const SizedBox(height: 16),

              _buildRiskItem(
                icon: Icons.lock_outline_rounded,
                title: 'Melindungi Data',
                description:
                'Membantu menjaga informasi agar tidak '
                    'diakses oleh pihak yang tidak berwenang.',
              ),

              const SizedBox(height: 10),

              _buildRiskItem(
                icon: Icons.devices_other_rounded,
                title: 'Melindungi Perangkat',
                description:
                'Mengurangi risiko penggunaan perangkat '
                    'jaringan oleh pihak yang tidak memiliki izin.',
              ),

              const SizedBox(height: 10),

              _buildRiskItem(
                icon: Icons.wifi_rounded,
                title: 'Menjaga Komunikasi',
                description:
                'Membantu menjaga proses pertukaran data '
                    'agar tetap aman.',
              ),

              const SizedBox(height: 30),

              _buildSectionTitle(
                number: '03',
                title: 'Bentuk Perlindungan Dasar',
              ),
              const SizedBox(height: 12),

              _buildProtectionCard(
                icon: Icons.password_rounded,
                title: 'Password',
                description:
                'Gunakan password yang kuat dan jangan '
                    'membagikannya kepada orang lain.',
              ),

              const SizedBox(height: 12),

              _buildProtectionCard(
                icon: Icons.person_outline_rounded,
                title: 'Autentikasi',
                description:
                'Pastikan pengguna yang mengakses sistem '
                    'merupakan pengguna yang memiliki izin.',
              ),

              const SizedBox(height: 12),

              _buildProtectionCard(
                icon: Icons.admin_panel_settings_outlined,
                title: 'Hak Akses',
                description:
                'Atur hak akses sesuai dengan kebutuhan '
                    'masing-masing pengguna.',
              ),

              const SizedBox(height: 12),

              _buildProtectionCard(
                icon: Icons.security_rounded,
                title: 'Firewall',
                description:
                'Firewall dapat membantu mengontrol '
                    'komunikasi jaringan berdasarkan aturan '
                    'yang telah ditentukan.',
              ),

              const SizedBox(height: 30),

              _buildSectionTitle(
                number: '04',
                title: 'Kebiasaan Aman Saat Menggunakan Jaringan',
              ),
              const SizedBox(height: 14),

              _buildSafetyChecklist(),

              const SizedBox(height: 30),

              _buildSectionTitle(
                number: '05',
                title: 'Contoh di Laboratorium TKJ',
              ),
              const SizedBox(height: 12),

              _buildParagraph(
                'Di laboratorium komputer, keamanan jaringan '
                    'dapat diterapkan dengan menggunakan akun '
                    'masing-masing, menjaga password, membatasi '
                    'hak akses, dan tidak sembarangan memasang '
                    'perangkat atau aplikasi ke jaringan.',
              ),

              const SizedBox(height: 18),

              _buildLabExample(),

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
            'MATERI 07',
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
          'Keamanan Jaringan',
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
          'Mengenal cara dasar melindungi jaringan, '
              'perangkat, dan data dari akses yang tidak diizinkan.',
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
            Icons.shield_outlined,
            color: primaryBlue,
            size: 23,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Keamanan jaringan bukan hanya tentang '
                  'teknologi. Kebiasaan pengguna juga menjadi '
                  'bagian penting dalam menjaga keamanan.',
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

  Widget _buildSecurityDiagram() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: borderGrey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Text(
            'Gambaran perlindungan jaringan',
            style: TextStyle(
              color: textDark,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _securityNode(
                  icon: Icons.computer_rounded,
                  label: 'Perangkat',
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                color: primaryBlue,
                size: 22,
              ),
              Expanded(
                child: _securityNode(
                  icon: Icons.security_rounded,
                  label: 'Perlindungan',
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                color: primaryBlue,
                size: 22,
              ),
              Expanded(
                child: _securityNode(
                  icon: Icons.storage_rounded,
                  label: 'Data',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _securityNode({
    required IconData icon,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: lightBlue,
            border: Border.all(
              color: const Color(0xFFB8D2EE),
            ),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            icon,
            color: primaryBlue,
            size: 25,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: textDark,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildRiskItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: borderGrey,
        ),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: primaryBlue,
            size: 22,
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
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 11.5,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProtectionCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: borderGrey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: primaryBlue,
              size: 21,
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
                    color: darkBlue,
                    fontSize: 14,
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

  Widget _buildSafetyChecklist() {
    final items = [
      'Gunakan password yang kuat.',
      'Jangan membagikan password kepada orang lain.',
      'Gunakan akun sesuai dengan hak akses.',
      'Berhati-hati saat membuka tautan atau file yang tidak dikenal.',
      'Jaga perangkat jaringan dan komputer tetap aman.',
    ];

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
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: primaryBlue,
                    size: 15,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: textGrey,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLabExample() {
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: const Color(0xFFB8D2EE),
              ),
            ),
            child: const Icon(
              Icons.computer_rounded,
              color: primaryBlue,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contoh sederhana',
                  style: TextStyle(
                    color: darkBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Siswa menggunakan akun masing-masing '
                      'untuk mengakses komputer laboratorium '
                      'dan tidak menggunakan akun milik siswa lain.',
                  style: TextStyle(
                    color: textGrey,
                    fontSize: 11.5,
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
            'Ringkasan',
            style: TextStyle(
              color: textDark,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),

          _summaryRow(
            'Keamanan',
            'Melindungi jaringan, perangkat, dan data.',
          ),

          _summaryDivider(),

          _summaryRow(
            'Password',
            'Digunakan untuk membantu menjaga akses.',
          ),

          _summaryDivider(),

          _summaryRow(
            'Autentikasi',
            'Memastikan identitas pengguna.',
          ),

          _summaryDivider(),

          _summaryRow(
            'Hak Akses',
            'Mengatur sumber daya yang dapat digunakan.',
          ),

          _summaryDivider(),

          _summaryRow(
            'Firewall',
            'Mengontrol komunikasi jaringan berdasarkan aturan.',
          ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 82,
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
                height: 1.4,
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
            'Keamanan jaringan dilakukan untuk melindungi '
                'data, perangkat, dan komunikasi. Password, '
                'autentikasi, hak akses, firewall, dan kebiasaan '
                'pengguna yang aman merupakan bagian dari '
                'perlindungan jaringan.',
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
              builder: (context) => const PenerapanJaringanScreen(),
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