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
  // 1. DASAR JARINGAN (25 PRE-TEST & 25 POST-TEST)
  // ==========================================
  static final List<Map<String, dynamic>> _preTestDasarJaringan = [
    {
      'question': '1. Jaringan komputer adalah sistem yang terdiri dari beberapa komputer yang terhubung untuk...',
      'options': ['Berbagi data dan sumber daya', 'Mempercepat kecepatan kipas', 'Menghemat penggunaan listrik PC', 'Menghapus virus secara otomatis'],
      'answer': 0,
    },
    {
      'question': '2. Jenis jaringan komputer berdasarkan jangkauan geografis terkecil adalah...',
      'options': ['PAN (Personal Area Network)', 'LAN (Local Area Network)', 'MAN (Metropolitan Area Network)', 'WAN (Wide Area Network)'],
      'answer': 0,
    },
    {
      'question': '3. Topologi jaringan yang setiap komputernya terhubung ke pusat (Switch/Hub) berbentuk bintang disebut...',
      'options': ['Topologi Star', 'Topologi Bus', 'Topologi Ring', 'Topologi Mesh'],
      'answer': 0,
    },
    {
      'question': '4. Jumlah lapisan (layer) dalam model OSI (Open Systems Interconnection) adalah...',
      'options': ['7 Layer', '5 Layer', '4 Layer', '3 Layer'],
      'answer': 0,
    },
    {
      'question': '5. Layer OSI pertama yang berhubungan langsung dengan perangkat fisik seperti kabel dan sinyal listrik adalah...',
      'options': ['Physical Layer', 'Data Link Layer', 'Network Layer', 'Transport Layer'],
      'answer': 0,
    },
    {
      'question': '6. Protokol yang digunakan untuk mentransfer halaman web secara aman terenkripsi adalah...',
      'options': ['HTTPS', 'HTTP', 'FTP', 'SMTP'],
      'answer': 0,
    },
    {
      'question': '7. Protokol yang secara otomatis memberikan alamat IP kepada komputer klien dalam jaringan adalah...',
      'options': ['DHCP', 'DNS', 'ICMP', 'ARP'],
      'answer': 0,
    },
    {
      'question': '8. Alamat fisik yang unik dan permanen pada setiap kartu jaringan (NIC) disebut...',
      'options': ['MAC Address', 'IP Address', 'Subnet Mask', 'Gateway Address'],
      'answer': 0,
    },
    {
      'question': '9. Perangkat jaringan yang berfungsi menghubungkan dua atau lebih jaringan berbedasegment adalah...',
      'options': ['Router', 'Switch Unmanaged', 'Hub', 'Repeater'],
      'answer': 0,
    },
    {
      'question': '10. Model arsitektur jaringan di mana setiap komputer memiliki kedudukan yang sejajar tanpa server khusus disebut...',
      'options': ['Peer-to-Peer (P2P)', 'Client-Server', 'Mainframe System', 'Cloud Cluster'],
      'answer': 0,
    },
    {
      'question': '11. Protokol DNS (Domain Name System) berfungsi untuk...',
      'options': ['Menerjemahkan nama domain menjadi alamat IP', 'Mengamankan data dari peretas', 'Mengirimkan email secara otomatis', 'Mengkompres file berukuran besar'],
      'answer': 0,
    },
    {
      'question': '12. Satuan kecepatan transfer data dalam jaringan komputer dinyatakan dalam...',
      'options': ['bps (bits per second)', 'Hz (Hertz)', 'RPM (Rotation per minute)', 'Watt'],
      'answer': 0,
    },
    {
      'question': '13. Komunikasi data yang memungkinkan transmisi dua arah secara bersamaan sekaligus disebut...',
      'options': ['Full-Duplex', 'Half-Duplex', 'Simplex', 'Single-Direction'],
      'answer': 0,
    },
    {
      'question': '14. Kabel UTP dan Fiber Optik termasuk ke dalam media transmisi jenis...',
      'options': ['Guided Media (Terpandu)', 'Unguided Media (Nirkabel)', 'Satellite Media', 'Radiated Media'],
      'answer': 0,
    },
    {
      'question': '15. Perintah dasar pada Command Prompt (CMD) yang digunakan untuk menguji konektivitas antar komputer adalah...',
      'options': ['ping', 'ipconfig', 'traceroute', 'netstat'],
      'answer': 0,
    },
    {
      'question': '16. Perangkat yang digunakan untuk memperkuat kembali sinyal jaringan yang lemah akibat jarak jauh adalah...',
      'options': ['Repeater', 'Splitter', 'LAN Card', 'Modem'],
      'answer': 0,
    },
    {
      'question': '17. Layer OSI yang bertanggung jawab untuk membagi data menjadi segmen dan menangani error control adalah...',
      'options': ['Transport Layer', 'Network Layer', 'Session Layer', 'Application Layer'],
      'answer': 0,
    },
    {
      'question': '18. Topologi jaringan yang memiliki ketahanan paling tinggi terhadap kegagalan jaringan karena setiap node saling terhubung adalah...',
      'options': ['Topologi Mesh', 'Topologi Ring', 'Topologi Bus', 'Topologi Tree'],
      'answer': 0,
    },
    {
      'question': '19. Pengiriman data dari satu sumber ke satu tujuan spesifik dalam jaringan dinamakan...',
      'options': ['Unicast', 'Broadcast', 'Multicast', 'Anycast'],
      'answer': 0,
    },
    {
      'question': '20. Kabel coaxial paling sering ditemukan pada penggunaan jaringan...',
      'options': ['Antena TV & CCTV lama', 'Serat optik antar pulau', 'Wifi publik', 'Bluetooth HP'],
      'answer': 0,
    },
    {
      'question': '21. Perangkat jaringan yang membagi satu jalur kabel fiber optik menjadi beberapa jalur pelanggan dinamakan...',
      'options': ['Optical Distribution Cabinet (ODC/ODP)', 'Switch Hub', 'Access Point', 'LAN Card'],
      'answer': 0,
    },
    {
      'question': '22. Protokol pengiriman email dari komputer klien ke server email adalah...',
      'options': ['SMTP', 'POP3', 'IMAP', 'HTTP'],
      'answer': 0,
    },
    {
      'question': '23. Struktur model TCP/IP terdiri dari berapa layer...',
      'options': ['4 Layer', '7 Layer', '5 Layer', '3 Layer'],
      'answer': 0,
    },
    {
      'question': '24. Gelombang Radio, Wi-Fi, dan Bluetooth tergolong ke dalam media transmisi...',
      'options': ['Unguided Media (Nirkabel)', 'Guided Media', 'Wired Media', 'Fiber Media'],
      'answer': 0,
    },
    {
      'question': '25. Urutan teratas dalam 7 Layer OSI adalah...',
      'options': ['Application Layer', 'Presentation Layer', 'Session Layer', 'Physical Layer'],
      'answer': 0,
    },
  ];

  static final List<Map<String, dynamic>> _postTestDasarJaringan = [
    {
      'question': '1. Jika sebuah switch utama dalam topologi Star rusak total, dampak yang akan terjadi pada jaringan adalah...',
      'options': ['Seluruh komputer yang terhubung ke switch tersebut tidak bisa saling berkomunikasi', 'Hanya komputer pertama yang mati', 'Jaringan tetap berjalan tanpa hambatan', 'Kecepatan internet menjadi 2 kali lipat'],
      'answer': 0,
    },
    {
      'question': '2. Pada proses enkapsulasi data OSI Layer, unit data pada Transport Layer disebut...',
      'options': ['Segment', 'Packet', 'Frame', 'Bits'],
      'answer': 0,
    },
    {
      'question': '3. Manakah nomor port default yang digunakan oleh protokol web HTTPS?',
      'options': ['443', '80', '21', '22'],
      'answer': 0,
    },
    {
      'question': '4. Port standar 21 pada protokol TCP digunakan untuk layanan...',
      'options': ['FTP (File Transfer Protocol)', 'SSH (Secure Shell)', 'Telnet', 'DNS'],
      'answer': 0,
    },
    {
      'question': '5. Perbedaan utama antara protokol TCP dan UDP adalah...',
      'options': ['TCP bersifat Connection-Oriented dan andal, sedangkan UDP bersifat Connectionless dan cepat', 'TCP lebih cepat daripada UDP', 'UDP memiliki fitur retransmisi data yang hilang', 'TCP khusus untuk media nirkabel'],
      'answer': 0,
    },
    {
      'question': '6. Perangkat Switch bekerja pada Layer OSI nomor...',
      'options': ['Layer 2 (Data Link Layer)', 'Layer 1 (Physical Layer)', 'Layer 3 (Network Layer)', 'Layer 7 (Application Layer)'],
      'answer': 0,
    },
    {
      'question': '7. Perangkat Router bekerja pada Layer OSI nomor...',
      'options': ['Layer 3 (Network Layer)', 'Layer 2 (Data Link Layer)', 'Layer 1 (Physical Layer)', 'Layer 4 (Transport Layer)'],
      'answer': 0,
    },
    {
      'question': '8. Istilah Collision Domain paling rentan terjadi pada jaringan yang menggunakan perangkat...',
      'options': ['Hub', 'Switch Managed', 'Router', 'Firewall Hardware'],
      'answer': 0,
    },
    {
      'question': '9. Protokol ARP (Address Resolution Protocol) berfungsi untuk mencari...',
      'options': ['MAC Address berdasarkan IP Address', 'IP Address berdasarkan nama domain', 'Port number berdasarkan nama aplikasi', 'Subnet mask dari router'],
      'answer': 0,
    },
    {
      'question': '10. Apabila komputer A ping ke IP komputer B dan muncul pesan "Request Timed Out (RTO)", penyebab umumnya adalah...',
      'options': ['Firewall komputer B aktif atau tidak ada jalur koneksi ke komputer B', 'Komputer A kekurangan RAM', 'Kabel LAN komputer A terlalu pendek', 'IP address komputer B sama persis dengan A'],
      'answer': 0,
    },
    {
      'question': '11. Perintah CMD `tracert` (atau `traceroute` di Linux) berguna untuk...',
      'options': ['Melacak rute lompatan (hop) router yang dilalui paket data menuju tujuan', 'Mengubah password Windows', 'Membersihkan cache browser', 'Menampilkan daftar MAC address lokal'],
      'answer': 0,
    },
    {
      'question': '12. Protokol yang bertugas menerima email dari server ke perangkat lokal adalah...',
      'options': ['POP3 / IMAP', 'SMTP', 'SNMP', 'DHCP'],
      'answer': 0,
    },
    {
      'question': '13. Urutan enkapsulasi data dari atas ke bawah pada OSI Model adalah...',
      'options': ['Data -> Segment -> Packet -> Frame -> Bits', 'Bits -> Frame -> Packet -> Segment -> Data', 'Packet -> Data -> Segment -> Frame -> Bits', 'Frame -> Segment -> Data -> Packet -> Bits'],
      'answer': 0,
    },
    {
      'question': '14. Apa keuntungan utama arsitektur Client-Server dibanding Peer-to-Peer?',
      'options': ['Manajemen keamanan dan terpusat pada server', 'Biaya instalasi jauh lebih murah', 'Tidak membutuhkan perangkat switch', 'Tidak perlu mengkonfigurasi IP address'],
      'answer': 0,
    },
    {
      'question': '15. Teknologi VLAN (Virtual LAN) diimplementasikan pada perangkat Switch untuk...',
      'options': ['Membagi satu jaringan fisik menjadi beberapa segmen jaringan logis terpisah', 'Menambah kecepatan prosesor switch', 'Mengganti fungsi router secara total', 'Menghubungkan kabel optik ke kabel telepon'],
      'answer': 0,
    },
    {
      'question': '16. Nilai MAC Address terdiri dari berapa bit...',
      'options': ['48 bit (12 karakter heksadesimal)', '32 bit', '128 bit', '64 bit'],
      'answer': 0,
    },
    {
      'question': '17. Port 53 pada jaringan digunakan untuk layanan...',
      'options': ['DNS', 'HTTP', 'HTTPS', 'SSH'],
      'answer': 0,
    },
    {
      'question': '18. Port 22 pada protokol jaringan digunakan untuk...',
      'options': ['SSH (Secure Shell)', 'Telnet', 'FTP', 'SMTP'],
      'answer': 0,
    },
    {
      'question': '19. Kelemahan utama topologi Bus adalah...',
      'options': ['Jika kabel utama (backbone) terputus, seluruh jaringan akan lumpuh', 'Membutuhkan biaya sangat mahal', 'Membutuhkan banyak switch', 'Proses instalasi sangat rumit'],
      'answer': 0,
    },
    {
      'question': '20. Layanan ICMP (Internet Control Message Protocol) digunakan oleh perintah...',
      'options': ['ping', 'ftp', 'ssh', 'http'],
      'answer': 0,
    },
    {
      'question': '21. Pengalihan nomor port dan IP publik ke IP privat menggunakan teknologi...',
      'options': ['NAT (Network Address Translation)', 'DNS Forwarder', 'DHCP Lease', 'MAC Filtering'],
      'answer': 0,
    },
    {
      'question': '22. Broadcast domain pada switch unmanaged dapat diisolasi dan dipisahkan dengan menggunakan...',
      'options': ['Router atau VLAN', 'Hub tambahan', 'Kabel UTP lebih panjang', 'LAN Card tambahan'],
      'answer': 0,
    },
    {
      'question': '23. Protokol transmisi data video streaming realtime yang mengutamakan kecepatan dibanding keandalan menggunakan...',
      'options': ['UDP', 'TCP', 'FTP', 'HTTP'],
      'answer': 0,
    },
    {
      'question': '24. Karakteristik sinyal digital adalah...',
      'options': ['Bebentuk gelombang biner (0 dan 1)', 'Berbentuk gelombang sinus kontinu', 'Hanya bisa lewat udara', 'Tidak memiliki kecepatan'],
      'answer': 0,
    },
    {
      'question': '25. Fungsi Layer Presentation pada model OSI adalah...',
      'options': ['Menerjemahkan format data, enkripsi, dan kompresi', 'Mengatur rute paket data', 'Mendeteksi tabrakan data fisik', 'Menyediakan interface aplikasi web'],
      'answer': 0,
    },
  ];

  // ==========================================
  // 2. K3LH (25 PRE-TEST & 25 POST-TEST)
  // ==========================================
  static final List<Map<String, dynamic>> _preTestK3 = [
    {
      'question': '1. Kepanjangan dari K3LH adalah...',
      'options': ['Keselamatan, Kesehatan Kerja, dan Lingkungan Hidup', 'Keamanan, Keselamatan Kerja, dan Lingkungan Hidup', 'Kesehatan, Keahlian Kerja, dan Lingkungan Hidup', 'Keselamatan, Ketertiban Kerja, dan Lingkungan Hidup'],
      'answer': 0,
    },
    {
      'question': '2. Tujuan utama penerapan K3 di laboratorium TKJ adalah...',
      'options': ['Mencegah kecelakaan kerja dan melindungi praktikan serta peralatan', 'Mempercepat proses pengerjaan tanpa aturan', 'Mengurangi biaya pembelian komponen komputer', 'Memperindah tampilan ruangan laboratorium'],
      'answer': 0,
    },
    {
      'question': '3. Alat pelindung diri (APD) yang wajib digunakan saat merakit PC untuk mencegah listrik statis adalah...',
      'options': ['Gelang anti-statis (Anti-static wrist strap)', 'Helm proyek', 'Masker medis', 'Kacamata renang'],
      'answer': 0,
    },
    {
      'question': '4. Tindakan pertama saat terjadi korsleting listrik di lab komputer adalah...',
      'options': ['Mematikan sumber listrik utama (MCB)', 'Menyiram sumber api dengan air', 'Meneruskan pekerjaan merakit', 'Membuka semua jendela tanpa mematikan listrik'],
      'answer': 0,
    },
    {
      'question': '5. Posisi duduk yang ergonomis saat menggunakan komputer adalah...',
      'options': ['Punggung tegak, posisi mata sejajar dengan bagian atas layar', 'Membungkuk sangat dekat dengan layar', 'Sambil tiduran di lantai lab', 'Kaki menggantung tanpa menyentuh lantai'],
      'answer': 0,
    },
    {
      'question': '6. Alat pemadam api yang tepat untuk kebakaran akibat peralatan listrik adalah...',
      'options': ['APAR berbahan CO2 atau Powder kering', 'Ember berisi air bersih', 'Kain basah bernoda minyak', 'Bensin cair'],
      'answer': 0,
    },
    {
      'question': '7. Mengapa dilarang membawa makanan dan minuman ke dalam laboratorium komputer?',
      'options': ['Cairan yang tumpah dapat menyebabkan korsleting dan merusak komponen', 'Makanan membuat jaringan internet menjadi lambat', 'Komputer dapat menyerap bau makanan', 'Ruangan akan menjadi terlalu dingin'],
      'answer': 0,
    },
    {
      'question': '8. Penyakit akibat kerja yang timbul karena mengetik terlalu lama tanpa istirahat adalah...',
      'options': ['Carpal Tunnel Syndrome (CTS)', 'Anemia', 'Influenza', 'Sakit gigi'],
      'answer': 0,
    },
    {
      'question': '9. Warna simbol peringatan bahaya pada standar keselamatan K3 adalah...',
      'options': ['Kuning / Oranye', 'Biru Muda', 'Hijau Toska', 'Merah Jambu'],
      'answer': 0,
    },
    {
      'question': '10. Langkah awal sebelum membuka casing Power Supply unit komputer adalah...',
      'options': ['Mencabut kabel daya listrik dari stopkontak', 'Menyiram power supply dengan alkohol', 'Memegang kapasitor dengan tangan basah', 'Menyalakan tombol power berkali-kali'],
      'answer': 0,
    },
    {
      'question': '11. Penggunaan alas kaki berisolar zat karet saat merakit PC bertujuan untuk...',
      'options': ['Mencegah sengatan listrik tanah (grounding)', 'Menjaga kebersihan karpet', 'Mempercepat rakitan PC', 'Mencegah sepatu aus'],
      'answer': 0,
    },
    {
      'question': '12. Pencahayaan di ruang laboratorium komputer yang ideal harus...',
      'options': ['Cukup terang dan tidak menyilaukan mata pada monitor', 'Sangat remang-remang', 'Menggunakan lampu sorot langsung ke layar', 'Gelap gulita'],
      'answer': 0,
    },
    {
      'question': '13. Kebersihan komponen motherboard dari debu secara berkala menggunakan kuas halus bertujuan untuk...',
      'options': ['Mencegah overheat dan short-circuit akibat debu', 'Membuat RAM menjadi 16GB', 'Mengubah kecepatan clock CPU', 'Menambah port USB'],
      'answer': 0,
    },
    {
      'question': '14. Prinsip 5R/5S di ruang praktik TKJ mencakup...',
      'options': ['Ringkas, Rapi, Resik, Rawat, Rajin', 'Ramai, Rukun, Rapi, Ragu, Rusak', 'Rancang, Racik, Rakit, Rawat, Rusak', 'Raih, Rasa, Raba, Ragu, Raba'],
      'answer': 0,
    },
    {
      'question': '15. Jarak pandang yang aman antara mata dengan layar monitor PC adalah...',
      'options': ['40 - 70 cm', '10 - 15 cm', '100 - 200 cm', '5 - 10 cm'],
      'answer': 0,
    },
    {
      'question': '16. Bahaya fisik yang sering terjadi di lab komputer akibat kabel berserakan di lantai adalah...',
      'options': ['Tersandung dan jatuh', 'Sengatan matahari', 'Kebisingan tinggi', 'Radiasi nuklir'],
      'answer': 0,
    },
    {
      'question': '17. Ventilasi udara atau AC di laboratorium komputer diperlukan untuk...',
      'options': ['Menjaga suhu ruangan dan mencegah peralatan komputer overheating', 'Membuat siswa mengantuk', 'Menyimpan bahan makanan', 'Mengeringkan pakaian'],
      'answer': 0,
    },
    {
      'question': '18. Tindakan pertolongan pertama (P3K) jika rekan tersengat listrik adalah...',
      'options': ['Mematikan sakelar utama atau memisahkan korban dengan benda non-konduktor', 'Langsung memegang tangan korban dengan tangan kosong', 'Menyiram korban dengan air', 'Menarik korban dengan kawat tembaga'],
      'answer': 0,
    },
    {
      'question': '19. Kotak P3K di lab komputer wajib berisi obat dan bahan seperti...',
      'options': ['Kasa steril, antiseptik, plester, dan alkohol', 'Tang crimping dan konektor', 'Solder dan timah', 'Obat nyamuk bakar'],
      'answer': 0,
    },
    {
      'question': '20. Mengapa tang crimping dan obeng di lab TKJ harus memiliki gagang berbahan karet atau plastik...',
      'options': ['Sebagai isolator listrik yang melindungi pengguna', 'Agar harganya lebih mahal', 'Agar obeng tidak tenggelam di air', 'Agar warna lebih menarik'],
      'answer': 0,
    },
    {
      'question': '21. Aturan keselamatan saat menggunakan alat solder komponen elektronika adalah...',
      'options': ['Menggunakan dudukan solder dan menghindari menghirup asap timah secara langsung', 'Menebak panas solder dengan menyentuh ujungnya', 'Meletakkan solder panas di atas meja kayu', 'Solder digunakan sambil makan'],
      'answer': 0,
    },
    {
      'question': '22. Pengertian dari Ergonomi adalah...',
      'options': ['Ilmu penyesuaian lingkungan dan peralatan kerja dengan kondisi tubuh manusia', 'Ilmu merakit komputer cepat', 'Ilmu menghemat listrik negara', 'Ilmu mendesain logo'],
      'answer': 0,
    },
    {
      'question': '23. Jenis sampah elektronik (E-Waste) bekas praktikum TKJ harus...',
      'options': ['Dikelompokkan dan dibuang ke tempat pengolahan khusus limbah elektronik', 'Dibakar di lapangan sekolah', 'Dibuang ke sungai', 'Dibuang bersatu dengan sampah makanan'],
      'answer': 0,
    },
    {
      'question': '24. Tanda panah hijau pada jalur evakuasi keselamatan berfungsi untuk...',
      'options': ['Petunjuk arah keluar menuju titik kumpul saat darurat', 'Petunjuk letak kamar mandi', 'Petunjuk lokasi kantin', 'Petunjuk tempat bermain'],
      'answer': 0,
    },
    {
      'question': '25. Slogan K3 yang utama di tempat kerja adalah...',
      'options': ['Utamakan Keselamatan dan Kesehatan Kerja', 'Utamakan Kecepatan tanpa Aturan', 'Bekerja Cepat tanpa APD', 'Bekerja Santai Tanpa Target'],
      'answer': 0,
    },
  ];

  static final List<Map<String, dynamic>> _postTestK3 = [
    {
      'question': '1. Seorang siswa merasa kesemutan di pergelangan tangan setelah mengetik 4 jam non-stop. Tindakan ergonomis pencegahan yang tepat adalah...',
      'options': ['Melakukan peregangan dan mengatur posisi wrist rest serta posisi mengetik yang benar', 'Menambah waktu mengetik tanpa jeda', 'Menggunakan keyboard tanpa alas meja', 'Mendekatkan layar ke mata'],
      'answer': 0,
    },
    {
      'question': '2. Mengapa air sama sekali tidak boleh digunakan untuk memadamkan kebakaran akibat listrik kelas C?',
      'options': ['Air menghantarkan listrik dan dapat menyengat pemadam kebakaran', 'Air membuat api membeku', 'Air menyebabkan kebocoran sinyal wifi', 'Air merubah komponen menjadi plastik'],
      'answer': 0,
    },
    {
      'question': '3. SOP penghentian darurat (Emergency Shutdown) di ruang server dilakukan ketika...',
      'options': ['Terjadi bencana atau kebakaran besar yang mengancam keselamatan', 'Ada siswa yang tidak membawa buku catatan', 'Suhu ruangan lab naik 1 derajat Celcius', 'Listrik padam selama 1 detik'],
      'answer': 0,
    },
    {
      'question': '4. Penggunaan kabel rol yang menumpuk berlebihan pada satu stopkontak di lab TKJ berpotensi menyebabkan...',
      'options': ['Kelebihan beban listrik (overload) dan kebakaran', 'Kecepatan transmisi data meningkat pesat', 'Tegangan listrik menjadi nol secara permanen', 'RAM komputer bertambah otomatis'],
      'answer': 0,
    },
    {
      'question': '5. Fungsi penataan kabel (Cable Management) di dalam lab komputer dari sudut pandang K3 adalah...',
      'options': ['Mencegah orang tersandung kabel dan memudahkan pemeliharaan', 'Menambah kecepatan processor komputer', 'Mengurangi konsumsi listrik monitor', 'Memperbaiki harddisk yang rusak'],
      'answer': 0,
    },
    {
      'question': '6. Aturan 20-20-20 dalam penggunaan komputer berfungsi untuk mengistirahatkan mata, artinya...',
      'options': ['Setiap 20 menit, alihkan pandangan sejauh 20 kaki (6m) selama 20 detik', 'Belajar 20 jam, tidur 20 menit, makan 20 kali', 'Mengetik 20 kata, istirahat 20 menit', 'Mematikan monitor setiap 20 detik'],
      'answer': 0,
    },
    {
      'question': '7. Kebisingan berlebih di ruang praktikum server dapat dicegah atau diatasi dengan APD berupa...',
      'options': ['Earplug atau Earmuff', 'Kacamata Safety', 'Sarung Tangan Kulit', 'Masker Gas'],
      'answer': 0,
    },
    {
      'question': '8. Kerusakan komponen IC mikroprosesor akibat gesekan listrik statis tubuh manusia disebut fenomena...',
      'options': ['ESD (Electrostatic Discharge)', 'CPU Overclocking', 'Thermal Throttling', 'Power Surge'],
      'answer': 0,
    },
    {
      'question': '9. APAR kimia kering (Dry Chemical Powder) cocok digunakan untuk memadamkan kebakaran kelas...',
      'options': ['Kelas A, B, dan C', 'Hanya kelas D', 'Hanya minyak goreng', 'Hanya kertas'],
      'answer': 0,
    },
    {
      'question': '10. Lokasi Titik Kumpul (Assembly Point) pada gedung lab komputer berfungsi sebagai...',
      'options': ['Lokasi aman untuk berkumpul dan evakuasi saat kondisi darurat/kebakaran', 'Tempat parkir kendaraan siswa', 'Lokasi kantin sekolah', 'Tempat menyimpan inventaris lab'],
      'answer': 0,
    },
    {
      'question': '11. Kebersihan sirkulasi udara pada casing PC penting untuk menjaga K3 perangkat karena...',
      'options': ['Debu yang menumpuk menghambat kipas dan memicu panas berlebih', 'Debu membuat kecepatan internet berkurang', 'Debu merubah warna casing', 'Debu membuat BIOS terhapus'],
      'answer': 0,
    },
    {
      'question': '12. Pencahayaan silau (glare) pada layar monitor dapat dikurangi dengan...',
      'options': ['Mengatur sudut layar dan memasang filter anti-glare', 'Mematikan seluruh lampu lab', 'Mendekatkan monitor ke jendela terang', 'Menggunakan kacamata hitam di lab'],
      'answer': 0,
    },
    {
      'question': '13. Ketika mengangkat unit CPU berat dari lantai, posisi tubuh yang benar sesuai ergonomi adalah...',
      'options': ['Menitikberatkan beban pada tekukan kaki/lutut, bukan membungkukkan punggung', 'Membungkukkan punggung dengan kaki lurus', 'Mengangkat dengan satu tangan sambil memutar badan', 'Menarik kabel CPU secara paksa'],
      'answer': 0,
    },
    {
      'question': '14. Bahaya paparan asap solder yang mengandung timbal dapat dicegah dengan...',
      'options': ['Menggunakan alat Solder Fume Extractor / Ventilasi yang baik', 'Menghirup asap secara langsung', 'Menutup mata saat menyolder', 'Menyiram timah panas dengan minyak'],
      'answer': 0,
    },
    {
      'question': '15. Standar warna tabung APAR CO2 di laboratorium umumnya berwarna...',
      'options': ['Merah', 'Kuning', 'Biru', 'Hijau'],
      'answer': 0,
    },
    {
      'question': '16. Sebelum menggunakan perangkat solder listrik, tindakan K3 wajib adalah...',
      'options': ['Memeriksa keutuhan isolasi kabel solder agar tidak terkelupas', 'Mencelupkan ujung solder ke air', 'Mengikat solder pada tangan', 'Membiarkan solder tanpa dudukan'],
      'answer': 0,
    },
    {
      'question': '17. Tindakan yang tepat saat menemukan kabel grounding PLN di lab komputer terputus adalah...',
      'options': ['Segera melapor ke teknisi/guru untuk diperbaiki demi mencegah tersetrum casing', 'Membiarkan saja karena tidak berpengaruh', 'Menyambung kabel dengan selotip kertas', 'Menyiram tempat terputus dengan air'],
      'answer': 0,
    },
    {
      'question': '18. Efek samping penggunaan kacamata anti-radiasi bluelight bagi pengguna PC adalah...',
      'options': ['Mengurangi kelelahan mata akibat paparan cahaya biru monitor', 'Membuat mata menjadi kabur selamanya', 'Menambah kecepatan ketik', 'Memperbaiki kerusakan monitor'],
      'answer': 0,
    },
    {
      'question': '19. Apa tindakan K3 pertama saat mencium bau plastik terbakar di dalam lab komputer?',
      'options': ['Matikan tombol power utama/cabut sumber listrik setempat dan cari asal bau', 'Abaikan dan lanjutkan praktikum', 'Menambah beban colokan listrik', 'Membuka aplikasi pemutar musik'],
      'answer': 0,
    },
    {
      'question': '20. Mengapa dilarang menyentuh pin emas pada RAM atau kartu VGA dengan jari tangan?',
      'options': ['Keringat dan minyak jari dapat menyebabkan korosi dan penyaluran listrik statis', 'Pin emas akan meleleh kena suhu tubuh', 'Komputer akan terkunci password', 'Warna emas akan pudar menjadi perak'],
      'answer': 0,
    },
    {
      'question': '21. Pertolongan pertama pada luka bakar ringan akibat terkena solder panas di lab adalah...',
      'options': ['Membilas dengan air bersih mengalir selama 10-15 menit', 'Mengecat luka dengan pasta gigi berminyak', 'Menyiram dengan minyak tanah', 'Menempelkan es batu langsung hingga membeku'],
      'answer': 0,
    },
    {
      'question': '22. Fungsi rambu tanda panah kuning dan hitam di lingkungan kerja adalah...',
      'options': ['Peringatan area berbahaya atau ada potensi rintangan', 'Lokasi tempat tidur', 'Tempat parkir bus', 'Area bebas sampah'],
      'answer': 0,
    },
    {
      'question': '23. Penerapan K3LH di tempat kerja merupakan tanggung jawab dari...',
      'options': ['Seluruh praktikan, siswa, guru, dan pengelola laboratorium', 'Hanya petugas kebersihan', 'Hanya kepala sekolah', 'Hanya penjaga malam'],
      'answer': 0,
    },
    {
      'question': '24. Penggunaan kacamata safety saat memotong serat optik (Fiber Optic) bertujuan untuk...',
      'options': ['Mencegah serpihan kaca serat optik mengenai mata', 'Melihat inti kabel yang sangat kecil', 'Membuat tampilan teknisi makin keren', 'Mencegah dari cahaya matahari'],
      'answer': 0,
    },
    {
      'question': '25. Dokumen panduan langkah kerja aman yang harus dipatuhi di lab komputer disebut...',
      'options': ['SOP (Standard Operating Procedure)', 'KTP', 'SIM', 'STNK'],
      'answer': 0,
    },
  ];

  // ==========================================
  // 3. KOMPONEN KOMPUTER (25 PRE-TEST & 25 POST-TEST)
  // ==========================================
  static final List<Map<String, dynamic>> _preTestKomponen = [
    {
      'question': '1. Otak dari komputer yang berfungsi memproses instruksi dan data adalah...',
      'options': ['CPU (Central Processing Unit)', 'RAM', 'Harddisk', 'Power Supply'],
      'answer': 0,
    },
    {
      'question': '2. Memori utama komputer yang bersifat sementara (volatile) adalah...',
      'options': ['RAM (Random Access Memory)', 'ROM', 'SSD', 'Flashdisk'],
      'answer': 0,
    },
    {
      'question': '3. Perangkat keras yang berfungsi mengubah arus AC dari listrik PLN menjadi arus DC untuk komputer adalah...',
      'options': ['Power Supply Unit (PSU)', 'Motherboard', 'Heatsink', 'VGA Card'],
      'answer': 0,
    },
    {
      'question': '4. Komponen papan sirkuit utama tempat menempelnya CPU, RAM, dan VGA adalah...',
      'options': ['Motherboard', 'Casing', 'Sound Card', 'LAN Card'],
      'answer': 0,
    },
    {
      'question': '5. Perangkat penyimpanan sekunder berbasis piringan magnetik adalah...',
      'options': ['HDD (Hard Disk Drive)', 'SSD (Solid State Drive)', 'RAM', 'NVMe'],
      'answer': 0,
    },
    {
      'question': '6. Perangkat penyimpanan modern tanpa bagian bergerak yang menggunakan flash memory adalah...',
      'options': ['SSD (Solid State Drive)', 'HDD', 'Floppy Disk', 'CD-ROM'],
      'answer': 0,
    },
    {
      'question': '7. Komponen yang bertugas mengolah grafik dan tampilan visual ke layar monitor adalah...',
      'options': ['VGA Card (GPU)', 'Sound Card', 'NIC Card', 'Capture Card'],
      'answer': 0,
    },
    {
      'question': '8. Komponen pendingin CPU yang terdiri dari aluminium dan fan dinamakan...',
      'options': ['Heatsink Fan (HSF)', 'Power Fan', 'Case Fan', 'Water Pump'],
      'answer': 0,
    },
    {
      'question': '9. Baterai kecil pada motherboard yang berfungsi menjaga pengaturan waktu dan BIOS adalah...',
      'options': ['Baterai CMOS', 'Baterai Lithium AA', 'Baterai Power Bank', 'Baterai Basah'],
      'answer': 0,
    },
    {
      'question': '10. Port yang umum digunakan untuk menghubungkan monitor modern berresolusi tinggi adalah...',
      'options': ['HDMI / DisplayPort', 'VGA Port lama', 'Parallel Port', 'PS/2 Port'],
      'answer': 0,
    },
    {
      'question': '11. Jenis slot ekspansi motherboard yang paling umum digunakan untuk memasang VGA Card saat ini adalah...',
      'options': ['PCI Express (PCIe) x16', 'AGP Slot', 'ISA Slot', 'PCI Biasa'],
      'answer': 0,
    },
    {
      'question': '12. Gel penghantar panas yang dioleskan di atas permukaan CPU sebelum memasang heatsink disebut...',
      'options': ['Thermal Paste (Pasta Thermal)', 'Lem Gajah', 'Oli Mesin', 'Cairan Alkohol'],
      'answer': 0,
    },
    {
      'question': '13. Perangkat input yang digunakan untuk memasukkan data perintah tulisan ke PC adalah...',
      'options': ['Keyboard', 'Monitor', 'Printer', 'Speaker'],
      'answer': 0,
    },
    {
      'question': '14. Memori khusus yang menyimpan program instruksi dasar booting awal PC (BIOS) dinamakan...',
      'options': ['ROM (Read Only Memory)', 'RAM', 'Cache L3', 'Virtual Memory'],
      'answer': 0,
    },
    {
      'question': '15. Soket pada motherboard tempat memasukkan prosessor dinamakan...',
      'options': ['Socket CPU', 'Slot DIMM', 'Header USB', 'SATA Port'],
      'answer': 0,
    },
    {
      'question': '16. Faktor bentuk (Form Factor) motherboard yang paling populer untuk PC desktop standar adalah...',
      'options': ['ATX / Micro-ATX', 'Mini-ITX', 'E-ATX', 'BTX'],
      'answer': 0,
    },
    {
      'question': '17. Kabel data yang digunakan untuk menghubungkan SSD SATA atau HDD ke motherboard dinamakan...',
      'options': ['Kabel SATA', 'Kabel IDE ATA', 'Kabel Molex', 'Kabel LAN'],
      'answer': 0,
    },
    {
      'question': '18. Port PS/2 berwarna hijau pada motherboard komputer lama digunakan untuk...',
      'options': ['Mouse', 'Keyboard', 'Speaker', 'Monitor'],
      'answer': 0,
    },
    {
      'question': '19. Port PS/2 berwarna ungu pada motherboard komputer lama digunakan untuk...',
      'options': ['Keyboard', 'Mouse', 'Printer', 'Microphone'],
      'answer': 0,
    },
    {
      'question': '20. Perangkat output yang menghasilkan salinan fisik dokumen pada kertas adalah...',
      'options': ['Printer', 'Scanner', 'Plotter', 'Monitor'],
      'answer': 0,
    },
    {
      'question': '21. Satuan kecepatan clock pada processor CPU dinyatakannya dalam...',
      'options': ['GHz (Gigahertz)', 'GB (Gigabyte)', 'Mbps', 'RPM'],
      'answer': 0,
    },
    {
      'question': '22. Perangkat input suara ke dalam komputer adalah...',
      'options': ['Microphone', 'Speaker', 'Headphone', 'Webcam'],
      'answer': 0,
    },
    {
      'question': '23. Slot pada motherboard khusus untuk memasang modul RAM dinamakan...',
      'options': ['Slot DIMM', 'Slot PCIe', 'Soket LGA', 'Slot M.2'],
      'answer': 0,
    },
    {
      'question': '24. Fungsi dari casing komputer adalah...',
      'options': ['Melindungi komponen internal dari debu, kotoran, dan benturan fisik', 'Mengolah grafik 3D', 'Menambah daya listrik', 'Mengubah jaringan internet'],
      'answer': 0,
    },
    {
      'question': '25. Slot M.2 NVMe pada motherboard modern digunakan untuk memasang...',
      'options': ['SSD M.2 berkecepatan sangat tinggi', 'VGA Card', 'Power Supply', 'Processor'],
      'answer': 0,
    },
  ];

  static final List<Map<String, dynamic>> _postTestKomponen = [
    {
      'question': '1. Komputer mengeluarkan bunyi beep pendek 1 kali saat dinyalakan (POST BIOS AMI). Arti kode beep ini adalah...',
      'options': ['Sistem booting normal dan berhasil melewati tes hardware', 'Kerusakan pada RAM', 'Kerusakan pada VGA Card', 'Power Supply mati total'],
      'answer': 0,
    },
    {
      'question': '2. Mengapa penggunaan SSD NVMe jauh lebih cepat daripada HDD mekanis biasa?',
      'options': ['NVMe menggunakan chip flash memory dan jalur PCIe tanpa piringan berputar', 'NVMe memiliki kipas pendingin di dalamnya', 'NVMe terhubung ke kabel SATA', 'NVMe menggunakan piringan emas'],
      'answer': 0,
    },
    {
      'question': '3. Gejala saat tanggal dan waktu di jam BIOS Windows selalu tereset ke tahun lama setiap PC dimatikan adalah tanda...',
      'options': ['Baterai CMOS di motherboard sudah habis/soak', 'Harddisk terkena virus', 'RAM tidak cocok', 'Power Supply kekurangan watt'],
      'answer': 0,
    },
    {
      'question': '4. Suhu CPU tiba-tiba melonjak hingga 90°C saat idle dan PC mati sendiri. Penyebab utama kemungkinan besar adalah...',
      'options': ['Kipas Heatsink mati atau thermal paste sudah kering total', 'Kapasitas RAM terlalu besar', 'Windows belum diaktivasi', 'Kabel SATA terlepas'],
      'answer': 0,
    },
    {
      'question': '5. Keuntungan mengonfigurasi RAM dalam mode Dual Channel adalah...',
      'options': ['Meningkatkan bandwidth memori dan performa pemrosesan data dua kali lipat', 'Menghemat penggunaan kapasitas harddisk', 'Membuat monitor menjadi 4K', 'Meningkatkan daya power supply'],
      'answer': 0,
    },
    {
      'question': '6. Istilah Bottleneck pada perakitan PC terjadi ketika...',
      'options': ['Salah satu komponen (seperti CPU tua) membatasi performa maksimal komponen lain (seperti VGA baru)', 'Power supply terlalu besar wattnya', 'Kapasitas SSD lebih besar dari HDD', 'Casing terlalu lebar'],
      'answer': 0,
    },
    {
      'question': '7. Sertifikasi 80 Plus pada Power Supply Unit (PSU) menunjukkan...',
      'options': ['Tingkat efisiensi daya listrik PSU minimal 80%', 'Daya PSU pasti 800 Watt', 'Suhu PSU maksimal 80°C', 'Masa garansi PSU 80 bulan'],
      'answer': 0,
    },
    {
      'question': '8. Sistem BIOS UEFI modern memiliki keunggulan dibanding BIOS Legacy kuno dalam hal...',
      'options': ['Mendukung drive penyimpanan lebih dari 2.2 TB (GPT) dan GUI dengan mouse', 'Hanya bisa menggunakan tampilan teks hitam putih', 'Tidak memerlukan keyboard', 'Menghapus RAM secara otomatis'],
      'answer': 0,
    },
    {
      'question': '9. Kebijakan Thermal Throttling pada prosesor CPU berfungsi untuk...',
      'options': ['Menurunkan kecepatan clock secara otomatis saat suhu terlalu panas demi mencegah kerusakan', 'Menambah kecepatan CPU secara ekstrem', 'Mematikan kipas pendingin', 'Mengosongkan ruang harddisk'],
      'answer': 0,
    },
    {
      'question': '10. Jenis arsitektur pin soket Intel yang pinnya terletak di motherboard (bukan di CPU) disebut...',
      'options': ['LGA (Land Grid Array)', 'PGA (Pin Grid Array)', 'BGA (Ball Grid Array)', 'Slot A'],
      'answer': 0,
    },
    {
      'question': '11. Arsitektur soket CPU AMD lama yang pin kuningan jarumnya menempel pada processor dinamakan...',
      'options': ['PGA (Pin Grid Array)', 'LGA (Land Grid Array)', 'BGA', 'DIMM'],
      'answer': 0,
    },
    {
      'question': '12. Kabel power 24-pin ATX dari PSU dicolokkan ke...',
      'options': ['Motherboard sebagai daya utama', 'VGA Card tambahan', 'Harddisk SATA', 'Kipas casing'],
      'answer': 0,
    },
    {
      'question': '13. Kabel power 4-pin atau 8-pin CPU dari PSU berguna untuk memberi daya pada...',
      'options': ['Processor (CPU)', 'RAM', 'Chipset Audio', 'Monitor'],
      'answer': 0,
    },
    {
      'question': '14. Istilah Overclocking pada komponen hardware PC berarti...',
      'options': ['Meningkatkan kecepatan clock komponen di atas standar pabrik untuk performa ekstra', 'Menurunkan suhu PC menjadi minus', 'Mengunci kecepatan PC', 'Mengganti komponen dengan baru'],
      'answer': 0,
    },
    {
      'question': '15. Konektor kabel daya khusus bertanduk Molex 4-pin tua dari PSU biasanya digunakan untuk...',
      'options': ['Kipas casing lama atau HDD IDE tua', 'Soket CPU Intel', 'Layar LED', 'Keyboard USB'],
      'answer': 0,
    },
    {
      'question': '16. Ciri utama kerusakan fisik pada kapasitor motherboard (Elco) adalah...',
      'options': ['Bagian atas kapasitor menggembung atau bocor', 'Kapasitor patah menjadi dua', 'Kapasitor berubah warna menjadi emas', 'Kapasitor membesar 10 kali lipat'],
      'answer': 0,
    },
    {
      'question': '17. Perangkat GPU terintegrasi (iGPU) berarti...',
      'options': ['Pengolah grafis menyatu di dalam chip processor (CPU)', 'Pengolah grafis berada di kabel monitor', 'Pengolah grafis dipasang di slot RAM', 'Pengolah grafis terpisah berbentuk kartu besar'],
      'answer': 0,
    },
    {
      'question': '18. Tingkat kecepatan rotasi piringan HDD standar untuk PC dekstop adalah...',
      'options': ['7200 RPM', '100 RPM', '50000 RPM', '10 RPM'],
      'answer': 0,
    },
    {
      'question': '19. Fitur XMP (Extreme Memory Profile) pada BIOS berfungsi untuk...',
      'options': ['Menjalankan RAM pada kecepatan frekuensi overclock teruji pabrik secara otomatis', 'Mengkonversi RAM menjadi ROM', 'Mencetak dokumen tanpa printer', 'Mengunci kecepatan harddisk'],
      'answer': 0,
    },
    {
      'question': '20. Urutan prioritas booting (Boot Order) dapat diatur pada menu...',
      'options': ['BIOS / UEFI Setup', 'Windows Task Manager', 'Control Panel Device Manager', 'CMD ipconfig'],
      'answer': 0,
    },
    {
      'question': '21. Chipset motherboard kelas atas untuk prosessor Intel yang mendukung overclocking ditandai seri huruf...',
      'options': ['Seri Z (misal: Z690)', 'Seri H', 'Seri B', 'Seri A'],
      'answer': 0,
    },
    {
      'question': '22. Fungsi utama komponen Sound Card pada komputer adalah...',
      'options': ['Mengolah dan menghasilkan sinyal audio input/output', 'Meningkatkan kecepatan internet', 'Memperbesar kapasitas RAM', 'Menampilkan gambar ke TV'],
      'answer': 0,
    },
    {
      'question': '23. Memori Cache L1, L2, dan L3 terletak di dalam...',
      'options': ['Chip Processor (CPU)', 'Kepingan RAM', 'Chip Motherboard', 'Unit SSD'],
      'answer': 0,
    },
    {
      'question': '24. Teknologi DisplayPort dibanding HDMI memiliki keunggulan pada...',
      'options': ['Bandwidth transfer lebih tinggi untuk refresh rate ekstrim monitor gaming', 'Bentuk konektor lebih kecil dari USB', 'Hanya bisa menyalurkan gambar tanpa suara', 'Tidak menggunakan kabel'],
      'answer': 0,
    },
    {
      'question': '25. Jenis memori RAM generasi terbaru saat ini untuk PC adalah...',
      'options': ['DDR5', 'DDR1', 'SDRAM 66MHz', 'EDO RAM'],
      'answer': 0,
    },
  ];

  // ==========================================
  // 4. PERANGKAT JARINGAN (25 PRE-TEST & 25 POST-TEST)
  // ==========================================
  static final List<Map<String, dynamic>> _preTestPerangkat = [
    {
      'question': '1. Kartu jaringan yang terpasang pada komputer untuk menghubungkan kabel LAN dinamakan...',
      'options': ['NIC (Network Interface Card) / LAN Card', 'VGA Card', 'Sound Card', 'Capture Card'],
      'answer': 0,
    },
    {
      'question': '2. Perangkat jaringan yang berfungsi memancarkan sinyal Wi-Fi nirkabel ke perangkat klien dinamakan...',
      'options': ['Access Point', 'Switch Hub', 'LAN Tester', 'Crimping Tool'],
      'answer': 0,
    },
    {
      'question': '3. Perangkat pemisah/penghubung yang meneruskan paket data secara pintar berdasarkan MAC address adalah...',
      'options': ['Switch Managed', 'Hub Unmanaged', 'Repeater', 'Splitter Passive'],
      'answer': 0,
    },
    {
      'question': '4. Perangkat lama yang meneruskan sinyal data ke seluruh port tanpa filter (broadcast berlebih) adalah...',
      'options': ['Hub', 'Switch', 'Router', 'Firewall'],
      'answer': 0,
    },
    {
      'question': '5. Perangkat penghubung utama antara jaringan telepon/fiber dengan jaringan komputer lokal dinamakan...',
      'options': ['Modem', 'Access Point', 'Switch', 'LAN Card'],
      'answer': 0,
    },
    {
      'question': '6. Perangkat jaringan yang berfungsi menghubungkan dua jenis media transmisi berbeda (misal Fiber ke UTP) dinamakan...',
      'options': ['Media Converter', 'Repeater', 'Gateway', 'Bridge'],
      'answer': 0,
    },
    {
      'question': '7. Alat keamanan jaringan yang menyaring lalu lintas data masuk dan keluar sesuai aturan dinamakan...',
      'options': ['Firewall', 'Access Point', 'Hub', 'Repeater'],
      'answer': 0,
    },
    {
      'question': '8. Lemari khusus standar berbahan besi untuk menempatkan server dan perangkat jaringan dinamakan...',
      'options': ['Rack Server', 'Casing PC', 'Brankas', 'Box ODP'],
      'answer': 0,
    },
    {
      'question': '9. Perangkat panel berderet port RJ45 di rak server tempat terminasi ujung kabel dari ruangan dinamakan...',
      'options': ['Patch Panel', 'Switch Unmanaged', 'Power Strip', 'Cable Tray'],
      'answer': 0,
    },
    {
      'question': '10. Teknologi PoE (Power over Ethernet) memungkinkan kabel LAN menyalurkan...',
      'options': ['Sinyal data sekaligus daya listrik DC ke perangkat', 'Air pendingin', 'Sinyal suara telepon rumah', 'Gas alami'],
      'answer': 0,
    },
    {
      'question': '11. Antena Wi-Fi yang memancarkan sinyal ke segala arah 360 derajat dinamakan antena...',
      'options': ['Omnidirectional', 'Directional / Grid', 'Yagi', 'Parabola'],
      'answer': 0,
    },
    {
      'question': '12. Antena Wi-Fi yang fokus memancarkan sinyal ke satu arah tertentu untuk jarak jauh dinamakan antena...',
      'options': ['Directional / Grid / Sectoral', 'Omnidirectional', 'Dipole', 'Rubber Duck'],
      'answer': 0,
    },
    {
      'question': '13. Perangkat Modem singkatan dari...',
      'options': ['Modulator Demodulator', 'Modern Demodulator', 'Mode Digital Modem', 'Module Data Emitter'],
      'answer': 0,
    },
    {
      'question': '14. Perangkat Access Point Outdoor dirancang khusus dengan ketahanan terhadap...',
      'options': ['Cuaca eksternal (air hujan, panas matahari, & petir)', 'Suhu dingin ac', 'Guncangan gempabumi', 'Lumpur basah'],
      'answer': 0,
    },
    {
      'question': '15. Fitur SSID pada Access Point berguna untuk...',
      'options': ['Memberi nama identitas jaringan Wi-Fi yang terlihat oleh pengguna', 'Mengunci password secara permanen', 'Mengatur IP address server', 'Menghapus data laptop'],
      'answer': 0,
    },
    {
      'question': '16. Perangkat pendeteksi dan penguji kabel LAN yang menggunakan lampu indikator LED 1-8 dinamakan...',
      'options': ['LAN Tester', 'Multitester AVO', 'OTDR', 'Splicer'],
      'answer': 0,
    },
    {
      'question': '17. Tang khusus untuk menjepit konektor RJ45 pada kabel UTP dinamakan...',
      'options': ['Crimping Tool', 'Tang Potong Biasa', 'Tang Buaya', 'Obeng Min'],
      'answer': 0,
    },
    {
      'question': '18. Perangkat SFP (Small Form-factor Pluggable) pada switch managed berfungsi sebagai...',
      'options': ['Modul transceiver eksternal untuk colokan kabel Fiber Optik', 'Slot memori tambahan', 'Port charger HP', 'Antena Wi-Fi internal'],
      'answer': 0,
    },
    {
      'question': '19. Router jaringan populer bersistem operasi RouterOS buatan Latvia adalah...',
      'options': ['MikroTik', 'Cisco', 'TP-Link', 'Tenda'],
      'answer': 0,
    },
    {
      'question': '20. Merek perangkat jaringan standar industri enterprise dunia yang terkenal dengan sertifikasi CCNA adalah...',
      'options': ['Cisco Systems', 'D-Link', 'Totolink', 'Mercusys'],
      'answer': 0,
    },
    {
      'question': '21. Perangkat jaringan tanpa kabel yang menangkap sinyal Wi-Fi di PC desktop adalah...',
      'options': ['USB Wi-Fi Adapter', 'VGA Card', 'Sound Card', 'TV Tuner'],
      'answer': 0,
    },
    {
      'question': '22. Istilah Unmanaged Switch berarti...',
      'options': ['Switch plug-and-play sederhana tanpa fitur konfigurasi software', 'Switch yang rusak total', 'Switch yang harus diatur Winbox', 'Switch berlayar sentuh'],
      'answer': 0,
    },
    {
      'question': '23. Istilah Managed Switch berarti...',
      'options': ['Switch pintar yang dapat dikonfigurasi fitur VLAN, QoS, dan Port Security', 'Switch tanpa colokan listrik', 'Switch yang hanya memiliki 2 port', 'Switch khusus komputer Mac'],
      'answer': 0,
    },
    {
      'question': '24. Perangkat penstabil tegangan listrik sekaligus penyedia daya baterai cadangan saat listrik mati adalah...',
      'options': ['UPS (Uninterruptible Power Supply)', 'Stabilizer biasa', 'MCB', 'Genset Solar'],
      'answer': 0,
    },
    {
      'question': '25. Fungsi utama dari Port Console pada Router Cisco adalah...',
      'options': ['Port khusus konfigurasi awal router menggunakan kabel Roll-over/Serial via PC', 'Port colokan kabel optik', 'Port stik game', 'Port antena Wi-Fi'],
      'answer': 0,
    },
  ];

  static final List<Map<String, dynamic>> _postTestPerangkat = [
    {
      'question': '1. Perbedaan mendasar antara Switch Layer 2 dan Switch Layer 3 adalah...',
      'options': ['Switch Layer 3 dapat melakukan fungsi routing IP layaknya router', 'Switch Layer 2 mendukung sambungan kabel fiber', 'Switch Layer 3 tidak memiliki port RJ45', 'Switch Layer 2 membutuhkan OS Windows'],
      'answer': 0,
    },
    {
      'question': '2. Tabel pada switch yang menyimpan daftar pasangan MAC Address dan Port dinamakan...',
      'options': ['CAM Table / MAC Address Table', 'Routing Table', 'ARP Cache Table', 'DHCP Lease Table'],
      'answer': 0,
    },
    {
      'question': '3. Keuntungan utama menggunakan PoE Injector / Switch PoE untuk memasang Access Point di atap adalah...',
      'options': ['Tidak perlu ditarik kabel colokan listrik PLN ke atas atap', 'Sinyal Wi-Fi bisa tembus besi', 'Access Point menjadi tahan air hujan', 'Frekuensi Wi-Fi berubah otomatis'],
      'answer': 0,
    },
    {
      'question': '4. Mengapa perangkat Hub memicu tabrakan data (Collision) yang tinggi dalam jaringan?',
      'options': ['Karena Hub meneruskan data secara half-duplex ke seluruh port sekaligus tanpa filter', 'Sebab Hub tidak memakai colokan listrik', 'Sebab Hub hanya memiliki 1 port', 'Karena Hub menggunakan sinyal radio'],
      'answer': 0,
    },
    {
      'question': '5. Fitur Port Security pada Switch Managed berfungsi untuk...',
      'options': ['Membatasi MAC Address tertentu yang boleh terhubung ke port switch demi keamanan', 'Mengunci port agar tidak bisa dilepas', 'Menghentikan arus listrik port', 'Menghapus paket data yang masuk'],
      'answer': 0,
    },
    {
      'question': '6. Standar PoE IEEE 802.3at (PoE+) mampu menyalurkan daya hingga sekitar...',
      'options': ['30 Watt', '15 Watt', '100 Watt', '5 Watt'],
      'answer': 0,
    },
    {
      'question': '7. Aplikasi Winbox digunakan khusus untuk mengonfigurasi perangkat...',
      'options': ['MikroTik RouterOS', 'Cisco Switch', 'Ruijie AP', 'Ubiquiti ToughSwitch'],
      'answer': 0,
    },
    {
      'question': '8. Mode Wireless Access Point "Client / Station Mode" berfungsi untuk...',
      'options': ['Menangkap sinyal Wi-Fi dari pemancar lain dan mengubahnya ke port LAN kabel', 'Memancarkan sinyal SSID baru', 'Memblokir pengguna Wi-Fi', 'Mengubah password router'],
      'answer': 0,
    },
    {
      'question': '9. Mode Wireless "Repeater / Range Extender" berfungsi untuk...',
      'options': ['Menangkap sinyal Wi-Fi yang lemah lalu memancarkannya kembali untuk memperluas jangkauan', 'Menghentikan sinyal Wi-Fi tetangga', 'Mengganti nama ISP internet', 'Menghitung kuota internet'],
      'answer': 0,
    },
    {
      'question': '10. Fungsi dari Load Balancer pada perangkat router adalah...',
      'options': ['Membagi beban lalu lintas data secara merata ke dua atau lebih jalur koneksi ISP', 'Menambah kecepatan ISP secara gratis', 'Mengubah koneksi LAN jadi Bluetooth', 'Mematikan server saat panas'],
      'answer': 0,
    },
    {
      'question': '11. Perangkat ONT (Optical Network Terminal) pada jaringan indihome/fiber berfungsi sebagai...',
      'options': ['Modem modem optik di sisi pelanggan untuk mengubah sinyal optik menjadi eter/wifi', 'Splicer kabel fiber', 'Antena parabola', 'Power supply central'],
      'answer': 0,
    },
    {
      'question': '12. Perangkat OLT (Optical Line Terminal) berada di lokasi...',
      'options': ['Pusat Sentral / POP penyedia layanan internet (ISP)', 'Atas atap rumah pelanggan', 'Di dalam casing PC', 'Di dalam tang crimping'],
      'answer': 0,
    },
    {
      'question': '13. Penggunaan protokol Spanning Tree Protocol (STP) pada Switch Managed bertujuannya untuk...',
      'options': ['Mencegah terjadinya looping (perulangan sinyal tak terbatas) pada topologi switch redundant', 'Mempercepat pengiriman email', 'Mengamankan password Wi-Fi', 'Menghitung panjang kabel UTP'],
      'answer': 0,
    },
    {
      'question': '14. Fitur Captive Portal pada Access Point biasanya digunakan untuk...',
      'options': ['Halaman login web autentikasi sebelum pengguna mendapatkan akses internet Wi-Fi', 'Mengubah sinyal Wi-Fi jadi sinyal radio FM', 'Mematikan sinyal saat malam', 'Membuka kunci casing AP'],
      'answer': 0,
    },
    {
      'question': '15. Standar enkripsi keamanan Wi-Fi nirkabel yang paling kuat dan modern saat ini adalah...',
      'options': ['WPA3', 'WEP (Lama & Rentan)', 'WPA1', 'No Security'],
      'answer': 0,
    },
    {
      'question': '16. Perangkat Hardware Firewall dedicated (seperti Fortinet / Palo Alto) memiliki keunggulan dibanding Software Firewall yaitu...',
      'options': ['Memiliki pemrosesan ASIC hardware khusus yang mampu menangani trafik giga bit tanpa membebani server', 'Harganya sangat murah', 'Tidak memerlukan arus listrik', 'Bisa dipasang di HP Android'],
      'answer': 0,
    },
    {
      'question': '17. Perangkat KVM Switch (Keyboard, Video, Mouse Switch) di rak server berguna untuk...',
      'options': ['Mengendalikan beberapa unit server menggunakan 1 set monitor, keyboard, dan mouse', 'Menghubungkan 10 kabel internet', 'Mengubah suara server', 'Menghemat penggunaan RAM'],
      'answer': 0,
    },
    {
      'question': '18. Fitur Bandwidth Limiter (QoS) pada Router berguna untuk...',
      'options': ['Membatasi dan membagi alokasi kecepatan download/upload per pengguna', 'Membuat internet gratis selamanya', 'Mengubah IP publik jadi privat', 'Menghapus riwayat pencarian'],
      'answer': 0,
    },
    {
      'question': '19. Penggunaan kabel Serial / Console Roll-over membutuhkan aplikasi terminal di PC seperti...',
      'options': ['PuTTY / TeraTerm', 'Google Chrome', 'Microsoft Word', 'VLC Player'],
      'answer': 0,
    },
    {
      'question': '20. Indikator lampu Link/Act berwarna hijau berkedip pada port LAN Card menunjukkan...',
      'options': ['Ada koneksi fisik fisik dan sedang terjadi aktivitas transmisi data', 'Kabel LAN terputus total', 'LAN Card terbakar', 'IP Address bentrok'],
      'answer': 0,
    },
    {
      'question': '21. Jenis antena Wi-Fi Sectoral paling sering dipasang pada jaringan ISP Nirkabel (RTLRWNet) karena...',
      'options': ['Memiliki sudut pancar luas (60-120 derajat) dengan gain tinggi ke arah klien', 'Memancar bulat 360 derajat sejauh 1 meter', 'Hanya bisa dipakai di dalam kamar', 'Tidak membutuhkan tiang'],
      'answer': 0,
    },
    {
      'question': '22. Protokol SNMP (Simple Network Management Protocol) berguna bagi sistem monitoring untuk...',
      'options': ['Pantau status performa, trafik, dan kesehatan perangkat jaringan secara otomatis', 'Mengirimkan pesan singkat SMS', 'Mengunduh file film cepat', 'Membuat animasi web'],
      'answer': 0,
    },
    {
      'question': '23. Sakelar Failover pada sistem jaringan otomatis akan...',
      'options': ['Pindah ke jalur internet cadangan saat jalur internet utama mengalami kealpaan (down)', 'Mematikan seluruh server', 'Menghapus konfigurasi router', 'Mengunci ruang lab'],
      'answer': 0,
    },
    {
      'question': '24. Frekuensi standar sinyal Wi-Fi nirkabel yang paling bebas gangguan intervensi namun jangkauan lebih pendek adalah...',
      'options': ['5 GHz', '2.4 GHz', '900 MHz', '100 MHz'],
      'answer': 0,
    },
    {
      'question': '25. Frekuensi sinyal Wi-Fi 2.4 GHz memiliki keunggulan dibanding 5 GHz dalam hal...',
      'options': ['Jangkauan pancaran sinyal lebih jauh dan lebih baik menembus dinding', 'Kecepatan transfer data lebih tinggi 3 kali lipat', 'Bebas dari gangguan microwave dan bluetooth', 'Tidak membutuhkan antena'],
      'answer': 0,
    },
  ];

  // ==========================================
  // 5. IP ADDRESS (25 PRE-TEST & 25 POST-TEST)
  // ==========================================
  static final List<Map<String, dynamic>> _preTestIpAddress = [
    {
      'question': '1. IPv4 (IP versi 4) terdiri dari berapa bit alamat biner...',
      'options': ['32 bit', '64 bit', '128 bit', '16 bit'],
      'answer': 0,
    },
    {
      'question': '2. Penulisan IPv4 terdiri dari berapa oktet desimal yang dipisahkan oleh tanda titik...',
      'options': ['4 Oktet (contoh: 192.168.1.1)', '6 Oktet', '2 Oktet', '8 Oktet'],
      'answer': 0,
    },
    {
      'question': '3. Range IP Address Kelas A berada pada oktet pertama antara...',
      'options': ['1 - 126', '128 - 191', '192 - 223', '224 - 239'],
      'answer': 0,
    },
    {
      'question': '4. Range IP Address Kelas B berada pada oktet pertama antara...',
      'options': ['128 - 191', '1 - 126', '192 - 223', '224 - 239'],
      'answer': 0,
    },
    {
      'question': '5. Range IP Address Kelas C berada pada oktet pertama antara...',
      'options': ['192 - 223', '128 - 191', '1 - 126', '224 - 239'],
      'answer': 0,
    },
    {
      'question': '6. Subnet Mask default untuk IP Address Kelas C adalah...',
      'options': ['255.255.255.0', '255.255.0.0', '255.0.0.0', '255.255.255.255'],
      'answer': 0,
    },
    {
      'question': '7. Subnet Mask default untuk IP Address Kelas B adalah...',
      'options': ['255.255.0.0', '255.255.255.0', '255.0.0.0', '255.255.255.255'],
      'answer': 0,
    },
    {
      'question': '8. Subnet Mask default untuk IP Address Kelas A adalah...',
      'options': ['255.0.0.0', '255.255.0.0', '255.255.255.0', '255.255.255.255'],
      'answer': 0,
    },
    {
      'question': '9. Alamat IP khusus `127.0.0.1` digunakan untuk fungsi...',
      'options': ['Loopback / Testing kartu jaringan lokal (localhost)', 'IP Publik Internasional', 'Alamat Broadcast Global', 'Gateway Server'],
      'answer': 0,
    },
    {
      'question': '10. Manakah di bawah ini yang merupakan alamat IP Privat lokal kelas C standar...',
      'options': ['192.168.1.100', '8.8.8.8', '11.12.13.14', '200.100.50.1'],
      'answer': 0,
    },
    {
      'question': '11. Notasi CIDR untuk subnet mask `255.255.255.0` adalah...',
      'options': ['/24', '/16', '/8', '/32'],
      'answer': 0,
    },
    {
      'question': '12. Alamat IP pertama dalam sebuah blok jaringan yang menjadi identitas jaringan dinamakan...',
      'options': ['Network Address', 'Broadcast Address', 'Usable Host', 'Gateway'],
      'answer': 0,
    },
    {
      'question': '13. Alamat IP terakhir dalam sebuah blok subnet yang digunakan untuk mengirim pesan ke seluruh host dinamakan...',
      'options': ['Broadcast Address', 'Network Address', 'Loopback', 'DNS Server'],
      'answer': 0,
    },
    {
      'question': '14. Alamat IP router yang menghubungkan jaringan lokal ke internet dinamakan...',
      'options': ['Default Gateway', 'Subnet Mask', 'DNS Primary', 'MAC Address'],
      'answer': 0,
    },
    {
      'question': '15. Jumlah total bit pada IPv6 (IP versi 6) adalah...',
      'options': ['128 bit', '32 bit', '64 bit', '256 bit'],
      'answer': 0,
    },
    {
      'question': '16. Penulisan alamat IPv6 menggunakan format angka...',
      'options': ['Heksadesimal dipisahkan titik dua (:) ', 'Desimal dipisahkan titik', 'Biner dipisahkan spasi', 'Oktal dipisahkan koma'],
      'answer': 0,
    },
    {
      'question': '17. Layanan yang secara otomatis memberikan alamat IP ke komputer klien dinamakan...',
      'options': ['DHCP Server', 'DNS Server', 'FTP Server', 'Web Server'],
      'answer': 0,
    },
    {
      'question': '18. Metode pemberian IP Address secara manual oleh administrator disebut...',
      'options': ['Static IP (IP Statis)', 'Dynamic IP', 'DHCP Lease', 'Automatic Private IP'],
      'answer': 0,
    },
    {
      'question': '19. Dalam subnet /24, jumlah total alamat IP yang ada adalah...',
      'options': ['256 IP', '254 IP', '128 IP', '512 IP'],
      'answer': 0,
    },
    {
      'question': '20. Dalam subnet /24, jumlah alamat IP yang dapat digunakan untuk Host (Usable IP) adalah...',
      'options': ['254 IP (dikurangi Network & Broadcast)', '256 IP', '255 IP', '252 IP'],
      'answer': 0,
    },
    {
      'question': '21. Blok alamat IP Privat Kelas A yang dipesan oleh IANA adalah...',
      'options': ['10.0.0.0 - 10.255.255.255', '192.168.0.0 - 192.168.255.255', '172.16.0.0 - 172.31.255.255', '127.0.0.0 - 127.255.255.255'],
      'answer': 0,
    },
    {
      'question': '22. Perintah untuk melihat konfigurasi IP Address pada sistem operasi Windows via CMD adalah...',
      'options': ['ipconfig', 'ifconfig', 'netstat', 'ping'],
      'answer': 0,
    },
    {
      'question': '23. Perintah untuk melihat konfigurasi IP Address pada Linux terminal adalah...',
      'options': ['ip a / ifconfig', 'ipconfig', 'nslookup', 'systeminfo'],
      'answer': 0,
    },
    {
      'question': '24. Kebocoran/konflik IP Address (IP Conflict) terjadi ketika...',
      'options': ['Dua atau lebih perangkat menggunakan alamat IP yang sama persis dalam satu jaringan', 'Kabel LAN terputus', 'Password Wi-Fi salah', 'Server mati'],
      'answer': 0,
    },
    {
      'question': '25. Alamat IP khusus `8.8.8.8` dikenal umum sebagai alamat...',
      'options': ['Public DNS Server Google', 'Gateway Indihome', 'IP Komputer Lokal', 'Subnet Mask'],
      'answer': 0,
    },
  ];

  static final List<Map<String, dynamic>> _postTestIpAddress = [
    {
      'question': '1. Jika IP Address komputer A adalah `192.168.1.15/26`, berapakah nilai Subnet Mask-nya?',
      'options': ['255.255.255.192', '255.255.255.128', '255.255.255.224', '255.255.255.240'],
      'answer': 0,
    },
    {
      'question': '2. Pada IP Address `192.168.1.15/26`, berapakah jumlah Host Usable per subnet-nya?',
      'options': ['62 Host (64 - 2)', '64 Host', '30 Host', '126 Host'],
      'answer': 0,
    },
    {
      'question': '3. Pada IP Address `192.168.1.100/27`, berapakah Network Address dari blok subnet tersebut?',
      'options': ['192.168.1.96', '192.168.1.0', '192.168.1.64', '192.168.1.128'],
      'answer': 0,
    },
    {
      'question': '4. Pada IP Address `192.168.1.100/27`, berapakah Broadcast Address-nya?',
      'options': ['192.168.1.127', '192.168.1.255', '192.168.1.95', '192.168.1.159'],
      'answer': 0,
    },
    {
      'question': '5. Notasi CIDR yang paling hemat dan tepat digunakan untuk subnetting point-to-point antar 2 Router adalah...',
      'options': ['/30 (menyediakan 2 IP usable)', '/24', '/28', '/29'],
      'answer': 0,
    },
    {
      'question': '6. Teknik VLSM (Variable Length Subnet Mask) digunakan untuk...',
      'options': ['Membagi IP address menjadi subnet dengan ukuran mask yang bervariasi sesuai kebutuhan host', 'Mengubah IPv4 menjadi IPv6', 'Membuat IP publik gratis', 'Menyembunyikan MAC address'],
      'answer': 0,
    },
    {
      'question': '7. Apabila Windows menampilkan IP `169.254.x.x`, kondisi ini dinamakan APIPA yang menandakan...',
      'options': ['Komputer gagal mendapatkan IP dari DHCP Server', 'Komputer terhubung ke internet super cepat', 'IP Address diproteksi firewall', 'Sistem operasi belum diaktivasi'],
      'answer': 0,
    },
    {
      'question': '8. Konversi bilangan biner `11000000.10101000.00000001.00000001` ke desimal adalah...',
      'options': ['192.168.1.1', '172.16.1.1', '10.0.0.1', '255.255.255.0'],
      'answer': 0,
    },
    {
      'question': '9. Konversi desimal 192 ke biner 8 bit adalah...',
      'options': ['11000000', '10101000', '11110000', '11100000'],
      'answer': 0,
    },
    {
      'question': '10. Konversi desimal 255 ke biner 8 bit adalah...',
      'options': ['11111111', '11110000', '10101010', '10000000'],
      'answer': 0,
    },
    {
      'question': '11. Sebuah lab membutuhkan 50 IP usable untuk PC. Notasi CIDR terkecil yang mencukupi adalah...',
      'options': ['/26 (62 usable host)', '/27 (30 usable host)', '/28 (14 usable host)', '/25 (126 usable host)'],
      'answer': 0,
    },
    {
      'question': '12. Sebuah kantor membutuhkan 10 IP usable untuk printer. Notasi CIDR terkecil yang hemat dan tepat adalah...',
      'options': ['/28 (14 usable host)', '/29 (6 usable host)', '/27 (30 usable host)', '/30 (2 usable host)'],
      'answer': 0,
    },
    {
      'question': '13. Alamat IP Privat kelas B yang dipesan IANA berada pada range...',
      'options': ['172.16.0.0 - 172.31.255.255', '10.0.0.0 - 10.255.255.255', '192.168.0.0 - 192.168.255.255', '169.254.0.0 - 169.254.255.255'],
      'answer': 0,
    },
    {
      'question': '14. Nilai Wildcard Mask dari Subnet Mask `255.255.255.240` (/28) adalah...',
      'options': ['0.0.0.15', '0.0.0.255', '0.0.0.31', '0.0.0.7'],
      'answer': 0,
    },
    {
      'question': '15. Mengapa alamat Network dan Broadcast tidak boleh dipasang pada PC klien?',
      'options': ['Karena Network adalah identitas segmen dan Broadcast untuk kirim pesan ke semua host', 'Sebab akan merusak hardware VGA', 'Sebab IP tersebut memiliki virus', 'Sebab IP tersebut khusus untuk printer'],
      'answer': 0,
    },
    {
      'question': '16. Berapakah jumlah blok subnet yang terbentuk dari subnetting /26 pada kelas C...',
      'options': ['4 Subnet (\$2^2)', '2 Subnet', '8 Subnet', '16 Subnet'],
      'answer': 0,
    },
    {
      'question': '17. Berapakah jumlah blok subnet yang terbentuk dari subnetting /27 pada kelas C...',
      'options': ['8 Subnet (\$2^3)', '4 Subnet', '16 Subnet', '32 Subnet'],
      'answer': 0,
    },
    {
      'question': '18. Berapakah jumlah blok subnet yang terbentuk dari subnetting /28 pada kelas C...',
      'options': ['16 Subnet (\$2^4)', '8 Subnet', '32 Subnet', '64 Subnet'],
      'answer': 0,
    },
    {
      'question': '19. Berapakah nilai Subnet Mask dari /29...',
      'options': ['255.255.255.248', '255.255.255.240', '255.255.255.252', '255.255.255.224'],
      'answer': 0,
    },
    {
      'question': '20. Berapakah jumlah Host Usable dari subnet /29...',
      'options': ['6 Host (8 - 2)', '14 Host', '2 Host', '30 Host'],
      'answer': 0,
    },
    {
      'question': '21. Berapakah nilai Subnet Mask dari /30...',
      'options': ['255.255.255.252', '255.255.255.248', '255.255.255.240', '255.255.255.255'],
      'answer': 0,
    },
    {
      'question': '22. Fungsi utama dari Subnetting adalah...',
      'options': ['Efisiensi pengalokasian IP, mengurangi traffic broadcast, dan meningkatkan keamanan', 'Mempercepat sinyal Wi-Fi', 'Menambah kapasitas memori HDD', 'Mengganti kabel UTP dengan FO'],
      'answer': 0,
    },
    {
      'question': '23. Kebijakan Dual Stack pada transisi IP berarti...',
      'options': ['Menjalankan IPv4 dan IPv6 secara bersamaan pada perangkat jaringan', 'Menggunakan dua kabel LAN pada satu PC', 'Memasang dua kartu NIC', 'Mengisi dua IP Publik'],
      'answer': 0,
    },
    {
      'question': '24. Alamat IPv6 `::1` ekuivalen dengan alamat IPv4...',
      'options': ['127.0.0.1 (Loopback)', '192.168.1.1', '0.0.0.0', '255.255.255.255'],
      'answer': 0,
    },
    {
      'question': '25. Manakah dari IP Address berikut yang INVALID (tidak sah) dalam IPv4?',
      'options': ['192.168.1.256 (Oktet melebihi 255)', '10.0.0.1', '172.16.254.1', '8.8.4.4'],
      'answer': 0,
    },
  ];

  // ==========================================
  // 6. KABEL JARINGAN (25 PRE-TEST & 25 POST-TEST)
  // ==========================================
  static final List<Map<String, dynamic>> _preTestKabel = [
    {
      'question': '1. Jenis kabel UTP singkatan dari...',
      'options': ['Unshielded Twisted Pair', 'Universal Twisted Pair', 'United Tactical Pair', 'Unshielded Total Protection'],
      'answer': 0,
    },
    {
      'question': '2. Jenis kabel STP singkatan dari...',
      'options': ['Shielded Twisted Pair', 'Standard Twisted Pair', 'Single Twisted Pair', 'Secure Tactical Pair'],
      'answer': 0,
    },
    {
      'question': '3. Konektor standar yang digunakan untuk merakit kabel UTP/STP ke LAN Card dinamakan...',
      'options': ['RJ45', 'RJ11', 'BNC', 'SC Connector'],
      'answer': 0,
    },
    {
      'question': '4. Urutan standar pewarnaan kabel T568B diawali dengan warna...',
      'options': ['Putih Oranye - Oranye', 'Putih Hijau - Hijau', 'Putih Biru - Biru', 'Putih Cokelat - Cokelat'],
      'answer': 0,
    },
    {
      'question': '5. Urutan standar pewarnaan kabel T568A diawali dengan warna...',
      'options': ['Putih Hijau - Hijau', 'Putih Oranye - Oranye', 'Putih Biru - Biru', 'Putih Cokelat - Cokelat'],
      'answer': 0,
    },
    {
      'question': '6. Susunan kabel Straight-Through digunakan untuk menghubungkan dua perangkat yang...',
      'options': ['Berbeda jenis (contoh: PC ke Switch)', 'Sama jenis (contoh: PC ke PC)', 'PC ke Laptop langsung', 'Switch ke Switch langsung'],
      'answer': 0,
    },
    {
      'question': '7. Susunan kabel Crossover digunakan untuk menghubungkan dua perangkat yang...',
      'options': ['Sama jenis (contoh: PC ke PC, Switch ke Switch)', 'Berbeda jenis (contoh: PC ke Switch)', 'PC ke Access Point', 'Router ke Modem'],
      'answer': 0,
    },
    {
      'question': '8. Alat yang digunakan untuk memotong, mengupas, dan mengepress konektor RJ45 ke kabel UTP dinamakan...',
      'options': ['Tang Crimping (Crimping Tool)', 'LAN Tester', 'Fusion Splicer', 'Obeng Plus'],
      'answer': 0,
    },
    {
      'question': '9. Alat penguji konektivitas kabel UTP yang memiliki 8 indikator lampu LED dinamakan...',
      'options': ['LAN Tester', 'Multitester', 'Splicer', 'OTDR'],
      'answer': 0,
    },
    {
      'question': '10. Jangkauan panjang maksimal transmisi data kabel UTP tanpa bantuan repeater adalah...',
      'options': ['100 meter', '500 meter', '10 meter', '1000 meter'],
      'answer': 0,
    },
    {
      'question': '11. Kabel jaringan yang mentransmisikan data menggunakan pembiasan cahaya adalah...',
      'options': ['Fiber Optic (Serat Optik)', 'UTP Cat5e', 'STP Cat6', 'Kabel Coaxial'],
      'answer': 0,
    },
    {
      'question': '12. Bagian inti paling dalam dari kabel Fiber Optic tempat merambatnya cahaya dinamakan...',
      'options': ['Core', 'Cladding', 'Coating', 'Jacket'],
      'answer': 0,
    },
    {
      'question': '13. Bagian kabel Fiber Optic yang membungkus core dan memantulkan cahaya kembali ke dalam inti dinamakan...',
      'options': ['Cladding', 'Core', 'Buffer', 'Outer Jacket'],
      'answer': 0,
    },
    {
      'question': '14. Jumlah pasang (pair) kawat warna di dalam seutas kabel UTP Cat5e/Cat6 adalah...',
      'options': ['4 Pasang (8 kawat warna)', '2 Pasang', '6 Pasang', '8 Pasang'],
      'answer': 0,
    },
    {
      'question': '15. Jenis kabel Fiber Optic yang digunakan untuk jarak jauh antar kota/pulau karena memakai satu sinar laser dinamakan...',
      'options': ['Single-Mode Fiber', 'Multi-Mode Fiber', 'UTP Cable', 'STP Cable'],
      'answer': 0,
    },
    {
      'question': '16. Jenis kabel Fiber Optic yang menggunakan LED untuk jarak relatif pendek dinamakan...',
      'options': ['Multi-Mode Fiber', 'Single-Mode Fiber', 'Coaxial Thin', 'Coaxial Thick'],
      'answer': 0,
    },
    {
      'question': '17. Konektor telepon rumah yang ukurannya lebih kecil dari RJ45 adalah...',
      'options': ['RJ11', 'RJ45', 'BNC', 'FC'],
      'answer': 0,
    },
    {
      'question': '18. Fungsi dari pemutar plastik separator di tengah kabel UTP Cat6 adalah...',
      'options': ['Mengurangi crosstalk (interferensi antar pasangan kawat)', 'Membuat kabel lentur', 'Sebagai penghantar listrik', 'Menambah warna kabel'],
      'answer': 0,
    },
    {
      'question': '19. Alat penyambung kaca kabel Fiber Optic menggunakan sinar leburan listrik dinamakan...',
      'options': ['Fusion Splicer', 'Crimping Tool', 'Stripper', 'Miller Cleaver'],
      'answer': 0,
    },
    {
      'question': '20. Alat pemotong kaca Fiber Optic secara presisi rata sebelum displicing dinamakan...',
      'options': ['Fiber Cleaver', 'Tang Potong', 'Gunting Kertas', 'Solder'],
      'answer': 0,
    },
    {
      'question': '21. Hambatan atau penurunan kekuatan sinyal data sepanjang rute kabel dinamakan...',
      'options': ['Atenuasi (Attenuation)', 'Crosstalk', 'Bandwidth', 'Latency'],
      'answer': 0,
    },
    {
      'question': '22. Gangguan bocoran sinyal elektromagnetik antar pasangan kabel yang berdekatan dinamakan...',
      'options': ['Crosstalk', 'Atenuasi', 'Jitter', 'Noise'],
      'answer': 0,
    },
    {
      'question': '23. Kabel UTP Category 6 (Cat6) memiliki kecepatan transfer maksimal hingga...',
      'options': ['10 Gbps (pada jarak pendek) / 1 Gbps', '10 Mbps', '100 Mbps', '100 Gbps'],
      'answer': 0,
    },
    {
      'question': '24. Kabel UTP Category 5e (Cat5e) mendukung kecepatan transfer hingga...',
      'options': ['1 Gbps (1000 Mbps)', '10 Mbps', '100 Gbps', '1 Mbps'],
      'answer': 0,
    },
    {
      'question': '25. Pelindung berupa pembungkus aluminium foil pada kabel STP berguna untuk...',
      'options': ['Melindungi kabel dari gangguan interferensi elektromagnetik luar (EMI)', 'Membuat kabel tahan air laut', 'Menambah daya listrik', 'Menghemat timah'],
      'answer': 0,
    },
  ];

  static final List<Map<String, dynamic>> _postTestKabel = [
    {
      'question': '1. Urutan lengkap pewarnaan susunan T568B dari pin 1 sampai pin 8 adalah...',
      'options': ['Putih Oranye, Oranye, Putih Hijau, Biru, Putih Biru, Hijau, Putih Cokelat, Cokelat', 'Putih Hijau, Hijau, Putih Oranye, Biru, Putih Biru, Oranye, Putih Cokelat, Cokelat', 'Putih Biru, Biru, Putih Oranye, Hijau, Putih Hijau, Oranye, Putih Cokelat, Cokelat', 'Putih Cokelat, Cokelat, Putih Oranye, Oranye, Putih Hijau, Hijau, Putih Biru, Biru'],
      'answer': 0,
    },
    {
      'question': '2. Urutan lengkap pewarnaan susunan T568A dari pin 1 sampai pin 8 adalah...',
      'options': ['Putih Hijau, Hijau, Putih Oranye, Biru, Putih Biru, Oranye, Putih Cokelat, Cokelat', 'Putih Oranye, Oranye, Putih Hijau, Biru, Putih Biru, Hijau, Putih Cokelat, Cokelat', 'Putih Biru, Biru, Putih Hijau, Hijau, Putih Oranye, Oranye, Putih Cokelat, Cokelat', 'Putih Cokelat, Cokelat, Putih Biru, Biru, Putih Hijau, Hijau, Putih Oranye, Oranye'],
      'answer': 0,
    },
    {
      'question': '3. Pada pembuatan kabel Crossover, jika ujung A memakai standar T568B, maka ujung B wajib memakai standar...',
      'options': ['T568A', 'T568B', 'Rollover', 'Straight'],
      'answer': 0,
    },
    {
      'question': '4. Pin berapa sajakah pada konektor RJ45 jaringan 10/100 Mbps yang aktif digunakan untuk transmisi data (Tx & Rx)...',
      'options': ['Pin 1, 2, 3, dan 6', 'Pin 1, 2, 4, dan 5', 'Pin 4, 5, 7, dan 8', 'Semua 8 pin secara acak'],
      'answer': 0,
    },
    {
      'question': '5. Pasangan pin pada jaringan Fast Ethernet 100Mbps yang berfungsi sebagai Transmitter (Tx) pada standar T568B adalah...',
      'options': ['Pin 1 dan 2 (Putih Oranye & Oranye)', 'Pin 3 dan 6 (Putih Hijau & Hijau)', 'Pin 4 dan 5 (Biru & Putih Biru)', 'Pin 7 dan 8 (Putih Cokelat & Cokelat)'],
      'answer': 0,
    },
    {
      'question': '6. Saat diuji dengan LAN Tester, lampu indikator menyala urut 1-1 sampai 8-8 pada kedua sisi. Ini menandakan jenis kabel...',
      'options': ['Kabel Straight-Through yang berfungsi normal', 'Kabel Crossover yang rusak', 'Kabel Rollover', 'Kabel terputus di tengah'],
      'answer': 0,
    },
    {
      'question': '7. Alat ukur khusus untuk mendeteksi lokasi titik putus dan mengukur redaman jarak pada kabel Fiber Optic adalah...',
      'options': ['OTDR (Optical Time Domain Reflectometer)', 'Fusion Splicer', 'Visual Fault Locator (VFL/Laser Pulpen)', 'LAN Tester'],
      'answer': 0,
    },
    {
      'question': '8. Sinar laser pen saku (Visual Fault Locator / VFL) pada Fiber Optic berguna untuk...',
      'options': ['Mendeteksi kebocoran atau tekukan patah pada serat optik dengan pendaran sinar merah', 'Menyambung kabel yang putus', 'Mengupas lapisan cladding', 'Mengukur bandwidth'],
      'answer': 0,
    },
    {
      'question': '9. Jenis konektor Fiber Optic berbentuk dorong-tarik persegi yang populer dicolokkan ke media converter adalah...',
      'options': ['SC (Subscriber Connector)', 'ST (Straight Tip)', 'LC (Lucent Connector)', 'FC (Ferrule Connector)'],
      'answer': 0,
    },
    {
      'question': '10. Jenis konektor Fiber Optic berbentuk bulat putar bayonet mirip konektor BNC adalah...',
      'options': ['ST (Straight Tip)', 'SC (Subscriber Connector)', 'LC', 'RJ45'],
      'answer': 0,
    },
    {
      'question': '11. Jenis konektor Fiber Optic berukuran kecil (Small Form Factor) yang umum dicolokkan ke SFP Module adalah...',
      'options': ['LC (Lucent Connector)', 'SC', 'ST', 'FC'],
      'answer': 0,
    },
    {
      'question': '12. Toleransi sudut tekukan maksimal pada kabel Fiber Optic (Bending Radius) harus dijaga agar tidak patah karena...',
      'options': ['Inti kaca di dalamnya dapat retak/patah sehingga sinyal cahaya bocor mati', 'Kabel akan mengeluarkan sengatan listrik', 'Warna kabel memudar', 'Sinyal Wi-Fi hilang'],
      'answer': 0,
    },
    {
      'question': '13. Penyebab indikator lampu LAN Tester nomor 3 mati saat pengujian kabel Straight adalah...',
      'options': ['Kawat nomor 3 tidak terpasang/terkupas sempurna pada pin RJ45', 'Baterai LAN tester habis', 'Komputer mati', 'Kabel terlalu pendek'],
      'answer': 0,
    },
    {
      'question': '14. Fungsi dari kabel UTP susunan Rollover (Cisco Console Cable) adalah...',
      'options': ['Menghubungkan port COM/USB PC ke Port Console Router/Switch Cisco', 'Menghubungkan PC ke Internet', 'Menghubungkan Switch ke Switch', 'Menghubungkan Printer ke PC'],
      'answer': 0,
    },
    {
      'question': '15. Standar susunan pin pada kabel Rollover adalah...',
      'options': ['Pin 1 di ujung A terhubung ke Pin 8 di ujung B (dibalik total 1-8 ke 8-1)', 'Pin 1 terhubung ke Pin 3', 'Pin 1 terhubung ke Pin 1', 'Pin acak'],
      'answer': 0,
    },
    {
      'question': '16. Kelebihan utama kabel Fiber Optic dibanding kabel UTP Tembaga adalah...',
      'options': ['Kecepatan sangat tinggi, jangkauan puluhan km, dan kebal dari interferensi listrik', 'Harga jauh lebih murah dan gampang disambung tangan', 'Tidak membutuhkan alat khusus saat putus', 'Dapat ditekuk hingga lipatan tajam'],
      'answer': 0,
    },
    {
      'question': '17. Alat pembersih alkohol isoprophyl 99% pada penyambungan Fiber Optic berguna untuk...',
      'options': ['Membersihkan kotoran/debu pada inti kaca core sebelum dipotong cleaver', 'Melumasi tang crimping', 'Mencuci tangan teknisi', 'Mengilapkan konektor plastik'],
      'answer': 0,
    },
    {
      'question': '18. Selongsong plastik pelindung sambungan kaca fiber yang dipanaskan setelah splicing dinamakan...',
      'options': ['Protection Sleeve', 'Buffer Tube', 'Crimping Cap', 'Modular Jack'],
      'answer': 0,
    },
    {
      'question': '19. Kebijakan Auto-MDI/MDIX pada Switch modern berfungsi untuk...',
      'options': ['Mendeteksi dan menyesuaikan tipe kabel (Straight/Cross) secara otomatis', 'Mengubah kabel UTP jadi Fiber', 'Menghapus data kuis', 'Mematikan switch otomatis'],
      'answer': 0,
    },
    {
      'question': '20. Mengapa kawat tembaga di dalam kabel UTP dipilin (twisted) berpasangan?',
      'options': ['Untuk membatalkan/mengurangi interferensi elektromagnetik dan crosstalk', 'Agar kabel terlihat lebih tebal dan bagus', 'Agar mudah dipotong gunting', 'Agar tahan panas api'],
      'answer': 0,
    },
    {
      'question': '21. Kabel UTP Category 6a (Cat6a) dirancang untuk mendukung kecepatan 10 Gbps hingga jarak...',
      'options': ['100 meter penuh', '10 meter saja', '1000 meter', '1 meter'],
      'answer': 0,
    },
    {
      'question': '22. Pelindung luar paling tebal yang melindung kabel FO tanah dari galian/gigitan gigitan binatang adalah...',
      'options': ['Armored Cable Outer Jacket', 'Thermal Sleeve', 'Buffer Coating', 'Cladding Layer'],
      'answer': 0,
    },
    {
      'question': '23. Nilai standar redaman ideal (loss) penyambungan Splicing Fiber Optic yang baik adalah di bawah...',
      'options': ['0.03 dB per sambungan', '10 dB', '50 dB', '100 dB'],
      'answer': 0,
    },
    {
      'question': '24. Alat OPM (Optical Power Meter) berfungsi untuk...',
      'options': ['Mengukur daya kekuatan sinyal cahaya (dBm) pada kabel Fiber Optic', 'Mengukur tegangan listrik PLN', 'Mengukur panjang kabel UTP', 'Mengukur kecepatan mengetik'],
      'answer': 0,
    },
    {
      'question': '25. Batas frekuensi bandwidth kerja kabel UTP Cat6 adalah...',
      'options': ['250 MHz', '100 MHz', '10 MHz', '1000 MHz'],
      'answer': 0,
    },
  ];
}
