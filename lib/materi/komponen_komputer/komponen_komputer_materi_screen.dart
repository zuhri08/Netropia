import 'package:flutter/material.dart';

class KomponenKomputerMateriScreen extends StatefulWidget {
  final int index;

  const KomponenKomputerMateriScreen({
    super.key,
    this.index = 0,
  });

  @override
  State<KomponenKomputerMateriScreen> createState() =>
      _KomponenKomputerMateriScreenState();
}

class _KomponenKomputerMateriScreenState
    extends State<KomponenKomputerMateriScreen> {
  static const Color _primary = Color(0xFFAD8B73);
  static const Color _background = Color(0xFFF5F7FA);

  late final PageController _pageController;
  int _currentPage = 0;

  final List<_LessonPage> _pages = [
    _LessonPage(
      number: 'MATERI 01',
      title: 'Mengenal Komponen Komputer',
      subtitle:
      'Memahami bagian-bagian utama komputer dan peran setiap komponen dalam menjalankan sistem komputer.',
      icon: Icons.computer_rounded,
      visualTitle: 'Komponen utama komputer',
      visualItems: [
        _VisualItem(Icons.memory_rounded, 'Prosesor'),
        _VisualItem(Icons.developer_board_rounded, 'Motherboard'),
        _VisualItem(Icons.sd_storage_rounded, 'RAM'),
        _VisualItem(Icons.storage_rounded, 'Penyimpanan'),
      ],
      sections: [
        _LessonSection(
          title: 'Apa itu komponen komputer?',
          body:
          'Komponen komputer adalah bagian-bagian yang membentuk sistem komputer dan bekerja sama untuk menerima, mengolah, menyimpan, serta menampilkan informasi.',
        ),
        _LessonSection(
          title: 'Mengapa komponen harus saling terhubung?',
          body:
          'Setiap komponen memiliki fungsi yang berbeda. Prosesor mengolah instruksi, RAM menyimpan data sementara, penyimpanan menyimpan data dalam jangka panjang, dan perangkat input-output menjadi penghubung dengan pengguna.',
        ),
        _LessonSection(
          title: 'Kelompok komponen komputer',
          bullets: [
            'Perangkat input: memasukkan data atau perintah.',
            'Perangkat proses: mengolah data dan menjalankan instruksi.',
            'Perangkat penyimpanan: menyimpan data dan program.',
            'Perangkat output: menampilkan hasil pengolahan.',
          ],
        ),
        _LessonSection(
          title: 'Komponen internal dan eksternal',
          body:
          'Komponen internal berada di dalam casing, seperti motherboard, prosesor, RAM, dan penyimpanan. Komponen eksternal terhubung dari luar, seperti keyboard, mouse, monitor, dan printer.',
        ),
      ],
      takeaway:
      'Komputer bekerja sebagai satu sistem karena setiap komponennya saling mendukung sesuai fungsi masing-masing.',
    ),
    _LessonPage(
      number: 'MATERI 02',
      title: 'Motherboard',
      subtitle:
      'Mengenal papan utama komputer yang menjadi tempat terhubungnya berbagai komponen.',
      icon: Icons.developer_board_rounded,
      visualTitle: 'Bagian yang terhubung pada motherboard',
      visualItems: [
        _VisualItem(Icons.memory_rounded, 'CPU'),
        _VisualItem(Icons.sd_storage_rounded, 'RAM'),
        _VisualItem(Icons.cable_rounded, 'Port'),
      ],
      sections: [
        _LessonSection(
          title: 'Pengertian motherboard',
          body:
          'Motherboard atau papan induk adalah papan sirkuit utama yang menghubungkan berbagai komponen komputer agar dapat berkomunikasi dan bekerja bersama.',
        ),
        _LessonSection(
          title: 'Fungsi motherboard',
          bullets: [
            'Menjadi tempat pemasangan prosesor dan RAM.',
            'Menghubungkan komponen melalui jalur komunikasi.',
            'Menyediakan slot ekspansi dan konektor penyimpanan.',
            'Menghubungkan perangkat internal dan perangkat eksternal.',
          ],
        ),
        _LessonSection(
          title: 'Bagian-bagian motherboard',
          bullets: [
            'Socket CPU: tempat memasang prosesor.',
            'Slot RAM: tempat memasang modul memori.',
            'Slot ekspansi: tempat memasang kartu tambahan.',
            'Konektor SATA atau M.2: menghubungkan perangkat penyimpanan.',
            'Konektor daya: menerima pasokan listrik dari power supply.',
          ],
        ),
        _LessonSection(
          title: 'Hal yang perlu diperhatikan',
          body:
          'Motherboard harus sesuai dengan jenis socket prosesor, tipe RAM, ukuran casing, dan kebutuhan perangkat. Periksa spesifikasi sebelum memilih atau memasang komponen.',
        ),
      ],
      takeaway:
      'Motherboard menjadi pusat penghubung komponen sehingga kompatibilitasnya penting dalam merakit komputer.',
    ),
    _LessonPage(
      number: 'MATERI 03',
      title: 'Processor (CPU)',
      subtitle:
      'Memahami prosesor sebagai komponen yang menjalankan instruksi dan mengolah data.',
      icon: Icons.memory_rounded,
      visualTitle: 'Proses pengolahan instruksi',
      visualItems: [
        _VisualItem(Icons.input_rounded, 'Input'),
        _VisualItem(Icons.memory_rounded, 'CPU'),
        _VisualItem(Icons.output_rounded, 'Output'),
      ],
      sections: [
        _LessonSection(
          title: 'Pengertian processor',
          body:
          'Central Processing Unit (CPU) atau prosesor merupakan komponen yang menjalankan instruksi program dan melakukan operasi pengolahan data.',
        ),
        _LessonSection(
          title: 'Fungsi prosesor',
          bullets: [
            'Mengambil dan menjalankan instruksi.',
            'Melakukan operasi aritmetika dan logika.',
            'Mengatur jalannya proses komputasi.',
            'Berkomunikasi dengan memori dan komponen lain.',
          ],
        ),
        _LessonSection(
          title: 'Bagian penting CPU',
          bullets: [
            'ALU: melakukan operasi aritmetika dan logika.',
            'Control Unit: mengatur pelaksanaan instruksi.',
            'Register: menyimpan data sementara berkecepatan tinggi.',
            'Cache: membantu mempercepat akses data yang sering digunakan.',
          ],
        ),
        _LessonSection(
          title: 'Core dan clock speed',
          body:
          'Core merupakan unit pemrosesan di dalam prosesor. Clock speed menunjukkan frekuensi kerja prosesor. Kinerja komputer tidak ditentukan oleh satu angka saja, tetapi juga arsitektur, jumlah core, cache, dan kebutuhan aplikasi.',
        ),
        _LessonSection(
          title: 'Pentingnya pendinginan',
          body:
          'Prosesor menghasilkan panas ketika bekerja. Heatsink dan kipas atau sistem pendingin lain digunakan untuk menjaga suhu agar tetap berada dalam batas kerja yang aman.',
        ),
      ],
      takeaway:
      'Prosesor menjalankan instruksi dan mengolah data, sehingga menjadi salah satu komponen utama dalam kinerja komputer.',
    ),
    _LessonPage(
      number: 'MATERI 04',
      title: 'RAM (Random Access Memory)',
      subtitle:
      'Mengenal memori utama yang digunakan komputer untuk menyimpan data sementara ketika program berjalan.',
      icon: Icons.sd_storage_rounded,
      visualTitle: 'Hubungan CPU dan RAM',
      visualItems: [
        _VisualItem(Icons.memory_rounded, 'CPU'),
        _VisualItem(Icons.sd_storage_rounded, 'RAM'),
        _VisualItem(Icons.apps_rounded, 'Program'),
      ],
      sections: [
        _LessonSection(
          title: 'Pengertian RAM',
          body:
          'Random Access Memory (RAM) adalah memori utama yang menyimpan data dan instruksi yang sedang digunakan oleh komputer.',
        ),
        _LessonSection(
          title: 'Karakteristik RAM',
          bullets: [
            'Dapat dibaca dan ditulis selama komputer beroperasi.',
            'Bersifat sementara atau volatile.',
            'Data di dalam RAM hilang ketika daya listrik terputus.',
            'Memungkinkan CPU mengakses data yang sedang dibutuhkan.',
          ],
        ),
        _LessonSection(
          title: 'Kapasitas RAM',
          body:
          'Kapasitas RAM memengaruhi jumlah data dan program yang dapat ditangani secara bersamaan. Kebutuhan kapasitas bergantung pada sistem operasi, aplikasi, dan aktivitas pengguna.',
        ),
        _LessonSection(
          title: 'Jenis dan kompatibilitas RAM',
          body:
          'RAM memiliki beberapa generasi, seperti DDR3, DDR4, dan DDR5. Setiap generasi memiliki karakteristik dan bentuk fisik yang berbeda. Jenis RAM harus sesuai dengan dukungan motherboard.',
        ),
        _LessonSection(
          title: 'Contoh penerapan',
          body:
          'Ketika membuka aplikasi pengolah kata dan browser, data program yang sedang digunakan akan ditempatkan di memori agar dapat diakses oleh prosesor.',
        ),
      ],
      takeaway:
      'RAM menyimpan data sementara yang sedang digunakan. Kapasitas dan kompatibilitasnya perlu diperhatikan saat memilih komponen.',
    ),
    _LessonPage(
      number: 'MATERI 05',
      title: 'Penyimpanan: HDD dan SSD',
      subtitle:
      'Membedakan media penyimpanan yang digunakan untuk menyimpan sistem operasi, aplikasi, dan file pengguna.',
      icon: Icons.storage_rounded,
      visualTitle: 'Jenis media penyimpanan',
      visualItems: [
        _VisualItem(Icons.disc_full_rounded, 'HDD'),
        _VisualItem(Icons.storage_rounded, 'SSD'),
        _VisualItem(Icons.folder_rounded, 'Data'),
      ],
      sections: [
        _LessonSection(
          title: 'Fungsi perangkat penyimpanan',
          body:
          'Perangkat penyimpanan digunakan untuk menyimpan sistem operasi, aplikasi, dan data pengguna dalam jangka panjang, termasuk ketika komputer dimatikan.',
        ),
        _LessonSection(
          title: 'Hard Disk Drive (HDD)',
          body:
          'HDD menyimpan data menggunakan piringan magnetik yang berputar dan komponen mekanis untuk membaca atau menulis data.',
        ),
        _LessonSection(
          title: 'Solid State Drive (SSD)',
          body:
          'SSD menggunakan memori flash untuk menyimpan data dan tidak memiliki piringan berputar. SSD umumnya memiliki waktu akses lebih cepat dibandingkan HDD.',
        ),
        _LessonSection(
          title: 'Perbedaan HDD dan SSD',
          bullets: [
            'HDD menggunakan komponen mekanis, sedangkan SSD menggunakan memori flash.',
            'SSD umumnya memiliki waktu akses lebih cepat.',
            'HDD sering dipilih untuk kapasitas besar dengan biaya per kapasitas yang lebih rendah.',
            'Keduanya dapat digunakan untuk menyimpan sistem operasi dan data.',
          ],
        ),
        _LessonSection(
          title: 'Antarmuka penyimpanan',
          body:
          'Perangkat penyimpanan dapat menggunakan antarmuka seperti SATA atau NVMe melalui slot M.2. Pastikan motherboard mendukung jenis dan antarmuka penyimpanan yang akan digunakan.',
        ),
      ],
      takeaway:
      'HDD dan SSD sama-sama menyimpan data secara permanen, tetapi memiliki teknologi dan karakteristik yang berbeda.',
    ),
    _LessonPage(
      number: 'MATERI 06',
      title: 'Power Supply Unit (PSU)',
      subtitle:
      'Memahami fungsi catu daya yang menyediakan energi listrik bagi komponen komputer.',
      icon: Icons.electrical_services_rounded,
      visualTitle: 'Aliran daya pada komputer',
      visualItems: [
        _VisualItem(Icons.power_rounded, 'Listrik'),
        _VisualItem(Icons.electrical_services_rounded, 'PSU'),
        _VisualItem(Icons.computer_rounded, 'Komponen'),
      ],
      sections: [
        _LessonSection(
          title: 'Pengertian PSU',
          body:
          'Power Supply Unit (PSU) adalah perangkat yang mengubah listrik dari sumber AC menjadi tegangan DC yang dibutuhkan oleh komponen komputer.',
        ),
        _LessonSection(
          title: 'Fungsi PSU',
          bullets: [
            'Menyediakan daya listrik untuk komponen komputer.',
            'Mengubah tegangan AC menjadi tegangan DC.',
            'Mendistribusikan daya melalui konektor yang sesuai.',
            'Membantu menjaga pasokan daya sesuai spesifikasi perangkat.',
          ],
        ),
        _LessonSection(
          title: 'Konektor daya',
          bullets: [
            'Konektor 24-pin untuk motherboard pada banyak sistem desktop.',
            'Konektor CPU untuk memasok daya ke prosesor.',
            'Konektor PCIe untuk kartu grafis tertentu.',
            'Konektor SATA untuk perangkat penyimpanan.',
          ],
        ),
        _LessonSection(
          title: 'Memilih PSU',
          body:
          'Pemilihan PSU perlu mempertimbangkan kebutuhan daya seluruh komponen, kualitas unit, konektor yang tersedia, dan ruang pemasangan pada casing.',
        ),
        _LessonSection(
          title: 'Keselamatan kerja',
          body:
          'Matikan komputer dan lepaskan kabel listrik sebelum memasang atau melepas komponen. Jangan membuka casing PSU karena bagian dalamnya dapat menyimpan tegangan berbahaya.',
        ),
      ],
      takeaway:
      'PSU menyediakan daya bagi seluruh komponen. Pemilihan dan pemasangannya harus memperhatikan spesifikasi serta keselamatan kerja.',
    ),
    _LessonPage(
      number: 'MATERI 07',
      title: 'Perangkat Input dan Output',
      subtitle:
      'Mengenali perangkat yang digunakan untuk memasukkan data ke komputer dan menampilkan hasil pengolahan.',
      icon: Icons.devices_rounded,
      visualTitle: 'Contoh perangkat input dan output',
      visualItems: [
        _VisualItem(Icons.keyboard_rounded, 'Keyboard'),
        _VisualItem(Icons.mouse_rounded, 'Mouse'),
        _VisualItem(Icons.monitor_rounded, 'Monitor'),
        _VisualItem(Icons.print_rounded, 'Printer'),
      ],
      sections: [
        _LessonSection(
          title: 'Perangkat input',
          body:
          'Perangkat input digunakan untuk memasukkan data atau perintah ke komputer agar dapat diproses.',
        ),
        _LessonSection(
          title: 'Contoh perangkat input',
          bullets: [
            'Keyboard untuk memasukkan teks dan perintah.',
            'Mouse untuk menggerakkan penunjuk dan memilih objek.',
            'Scanner untuk mengubah dokumen atau gambar fisik menjadi data digital.',
            'Microphone untuk memasukkan suara.',
          ],
        ),
        _LessonSection(
          title: 'Perangkat output',
          body:
          'Perangkat output digunakan untuk menyampaikan hasil pengolahan komputer kepada pengguna dalam bentuk visual, suara, atau cetakan.',
        ),
        _LessonSection(
          title: 'Contoh perangkat output',
          bullets: [
            'Monitor menampilkan informasi secara visual.',
            'Printer menghasilkan dokumen atau gambar pada media cetak.',
            'Speaker mengeluarkan suara.',
            'Proyektor menampilkan gambar pada bidang yang lebih luas.',
          ],
        ),
        _LessonSection(
          title: 'Perangkat input dan output',
          body:
          'Beberapa perangkat dapat menjalankan fungsi input dan output sekaligus. Contohnya layar sentuh yang menampilkan informasi sekaligus menerima sentuhan pengguna.',
        ),
      ],
      takeaway:
      'Perangkat input memasukkan data, sedangkan perangkat output menyampaikan hasil pengolahan komputer kepada pengguna.',
    ),
    _LessonPage(
      number: 'MATERI 08',
      title: 'Casing, Pendingin, dan GPU',
      subtitle:
      'Mengenal komponen pendukung yang melindungi perangkat, menjaga suhu, dan membantu pemrosesan grafis.',
      icon: Icons.desktop_windows_rounded,
      visualTitle: 'Komponen pendukung komputer',
      visualItems: [
        _VisualItem(Icons.desktop_windows_rounded, 'Casing'),
        _VisualItem(Icons.ac_unit_rounded, 'Pendingin'),
        _VisualItem(Icons.videogame_asset_rounded, 'GPU'),
      ],
      sections: [
        _LessonSection(
          title: 'Casing komputer',
          body:
          'Casing merupakan wadah untuk memasang dan melindungi komponen komputer. Casing juga membantu pengaturan aliran udara dan kerapian pemasangan kabel.',
        ),
        _LessonSection(
          title: 'Sistem pendingin',
          body:
          'Sistem pendingin membantu membuang panas yang dihasilkan komponen. Contohnya heatsink, kipas, dan pendingin cair pada sistem tertentu.',
        ),
        _LessonSection(
          title: 'Graphics Processing Unit (GPU)',
          body:
          'GPU adalah unit pemrosesan yang dirancang untuk menangani pekerjaan grafis dan komputasi paralel tertentu. GPU dapat terintegrasi pada prosesor atau tersedia sebagai kartu grafis terpisah.',
        ),
        _LessonSection(
          title: 'Kartu ekspansi',
          body:
          'Kartu ekspansi dipasang pada slot yang tersedia di motherboard untuk menambahkan kemampuan komputer, misalnya kartu grafis, kartu suara, atau kartu jaringan.',
        ),
        _LessonSection(
          title: 'Menjaga kondisi komponen',
          bullets: [
            'Pastikan aliran udara casing tidak terhalang.',
            'Bersihkan debu secara berkala dengan prosedur yang aman.',
            'Pastikan kipas terpasang dan berfungsi dengan baik.',
            'Gunakan komponen yang sesuai dengan ukuran casing dan dukungan motherboard.',
          ],
        ),
      ],
      takeaway:
      'Komponen pendukung membantu melindungi perangkat, menjaga suhu, dan menambah kemampuan komputer sesuai kebutuhan.',
    ),
    _LessonPage(
      number: 'MATERI 09',
      title: 'Merangkai Komponen Komputer',
      subtitle:
      'Menghubungkan pengetahuan tentang komponen untuk memahami susunan dasar sebuah komputer.',
      icon: Icons.build_circle_rounded,
      visualTitle: 'Hubungan komponen dalam komputer',
      visualItems: [
        _VisualItem(Icons.developer_board_rounded, 'Motherboard'),
        _VisualItem(Icons.memory_rounded, 'CPU'),
        _VisualItem(Icons.sd_storage_rounded, 'RAM'),
        _VisualItem(Icons.storage_rounded, 'SSD'),
      ],
      sections: [
        _LessonSection(
          title: 'Contoh kebutuhan',
          body:
          'Sebuah laboratorium TKJ membutuhkan komputer untuk menjalankan sistem operasi, aplikasi perkantoran, browser, dan perangkat lunak pembelajaran.',
        ),
        _LessonSection(
          title: 'Menentukan komponen',
          bullets: [
            'Motherboard sebagai papan utama penghubung komponen.',
            'Prosesor untuk menjalankan instruksi dan mengolah data.',
            'RAM untuk menyimpan data sementara saat program berjalan.',
            'SSD atau HDD untuk menyimpan sistem operasi dan file.',
            'PSU untuk menyediakan daya listrik.',
            'Casing dan pendingin untuk mendukung pemasangan serta menjaga suhu.',
            'Monitor, keyboard, dan mouse untuk berinteraksi dengan komputer.',
          ],
        ),
        _LessonSection(
          title: 'Memeriksa kompatibilitas',
          body:
          'Sebelum merakit, periksa kesesuaian socket prosesor, jenis RAM, dukungan penyimpanan, ukuran motherboard, kebutuhan daya, dan ukuran casing.',
        ),
        _LessonSection(
          title: 'Urutan kerja secara umum',
          bullets: [
            'Siapkan area kerja dan lakukan tindakan pencegahan listrik statis.',
            'Periksa seluruh komponen dan spesifikasinya.',
            'Pasang komponen pada tempat yang sesuai dengan prosedur.',
            'Hubungkan kabel daya dan kabel data dengan benar.',
            'Periksa kembali pemasangan sebelum komputer dinyalakan.',
          ],
        ),
        _LessonSection(
          title: 'Pertanyaan refleksi',
          bullets: [
            'Apa fungsi motherboard dalam sebuah komputer?',
            'Mengapa komputer membutuhkan RAM dan penyimpanan?',
            'Apa akibatnya jika PSU tidak sesuai kebutuhan komponen?',
            'Mengapa kompatibilitas perlu diperiksa sebelum merakit komputer?',
          ],
        ),
      ],
      takeaway:
      'Merakit komputer membutuhkan pemahaman fungsi setiap komponen, pemeriksaan kompatibilitas, dan penerapan prosedur keselamatan kerja.',
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
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF263238),
        elevation: 0,
        title: const Text(
          'Komponen Komputer',
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
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildLessonContent(_LessonPage page, int index) {
    return SingleChildScrollView(
      key: PageStorageKey('komponen-komputer-page-$index'),
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
              'Kenali komponen • Pahami fungsi • Terapkan dengan tepat',
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

  Widget _buildBottomNavigation() {
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