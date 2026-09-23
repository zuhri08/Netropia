import 'package:flutter/material.dart';
import 'cara_kerja_jaringan_screen.dart';
class TujuanManfaatScreen extends StatelessWidget {
  final VoidCallback? onNext;

  const TujuanManfaatScreen({
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
              '02 / 08',
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
              widthFactor: 0.25,
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

              _buildMainIllustration(),

              const SizedBox(height: 30),

              _buildSectionTitle(
                number: '01',
                title: 'Tujuan Jaringan Komputer',
              ),

              const SizedBox(height: 12),

              _buildParagraph(
                'Jaringan komputer dibuat agar perangkat dapat '
                    'saling terhubung dan berkomunikasi. Dengan jaringan, '
                    'proses pertukaran informasi dan penggunaan sumber '
                    'daya dapat dilakukan dengan lebih mudah.',
              ),

              const SizedBox(height: 22),

              _buildPurpose(
                number: '01',
                icon: Icons.devices_other_rounded,
                title: 'Menghubungkan perangkat',
                description:
                'Menghubungkan komputer, server, printer, '
                    'dan perangkat jaringan agar dapat berkomunikasi.',
              ),

              _buildPurpose(
                number: '02',
                icon: Icons.swap_horiz_rounded,
                title: 'Mempermudah pertukaran data',
                description:
                'Memungkinkan data dikirim dan diterima '
                    'antarperangkat yang terhubung dalam jaringan.',
              ),

              _buildPurpose(
                number: '03',
                icon: Icons.share_rounded,
                title: 'Berbagi sumber daya',
                description:
                'Sumber daya seperti printer, penyimpanan, '
                    'dan koneksi jaringan dapat digunakan bersama.',
              ),

              const SizedBox(height: 28),

              _buildSectionTitle(
                number: '02',
                title: 'Manfaat Jaringan',
              ),

              const SizedBox(height: 16),

              _buildBenefit(
                icon: Icons.speed_rounded,
                title: 'Efisiensi',
                description:
                'Pekerjaan dapat dilakukan dengan lebih efisien '
                    'karena perangkat dan sumber daya dapat digunakan bersama.',
              ),

              _buildBenefit(
                icon: Icons.forum_outlined,
                title: 'Komunikasi',
                description:
                'Pengguna dapat bertukar informasi melalui perangkat '
                    'yang saling terhubung.',
              ),

              _buildBenefit(
                icon: Icons.print_rounded,
                title: 'Berbagi perangkat',
                description:
                'Satu perangkat seperti printer dapat digunakan '
                    'oleh beberapa komputer dalam jaringan.',
              ),

              _buildBenefit(
                icon: Icons.folder_shared_outlined,
                title: 'Berbagi file',
                description:
                'File dapat disimpan dan dibagikan kepada perangkat '
                    'atau pengguna lain sesuai kebutuhan.',
              ),

              const SizedBox(height: 28),

              _buildExample(),

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
            'MATERI 02',
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
          'Tujuan dan Manfaat\nJaringan',
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
          'Memahami alasan jaringan komputer digunakan '
              'dan manfaatnya dalam kehidupan sehari-hari.',
          style: TextStyle(
            color: textGrey,
            fontSize: 15,
            height: 1.55,
          ),
        ),
      ],
    );
  }

  Widget _buildMainIllustration() {
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
              'Jaringan menghubungkan perangkat dan sumber daya',
              style: TextStyle(
                color: textDark,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 22),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _networkDevice(
                icon: Icons.computer_rounded,
                label: 'Komputer',
              ),
              _networkDevice(
                icon: Icons.print_rounded,
                label: 'Printer',
              ),
              _networkDevice(
                icon: Icons.storage_rounded,
                label: 'Server',
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.hub_rounded,
                  color: primaryBlue,
                  size: 19,
                ),
                SizedBox(width: 8),
                Text(
                  'Terhubung dalam satu jaringan',
                  style: TextStyle(
                    color: darkBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _networkDevice({
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
          child: Icon(
            icon,
            color: primaryBlue,
            size: 27,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          label,
          style: const TextStyle(
            color: textDark,
            fontSize: 10,
            fontWeight: FontWeight.w600,
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

  Widget _buildPurpose({
    required String number,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
            width: 38,
            height: 38,
            alignment: Alignment.center,
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
                Row(
                  children: [
                    Text(
                      number,
                      style: const TextStyle(
                        color: primaryBlue,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: textDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
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

  Widget _buildBenefit({
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

  Widget _buildExample() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F8),
        border: Border.all(
          color: borderGrey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contoh di Laboratorium Komputer',
            style: TextStyle(
              color: textDark,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 9),
          Text(
            'Beberapa komputer dapat menggunakan satu '
                'printer yang terhubung ke jaringan. Siswa '
                'tidak perlu menyediakan printer untuk setiap '
                'komputer.',
            style: TextStyle(
              color: textGrey,
              fontSize: 12.5,
              height: 1.6,
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
            'Tujuan utama jaringan adalah menghubungkan '
                'perangkat, mempermudah komunikasi dan pertukaran '
                'data, serta memungkinkan penggunaan sumber daya '
                'secara bersama.',
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
                    builder: (context) => const CaraKerjaJaringanScreen(),
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