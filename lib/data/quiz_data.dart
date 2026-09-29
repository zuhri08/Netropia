class QuizData {
  static List<Map<String, dynamic>> getPreTestQuestions(String materiId) {
    switch (materiId) {
      case 'k3':
        return _preTestK3;
      case 'komponen_komputer':
        return _preTestKomponen;
      case 'perangkat_jaringan':
        return _preTestPerangkat;
      case 'ip_address':
        return _preTestIpAddress;
      case 'kabel_jaringan':
        return _preTestKabel;
      case 'dasar_jaringan':
      default:
        return _preTestDasarJaringan;
    }
  }

  static List<Map<String, dynamic>> getPostTestQuestions(String materiId) {
    switch (materiId) {
      case 'k3':
        return _postTestK3;
      case 'komponen_komputer':
        return _postTestKomponen;
      case 'perangkat_jaringan':
        return _postTestPerangkat;
      case 'ip_address':
        return _postTestIpAddress;
      case 'kabel_jaringan':
        return _postTestKabel;
      case 'dasar_jaringan':
      default:
        return _postTestDasarJaringan;
    }
  }

  // ==========================================
  // DASAR TKJ
  // ==========================================
  static final List<Map<String, dynamic>> _preTestDasarTkj = [
    {
      'question': 'Kepanjangan dari TKJ adalah...',
      'options': [
        'Teknik Komputer dan Jaringan',
        'Teknik Komunikasi dan Jaringan',
        'Teknologi Komputer dan Jaringan',
        'Teknik Kelistrikan dan Jaringan',
      ],
      'answer': 0,
    },
    {
      'question': 'Elemen utama dalam sistem komputer terdiri dari...',
      'options': [
        'Hardware, Software, Brainware',
        'CPU, RAM, Harddisk',
        'Input, Process, Output',
        'Windows, Linux, MacOS',
      ],
      'answer': 0,
    },
    {
      'question': 'Perangkat keras komputer yang berfungsi mengolah data disebut...',
      'options': [
        'Hardware',
        'Software',
        'Brainware',
        'Firmware',
      ],
      'answer': 0,
    },
    {
      'question': 'Pengguna atau manusia yang mengoperasikan komputer disebut...',
      'options': [
        'Brainware',
        'Software',
        'Hardware',
        'Shareware',
      ],
      'answer': 0,
    },
    {
      'question': 'Salah satu peluang karir lulusan TKJ adalah...',
      'options': [
        'Network Engineer / Administrator',
        'Dokter Spesialis',
        'Akuntan Publik',
        'Arsitek Bangunan',
      ],
      'answer': 0,
    },
    {
      'question': 'Sistem operasi merupakan contoh dari...',
      'options': [
        'Software Sistem',
        'Software Aplikasi',
        'Hardware Utama',
        'Brainware Tingkat Atas',
      ],
      'answer': 0,
    },
    {
      'question': 'Komponen komputer yang berfungsi menyimpan data secara permanen adalah...',
      'options': [
        'Storage (HDD/SSD)',
        'RAM',
        'Prosesor',
        'Cache Memory',
      ],
      'answer': 0,
    },
    {
      'question': 'Bagian dari sistem komputer yang tidak memiliki wujud fisik namun dapat dijalankan adalah...',
      'options': [
        'Software',
        'Hardware',
        'Brainware',
        'Peripheral',
      ],
      'answer': 0,
    },
    {
      'question': 'Tujuan utama mempelajari Teknik Komputer dan Jaringan adalah...',
      'options': [
        'Memahami cara merakit komputer dan mengkonfigurasi jaringan',
        'Membuat animasi 3D profesional',
        'Menulis artikel berita online',
        'Mengelola keuangan perusahaan',
      ],
      'answer': 0,
    },
    {
      'question': 'Sikap profesional yang penting dimiliki oleh seorang teknisi TKJ adalah...',
      'options': [
        'Teliti, disiplin, dan mengutamakan keselamatan kerja',
        'Bekerja tergesa-gesa tanpa SOP',
        'Abaikan instruksi K3 di laboratorium',
        'Hanya fokus pada teori tanpa praktik',
      ],
      'answer': 0,
    },
  ];

  static final List<Map<String, dynamic>> _postTestDasarTkj = [
    {
      'question': 'Jika sebuah sistem komputer memiliki hardware dan software canggih tetapi tidak ada manusia yang mengoperasikannya, maka...',
      'options': [
        'Sistem tidak dapat menghasilkan informasi yang berguna',
        'Komputer akan otomatis bekerja sendiri tanpa batas',
        'Software akan menjadi hardware secara otomatis',
        'Sistem operasi tidak membutuhkan brainware',
      ],
      'answer': 0,
    },
    {
      'question': 'Seorang teknisi jaringan bertugas memastikan komputer di kantor terhubung ke internet. Profesi ini tergolong ke bidang...',
      'options': [
        'Network Administrator / Engineer',
        'Web Designer Visual',
        'Database Analyst',
        'Content Creator',
      ],
      'answer': 0,
    },
    {
      'question': 'Manakah yang merupakan hubungan tepat antara Hardware, Software, dan Brainware?',
      'options': [
        'Brainware memberi perintah melalui Software untuk diolah oleh Hardware',
        'Hardware menjalankan Brainware tanpa perantara Software',
        'Software menciptakan Brainware untuk merakit Hardware',
        'Ketiganya berdiri sendiri tanpa ada keterkaitan fungsi',
      ],
      'answer': 0,
    },
    {
      'question': 'Komponen komputer yang kehilangan datanya saat listrik padam tergolong memori...',
      'options': [
        'Volatile (seperti RAM)',
        'Non-Volatile (seperti SSD)',
        'Permanen',
        'Sekunder',
      ],
      'answer': 0,
    },
    {
      'question': 'Contoh aplikasi sistem operasi yang populer digunakan pada PC adalah...',
      'options': [
        'Windows dan Linux',
        'Google Chrome dan Firefox',
        'Microsoft Word dan Excel',
        'Photoshop dan CorelDraw',
      ],
      'answer': 0,
    },
    {
      'question': 'Dalam merakit komputer, langkah penting sebelum menyalakan daya untuk pertama kali adalah...',
      'options': [
        'Memastikan semua kabel daya dan komponen terpasang dengan benar',
        'Langsung memasang casing tanpa mengetes komponen',
        'Menghubungkan monitor ke port daya AC',
        'Menginstall aplikasi game berat',
      ],
      'answer': 0,
    },
    {
      'question': 'Perbedaan utama antara booting dingin (cold boot) dan booting hangat (warm boot) adalah...',
      'options': [
        'Cold boot dari kondisi komputer mati total, warm boot dilakukan saat komputer menyala (restart)',
        'Cold boot menggunakan tombol keyboard, warm boot menggunakan tombol power',
        'Cold boot dilakukan di ruangan dingin, warm boot di ruangan panas',
        'Cold boot khusus sistem operasi Linux, warm boot khusus Windows',
      ],
      'answer': 0,
    },
    {
      'question': 'Keterampilan dasar yang wajib dikuasai siswa TKJ pada tahap pemula adalah...',
      'options': [
        'Pengenalan komponen hardware, instalasi OS, dan dasar pengkabelan jaringan',
        'Pembuatan game 3D berskala industri',
        'Desain grafis dan editing video bioskop',
        'Analisis pasar saham dan investasi',
      ],
      'answer': 0,
    },
    {
      'question': 'Mengapa pemahaman tentang Dasar TKJ penting sebelum mempelajari materi jaringan yang kompleks?',
      'options': [
        'Karena jaringan komputer dibangun di atas fondasi perangkat keras dan sistem operasi',
        'Karena Dasar TKJ hanya membahas tentang matematika',
        'Agar siswa tidak perlu belajar K3',
        'Sebab jaringan komputer tidak membutuhkan perangkat keras',
      ],
      'answer': 0,
    },
    {
      'question': 'Penerapan etika profesi di bidang TKJ salah satunya ditunjukkan dengan...',
      'options': [
        'Menjaga kerahasiaan data dan hak akses pengguna jaringan',
        'Membagikan kata sandi server ke publik',
        'Mengubah konfigurasi jaringan tanpa izin administrator',
        'Mengabaikan keamanan sistem komputer',
      ],
      'answer': 0,
    },
  ];

  // ==========================================
  // K3 (KESELAMATAN DAN KESEHATAN KERJA)
  // ==========================================
  static final List<Map<String, dynamic>> _preTestK3 = [
    {
      'question': 'Kepanjangan dari K3LH adalah...',
      'options': [
        'Keselamatan, Kesehatan Kerja, dan Lingkungan Hidup',
        'Keamanan, Keselamatan Kerja, dan Lingkungan Hidup',
        'Kesehatan, Keahlian Kerja, dan Lingkungan Hidup',
        'Keselamatan, Ketertiban Kerja, dan Lingkungan Hidup',
      ],
      'answer': 0,
    },
    {
      'question': 'Tujuan utama penerapan K3 di laboratorium TKJ adalah...',
      'options': [
        'Mencegah kecelakaan kerja dan melindungi praktikan serta peralatan',
        'Mempercepat proses pengerjaan tanpa aturan',
        'Mengurangi biaya pembelian komponen komputer',
        'Memperindah tampilan ruangan laboratorium',
      ],
      'answer': 0,
    },
    {
      'question': 'Alat pelindung diri (APD) yang wajib digunakan saat merakit PC untuk mencegah listrik statis adalah...',
      'options': [
        'Gelang anti-statis (Anti-static wrist strap)',
        'Helm proyek',
        'Masker medis',
        'Kacamata renang',
      ],
      'answer': 0,
    },
    {
      'question': 'Tindakan pertama saat terjadi korsleting listrik di lab komputer adalah...',
      'options': [
        'Mematikan sumber listrik utama (MCB)',
        'Menyiram sumber api dengan air',
        'Meneruskan pekerjaan merakit',
        'Membuka semua jendela tanpa mematikan listrik',
      ],
      'answer': 0,
    },
    {
      'question': 'Posisi duduk yang ergonomis saat menggunakan komputer adalah...',
      'options': [
        'Punggung tegak, posisi mata sejajar dengan bagian atas layar',
        'Membungkuk sangat dekat dengan layar',
        'Sambil tiduran di lantai lab',
        'Kaki menggantung tanpa menyentuh lantai',
      ],
      'answer': 0,
    },
    {
      'question': 'Alat pemadam api yang tepat untuk kebakaran akibat peralatan listrik adalah...',
      'options': [
        'APAR berbahan Co2 atau Powder kering',
        'Ember berisi air',
        'Kain basah bernoda minyak',
        'Bensin cair',
      ],
      'answer': 0,
    },
    {
      'question': 'Mengapa dilarang membawa makanan dan minuman ke dalam laboratorium komputer?',
      'options': [
        'Cairan yang tumpah dapat menyebabkan korsleting dan merusak komponen',
        'Makanan membuat jaringan internet menjadi lambat',
        'Komputer dapat menyerap bau makanan',
        'Ruangan akan menjadi terlalu dingin',
      ],
      'answer': 0,
    },
    {
      'question': 'Penyakit akibat kerja yang timbul karena mengetik terlalu lama tanpa istirahat adalah...',
      'options': [
        'Carpal Tunnel Syndrome (CTS)',
        'Anemia',
        'Influenza',
        'Sakit gigi',
      ],
      'answer': 0,
    },
    {
      'question': 'Warna simbol peringatan bahaya pada standar K3 biasanya menggunakan warna...',
      'options': [
        'Kuning / Oranye',
        'Biru Muda',
        'Hijau Toska',
        'Merah Jambu',
      ],
      'answer': 0,
    },
    {
      'question': 'Langkah awal sebelum membuka casing Power Supply unit komputer adalah...',
      'options': [
        'Mencabut kabel daya listrik dari stopkontak',
        'Menyiram power supply dengan alkohol',
        'Langsung memegang kapasitor dengan tangan basah',
        'Menyalakan tombol power berkali-kali',
      ],
      'answer': 0,
    },
  ];

  static final List<Map<String, dynamic>> _postTestK3 = [
    {
      'question': 'Seorang siswa merasa kesemutan di pergelangan tangan setelah mengetik 4 jam non-stop. Tindakan ergonomis pencegahan yang tepat adalah...',
      'options': [
        'Melakukan peregangan dan mengatur posisi wrist rest serta posisi mengetik yang benar',
        'Menambah waktu mengetik tanpa jeda',
        'Menggunakan keyboard tanpa alas meja',
        'Mendekatkan layar ke mata',
      ],
      'answer': 0,
    },
    {
      'question': 'Mengapa air sama sekali tidak boleh digunakan untuk memadamkan kebakaran akibat listrik kelas C?',
      'options': [
        'Air menghantarkan listrik dan dapat menyengat pemadam kebakaran',
        'Air membuat api membeku',
        'Air menyebabkan kebocoran sinyal wifi',
        'Air merubah komponen menjadi plastik',
      ],
      'answer': 0,
    },
    {
      'question': 'SOP penghentian darurat (Emergency Shutdown) di ruang server dilakukan ketika...',
      'options': [
        'Terjadi bencana atau kebakaran besar yang mengancam keselamatan',
        'Ada siswa yang tidak membawa buku catatan',
        'Suhu ruangan lab naik 1 derajat Celcius',
        'Listrik padam selama 1 detik',
      ],
      'answer': 0,
    },
    {
      'question': 'Penggunaan kabel rol yang menumpuk berlebihan pada satu stopkontak di lab TKJ berpotensi menyebabkan...',
      'options': [
        'Kelebihan beban listrik (overload) dan kebakaran',
        'Kecepatan transmisi data meningkat pesat',
        'Tegangan listrik menjadi nol secara permanen',
        'RAM komputer bertambah otomatis',
      ],
      'answer': 0,
    },
    {
      'question': 'Fungsi penataan kabel (Cable Management) di dalam lab komputer dari sudut pandang K3 adalah...',
      'options': [
        'Mencegah orang tersandung kabel dan memudahkan pemeliharaan',
        'Menambah kecepatan processor komputer',
        'Mengurangi konsumsi listrik monitor',
        'Memperbaiki harddisk yang rusak',
      ],
      'answer': 0,
    },
    {
      'question': 'Prinsip K3 5R/5S di lingkungan kerja meliputi...',
      'options': [
        'Ringkas, Rapi, Resik, Rawat, Rajin',
        'Rencanakan, Rakit, Rawat, Rusak, Rombak',
        'Riset, Rancang, Rapi, Rehat, Rutin',
        'Ruang, Rangka, Rakit, Rute, Rehat',
      ],
      'answer': 0,
    },
    {
      'question': 'Langkah penanganan cedera luka bakar ringan akibat terkena solder panas saat praktik adalah...',
      'options': [
        'Mendinginkan luka dengan air mengalir selama beberapa menit',
        'Oleskan minyak goreng mendidih',
        'Bungkus rapat dengan plastik',
        'Biarkan tanpa penanganan apapun',
      ],
      'answer': 0,
    },
    {
      'question': 'Pencahayaan ruangan laboratorium komputer yang ideal menurut K3 adalah...',
      'options': [
        'Cukup terang dan tidak menimbulkan silau pada layar monitor',
        'Sangat gelap seperti di dalam bioskop',
        'Lampu sorot langsung mengarah ke mata praktikan',
        'Gunakan lampu kedap-kedip berwarna-warni',
      ],
      'answer': 0,
    },
    {
      'question': 'Sebelum melakukan crimping kabel UTP menggunakan tang crimping, tindakan K3 yang harus diperhatikan adalah...',
      'options': [
        'Memastikan jari tidak berada di area pisau pemotong tang',
        'Menggigit kulit kabel menggunakan gigi',
        'Memotong kabel saat masih terhubung ke listrik',
        'Menggunakan tang crimping sebagai pemukul',
      ],
      'answer': 0,
    },
    {
      'question': 'Mengapa ventilasi dan sirkulasi udara yang baik sangat dibutuhkan di ruang server / lab TKJ?',
      'options': [
        'Menjaga suhu perangkat dan mencegah akumulasi panas berlebih',
        'Agar sinyal radio tidak keluar dari ruangan',
        'Menjaga agar harddisk tidak berputar',
        'Mencegah cahaya matahari masuk',
      ],
      'answer': 0,
    },
  ];

  // ==========================================
  // KOMPONEN KOMPUTER
  // ==========================================
  static final List<Map<String, dynamic>> _preTestKomponen = [
    {
      'question': 'Otak dari sebuah komputer yang bertugas memproses instruksi dan data adalah...',
      'options': [
        'CPU (Central Processing Unit)',
        'RAM (Random Access Memory)',
        'HDD (Hard Disk Drive)',
        'PSU (Power Supply Unit)',
      ],
      'answer': 0,
    },
    {
      'question': 'Komponen yang berfungsi sebagai papan sirkuit utama tempat menghubungkan semua komponen adalah...',
      'options': [
        'Motherboard',
        'VGA Card',
        'Sound Card',
        'LAN Card',
      ],
      'answer': 0,
    },
    {
      'question': 'Memori tempat penyimpanan data sementara saat komputer dihidupkan adalah...',
      'options': [
        'RAM',
        'SSD',
        'ROM',
        'Flashdisk',
      ],
      'answer': 0,
    },
    {
      'question': 'Perangkat penyimpanan berbasis flash tanpa komponen bergerak yang memiliki kecepatan tinggi adalah...',
      'options': [
        'SSD (Solid State Drive)',
        'HDD (Hard Disk Drive)',
        'CD-ROM',
        'Floppy Disk',
      ],
      'answer': 0,
    },
    {
      'question': 'Komponen yang menyuplai arus listrik DC ke seluruh komponen komputer adalah...',
      'options': [
        'Power Supply Unit (PSU)',
        'Heatsink Fan',
        'Northbridge',
        'BIOS Chip',
      ],
      'answer': 0,
    },
    {
      'question': 'Kartu grafis yang mengolah data gambar untuk ditampilkan ke layar monitor disebut...',
      'options': [
        'GPU / VGA Card',
        'Network Interface Card',
        'Capture Card',
        'Audio Interface',
      ],
      'answer': 0,
    },
    {
      'question': 'Sistem pendingin aktif pada CPU biasanya menggunakan kombinasi...',
      'options': [
        'Heatsink dan Kipas (Fan)',
        'RAM dan SSD',
        'Kabel SATA dan Power',
        'Pasta thermal dan Thermal pad saja',
      ],
      'answer': 0,
    },
    {
      'question': 'Socket CPU pada motherboard berfungsi untuk...',
      'options': [
        'Tempat dudukan dan pin koneksi prosesor',
        'Memasang modul RAM',
        'Menghubungkan kabel SATA',
        'Memasang kartu ekspansi PCIe',
      ],
      'answer': 0,
    },
    {
      'question': 'Port ekspansi pada motherboard yang biasa digunakan untuk memasang VGA card modern adalah...',
      'options': [
        'PCI Express (PCIe) x16',
        'Port AGP lama',
        'Slot ISA',
        'Port USB 2.0',
      ],
      'answer': 0,
    },
    {
      'question': 'Chipset pada motherboard yang menyimpan firmware pengujian hardware awal adalah...',
      'options': [
        'BIOS / UEFI',
        'CMOS Battery',
        'SATA Controller',
        'Audio Codec',
      ],
      'answer': 0,
    },
  ];

  static final List<Map<String, dynamic>> _postTestKomponen = [
    {
      'question': 'Sebuah komputer sering mengalami blue screen dan hang saat membuka banyak program berat secara bersamaan. Komponen yang paling mungkin perlu ditingkatkan kapasitasnya adalah...',
      'options': [
        'RAM (Random Access Memory)',
        'Casing komputer',
        'Kabel SATA',
        'Power kabel monitor',
      ],
      'answer': 0,
    },
    {
      'question': 'Prosesor dengan suhu mencapai 95 derajat Celcius hingga terjadi thermal throttling kemungkinan disebabkan oleh...',
      'options': [
        'Thermal paste mengering atau heatsink fan terpasang tidak rapat',
        'Kapasitas SSD penuh',
        'Jumlah RAM terlalu besar',
        'Kabel LAN tidak terpasang',
      ],
      'answer': 0,
    },
    {
      'question': 'Perbedaan mendasar antara SSD NVMe M.2 dan HDD SATA konvensional terletak pada...',
      'options': [
        'SSD NVMe menggunakan chip memori flash berkecepatan tinggi, HDD menggunakan piringan magnetik berputar',
        'SSD NVMe membutuhkan daya listrik lebih besar dari HDD',
        'HDD memiliki bentuk lebih kecil dari SSD NVMe',
        'HDD tidak membutuhkan controller SATA',
      ],
      'answer': 0,
    },
    {
      'question': 'Sistem komputer bekerja berdasarkan Arsitektur Von Neumann yang mencakup 4 bagian utama yaitu...',
      'options': [
        'Unit Input, Memory, CPU (ALU + Control Unit), dan Unit Output',
        'Keyboard, Mouse, Monitor, dan Printer',
        'Windows, Linux, Android, dan iOS',
        'SATA, NVMe, PCIe, dan USB',
      ],
      'answer': 0,
    },
    {
      'question': 'Fungsi utama dari Baterai CMOS pada motherboard adalah...',
      'options': [
        'Menjaga daya memori CMOS untuk menyimpan tanggal, waktu, dan setting BIOS',
        'Menyuplai listrik utama untuk menggerakkan fan CPU',
        'Memberi tenaga tambahan pada kartu VGA',
        'Mengisi daya listrik SSD saat mati lampu',
      ],
      'answer': 0,
    },
    {
      'question': 'Jika komputer dinyalakan, kipas berputar tetapi tidak ada tampilan di layar dan terdengar bunyi beep berulang kali, kemungkinan masalah terjadi pada...',
      'options': [
        'RAM tidak terpasang dengan benar atau kotor',
        'Keyboard rusak',
        'Mouse lepas dari port USB',
        'Kabel daya printer terlepas',
      ],
      'answer': 0,
    },
    {
      'question': 'Fungsi dari sertifikasi 80 Plus pada Power Supply Unit (PSU) adalah...',
      'options': [
        'Menjamin efisiensi daya minimal 80% sehingga hemat energi dan stabil',
        'Menandakan PSU dapat bertahan hingga 80 tahun',
        'Membuat watt PSU bertambah 80 watt otomatis',
        'Menjamin suhu PSU selalu di bawah 80 derajat',
      ],
      'answer': 0,
    },
    {
      'question': 'Bagian dari CPU yang melakukan perhitungan aritmatika dan logika adalah...',
      'options': [
        'ALU (Arithmetic Logic Unit)',
        'CU (Control Unit)',
        'Register Unit',
        'Cache L3 Unit',
      ],
      'answer': 0,
    },
    {
      'question': 'Mengapa konfigurasi RAM Dual Channel meningkatkan performa sistem dibandingkan Single Channel?',
      'options': [
        'Karena melipatgandakan lebar jalur data (bus width) dari memori ke memory controller',
        'Sebab RAM Dual Channel menghemat penggunaan storage SSD',
        'Karena frekuensi processor berkurang separuhnya',
        'Sebab tidak menggunakan listrik sama sekali',
      ],
      'answer': 0,
    },
    {
      'question': 'Langkah awal yang tepat saat melakukan troubleshooting PC yang mati total tanpa indikator lampu sama sekali adalah...',
      'options': [
        'Mengecek ketersediaan arus stopkontak dan kondisi Power Supply (PSU)',
        'Mengganti prosessor dengan yang baru',
        'Melakukan re-install sistem operasi',
        'Membeli motherboard baru',
      ],
      'answer': 0,
    },
  ];

  // ==========================================
  // PERANGKAT JARINGAN
  // ==========================================
  static final List<Map<String, dynamic>> _preTestPerangkat = [
    {
      'question': 'Perangkat jaringan yang berfungsi menghubungkan dua atau lebih jaringan yang berbeda subnet dinamakan...',
      'options': [
        'Router',
        'Switch',
        'Hub',
        'Access Point',
      ],
      'answer': 0,
    },
    {
      'question': 'Perangkat cerdas yang menghubungkan komputer dalam satu LAN berdasarkan MAC Address dinamakan...',
      'options': [
        'Switch',
        'Hub',
        'Repeater',
        'Modem',
      ],
      'answer': 0,
    },
    {
      'question': 'Perangkat jaringan sederhana yang memancarkan sinyal ke seluruh port (broadcast) tanpa memilah tujuan adalah...',
      'options': [
        'Hub',
        'Switch Managed',
        'Router MikroTik',
        'Bridge',
      ],
      'answer': 0,
    },
    {
      'question': 'Perangkat yang memancarkan sinyal nirkabel (Wi-Fi) agar komputer dapat terhubung tanpa kabel dinamakan...',
      'options': [
        'Access Point',
        'LAN Card',
        'Kabel UTP',
        'Rack Server',
      ],
      'answer': 0,
    },
    {
      'question': 'Perangkat yang mengonversi sinyal analog dari ISP menjadi sinyal digital untuk komputer adalah...',
      'options': [
        'Modem',
        'Switch Unmanaged',
        'LAN Tester',
        'Splitter Audio',
      ],
      'answer': 0,
    },
    {
      'question': 'Kartu jaringan yang terpasang pada komputer agar dapat terhubung ke jaringan ethernet dinamakan...',
      'options': [
        'NIC (Network Interface Card) / LAN Card',
        'VGA Card',
        'Sound Card',
        'Capture Card',
      ],
      'answer': 0,
    },
    {
      'question': 'Perangkat yang berfungsi memperluas jangkauan sinyal jaringan nirkabel dinamakan...',
      'options': [
        'Repeater / Range Extender',
        'Firewall Hardware',
        'Proxy Server',
        'Network Hub',
      ],
      'answer': 0,
    },
    {
      'question': 'Sistem keamanan perangkat yang menyaring paket data masuk dan keluar jaringan dinamakan...',
      'options': [
        'Firewall',
        'Gateway',
        'DHCP Server',
        'DNS Resolver',
      ],
      'answer': 0,
    },
    {
      'question': 'Alamat fisik unik yang tertanam pada setiap NIC pabrikan dinamakan...',
      'options': [
        'MAC Address',
        'IP Address',
        'Subnet Mask',
        'Default Gateway',
      ],
      'answer': 0,
    },
    {
      'question': 'Alat yang digunakan untuk menguji kontinuitas koneksi kabel jaringan RJ45 dinamakan...',
      'options': [
        'LAN Tester',
        'Tang Crimping',
        'Multimeter Analog',
        'Solder Listrik',
      ],
      'answer': 0,
    },
  ];

  static final List<Map<String, dynamic>> _postTestPerangkat = [
    {
      'question': 'Sebuah lab komputer sering mengalami tabrakan data (collision) yang tinggi karena menggunakan perangkat penghubung lama. Solusi terbaik adalah mengganti perangkat tersebut dengan...',
      'options': [
        'Switch, karena mengisolasi collision domain di setiap port-nya',
        'Hub baru dengan port lebih banyak',
        'Kabel coaxial tua',
        'Splitter RJ11',
      ],
      'answer': 0,
    },
    {
      'question': 'Perusahaan ingin menghubungkan jaringan lokal gedung A ke internet melalui layanan ISP Fiber Optik. Perangkat utama di gerbang jaringan adalah...',
      'options': [
        'Router dan Modem ONT',
        'Hub 8 port',
        'Access Point indoor saja',
        'LAN Tester',
      ],
      'answer': 0,
    },
    {
      'question': 'Perbedaan utama dalam cara kerja Switch dan Router adalah...',
      'options': [
        'Switch bekerja di Layer 2 (Data Link) memakai MAC Address, Router bekerja di Layer 3 (Network) memakai IP Address',
        'Switch menggunakan sinyal radio, Router menggunakan kabel saja',
        'Switch menghubungkan beda IP, Router menghubungkan satu subnet',
        'Switch membutuhkan modem, Router tidak butuh listrik',
      ],
      'answer': 0,
    },
    {
      'question': 'Manakah dari perangkat berikut yang beroperasi untuk memperkuat sinyal jaringan yang melemah akibat jarak kabel yang jauh?',
      'options': [
        'Repeater',
        'Firewall',
        'Network Adapter',
        'Web Server',
      ],
      'answer': 0,
    },
    {
      'question': 'Dalam menentukan kapasitas Switch untuk laboratorium berisi 30 PC praktikan, kriteria minimal yang tepat adalah...',
      'options': [
        'Switch dengan minimal 32 atau 48 port berkecepatan Gigabit Ethernet',
        'Hub 4 port berjumlah 8 buah yang diparalel',
        'Access Point 1 port saja',
        'Router tanpa port LAN',
      ],
      'answer': 0,
    },
    {
      'question': 'Fitur PoE (Power over Ethernet) pada Switch memungkinkan...',
      'options': [
        'Penyaluran arus listrik DC bersama data melalui kabel UTP ke perangkat Access Point / IP Camera',
        'Peningkatan kecepatan internet hingga 10x lipat',
        'Kabel UTP tidak memerlukan RJ45',
        'Switch bekerja tanpa disambung ke PLN',
      ],
      'answer': 0,
    },
    {
      'question': 'Fungsi dari Access Point dengan SSID Tersembunyi (Hidden SSID) adalah...',
      'options': [
        'Mencegah nama jaringan Wi-Fi muncul dalam daftar pemindaian publik',
        'Menghilangkan enkripsi password Wi-Fi',
        'Memperluas jangkauan sinyal hingga 10 km',
        'Menggantikan fungsi kabel Fiber Optik',
      ],
      'answer': 0,
    },
    {
      'question': 'Perangkat Bridge berfungsi untuk...',
      'options': [
        'Menghubungkan dua segmen jaringan lokal yang sejenis menjadi satu jaringan besar',
        'Mengonversi sinyal suara menjadi sinyal listrik',
        'Memotong kabel UTP secara otomatis',
        'Menyimpan file dokumen pengguna',
      ],
      'answer': 0,
    },
    {
      'question': 'Jika lampu indikator port pada Switch tidak menyala saat dihubungkan ke komputer praktikan, penyebab yang paling mungkin adalah...',
      'options': [
        'Kabel UTP terputus atau konektor RJ45 tidak terpasang sempurna',
        'Suhu ruangan lab terlalu dingin',
        'RAM komputer terlalu penuh',
        'Monitor komputer mati',
      ],
      'answer': 0,
    },
    {
      'question': 'Penggunaan Managed Switch memberikan keunggulan dibandingkan Unmanaged Switch dalam hal...',
      'options': [
        'Dapat dikonfigurasi fitur VLAN, Quality of Service (QoS), dan monitoring lalu lintas data',
        'Harganya jauh lebih murah dan tidak butuh listrik',
        'Hanya bisa dipakai untuk 2 komputer',
        'Tidak memiliki port RJ45',
      ],
      'answer': 0,
    },
  ];

  // ==========================================
  // DASAR JARINGAN
  // ==========================================
  static final List<Map<String, dynamic>> _preTestDasarJaringan = [
    {
      'question': 'Apa yang dimaksud dengan jaringan komputer?',
      'options': [
        'Kumpulan komputer yang saling terhubung untuk berbagi data dan sumber daya',
        'Perangkat yang digunakan untuk menghubungkan komputer ke internet',
        'Sistem operasi yang digunakan untuk mengelola komputer',
        'Kabel yang digunakan untuk menghubungkan perangkat',
      ],
      'answer': 0,
    },
    {
      'question': 'Salah satu manfaat utama jaringan komputer adalah...',
      'options': [
        'Membuat komputer bekerja tanpa sistem operasi',
        'Memungkinkan berbagi data dan sumber daya',
        'Menghilangkan kebutuhan akan perangkat jaringan',
        'Membatasi komunikasi antar komputer',
      ],
      'answer': 1,
    },
    {
      'question': 'Contoh sumber daya yang dapat dibagikan melalui jaringan adalah...',
      'options': [
        'Printer',
        'Keyboard internal',
        'Baterai laptop',
        'Layar monitor',
      ],
      'answer': 0,
    },
    {
      'question': 'Jaringan komputer dengan cakupan wilayah kecil seperti laboratorium sekolah disebut...',
      'options': [
        'WAN',
        'MAN',
        'LAN',
        'Internet',
      ],
      'answer': 2,
    },
    {
      'question': 'Jaringan yang mencakup wilayah metropolitan atau satu kota disebut...',
      'options': [
        'LAN',
        'MAN',
        'WAN',
        'PAN',
      ],
      'answer': 1,
    },
    {
      'question': 'Jaringan yang dapat mencakup wilayah geografis yang sangat luas disebut...',
      'options': [
        'LAN',
        'PAN',
        'WAN',
        'CAN',
      ],
      'answer': 2,
    },
    {
      'question': 'Topologi jaringan yang menggunakan satu perangkat pusat seperti switch disebut...',
      'options': [
        'Bus',
        'Ring',
        'Star',
        'Mesh',
      ],
      'answer': 2,
    },
    {
      'question': 'Protokol yang menjadi dasar komunikasi data pada internet adalah...',
      'options': [
        'TCP/IP',
        'HTML',
        'USB',
        'HDMI',
      ],
      'answer': 0,
    },
    {
      'question': 'Protokol yang digunakan untuk mengakses halaman web secara aman adalah...',
      'options': [
        'HTTPS',
        'FTP',
        'SMTP',
        'DHCP',
      ],
      'answer': 0,
    },
    {
      'question': 'Firewall pada jaringan berfungsi untuk...',
      'options': [
        'Membatasi atau mengontrol akses jaringan berdasarkan aturan tertentu',
        'Menambah kecepatan processor',
        'Menghubungkan printer secara fisik',
        'Mengganti alamat MAC',
      ],
      'answer': 0,
    },
  ];

  static final List<Map<String, dynamic>> _postTestDasarJaringan = [
    {
      'question': 'Sebuah laboratorium memiliki 20 komputer yang berada dalam satu ruangan dan saling terhubung untuk berbagi printer. Jenis jaringan yang paling sesuai adalah...',
      'options': [
        'LAN',
        'MAN',
        'WAN',
        'Internet',
      ],
      'answer': 0,
    },
    {
      'question': 'Sebuah sekolah menghubungkan jaringan komputer dari beberapa gedung yang masih berada dalam satu wilayah sekolah. Tujuan utama jaringan tersebut adalah...',
      'options': [
        'Membatasi pertukaran data antarperangkat',
        'Memungkinkan perangkat berbagi data dan sumber daya',
        'Menghilangkan kebutuhan perangkat jaringan',
        'Membuat setiap komputer bekerja secara terpisah',
      ],
      'answer': 1,
    },
    {
      'question': 'Sebuah perusahaan memiliki kantor di Surabaya, Jakarta, dan Bandung yang perlu saling terhubung melalui jaringan. Jenis jaringan yang sesuai adalah...',
      'options': [
        'LAN',
        'PAN',
        'WAN',
        'CAN',
      ],
      'answer': 2,
    },
    {
      'question': 'Pada jaringan dengan topologi star, beberapa komputer terhubung ke satu perangkat pusat. Perangkat pusat yang umum digunakan adalah...',
      'options': [
        'Switch',
        'Monitor',
        'Keyboard',
        'Printer',
      ],
      'answer': 0,
    },
    {
      'question': 'Jika salah satu kabel menuju sebuah komputer pada topologi star mengalami kerusakan, dampak yang paling mungkin terjadi adalah...',
      'options': [
        'Seluruh jaringan pasti mati',
        'Hanya komputer yang terhubung melalui kabel tersebut yang terganggu',
        'Semua komputer kehilangan sistem operasi',
        'Switch otomatis berubah menjadi router',
      ],
      'answer': 1,
    },
    {
      'question': 'Sebuah jaringan menggunakan satu kabel utama sebagai jalur komunikasi beberapa perangkat. Topologi tersebut adalah...',
      'options': [
        'Ring',
        'Mesh',
        'Star',
        'Bus',
      ],
      'answer': 3,
    },
    {
      'question': 'Pada topologi mesh, perangkat memiliki banyak koneksi langsung. Salah satu karakteristik dari topologi ini adalah...',
      'options': [
        'Memiliki banyak jalur komunikasi antarperangkat',
        'Hanya menggunakan satu kabel utama',
        'Seluruh perangkat bergantung pada satu perangkat pusat',
        'Tidak membutuhkan media transmisi',
      ],
      'answer': 0,
    },
    {
      'question': 'Sebuah komputer mengakses website menggunakan protokol HTTP. Fungsi utama HTTP adalah...',
      'options': [
        'Mengatur komunikasi untuk pertukaran data halaman web',
        'Menghubungkan kabel jaringan secara fisik',
        'Mengatur kapasitas penyimpanan komputer',
        'Menggantikan fungsi sistem operasi',
      ],
      'answer': 0,
    },
    {
      'question': 'Ketika sebuah website menggunakan HTTPS, salah satu keuntungan utamanya adalah...',
      'options': [
        'Data komunikasi web mendapatkan perlindungan enkripsi',
        'Komputer tidak membutuhkan jaringan',
        'Website hanya dapat dibuka secara offline',
        'Semua perangkat otomatis menjadi server',
      ],
      'answer': 0,
    },
    {
      'question': 'Aturan keamanan yang digunakan oleh firewall untuk menentukan paket data yang boleh lewat dinamakan...',
      'options': [
        'Firewall Rules / Security Policy',
        'Routing Table',
        'DHCP Scope',
        'MAC Table',
      ],
      'answer': 0,
    },
  ];

  // ==========================================
  // IP ADDRESS
  // ==========================================
  static final List<Map<String, dynamic>> _preTestIpAddress = [
    {
      'question': 'Alamat logika versi 4 (IPv4) terdiri dari deretan angka sebanyak...',
      'options': [
        '32 bit (4 octet)',
        '128 bit (8 hextet)',
        '48 bit',
        '64 bit',
      ],
      'answer': 0,
    },
    {
      'question': 'Setiap oktet pada IPv4 dipisahkan oleh tanda...',
      'options': [
        'Titik (dot)',
        'Titik dua (colon)',
        'Koma (comma)',
        'Garis miring (slash)',
      ],
      'answer': 0,
    },
    {
      'question': 'Panjang alamat IPv6 adalah...',
      'options': [
        '128 bit',
        '32 bit',
        '64 bit',
        '256 bit',
      ],
      'answer': 0,
    },
    {
      'question': 'Kelas IP versi 4 yang memiliki range oktet pertama 192 - 223 adalah...',
      'options': [
        'Kelas C',
        'Kelas A',
        'Kelas B',
        'Kelas D',
      ],
      'answer': 0,
    },
    {
      'question': 'Subnet Mask standar untuk IP kelas C (/24) adalah...',
      'options': [
        '255.255.255.0',
        '255.0.0.0',
        '255.255.0.0',
        '255.255.255.255',
      ],
      'answer': 0,
    },
    {
      'question': 'Alamat IP yang digunakan khusus untuk jaringan lokal dan tidak bisa dirouting di internet publik disebut...',
      'options': [
        'IP Private',
        'IP Public',
        'IP Loopback',
        'IP Automatic',
      ],
      'answer': 0,
    },
    {
      'question': 'Alamat IP 127.0.0.1 dinamakan alamat...',
      'options': [
        'Loopback address (Localhost)',
        'Broadcast address',
        'Network address',
        'Multicast address',
      ],
      'answer': 0,
    },
    {
      'question': 'Protokol yang memberikan alamat IP secara otomatis ke komputer klien dinamakan...',
      'options': [
        'DHCP (Dynamic Host Configuration Protocol)',
        'DNS (Domain Name System)',
        'NAT (Network Address Translation)',
        'ARP (Address Resolution Protocol)',
      ],
      'answer': 0,
    },
    {
      'question': 'Alamat IP pertama dalam sebuah subnet yang menandai identitas jaringan disebut...',
      'options': [
        'Network ID',
        'Broadcast ID',
        'Host ID',
        'Subnet ID',
      ],
      'answer': 0,
    },
    {
      'question': 'Alamat IP terakhir dalam sebuah subnet yang digunakan untuk mengirim pesan ke seluruh host dinamakan...',
      'options': [
        'Broadcast ID',
        'Network ID',
        'Gateway Address',
        'DNS Address',
      ],
      'answer': 0,
    },
  ];

  static final List<Map<String, dynamic>> _postTestIpAddress = [
    {
      'question': 'Manakah dari IP Address berikut yang termasuk dalam kelompok IP Private Kelas C?',
      'options': [
        '192.168.1.10',
        '8.8.8.8',
        '10.0.0.1',
        '172.16.0.1',
      ],
      'answer': 0,
    },
    {
      'question': 'Diberikan IP Address 192.168.10.15/24. Berapakah alokasi jumlah host yang dapat digunakan?',
      'options': [
        '254 host',
        '256 host',
        '128 host',
        '512 host',
      ],
      'answer': 0,
    },
    {
      'question': 'Jika komputer memiliki IP 192.168.1.5 dengan Subnet Mask 255.255.255.0, maka Network ID-nya adalah...',
      'options': [
        '192.168.1.0',
        '192.168.1.255',
        '192.168.0.0',
        '192.168.1.5',
      ],
      'answer': 0,
    },
    {
      'question': 'Untuk IP Address 192.168.1.0/24, alamat Broadcast ID-nya adalah...',
      'options': [
        '192.168.1.255',
        '192.168.1.0',
        '192.168.1.1',
        '192.168.1.254',
      ],
      'answer': 0,
    },
    {
      'question': 'Fungsi utama dari Subnetting dalam jaringan IP Address adalah...',
      'options': [
        'Membagi jaringan besar menjadi beberapa sub-jaringan yang lebih kecil dan efisien',
        'Menambah jumlah bit IPv4 menjadi 128 bit',
        'Mengubah IP Private menjadi IP Public tanpa NAT',
        'Menghilangkan alamat Broadcast dari jaringan',
      ],
      'answer': 0,
    },
    {
      'question': 'Diberikan Subnet Mask 255.255.255.128. Berapakah nilai notasi CIDR (prefix length)-nya?',
      'options': [
        '/25',
        '/24',
        '/26',
        '/27',
      ],
      'answer': 0,
    },
    {
      'question': 'Layanan yang menerjemahkan nama domain (seperti www.google.com) menjadi IP Address adalah...',
      'options': [
        'DNS (Domain Name System)',
        'DHCP',
        'FTP',
        'HTTP',
      ],
      'answer': 0,
    },
    {
      'question': 'Layanan NAT (Network Address Translation) berfungsi untuk...',
      'options': [
        'Menerjemahkan alamat IP Private lokal menjadi IP Public agar dapat mengakses internet',
        'Memberikan IP Address secara otomatis',
        'Membagi subnet mask menjadi oktet',
        'Mengamankan fisik kabel UTP',
      ],
      'answer': 0,
    },
    {
      'question': 'Dua komputer dalam satu ruangan diberi IP 192.168.1.10/24 dan 192.168.2.10/24 tanpa Router. Apakah keduanya dapat saling ping?',
      'options': [
        'Tidak bisa, karena berada di Network ID yang berbeda',
        'Bisa, karena menggunakan kabel UTP',
        'Bisa, karena sama-sama kelas C',
        'Bisa, asalkan menggunakan Switch',
      ],
      'answer': 0,
    },
    {
      'question': 'Penyebab utama timbulnya pesan kesalahan "IP Address Conflict" pada jaringan adalah...',
      'options': [
        'Dua atau lebih perangkat dalam satu jaringan menggunakan alamat IP yang persis sama',
        'Subnet mask komputer bernilai 255.255.255.0',
        'Komputer menggunakan kabel UTP Cat 6',
        'Server DHCP dalam keadaan aktif',
      ],
      'answer': 0,
    },
  ];

  // ==========================================
  // KABEL JARINGAN
  // ==========================================
  static final List<Map<String, dynamic>> _preTestKabel = [
    {
      'question': 'Kabel jaringan yang paling umum digunakan pada LAN dengan konektor RJ45 adalah...',
      'options': [
        'UTP (Unshielded Twisted Pair)',
        'Coaxial',
        'Fiber Optic',
        'Kabel Listrik NYA',
      ],
      'answer': 0,
    },
    {
      'question': 'Konektor standar yang digunakan untuk kabel UTP/STP pada jaringan komputer adalah...',
      'options': [
        'RJ45',
        'RJ11',
        'BNC',
        'LC Connector',
      ],
      'answer': 0,
    },
    {
      'question': 'Perbedaan utama kabel UTP dan STP adalah...',
      'options': [
        'Kabel STP memiliki pelindung foil pembungkus (shielding) terhadap interferensi elektromagnetik',
        'UTP lebih tebal dari STP',
        'STP khusus untuk serat kaca',
        'UTP menggunakan konektor BNC',
      ],
      'answer': 0,
    },
    {
      'question': 'Media transmisi kabel yang mengirimkan data menggunakan gelombang cahaya melalui serat kaca adalah...',
      'options': [
        'Fiber Optic',
        'UTP Cat 5e',
        'STP Cat 6',
        'Coaxial RG6',
      ],
      'answer': 0,
    },
    {
      'question': 'Tang khusus yang digunakan untuk memotong, mengupas, dan mengunci konektor RJ45 pada kabel UTP dinamakan...',
      'options': [
        'Tang Crimping',
        'Tang Potong Biasa',
        'Tang Kombinasi',
        'Tang Buaya',
      ],
      'answer': 0,
    },
    {
      'question': 'Urutan warna standar T568B untuk kabel jaringan dimulai dari pasangan warna...',
      'options': [
        'Putih-Oranye, Oranye',
        'Putih-Hijau, Hijau',
        'Putih-Biru, Biru',
        'Putih-Cokelat, Cokelat',
      ],
      'answer': 0,
    },
    {
      'question': 'Jenis konfigurasi kabel UTP yang digunakan untuk menghubungkan dua perangkat sejenis (misal PC ke PC) adalah...',
      'options': [
        'Kabel Crossover',
        'Kabel Straight-Through',
        'Kabel Rollover',
        'Kabel Console',
      ],
      'answer': 0,
    },
    {
      'question': 'Jenis konfigurasi kabel UTP yang digunakan untuk menghubungkan perangkat berbeda (misal PC ke Switch) adalah...',
      'options': [
        'Kabel Straight-Through',
        'Kabel Crossover',
        'Kabel Coaxial',
        'Kabel Fiber',
      ],
      'answer': 0,
    },
    {
      'question': 'Jumlah pin terminal emas yang terdapat di dalam konektor RJ45 adalah...',
      'options': [
        '8 pin',
        '4 pin',
        '6 pin',
        '10 pin',
      ],
      'answer': 0,
    },
    {
      'question': 'Panjang maksimal transmisi kabel UTP tanpa bantuan repeater agar tidak mengalami degradasi sinyal adalah...',
      'options': [
        '100 meter',
        '500 meter',
        '10 meter',
        '1000 meter',
      ],
      'answer': 0,
    },
  ];

  static final List<Map<String, dynamic>> _postTestKabel = [
    {
      'question': 'Urutan warna kabel UTP standar T568B secara lengkap dari pin 1 sampai pin 8 adalah...',
      'options': [
        'Putih-Oranye, Oranye, Putih-Hijau, Biru, Putih-Biru, Hijau, Putih-Cokelat, Cokelat',
        'Putih-Hijau, Hijau, Putih-Oranye, Biru, Putih-Biru, Oranye, Putih-Cokelat, Cokelat',
        'Putih-Biru, Biru, Putih-Oranye, Hijau, Putih-Hijau, Oranye, Putih-Cokelat, Cokelat',
        'Putih-Cokelat, Cokelat, Putih-Hijau, Hijau, Putih-Oranye, Oranye, Putih-Biru, Biru',
      ],
      'answer': 0,
    },
    {
      'question': 'Pada urutan standar T568A, dua warna pertama pada pin 1 dan pin 2 adalah...',
      'options': [
        'Putih-Hijau dan Hijau',
        'Putih-Oranye dan Oranye',
        'Putih-Biru dan Biru',
        'Putih-Cokelat dan Cokelat',
      ],
      'answer': 0,
    },
    {
      'question': 'Seorang teknisi membuat kabel Straight-Through T568B. Saat diuji dengan LAN Tester, indikator lampu nomor 3 dan 6 tidak menyala. Kemungkinan masalahnya adalah...',
      'options': [
        'Pin nomor 3 (Putih-Hijau) dan pin 6 (Hijau) tidak terhubung rapat atau terputus',
        'Kabel terlalu panjang dari 1000 meter',
        'Konektor RJ45 terbalik warna cokelatnya',
        'LAN Tester kekurangan daya baterai',
      ],
      'answer': 0,
    },
    {
      'question': 'Mengapa kabel Fiber Optik sangat ideal untuk backbone jaringan antar gedung dibanding UTP?',
      'options': [
        'Tahan interferensi elektromagnetik, bandwidth sangat besar, dan jangkauan kilometer tanpa penguat',
        'Harga kabel Fiber Optik jauh lebih murah dari UTP',
        'Fiber Optik mudah disambung hanya dengan isolasi bening',
        'Fiber optik tidak memerlukan transmitter cahaya',
      ],
      'answer': 0,
    },
    {
      'question': 'Proses menyambung dua ujung serat optik menggunakan panas leburan busur listrik dinamakan...',
      'options': [
        'Fusion Splicing',
        'Crimping',
        'Soldering',
        'Stripping',
      ],
      'answer': 0,
    },
    {
      'question': 'Alat pembeli daya pemotong serat optik yang rapi dan rata sebelum proses splicing serat optik dinamakan...',
      'options': [
        'Fiber Cleaver',
        'Fiber Stripper',
        'Tang Crimping',
        'OTDR',
      ],
      'answer': 0,
    },
    {
      'question': 'Alat OTDR (Optical Time-Domain Reflectometer) digunakan dalam jaringan Fiber Optik untuk...',
      'options': [
        'Mendeteksi lokasi titik putus dan mengukur redaman (loss) sepanjang serat optik',
        'Memasang konektor RJ45 ke fiber',
        'Mengukur daya tegangan listrik AC',
        'Menghitung jumlah IP Address',
      ],
      'answer': 0,
    },
    {
      'question': 'Pin pada konektor RJ45 kabel UTP yang khusus digunakan untuk mentransmisikan data (TX) pada standar 10/100 Mbps adalah...',
      'options': [
        'Pin 1 dan Pin 2',
        'Pin 4 dan Pin 5',
        'Pin 7 dan Pin 8',
        'Pin 3 dan Pin 6',
      ],
      'answer': 0,
    },
    {
      'question': 'Pin pada konektor RJ45 kabel UTP yang khusus digunakan untuk menerima data (RX) pada standar 10/100 Mbps adalah...',
      'options': [
        'Pin 3 dan Pin 6',
        'Pin 1 dan Pin 2',
        'Pin 4 dan Pin 5',
        'Pin 7 dan Pin 8',
      ],
      'answer': 0,
    },
    {
      'question': 'Kategori kabel UTP (Cat) yang mendukung kecepatan transfer data hingga 10 Gbps pada jarak terbatas adalah...',
      'options': [
        'Cat 6A / Cat 7',
        'Cat 3',
        'Cat 5 lama',
        'Cat 1',
      ],
      'answer': 0,
    },
  ];
}
