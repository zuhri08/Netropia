
import 'package:flutter/material.dart';

class K3MateriScreen extends StatefulWidget {
  final int index;

  const K3MateriScreen({
    super.key,
    this.index = 0,
  });

  @override
  State<K3MateriScreen> createState() => _K3MateriScreenState();
}

class _K3MateriScreenState extends State<K3MateriScreen> {
  static const Color _primary = Color(0xFFAD8B73);
  static const Color _background = Color(0xFFF5F7FA);

  late final PageController _pageController;
  int _currentPage = 0;

  final List<_LessonPage> _pages = [
    _LessonPage(
      number: 'MATERI 01',
      title: 'Mengenal K3LH',
      subtitle:
      'Memahami keselamatan, kesehatan kerja, dan lingkungan hidup dalam kegiatan belajar maupun praktik TKJ.',
      icon: Icons.health_and_safety_rounded,
      visualTitle: 'Tiga unsur utama K3LH',
      visualItems: [
        _VisualItem(Icons.shield_rounded, 'Keselamatan'),
        _VisualItem(Icons.favorite_rounded, 'Kesehatan'),
        _VisualItem(Icons.eco_rounded, 'Lingkungan'),
      ],
      sections: [
        _LessonSection(
          title: 'Apa itu K3LH?',
          body:
          'K3LH adalah singkatan dari Keselamatan, Kesehatan Kerja, dan Lingkungan Hidup. K3LH merupakan upaya untuk menciptakan kegiatan kerja dan belajar yang aman, sehat, serta tidak merusak lingkungan.',
        ),
        _LessonSection(
          title: 'Keselamatan Kerja',
          body:
          'Keselamatan kerja berhubungan dengan usaha mencegah kecelakaan ketika menggunakan alat, mesin, bahan, maupun saat melakukan suatu pekerjaan.',
          bullets: [
            'Memeriksa kondisi alat sebelum digunakan.',
            'Mengikuti prosedur kerja yang telah ditetapkan.',
            'Menghindari tindakan yang berisiko menyebabkan kecelakaan.',
          ],
        ),
        _LessonSection(
          title: 'Kesehatan Kerja',
          body:
          'Kesehatan kerja merupakan upaya menjaga kondisi fisik dan mental agar seseorang dapat melakukan kegiatan dengan aman dan nyaman serta terhindar dari gangguan kesehatan akibat pekerjaan.',
        ),
        _LessonSection(
          title: 'Lingkungan Hidup',
          body:
          'Lingkungan hidup dalam K3LH berkaitan dengan menjaga kebersihan, kerapian, kelestarian, dan kenyamanan lingkungan tempat bekerja atau belajar.',
        ),
      ],
      takeaway:
      'K3LH bukan hanya tentang menghindari kecelakaan, tetapi juga membangun kebiasaan bekerja dengan aman, sehat, dan peduli terhadap lingkungan.',
    ),
    _LessonPage(
      number: 'MATERI 02',
      title: 'Tujuan dan Manfaat K3LH',
      subtitle:
      'Mengapa setiap siswa TKJ perlu menerapkan K3LH sebelum, selama, dan setelah praktik?',
      icon: Icons.track_changes_rounded,
      visualTitle: 'K3LH menciptakan lingkungan praktik yang...',
      visualItems: [
        _VisualItem(Icons.verified_user_rounded, 'Aman'),
        _VisualItem(Icons.spa_rounded, 'Sehat'),
        _VisualItem(Icons.cleaning_services_rounded, 'Nyaman'),
        _VisualItem(Icons.trending_up_rounded, 'Produktif'),
      ],
      sections: [
        _LessonSection(
          title: 'Melindungi diri dan orang lain',
          body:
          'Penerapan K3LH membantu melindungi siswa, guru, dan orang lain dari risiko kecelakaan maupun gangguan kesehatan selama kegiatan praktik.',
        ),
        _LessonSection(
          title: 'Mencegah kecelakaan kerja',
          body:
          'Pemeriksaan alat, penggunaan perlengkapan yang sesuai, dan kepatuhan terhadap prosedur dapat mengurangi kemungkinan terjadinya kecelakaan.',
        ),
        _LessonSection(
          title: 'Menciptakan lingkungan yang nyaman',
          body:
          'Laboratorium yang bersih, rapi, memiliki sirkulasi udara baik, dan bebas dari kabel berserakan akan mendukung proses pembelajaran.',
        ),
        _LessonSection(
          title: 'Meningkatkan efisiensi praktik',
          body:
          'Alat yang tertata dan prosedur yang jelas membuat pekerjaan lebih mudah dilakukan, mengurangi kesalahan, serta membantu kegiatan praktik berjalan teratur.',
        ),
      ],
      takeaway:
      'Menerapkan K3LH berarti menjaga diri sendiri, teman, peralatan, dan lingkungan agar kegiatan praktik berjalan dengan baik.',
    ),
    _LessonPage(
      number: 'MATERI 03',
      title: 'Dasar Hukum K3',
      subtitle:
      'Mengenal beberapa peraturan yang menjadi dasar penerapan keselamatan dan kesehatan kerja di Indonesia.',
      icon: Icons.gavel_rounded,
      visualTitle: 'Landasan penerapan K3',
      visualItems: [
        _VisualItem(Icons.menu_book_rounded, 'UU 1/1970'),
        _VisualItem(Icons.account_balance_rounded, 'PP 50/2012'),
        _VisualItem(Icons.description_rounded, 'Permenaker'),
      ],
      sections: [
        _LessonSection(
          title: 'Undang-Undang Nomor 1 Tahun 1970',
          body:
          'Mengatur tentang Keselamatan Kerja. Peraturan ini menjadi salah satu landasan utama dalam upaya mencegah kecelakaan dan melindungi keselamatan orang di tempat kerja.',
        ),
        _LessonSection(
          title: 'Peraturan Pemerintah Nomor 50 Tahun 2012',
          body:
          'Mengatur Penerapan Sistem Manajemen Keselamatan dan Kesehatan Kerja (SMK3). SMK3 merupakan bagian dari sistem manajemen untuk mengendalikan risiko yang berkaitan dengan kegiatan kerja.',
        ),
        _LessonSection(
          title: 'Permenaker Nomor 5 Tahun 2018',
          body:
          'Mengatur Keselamatan dan Kesehatan Kerja Lingkungan Kerja, termasuk faktor lingkungan kerja yang dapat memengaruhi keselamatan dan kesehatan.',
        ),
        _LessonSection(
          title: 'Catatan perkembangan peraturan',
          body:
          'Materi referensi juga menyebut Permenaker Nomor 4 Tahun 1987 tentang P2K3. Peraturan tersebut telah dicabut oleh Permenaker Nomor 13 Tahun 2025. Karena itu, gunakan peraturan terbaru ketika mempelajari ketentuan P2K3.',
        ),
      ],
      takeaway:
      'Peraturan K3 menjadi pedoman agar keselamatan dan kesehatan tidak hanya bergantung pada kebiasaan pribadi, tetapi diterapkan secara terarah.',
    ),
    _LessonPage(
      number: 'MATERI 04',
      title: 'Bahaya di Laboratorium TKJ',
      subtitle:
      'Mengenali sumber bahaya dan memahami risiko yang dapat muncul saat merakit komputer atau bekerja dengan perangkat jaringan.',
      icon: Icons.warning_amber_rounded,
      visualTitle: 'Kenali potensi bahaya di lab',
      visualItems: [
        _VisualItem(Icons.electrical_services_rounded, 'Listrik'),
        _VisualItem(Icons.cable_rounded, 'Kabel'),
        _VisualItem(Icons.memory_rounded, 'Komponen'),
        _VisualItem(Icons.event_seat_rounded, 'Ergonomi'),
      ],
      sections: [
        _LessonSection(
          title: 'Bahaya kelistrikan',
          body:
          'Kabel terkelupas, stopkontak rusak, tangan basah, atau penggunaan listrik yang tidak sesuai dapat menimbulkan sengatan listrik maupun kebakaran.',
          bullets: [
            'Jangan menggunakan kabel yang isolasinya rusak.',
            'Jangan menyentuh peralatan listrik dengan tangan basah.',
            'Laporkan kondisi berbahaya kepada guru atau instruktur.',
          ],
        ),
        _LessonSection(
          title: 'Bahaya kabel dan peralatan',
          body:
          'Kabel yang melintang di jalur berjalan dapat menyebabkan seseorang tersandung. Peralatan yang diletakkan sembarangan juga berisiko jatuh atau rusak.',
        ),
        _LessonSection(
          title: 'Bahaya debu dan panas',
          body:
          'Debu yang menumpuk pada kipas dan heatsink dapat menghambat pelepasan panas. Komputer yang mengalami panas berlebih dapat menjadi tidak stabil atau mati secara tiba-tiba.',
        ),
        _LessonSection(
          title: 'Bahaya ergonomi',
          body:
          'Posisi duduk yang tidak tepat, layar terlalu rendah, dan penggunaan komputer dalam waktu lama tanpa istirahat dapat menyebabkan ketegangan mata serta keluhan otot.',
        ),
        _LessonSection(
          title: 'Bahaya listrik statis (ESD)',
          body:
          'Muatan listrik statis dari tubuh dapat merusak komponen elektronik yang sensitif, meskipun kerusakannya tidak selalu terlihat secara langsung.',
        ),
      ],
      takeaway:
      'Sebelum praktik, biasakan mengamati kondisi ruangan, kabel, alat, dan posisi kerja. Bahaya yang dikenali lebih awal dapat ditangani sebelum menimbulkan kecelakaan.',
    ),
    _LessonPage(
      number: 'MATERI 05',
      title: 'APD dan Fasilitas Keselamatan',
      subtitle:
      'Memilih perlindungan dan mengenali fasilitas keselamatan sesuai dengan risiko kegiatan praktik.',
      icon: Icons.engineering_rounded,
      visualTitle: 'Perlindungan sesuai kebutuhan',
      visualItems: [
        _VisualItem(Icons.visibility_rounded, 'Mata'),
        _VisualItem(Icons.masks_rounded, 'Pernapasan'),
        _VisualItem(Icons.back_hand_rounded, 'Tangan'),
        _VisualItem(Icons.health_and_safety_rounded, 'Kaki'),
      ],
      sections: [
        _LessonSection(
          title: 'Apa itu APD?',
          body:
          'Alat Pelindung Diri (APD) adalah perlengkapan yang digunakan untuk melindungi seseorang dari risiko bahaya saat melakukan pekerjaan. Jenis APD harus disesuaikan dengan kegiatan dan potensi bahayanya.',
        ),
        _LessonSection(
          title: 'Contoh APD',
          bullets: [
            'Kacamata keselamatan: melindungi mata dari debu atau serpihan.',
            'Masker: membantu melindungi pernapasan dari debu sesuai jenis maskernya.',
            'Sarung tangan: digunakan sesuai risiko, misalnya saat menangani benda tertentu.',
            'Sepatu keselamatan: membantu melindungi kaki dari risiko benturan atau benda jatuh.',
          ],
        ),
        _LessonSection(
          title: 'Fasilitas keselamatan',
          body:
          'Laboratorium perlu memiliki fasilitas keselamatan yang mudah dikenali dan dapat diakses, seperti kotak P3K, jalur evakuasi, tanda keselamatan, dan APAR yang sesuai.',
        ),
        _LessonSection(
          title: 'Mengenal APAR',
          body:
          'APAR adalah Alat Pemadam Api Ringan. Penggunaannya harus mengikuti jenis kebakaran, petunjuk pada tabung, dan arahan petugas atau instruktur. Untuk kebakaran yang melibatkan listrik, jangan menyiramnya dengan air.',
        ),
        _LessonSection(
          title: 'Keselamatan saat menangani listrik',
          body:
          'APD umum tidak otomatis membuat pekerjaan listrik menjadi aman. Siswa tidak boleh membuka atau memperbaiki instalasi listrik, stopkontak, maupun MCB tanpa izin dan pengawasan guru atau petugas yang berwenang.',
        ),
      ],
      takeaway:
      'APD membantu mengurangi risiko, tetapi tidak menggantikan prosedur kerja yang aman, pengawasan, dan penggunaan alat yang benar.',
    ),
    _LessonPage(
      number: 'MATERI 06',
      title: 'Budaya Kerja 5R',
      subtitle:
      'Membentuk kebiasaan menjaga area praktik agar selalu ringkas, rapi, resik, rawat, dan rajin.',
      icon: Icons.cleaning_services_rounded,
      visualTitle: 'Lima kebiasaan kerja',
      visualItems: [
        _VisualItem(Icons.filter_alt_rounded, 'Ringkas'),
        _VisualItem(Icons.inventory_2_rounded, 'Rapi'),
        _VisualItem(Icons.cleaning_services_rounded, 'Resik'),
        _VisualItem(Icons.autorenew_rounded, 'Rawat'),
        _VisualItem(Icons.repeat_rounded, 'Rajin'),
      ],
      sections: [
        _LessonSection(
          title: '1. Ringkas',
          body:
          'Memilah barang yang diperlukan dan tidak diperlukan. Barang yang tidak digunakan sebaiknya disingkirkan dari meja praktik.',
        ),
        _LessonSection(
          title: '2. Rapi',
          body:
          'Menempatkan alat dan komponen pada tempat yang telah ditentukan agar mudah ditemukan dan tidak mengganggu pekerjaan.',
        ),
        _LessonSection(
          title: '3. Resik',
          body:
          'Membersihkan area kerja dari debu, sampah, dan kotoran setelah atau selama kegiatan praktik.',
        ),
        _LessonSection(
          title: '4. Rawat',
          body:
          'Menjaga agar kebiasaan ringkas, rapi, dan resik tetap berlangsung secara konsisten.',
        ),
        _LessonSection(
          title: '5. Rajin',
          body:
          'Membiasakan diri menaati aturan dan melakukan 5R tanpa harus selalu diingatkan oleh guru.',
        ),
      ],
      takeaway:
      '5R bukan kegiatan bersih-bersih sesaat. 5R adalah budaya kerja yang dilakukan secara konsisten oleh seluruh pengguna laboratorium.',
    ),
    _LessonPage(
      number: 'MATERI 07',
      title: 'Prosedur K3 saat Praktik TKJ',
      subtitle:
      'Menerapkan langkah aman sebelum, selama, dan setelah melakukan kegiatan di laboratorium komputer.',
      icon: Icons.checklist_rounded,
      visualTitle: 'Alur praktik yang aman',
      visualItems: [
        _VisualItem(Icons.fact_check_rounded, 'Sebelum'),
        _VisualItem(Icons.handyman_rounded, 'Saat praktik'),
        _VisualItem(Icons.done_all_rounded, 'Sesudah'),
      ],
      sections: [
        _LessonSection(
          title: 'Sebelum praktik',
          bullets: [
            'Baca instruksi dan pahami tujuan kegiatan.',
            'Periksa kondisi meja, kursi, kabel, dan peralatan.',
            'Pastikan tangan dalam keadaan kering saat bekerja dengan perangkat.',
            'Gunakan APD jika diperlukan sesuai risiko praktik.',
            'Ketahui lokasi kotak P3K, APAR, dan jalur evakuasi.',
          ],
        ),
        _LessonSection(
          title: 'Saat praktik',
          bullets: [
            'Ikuti instruksi guru atau instruktur.',
            'Gunakan alat sesuai fungsi dan prosedurnya.',
            'Jangan makan atau minum di area kerja perangkat.',
            'Jangan memaksakan konektor atau komponen saat pemasangan.',
            'Hentikan kegiatan dan laporkan jika muncul bau terbakar, asap, percikan, atau kondisi tidak normal.',
          ],
        ),
        _LessonSection(
          title: 'Setelah praktik',
          bullets: [
            'Matikan perangkat sesuai prosedur dan arahan instruktur.',
            'Rapikan alat, kabel, dan komponen.',
            'Bersihkan area kerja dengan cara yang aman.',
            'Laporkan kerusakan atau kehilangan peralatan.',
            'Pastikan area praktik kembali aman sebelum ditinggalkan.',
          ],
        ),
        _LessonSection(
          title: 'Jika terjadi keadaan darurat',
          body:
          'Utamakan keselamatan diri dan orang di sekitar. Jangan menyentuh sumber bahaya. Beri tahu guru atau petugas, ikuti prosedur evakuasi, dan jangan mencoba memperbaiki instalasi listrik sendiri.',
        ),
      ],
      takeaway:
      'Praktik yang baik bukan hanya menghasilkan perangkat yang berfungsi, tetapi juga dilakukan melalui proses yang aman dan bertanggung jawab.',
    ),
    _LessonPage(
      number: 'MATERI 08',
      title: 'Studi Kasus dan Refleksi',
      subtitle:
      'Gunakan pengetahuan K3LH untuk menganalisis situasi dan menentukan tindakan yang aman.',
      icon: Icons.psychology_rounded,
      visualTitle: 'Berpikir sebelum bertindak',
      visualItems: [
        _VisualItem(Icons.visibility_rounded, 'Amati'),
        _VisualItem(Icons.lightbulb_rounded, 'Analisis'),
        _VisualItem(Icons.shield_rounded, 'Bertindak aman'),
      ],
      sections: [
        _LessonSection(
          title: 'Studi kasus: muncul asap dari komputer',
          body:
          'Saat praktik merakit PC, kamu mencium bau hangus dan melihat asap keluar dari area komputer. Beberapa teman ingin segera membuka casing untuk mencari sumber masalah.',
        ),
        _LessonSection(
          title: 'Apa yang sebaiknya dilakukan?',
          bullets: [
            'Hentikan kegiatan dan jangan menyentuh bagian yang berasap.',
            'Jauhkan diri dan teman dari sumber bahaya.',
            'Beri tahu guru atau instruktur dengan segera.',
            'Pemutusan sumber listrik hanya dilakukan jika aman dan sesuai arahan petugas atau instruktur.',
            'Jangan menyiram perangkat listrik dengan air.',
            'Ikuti prosedur darurat dan evakuasi yang berlaku di laboratorium.',
          ],
        ),
        _LessonSection(
          title: 'Ayo berpikir kritis',
          body:
          'Mengapa membuka casing ketika perangkat masih terhubung dengan listrik dapat membahayakan? Mengapa melaporkan kejadian kepada instruktur lebih tepat daripada mencoba memperbaikinya sendiri?',
        ),
        _LessonSection(
          title: 'Refleksi pribadi',
          body:
          'Tuliskan tiga kebiasaan K3LH yang akan kamu terapkan setiap kali melakukan praktik TKJ. Pikirkan tindakan sederhana yang dapat melindungi dirimu, teman, peralatan, dan lingkungan.',
          bullets: [
            'Kebiasaan yang akan saya lakukan sebelum praktik.',
            'Kebiasaan yang akan saya jaga selama praktik.',
            'Tanggung jawab saya setelah praktik selesai.',
          ],
        ),
      ],
      takeaway:
      'Seorang teknisi yang bertanggung jawab tidak terburu-buru bertindak. Ia mengenali risiko, mengikuti prosedur, dan mengutamakan keselamatan.',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _currentPage = widget.index.clamp(0, _pages.length - 1).toInt();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    if (page < 0 || page >= _pages.length) return;

    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF263238),
        elevation: 0,
        title: const Text(
          'K3LH',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
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
              color: const Color(0xFFF4EDE8),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              '${(_currentPage + 1).toString().padLeft(2, '0')} / ${_pages.length.toString().padLeft(2, '0')}',
              style: const TextStyle(
                color: _primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: LinearProgressIndicator(
            value: (_currentPage + 1) / _pages.length,
            backgroundColor: const Color(0xFFECEFF1),
            valueColor: const AlwaysStoppedAnimation<Color>(_primary),
            minHeight: 3,
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return _buildLessonContent(_pages[index], index);
        },
      ),
      bottomNavigationBar: _buildBottomNavigation(page),
    );
  }

  Widget _buildLessonContent(_LessonPage page, int index) {
    return SingleChildScrollView(
      key: PageStorageKey('k3-page-$index'),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLessonHeading(page),
          const SizedBox(height: 22),
          _buildVisualCard(page),
          const SizedBox(height: 24),
          ...page.sections.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 22),
              child: _buildSection(entry.key + 1, entry.value),
            );
          }),
          _buildTakeaway(page.takeaway),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildLessonHeading(_LessonPage page) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: _primary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            page.number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 13),
        Text(
          page.title,
          style: const TextStyle(
            color: Color(0xFF17447E),
            fontSize: 27,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          page.subtitle,
          style: const TextStyle(
            color: Color(0xFF607D8B),
            fontSize: 14,
            height: 1.55,
          ),
        ),
      ],
    );
  }

  Widget _buildVisualCard(_LessonPage page) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDCE3E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            page.visualTitle,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF455A64),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 12,
            children: page.visualItems.map((item) {
              return SizedBox(
                width: page.visualItems.length >= 5 ? 75 : 82,
                child: Column(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5EDE7),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: const Color(0xFFE6D4C7),
                        ),
                      ),
                      child: Icon(
                        item.icon,
                        color: _primary,
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      item.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF455A64),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFE7ECEF)),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Pahami konsep • Amati lingkungan • Terapkan dengan aman',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF78909C),
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(int number, _LessonSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number.toString().padLeft(2, '0'),
              style: const TextStyle(
                color: _primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                section.title,
                style: const TextStyle(
                  color: Color(0xFF263238),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (section.body != null)
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              section.body!,
              style: const TextStyle(
                color: Color(0xFF546E7A),
                fontSize: 13.5,
                height: 1.65,
              ),
            ),
          ),
        if (section.bullets.isNotEmpty) ...[
          const SizedBox(height: 9),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Column(
              children: section.bullets.map((bullet) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 7, right: 9),
                        decoration: const BoxDecoration(
                          color: _primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          bullet,
                          style: const TextStyle(
                            color: Color(0xFF546E7A),
                            fontSize: 13,
                            height: 1.55,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTakeaway(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4EDE8),
        border: const Border(
          left: BorderSide(
            color: _primary,
            width: 4,
          ),
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            color: _primary,
            size: 21,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Intinya',
                  style: TextStyle(
                    color: Color(0xFF17447E),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xFF37474F),
                    fontSize: 12.5,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(_LessonPage page) {
    final isFirst = _currentPage == 0;
    final isLast = _currentPage == _pages.length - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE7ECEF)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (!isFirst)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _goToPage(_currentPage - 1),
                  icon: const Icon(Icons.arrow_back_rounded, size: 17),
                  label: const Text('Sebelumnya'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _primary,
                    side: const BorderSide(color: _primary),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
              ),
            if (!isFirst) const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isLast
                    ? () => Navigator.pop(context)
                    : () => _goToPage(_currentPage + 1),
                icon: Icon(
                  isLast
                      ? Icons.check_circle_outline_rounded
                      : Icons.arrow_forward_rounded,
                  size: 17,
                ),
                label: Text(isLast ? 'Selesai' : 'Berikutnya'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// MODEL DATA MATERI
// ============================================================

class _LessonPage {
  final String number;
  final String title;
  final String subtitle;
  final IconData icon;
  final String visualTitle;
  final List<_VisualItem> visualItems;
  final List<_LessonSection> sections;
  final String takeaway;

  const _LessonPage({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.visualTitle,
    required this.visualItems,
    required this.sections,
    required this.takeaway,
  });
}

class _VisualItem {
  final IconData icon;
  final String label;

  const _VisualItem(this.icon, this.label);
}

class _LessonSection {
  final String title;
  final String? body;
  final List<String> bullets;

  const _LessonSection({
    required this.title,
    this.body,
    this.bullets = const [],
  });
}