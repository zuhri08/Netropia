import 'package:flutter/material.dart';
import 'jenis_jaringan_screen.dart';
class CaraKerjaJaringanScreen extends StatelessWidget {
  final VoidCallback? onNext;

  const CaraKerjaJaringanScreen({
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
              '03 / 08',
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
              widthFactor: 0.375,
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

              _buildFlowDiagram(),

              const SizedBox(height: 30),

              _buildSectionTitle(
                number: '01',
                title: 'Data Dikirim oleh Pengirim',
              ),

              const SizedBox(height: 12),

              _buildParagraph(
                'Ketika pengguna mengirim data, perangkat '
                    'pengirim menyiapkan informasi yang akan dikirim '
                    'melalui jaringan. Data tersebut dapat berupa '
                    'pesan, dokumen, gambar, atau file lainnya.',
              ),

              const SizedBox(height: 24),

              _buildSectionTitle(
                number: '02',
                title: 'Data Melewati Jaringan',
              ),

              const SizedBox(height: 12),

              _buildParagraph(
                'Data kemudian diteruskan melalui perangkat '
                    'jaringan menuju perangkat tujuan. Perangkat '
                    'jaringan membantu mengatur ke mana data harus '
                    'diteruskan.',
              ),

              const SizedBox(height: 18),

              _buildNetworkProcess(),

              const SizedBox(height: 28),

              _buildSectionTitle(
                number: '03',
                title: 'Data Diterima oleh Tujuan',
              ),

              const SizedBox(height: 12),

              _buildParagraph(
                'Setelah sampai pada perangkat tujuan, data '
                    'diterima dan dapat digunakan oleh pengguna. '
                    'Proses ini berlangsung sangat cepat sehingga '
                    'komunikasi melalui jaringan terasa langsung.',
              ),

              const SizedBox(height: 24),

              _buildExample(),

              const SizedBox(height: 28),

              _buildSectionTitle(
                number: '04',
                title: 'Gambaran Sederhana',
              ),

              const SizedBox(height: 14),

              _buildStep(
                number: '1',
                title: 'Pengirim',
                description:
                'Komputer A mengirim sebuah file.',
                icon: Icons.computer_rounded,
              ),

              _buildArrow(),

              _buildStep(
                number: '2',
                title: 'Jaringan',
                description:
                'Data diteruskan melalui perangkat jaringan.',
                icon: Icons.hub_rounded,
              ),

              _buildArrow(),

              _buildStep(
                number: '3',
                title: 'Penerima',
                description:
                'Komputer B menerima file tersebut.',
                icon: Icons.computer_rounded,
              ),

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
            'MATERI 03',
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
          'Cara Kerja Dasar\nJaringan',
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
          'Memahami bagaimana data berpindah dari satu '
              'perangkat menuju perangkat lain melalui jaringan.',
          style: TextStyle(
            color: textGrey,
            fontSize: 15,
            height: 1.55,
          ),
        ),
      ],
    );
  }

  Widget _buildFlowDiagram() {
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
              'Alur komunikasi sederhana',
              style: TextStyle(
                color: textDark,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _flowDevice(
                  icon: Icons.computer_rounded,
                  label: 'Pengirim',
                ),
              ),

              const SizedBox(width: 6),

              const Icon(
                Icons.arrow_forward_rounded,
                color: primaryBlue,
                size: 22,
              ),

              const SizedBox(width: 6),

              Expanded(
                child: _flowDevice(
                  icon: Icons.hub_rounded,
                  label: 'Jaringan',
                ),
              ),

              const SizedBox(width: 6),

              const Icon(
                Icons.arrow_forward_rounded,
                color: primaryBlue,
                size: 22,
              ),

              const SizedBox(width: 6),

              Expanded(
                child: _flowDevice(
                  icon: Icons.computer_rounded,
                  label: 'Penerima',
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const Text(
            'Data bergerak dari pengirim menuju penerima',
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

  Widget _flowDevice({
    required IconData icon,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
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

  Widget _buildNetworkProcess() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightBlue,
        border: Border.all(
          color: const Color(0xFFD1E3F5),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _processRow(
            icon: Icons.upload_rounded,
            title: 'Kirim',
            description: 'Data disiapkan oleh perangkat pengirim.',
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Icon(
              Icons.arrow_downward_rounded,
              color: primaryBlue,
              size: 20,
            ),
          ),

          _processRow(
            icon: Icons.route_rounded,
            title: 'Teruskan',
            description:
            'Perangkat jaringan meneruskan data menuju tujuan.',
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Icon(
              Icons.arrow_downward_rounded,
              color: primaryBlue,
              size: 20,
            ),
          ),

          _processRow(
            icon: Icons.download_rounded,
            title: 'Terima',
            description:
            'Perangkat tujuan menerima data yang dikirim.',
          ),
        ],
      ),
    );
  }

  Widget _processRow({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white,
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
                  color: darkBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
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
            'Contoh dalam kehidupan sehari-hari',
            style: TextStyle(
              color: textDark,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 9),
          Text(
            'Saat mengirim file dari satu komputer ke komputer '
                'lain dalam jaringan sekolah, file tersebut melewati '
                'jalur jaringan sebelum diterima oleh komputer tujuan.',
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

  Widget _buildStep({
    required String number,
    required String title,
    required String description,
    required IconData icon,
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
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(width: 12),

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
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 12,
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

  Widget _buildArrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 7),
      child: Icon(
        Icons.arrow_downward_rounded,
        color: primaryBlue,
        size: 20,
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
            'Secara sederhana, komunikasi jaringan terdiri '
                'dari pengirim, jalur jaringan, dan penerima. '
                'Data dikirim melalui jaringan hingga mencapai '
                'perangkat tujuan.',
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
                    builder: (context) => const JenisJaringanScreen(),
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