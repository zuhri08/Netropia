class ReferensiItem {
  final String materiId;
  final String nama;
  final String kategori;
  final String deskripsi;
  final String url;

  const ReferensiItem({
    required this.materiId,
    required this.nama,
    required this.kategori,
    required this.deskripsi,
    required this.url,
  });
}

class ReferensiData {
  static const List<ReferensiItem> items = [
    // ============================================================
    // K3
    // ============================================================

    ReferensiItem(
      materiId: 'k3',
      nama: 'SMK Muhammadiyah Cirebon',
      kategori: 'K3 & K3LH',
      deskripsi:
      'Membahas K3LH dalam lingkungan SMK kejuruan TJKT, mulai dari pengertian, prinsip, tujuan, prosedur, hingga penerapannya.',
      url:
      'https://smkmucirebon.sch.id/memahami-k3lh-dalam-smk-kejuruan-tjkt/',
    ),

    ReferensiItem(
      materiId: 'k3',
      nama: 'SlideShare',
      kategori: 'Modul Pembelajaran',
      deskripsi:
      'Referensi berbentuk modul ajar yang dapat digunakan untuk memperluas pemahaman mengenai K3LH pada bidang TKJ.',
      url:
      'https://www.slideshare.net/slideshow/modul-ajar-tkj-cp-k3lhdocx/259531992',
    ),

    // ============================================================
    // KOMPONEN KOMPUTER
    // ============================================================

    ReferensiItem(
      materiId: 'komponen_komputer',
      nama: 'IDN.ID',
      kategori: 'Materi Komputer',
      deskripsi:
      'Mengenal berbagai komponen komputer dan fungsi masing-masing komponen sebagai dasar memahami perangkat komputer.',
      url:
      'https://www.idn.id/mengenali-komponen-komponen-komputer/',
    ),

    ReferensiItem(
      materiId: 'komponen_komputer',
      nama: 'Kompas Tekno',
      kategori: 'Materi Komputer',
      deskripsi:
      'Membahas pengertian, jenis, contoh, dan fungsi berbagai komponen yang terdapat pada komputer.',
      url:
      'https://tekno.kompas.com/read/2023/09/02/15020077/komponen-komputer--pengertian-jenis-contoh-dan-fungsinya?page=all',
    ),

    ReferensiItem(
      materiId: 'komponen_komputer',
      nama: 'detikBali',
      kategori: 'Materi Komputer',
      deskripsi:
      'Referensi pengenalan komponen komputer beserta fungsi dari masing-masing bagian dalam sistem komputer.',
      url:
      'https://www.detik.com/bali/berita/d-6573727/mengenal-komponen-komputer-dan-masing-masing-fungsinya',
    ),

    ReferensiItem(
      materiId: 'komponen_komputer',
      nama: 'Universitas Alma Ata',
      kategori: 'Materi Komputer',
      deskripsi:
      'Sumber pembelajaran tambahan untuk memahami komponen komputer dan perannya dalam sistem komputer.',
      url:
      'https://si.almaata.ac.id/2024/12/05/apa-itu-komponen-komputer/',
    ),

    // ============================================================
    // PERANGKAT JARINGAN
    // ============================================================

    ReferensiItem(
      materiId: 'perangkat_jaringan',
      nama: 'Telkom University',
      kategori: 'Networking',
      deskripsi:
      'Membahas komponen jaringan komputer, perangkat jaringan, protokol, topologi, serta fungsi perangkat dalam komunikasi data.',
      url:
      'https://it.telkomuniversity.ac.id/komponen-jaringan-komputer/',
    ),

    ReferensiItem(
      materiId: 'perangkat_jaringan',
      nama: 'Kompas Tekno',
      kategori: 'Networking',
      deskripsi:
      'Mengenal berbagai macam perangkat jaringan komputer beserta pengertian dan fungsi penggunaannya.',
      url:
      'https://tekno.kompas.com/read/2024/06/26/03350077/macam-macam-perangkat-jaringan-komputer-beserta-pengertian-dan-fungsinya?page=all',
    ),

    ReferensiItem(
      materiId: 'perangkat_jaringan',
      nama: 'IDN.ID',
      kategori: 'Networking',
      deskripsi:
      'Referensi untuk mengenal perangkat jaringan yang digunakan dalam membangun dan menghubungkan jaringan komputer.',
      url:
      'https://www.idn.id/mengenal-perangkat-jaringan/',
    ),

    ReferensiItem(
      materiId: 'perangkat_jaringan',
      nama: 'Telkomsel',
      kategori: 'Networking',
      deskripsi:
      'Mengenal berbagai perangkat jaringan komputer dan fungsi yang dimiliki setiap perangkat dalam jaringan.',
      url:
      'https://www.telkomsel.com/jelajah/jelajah-lifestyle/mengenal-10-macam-perangkat-jaringan-komputer-dan-fungsinya',
    ),

    ReferensiItem(
      materiId: 'perangkat_jaringan',
      nama: 'Telkom University Jakarta',
      kategori: 'Networking',
      deskripsi:
      'Membahas perangkat jaringan seperti router, switch, dan access point serta perannya dalam jaringan komputer.',
      url:
      'https://jakarta.telkomuniversity.ac.id/perangkat-jaringan-router-switch-dan-access-point/',
    ),

    // ============================================================
    // IP ADDRESS
    // ============================================================

    ReferensiItem(
      materiId: 'ip_address',
      nama: 'Universitas Diponegoro',
      kategori: 'IP Address',
      deskripsi:
      'Membahas pengertian, fungsi, jenis, cara kerja, serta konsep dasar IP Address dalam komunikasi jaringan.',
      url:
      'https://dsti.undip.ac.id/apa-itu-ip-address-kenali-pengertian-fungsi-jenis-dan-cara-kerjanya/',
    ),

    ReferensiItem(
      materiId: 'ip_address',
      nama: 'Telkom University',
      kategori: 'IP Address',
      deskripsi:
      'Referensi tambahan untuk memahami konsep IP Address, fungsi, serta berbagai jenis pengalamatan dalam jaringan.',
      url:
      'https://dim.telkomuniversity.ac.id/apa-itu-ip-address-perbedaan-fungsi-dan-jenis-jenis-ip-address/',
    ),

    ReferensiItem(
      materiId: 'ip_address',
      nama: 'Masuk-PTN',
      kategori: 'IP Address',
      deskripsi:
      'Materi pengalamatan IP yang dapat digunakan untuk memperdalam pemahaman konsep addressing pada jaringan komputer.',
      url:
      'https://masuk-ptn.com/materi/jaringan-komputer-tingkat-lanjut-materi-informatika-kelas-11/pengalamatan-ip',
    ),

    // ============================================================
    // KABEL JARINGAN
    // ============================================================

    ReferensiItem(
      materiId: 'kabel_jaringan',
      nama: 'Telkom University Jakarta',
      kategori: 'Kabel Jaringan',
      deskripsi:
      'Membahas kabel UTP, STP, dan Fiber Optic, termasuk karakteristik, penggunaan, kelebihan, dan kekurangannya.',
      url:
      'https://jakarta.telkomuniversity.ac.id/jenis-jenis-kabel-jaringan-utp-stp-dan-fiber-optic/',
    ),

    ReferensiItem(
      materiId: 'kabel_jaringan',
      nama: 'Konek Market',
      kategori: 'Kabel Jaringan',
      deskripsi:
      'Referensi tambahan untuk mengenal kabel jaringan dan penggunaannya dalam membangun jaringan komputer.',
      url:
      'https://konek.market/articles/apa-itu-kabel-jaringan',
    ),

    ReferensiItem(
      materiId: 'kabel_jaringan',
      nama: 'NusaNet',
      kategori: 'Kabel Jaringan',
      deskripsi:
      'Sumber pembelajaran mengenai pengetahuan dasar dan penggunaan kabel dalam jaringan komputer.',
      url:
      'https://www.nusa.net.id/kb/seputar-pengetahuan-tentang-kabel-jaringan/',
    ),

    ReferensiItem(
      materiId: 'kabel_jaringan',
      nama: 'DimensiData',
      kategori: 'Kabel Jaringan',
      deskripsi:
      'Mengenal berbagai jenis kabel jaringan yang digunakan untuk kebutuhan koneksi dan transmisi data.',
      url:
      'https://blog.dimensidata.com/macam-jenis-kabel-jaringan-internet-dan-pengertiannya/',
    ),

    // ============================================================
    // DASAR JARINGAN
    // ============================================================

    ReferensiItem(
      materiId: 'dasar_jaringan',
      nama: 'Telkom University',
      kategori: 'Dasar Jaringan',
      deskripsi:
      'Membahas pengertian, fungsi, cara kerja, dan berbagai jenis jaringan komputer sebagai dasar memahami networking.',
      url:
      'https://telkomuniversity.ac.id/mengenal-jaringan-komputer-definisi-fungsi-cara-kerja-dan-ragam-jenisnya/',
    ),

    ReferensiItem(
      materiId: 'dasar_jaringan',
      nama: 'BINUS University',
      kategori: 'Dasar Jaringan',
      deskripsi:
      'Referensi mengenai jenis-jenis jaringan komputer dan internet beserta fungsi dan manfaatnya.',
      url:
      'https://binus.ac.id/malang/2024/07/yuk-ketahui-jenis-jenis-jaringan-komputer-dan-internet-lengkap-dengan-fungsinya/',
    ),

    ReferensiItem(
      materiId: 'dasar_jaringan',
      nama: 'Biznet Home',
      kategori: 'Networking',
      deskripsi:
      'Membahas pengertian, jenis, dan fungsi jaringan komputer serta penerapannya dalam kehidupan sehari-hari.',
      url:
      'https://biznethome.net/blog/yuk-kenali-jenis-jenis-jaringan-komputer-dan-internet/',
    ),

    ReferensiItem(
      materiId: 'dasar_jaringan',
      nama: 'Kumparan',
      kategori: 'Bacaan Tambahan',
      deskripsi:
      'Bacaan tambahan untuk memahami hubungan antara jaringan komputer dan internet serta beberapa jenis jaringan.',
      url:
      'https://kumparan.com/ragam-info/apa-pengertian-jaringan-komputer-dan-internet-ini-penjelasannya-23vNKpplFTP',
    ),

    ReferensiItem(
      materiId: 'dasar_jaringan',
      nama: 'Dicoding',
      kategori: 'Teknologi',
      deskripsi:
      'Referensi teknologi untuk memperluas pemahaman dasar mengenai jaringan komputer dan jenis-jenisnya.',
      url:
      'https://www.dicoding.com/blog/apa-itu-jaringan-komputer-pengertian-dan-jenisnya/',
    ),
  ];

  static List<ReferensiItem> byMateri(String materiId) {
    return items
        .where((item) => item.materiId == materiId)
        .toList();
  }
}