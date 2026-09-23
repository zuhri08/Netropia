import 'package:flutter/material.dart';
import 'keamanan_jaringan_screen.dart';
class ProtokolJaringanScreen extends StatelessWidget {
  final VoidCallback? onNext;

  const ProtokolJaringanScreen({
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
              '06 / 08',
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
              widthFactor: 0.75,
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
                title: 'Apa Itu Protokol Jaringan?',
              ),

              const SizedBox(height: 12),

              _buildParagraph(
                'Protokol jaringan adalah aturan dan ketentuan '
                    'yang digunakan agar perangkat dapat saling '
                    'berkomunikasi dalam sebuah jaringan.',
              ),

              const SizedBox(height: 18),

              _buildCommunicationDiagram(),

              const SizedBox(height: 30),

              _buildSectionTitle(
                number: '02',
                title: 'TCP/IP',
              ),

              const SizedBox(height: 12),

              _buildParagraph(
                'TCP/IP merupakan kumpulan protokol yang menjadi '
                    'dasar komunikasi pada jaringan komputer dan '
                    'internet. TCP dan IP memiliki peran yang berbeda '
                    'dalam proses komunikasi data.',
              ),

              const SizedBox(height: 16),

              _buildProtocolCard(
                icon: Icons.data_object_rounded,
                title: 'TCP',
                description:
                'Membantu memastikan data dapat dikirim '
                    'dengan baik dan diterima sesuai urutan.',
              ),

              const SizedBox(height: 12),

              _buildProtocolCard(
                icon: Icons.location_on_rounded,
                title: 'IP',
                description:
                'Digunakan untuk memberikan alamat dan '
                    'membantu menentukan tujuan pengiriman data.',
              ),

              const SizedBox(height: 28),

              _buildSectionTitle(
                number: '03',
                title: 'HTTP dan HTTPS',
              ),

              const SizedBox(height: 12),

              _buildParagraph(
                'HTTP dan HTTPS digunakan dalam komunikasi antara '
                    'browser dan server ketika mengakses layanan web.',
              ),

              const SizedBox(height: 16),

              _buildWebProtocolComparison(),

              const SizedBox(height: 28),

              _buildSectionTitle(
                number: '04',
                title: 'UDP',
              ),

              const SizedBox(height: 12),

              _buildParagraph(
                'UDP merupakan protokol yang mengirimkan data '
                    'tanpa proses koneksi dan pemeriksaan seperti '
                    'yang dilakukan TCP. Karena itu, UDP dapat '
                    'digunakan pada komunikasi yang membutuhkan '
                    'kecepatan.',
              ),

              const SizedBox(height: 18),

              _buildProtocolFlow(),

              const SizedBox(height: 30),

              _buildSectionTitle(
                number: '05',
                title: 'Contoh Penggunaan',
              ),

              const SizedBox(height: 14),

              _buildUsageItem(
                icon: Icons.language_rounded,
                title: 'Membuka Website',
                description:
                'Browser berkomunikasi dengan server untuk '
                    'meminta dan menerima data halaman web.',
              ),

              const SizedBox(height: 10),

              _buildUsageItem(
                icon: Icons.email_rounded,
                title: 'Mengirim Email',
                description:
                'Layanan email menggunakan berbagai protokol '
                    'untuk mengirim dan menerima pesan.',
              ),

              const SizedBox(height: 10),

              _buildUsageItem(
                icon: Icons.videocam_rounded,
                title: 'Komunikasi Real-Time',
                description:
                'Aplikasi komunikasi dapat menggunakan '
                    'protokol tertentu untuk mengirim data '
                    'dengan cepat.',
              ),

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
            'MATERI 06',
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
          'Protokol Jaringan',
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
          'Mengenal aturan komunikasi yang digunakan '
              'perangkat agar dapat saling bertukar data.',
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
            Icons.rule_rounded,
            color: primaryBlue,
            size: 23,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tanpa aturan komunikasi yang sama, perangkat '
                  'akan kesulitan memahami data yang dikirim '
                  'oleh perangkat lain.',
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

  Widget _buildCommunicationDiagram() {
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
            'Komunikasi antarperangkat',
            style: TextStyle(
              color: textDark,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: _device(
                  icon: Icons.computer_rounded,
                  label: 'Perangkat A',
                ),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  const Icon(
                    Icons.sync_alt_rounded,
                    color: primaryBlue,
                    size: 27,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: lightBlue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'PROTOKOL',
                      style: TextStyle(
                        color: primaryBlue,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _device(
                  icon: Icons.computer_rounded,
                  label: 'Perangkat B',
                ),
              ),
            ],
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
          width: 55,
          height: 55,
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
            size: 27,
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

  Widget _buildProtocolCard({
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

  Widget _buildWebProtocolComparison() {
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
        children: [
          _webProtocolRow(
            title: 'HTTP',
            description:
            'Protokol untuk komunikasi data pada web.',
            secure: false,
          ),
          const Divider(
            height: 20,
            color: borderGrey,
          ),
          _webProtocolRow(
            title: 'HTTPS',
            description:
            'Versi HTTP dengan perlindungan melalui enkripsi.',
            secure: true,
          ),
        ],
      ),
    );
  }

  Widget _webProtocolRow({
    required String title,
    required String description,
    required bool secure,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: secure
                ? const Color(0xFFE8F5E9)
                : const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: secure
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFFE65100),
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            description,
            style: const TextStyle(
              color: textGrey,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProtocolFlow() {
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
      child: Column(
        children: [
          const Text(
            'Gambaran sederhana',
            style: TextStyle(
              color: darkBlue,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _flowBox('Data'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: primaryBlue,
                  size: 18,
                ),
              ),
              _flowBox('UDP'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: primaryBlue,
                  size: 18,
                ),
              ),
              _flowBox('Tujuan'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _flowBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: const Color(0xFFB8D2EE),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: primaryBlue,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildUsageItem({
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
            'TCP/IP',
            'Dasar komunikasi jaringan dan internet',
          ),
          _summaryDivider(),
          _summaryRow(
            'HTTP',
            'Komunikasi pada layanan web',
          ),
          _summaryDivider(),
          _summaryRow(
            'HTTPS',
            'Komunikasi web dengan enkripsi',
          ),
          _summaryDivider(),
          _summaryRow(
            'UDP',
            'Komunikasi tanpa proses koneksi TCP',
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
            'Protokol jaringan merupakan aturan komunikasi '
                'yang membantu perangkat bertukar data. '
                'Beberapa protokol yang umum dikenal antara lain '
                'TCP/IP, HTTP, HTTPS, dan UDP.',
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
                    builder: (context) => const KeamananJaringanScreen(),
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