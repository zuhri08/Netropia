import 'package:flutter/material.dart';

class PenugasanScreen extends StatefulWidget {
  const PenugasanScreen({super.key});

  @override
  State<PenugasanScreen> createState() => _PenugasanScreenState();
}

class _PenugasanScreenState extends State<PenugasanScreen> {
  bool _isStarted = false;
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Penugasan',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF172B4D),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildInfoCard(),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Tujuan Pembelajaran',
              icon: Icons.flag_rounded,
              child: const Text(
                'Setelah menyelesaikan tugas ini, siswa diharapkan mampu '
                    'menerapkan konsep dasar jaringan komputer dengan merancang '
                    'sebuah jaringan LAN sederhana sesuai kebutuhan.',
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Deskripsi Tugas',
              icon: Icons.description_rounded,
              child: const Text(
                'Buatlah rancangan jaringan LAN sederhana untuk sebuah '
                    'laboratorium komputer sekolah. Rancangan harus menunjukkan '
                    'perangkat yang digunakan, topologi jaringan, serta hubungan '
                    'antarperangkat.',
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Instruksi Pengerjaan',
              icon: Icons.list_alt_rounded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInstruction(
                    '1',
                    'Tentukan kebutuhan jaringan untuk sebuah laboratorium '
                        'yang memiliki minimal 10 komputer.',
                  ),
                  _buildInstruction(
                    '2',
                    'Pilih topologi jaringan yang sesuai dan jelaskan alasan '
                        'pemilihannya.',
                  ),
                  _buildInstruction(
                    '3',
                    'Tentukan perangkat jaringan yang diperlukan.',
                  ),
                  _buildInstruction(
                    '4',
                    'Buat gambar atau diagram rancangan jaringan.',
                  ),
                  _buildInstruction(
                    '5',
                    'Jelaskan secara singkat bagaimana komputer dapat '
                        'saling berkomunikasi dalam jaringan tersebut.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Alat dan Bahan',
              icon: Icons.inventory_2_rounded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _BulletText('Kertas atau aplikasi untuk membuat diagram'),
                  _BulletText('Referensi materi Dasar Jaringan'),
                  _BulletText('Daftar perangkat jaringan'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Hasil yang Diharapkan',
              icon: Icons.task_alt_rounded,
              child: const Text(
                'Sebuah rancangan jaringan LAN yang jelas, lengkap, dan '
                    'sesuai dengan kebutuhan laboratorium komputer.',
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Ketentuan Pengumpulan',
              icon: Icons.upload_file_rounded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _BulletText('Format: PDF atau gambar'),
                  _BulletText('Berikan nama dan kelas pada hasil tugas'),
                  _BulletText('Pastikan diagram dapat dibaca dengan jelas'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildStatusCard(),
            const SizedBox(height: 20),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF1565C0),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.assignment_rounded,
            color: Colors.white,
            size: 34,
          ),
          SizedBox(height: 16),
          Text(
            'Membuat Rancangan Jaringan LAN',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tugas penerapan konsep Dasar Jaringan',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE3E8EF),
        ),
      ),
      child: Row(
        children: [
          _buildInfoItem(
            Icons.category_rounded,
            'Materi',
            'Dasar Jaringan',
          ),
          Container(
            width: 1,
            height: 45,
            color: const Color(0xFFE5E7EB),
          ),
          _buildInfoItem(
            Icons.school_rounded,
            'Jenis',
            'Praktik',
          ),
          Container(
            width: 1,
            height: 45,
            color: const Color(0xFFE5E7EB),
          ),
          _buildInfoItem(
            Icons.timer_outlined,
            'Estimasi',
            '60 menit',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
      IconData icon,
      String label,
      String value,
      ) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            size: 22,
            color: const Color(0xFF1565C0),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF7A869A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF172B4D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE3E8EF),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FF),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF1565C0),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF172B4D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          DefaultTextStyle(
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF52606D),
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildInstruction(
      String number,
      String text,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: Color(0xFF1565C0),
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF52606D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final completed = _isCompleted;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: completed
            ? const Color(0xFFEAF7EE)
            : const Color(0xFFFFF7E6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: completed
              ? const Color(0xFFB7DFC3)
              : const Color(0xFFF2D28A),
        ),
      ),
      child: Row(
        children: [
          Icon(
            completed
                ? Icons.check_circle_rounded
                : Icons.info_rounded,
            color: completed
                ? const Color(0xFF2E7D32)
                : const Color(0xFFE08A00),
            size: 25,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  completed
                      ? 'Tugas selesai'
                      : _isStarted
                      ? 'Tugas sedang dikerjakan'
                      : 'Tugas belum dimulai',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF172B4D),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  completed
                      ? 'Kamu telah menyelesaikan tugas ini.'
                      : 'Mulai tugas ketika kamu sudah siap.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: _isCompleted
            ? null
            : () {
          setState(() {
            if (!_isStarted) {
              _isStarted = true;
            } else {
              _isCompleted = true;
            }
          });
        },
        icon: Icon(
          _isCompleted
              ? Icons.check_rounded
              : _isStarted
              ? Icons.done_rounded
              : Icons.play_arrow_rounded,
        ),
        label: Text(
          _isCompleted
              ? 'Tugas Selesai'
              : _isStarted
              ? 'Tandai Selesai'
              : 'Mulai Tugas',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1565C0),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFB8C2CC),
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

class _BulletText extends StatelessWidget {
  final String text;

  const _BulletText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7),
            child: Icon(
              Icons.circle,
              size: 6,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}