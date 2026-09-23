import 'package:flutter/material.dart';

class PenerapanJaringanScreen extends StatelessWidget {
  final VoidCallback? onNext;

  const PenerapanJaringanScreen({
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
              '08 / 08',
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
            color: primaryBlue,
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
                title: 'Jaringan di Lingkungan Sekolah',
              ),
              const SizedBox(height: 12),

              _buildParagraph(
                'Jaringan komputer banyak digunakan di sekolah '
                    'untuk menghubungkan komputer, printer, server, '
                    'dan perangkat lainnya. Jaringan membantu proses '
                    'pembelajaran dan pengelolaan informasi menjadi '
                    'lebih mudah.',
              ),

              const SizedBox(height: 18),

              _buildSchoolNetwork(),

              const SizedBox(height: 30),

              _buildSectionTitle(
                number: '02',
                title: 'Jaringan di Rumah',
              ),
              const SizedBox(height: 12),

              _buildParagraph(
                'Di rumah, jaringan dapat digunakan untuk '
                    'menghubungkan berbagai perangkat seperti '
                    'komputer, laptop, smartphone, televisi pintar, '
                    'dan perangkat lainnya ke jaringan lokal atau '
                    'internet.',
              ),

              const SizedBox(height: 18),

              _buildHomeNetwork(),

              const SizedBox(height: 30),

              _buildSectionTitle(
                number: '03',
                title: 'Jaringan di Perusahaan',
              ),
              const SizedBox(height: 12),

              _buildParagraph(
                'Perusahaan menggunakan jaringan untuk '
                    'menghubungkan komputer dan berbagai sumber '
                    'daya agar karyawan dapat bertukar informasi '
                    'dan menggunakan layanan jaringan sesuai '
                    'kebutuhan.',
              ),

              const SizedBox(height: 16),

              _buildCompanyItem(
                icon: Icons.folder_shared_rounded,
                title: 'Berbagi Data',
                description:
                'Karyawan dapat bertukar dan mengakses '
                    'data melalui jaringan sesuai hak akses.',
              ),

              const SizedBox(height: 10),

              _buildCompanyItem(
                icon: Icons.print_rounded,
                title: 'Berbagi Perangkat',
                description:
                'Perangkat seperti printer dapat digunakan '
                    'oleh beberapa komputer dalam jaringan.',
              ),

              const SizedBox(height: 10),

              _buildCompanyItem(
                icon: Icons.storage_rounded,
                title: 'Mengakses Server',
                description:
                'Komputer dapat terhubung ke server untuk '
                    'menggunakan layanan atau menyimpan data.',
              ),

              const SizedBox(height: 30),

              _buildSectionTitle(
                number: '04',
                title: 'Jaringan dan Internet',
              ),
              const SizedBox(height: 12),

              _buildParagraph(
                'Internet merupakan jaringan global yang '
                    'menghubungkan banyak jaringan dan perangkat '
                    'di berbagai lokasi. Dengan internet, pengguna '
                    'dapat mengakses berbagai layanan dan informasi.',
              ),

              const SizedBox(height: 18),

              _buildInternetFlow(),

              const SizedBox(height: 30),

              _buildSectionTitle(
                number: '05',
                title: 'Contoh Penerapan dalam Kehidupan',
              ),
              const SizedBox(height: 14),

              _buildApplicationCard(
                icon: Icons.school_rounded,
                title: 'Pembelajaran',
                description:
                'Mengakses materi pembelajaran, platform '
                    'belajar, dan sumber informasi melalui jaringan.',
              ),

              const SizedBox(height: 10),

              _buildApplicationCard(
                icon: Icons.chat_rounded,
                title: 'Komunikasi',
                description:
                'Menggunakan email, pesan instan, dan '
                    'layanan komunikasi lainnya.',
              ),

              const SizedBox(height: 10),

              _buildApplicationCard(
                icon: Icons.cloud_rounded,
                title: 'Penyimpanan Data',
                description:
                'Mengakses penyimpanan atau layanan berbasis '
                    'jaringan untuk menyimpan dan mengambil data.',
              ),

              const SizedBox(height: 10),

              _buildApplicationCard(
                icon: Icons.business_rounded,
                title: 'Perkantoran',
                description:
                'Menghubungkan komputer dan perangkat '
                    'untuk mendukung aktivitas pekerjaan.',
              ),

              const SizedBox(height: 30),

              _buildSectionTitle(
                number: '06',
                title: 'Penerapan dalam Praktik TKJ',
              ),
              const SizedBox(height: 12),

              _buildParagraph(
                'Sebagai siswa TKJ, pemahaman jaringan dapat '
                    'diterapkan melalui kegiatan seperti membuat '
                    'jaringan lokal, menghubungkan perangkat, '
                    'mengatur alamat jaringan, melakukan pengujian, '
                    'dan menangani masalah koneksi.',
              ),

              const SizedBox(height: 18),

              _buildTkjFlow(),

              const SizedBox(height: 30),

              _buildSummary(),

              const SizedBox(height: 28),

              _buildKeyPoint(),

              const SizedBox(height: 30),

              _buildCompletion(),

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
            'MATERI 08',
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
          'Penerapan Jaringan',
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
          'Melihat bagaimana konsep jaringan komputer '
              'diterapkan dalam kehidupan sehari-hari dan praktik TKJ.',
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
            Icons.public_rounded,
            color: primaryBlue,
            size: 23,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Jaringan komputer tidak hanya digunakan '
                  'di laboratorium. Jaringan telah menjadi bagian '
                  'dari sekolah, rumah, perusahaan, hingga layanan '
                  'internet yang digunakan sehari-hari.',
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

  Widget _buildSchoolNetwork() {
    return _buildNetworkIllustration(
      title: 'Contoh jaringan sekolah',
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
        _networkDevice(
          icon: Icons.wifi_rounded,
          label: 'Wi-Fi',
        ),
      ],
    );
  }

  Widget _buildHomeNetwork() {
    return _buildNetworkIllustration(
      title: 'Contoh jaringan rumah',
      children: [
        _networkDevice(
          icon: Icons.router_rounded,
          label: 'Router',
        ),
        _networkDevice(
          icon: Icons.laptop_rounded,
          label: 'Laptop',
        ),
        _networkDevice(
          icon: Icons.smartphone_rounded,
          label: 'Smartphone',
        ),
        _networkDevice(
          icon: Icons.tv_rounded,
          label: 'Smart TV',
        ),
      ],
    );
  }

  Widget _buildNetworkIllustration({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: borderGrey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: textDark,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 14,
            children: children,
          ),
        ],
      ),
    );
  }

  Widget _networkDevice({
    required IconData icon,
    required String label,
  }) {
    return SizedBox(
      width: 70,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
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
              size: 24,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textGrey,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyItem({
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

  Widget _buildInternetFlow() {
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
            'Gambaran sederhana',
            style: TextStyle(
              color: textDark,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _flowBox(
                icon: Icons.computer_rounded,
                label: 'Perangkat',
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: primaryBlue,
                  size: 18,
                ),
              ),
              _flowBox(
                icon: Icons.router_rounded,
                label: 'Jaringan',
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: primaryBlue,
                  size: 18,
                ),
              ),
              _flowBox(
                icon: Icons.public_rounded,
                label: 'Internet',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _flowBox({
    required IconData icon,
    required String label,
  }) {
    return Container(
      width: 72,
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: lightBlue,
        border: Border.all(
          color: const Color(0xFFB8D2EE),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: primaryBlue,
            size: 21,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: primaryBlue,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationCard({
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

  Widget _buildTkjFlow() {
    final steps = [
      {
        'number': '1',
        'title': 'Rancang',
        'description': 'Menentukan kebutuhan jaringan.',
      },
      {
        'number': '2',
        'title': 'Bangun',
        'description': 'Menghubungkan perangkat.',
      },
      {
        'number': '3',
        'title': 'Konfigurasi',
        'description': 'Mengatur jaringan sesuai kebutuhan.',
      },
      {
        'number': '4',
        'title': 'Uji',
        'description': 'Memastikan jaringan dapat bekerja.',
      },
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
        children: steps.map((step) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                      color: const Color(0xFFB8D2EE),
                    ),
                  ),
                  child: Text(
                    step['number']!,
                    style: const TextStyle(
                      color: primaryBlue,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step['title']!,
                        style: const TextStyle(
                          color: textDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        step['description']!,
                        style: const TextStyle(
                          color: textGrey,
                          fontSize: 11.5,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
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
            'Sekolah',
            'Jaringan membantu kegiatan pembelajaran '
                'dan pengelolaan perangkat.',
          ),

          _summaryDivider(),

          _summaryRow(
            'Rumah',
            'Menghubungkan berbagai perangkat '
                'ke jaringan lokal atau internet.',
          ),

          _summaryDivider(),

          _summaryRow(
            'Perusahaan',
            'Mendukung pertukaran data dan penggunaan '
                'sumber daya jaringan.',
          ),

          _summaryDivider(),

          _summaryRow(
            'TKJ',
            'Konsep jaringan diterapkan melalui '
                'perancangan, konfigurasi, dan pengujian.',
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
            width: 76,
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
            'Jaringan komputer diterapkan di berbagai '
                'lingkungan seperti sekolah, rumah, dan '
                'perusahaan. Sebagai siswa TKJ, konsep tersebut '
                'dapat diterapkan melalui kegiatan merancang, '
                'membangun, mengonfigurasi, dan menguji jaringan.',
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

  Widget _buildCompletion() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: lightBlue,
        border: Border.all(
          color: const Color(0xFFD1E3F5),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: primaryBlue,
            size: 34,
          ),
          SizedBox(height: 10),
          Text(
            'Materi Dasar Jaringan Selesai',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: darkBlue,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Kamu telah menyelesaikan 8 materi dasar '
                'tentang jaringan komputer.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textGrey,
              fontSize: 12,
              height: 1.5,
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
                Navigator.pop(context);
              }
            },
            icon: const Icon(
              Icons.check_rounded,
              size: 18,
            ),
            label: const Text('Selesai'),
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