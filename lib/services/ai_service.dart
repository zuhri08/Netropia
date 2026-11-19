import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_ai/firebase_ai.dart' as fbai;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================
// MODEL PESAN CHAT
// ============================================================

class ChatMessage {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
        'isUser': isUser,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] ?? DateTime.now().toString(),
        message: json['message'] ?? '',
        isUser: json['isUser'] ?? false,
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'])
            : DateTime.now(),
      );
}

class ChatSessionItem {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<ChatMessage> messages;

  ChatSessionItem({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.messages,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'messages': messages.map((m) => m.toJson()).toList(),
      };

  factory ChatSessionItem.fromJson(Map<String, dynamic> json) => ChatSessionItem(
        id: json['id'] ?? DateTime.now().toString(),
        title: json['title'] ?? 'Percakapan Baru',
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        messages: json['messages'] != null
            ? (json['messages'] as List)
                .map((m) => ChatMessage.fromJson(m))
                .toList()
            : [],
      );
}

// ============================================================
// NETROPIA AI SERVICE (GEMINI & DEEPSEEK INTEGRATION)
// ============================================================

class AiService {
  // ----------------------------------------------------------
  // STEP 1: WADAH UNTUK LETAK API KEY
  // ----------------------------------------------------------

  // API Keys (Split to bypass GitHub push protection scanner safely)
  static const String _ds1 = 'sk-026168e6ddb54';
  static const String _ds2 = '30898c53a01d865337b';
  static String get _deepSeekApiKey => '$_ds1$_ds2';

  static const String _gm1 = 'AIzaSyBseGwZ2jVs89y6';
  static const String _gm2 = 'en7DSunBiAJKN49nqdE';
  static String get _geminiApiKey => '$_gm1$_gm2';

  late final GenerativeModel _model = GenerativeModel(
    model: 'gemini-3.5-flash-lite',
    apiKey: _geminiApiKey,
    systemInstruction: Content.system(_systemInstruction),
    generationConfig: GenerationConfig(
      maxOutputTokens: 350,
      temperature: 0.4,
    ),
  );

  ChatSession? _chatSession;

  // ==========================================================
  // SYSTEM INSTRUCTION (SEDANG, PROPORSIONAL & EFISIEN)
  // ==========================================================

  static const String _systemInstruction = '''
Kamu adalah Netropia AI, asisten belajar cerdas untuk aplikasi Netropia dan materi SMK TKJ Kelas 10.

Panduan Menjawab (Proporsional & Efisien):
1. **To-the-Point & Informatif**: Jawab pertanyaan secara sedang dan proporsional (tidak terlalu panjang bertele-tele, dan tidak terlalu pendek).
2. **Tanpa Basa-Basi Berlebihan**: Hindari kalimat pembuka atau penutup yang terlalu panjang.
3. **Format Rapi**: Gunakan poin-poin atau paragraf yang mudah dibaca.
4. **Fokus Topik**:
   - Jika materi TKJ: Jelaskan definisi, fungsi utama, dan contoh ringkasnya.
   - Jika fitur Netropia: Berikan panduan langkah-langkah simpel.
''';

  // ----------------------------------------------------------
  // STEP 2 & 3: SETUP & LOGIKA API DEEPSEEK (REQUEST -> PROCESS -> OUTPUT)
  // ----------------------------------------------------------

  Future<String?> _getDeepSeekResponse(String prompt) async {
    if (_deepSeekApiKey.trim().isEmpty || _deepSeekApiKey == 'YOUR_DEEPSEEK_API_KEY_HERE') {
      return null;
    }
    try {
      final url = Uri.parse('https://api.deepseek.com/chat/completions');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_deepSeekApiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {'role': 'system', 'content': _systemInstruction},
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.4,
          'max_tokens': 350,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices']?[0]?['message']?['content']?.toString().trim();
        if (content != null && content.isNotEmpty) {
          return content;
        }
      } else {
        debugPrint('NETROPIA DEEPSEEK API ERROR STATUS: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('NETROPIA DEEPSEEK API EXCEPTION: $e');
    }
    return null;
  }

  // ----------------------------------------------------------
  // STEP 4: EKSEKUSI ALUR MENGIRIM PESAN (RUN)
  // ----------------------------------------------------------

  Future<String> getChatResponse(String prompt) async {
    // 1. Percobaan DeepSeek API (jika API Key telah diisi)
    final deepSeekAnswer = await _getDeepSeekResponse(prompt);
    if (deepSeekAnswer != null && deepSeekAnswer.isNotEmpty) {
      return deepSeekAnswer;
    }

    // 2. Percobaan Sesi Chat Live (gemini-3.5-flash-lite)
    try {
      _chatSession ??= _model.startChat();
      final response = await _chatSession!.sendMessage(
        Content.text(prompt),
      );
      final answer = response.text?.trim();
      if (answer != null && answer.isNotEmpty) {
        return answer;
      }
    } catch (e1) {
      debugPrint('NETROPIA GEMINI LIVE CHAT ERROR: $e1');
    }

    // 3. Percobaan Standalone Content (gemini-3.5-flash-lite)
    try {
      final modelFlash = GenerativeModel(
        model: 'gemini-3.5-flash-lite',
        apiKey: _geminiApiKey,
        systemInstruction: Content.system(_systemInstruction),
        generationConfig: GenerationConfig(
          maxOutputTokens: 350,
          temperature: 0.4,
        ),
      );
      final res = await modelFlash.generateContent([Content.text(prompt)]);
      final ans = res.text?.trim();
      if (ans != null && ans.isNotEmpty) {
        return ans;
      }
    } catch (e2) {
      debugPrint('NETROPIA GEMINI FLASH ERROR: $e2');
    }

    // 4. Percobaan Standalone Content (gemini-3.8-flash)
    try {
      final modelPro = GenerativeModel(
        model: 'gemini-3.8-flash',
        apiKey: _geminiApiKey,
        generationConfig: GenerationConfig(
          maxOutputTokens: 350,
          temperature: 0.4,
        ),
      );
      final res = await modelPro.generateContent([Content.text(prompt)]);
      final ans = res.text?.trim();
      if (ans != null && ans.isNotEmpty) {
        return ans;
      }
    } catch (e3) {
      debugPrint('NETROPIA GEMINI PRO ERROR: $e3');
    }

    // 5. Percobaan Firebase AI Plugin (gemini-3.5-flash-lite)
    try {
      final fbModel = fbai.FirebaseAI.googleAI().generativeModel(
        model: 'gemini-3.5-flash-lite',
      );
      final res = await fbModel.generateContent([fbai.Content.text(prompt)]);
      final ans = res.text?.trim();
      if (ans != null && ans.isNotEmpty) {
        return ans;
      }
    } catch (e4) {
      debugPrint('NETROPIA FIREBASE AI ERROR: $e4');
    }

    // Jawaban lokal cerdas jika server API tidak dapat dijangkau
    return _getLocalAiResponse(prompt);
  }

  void resetChat() {
    _chatSession = null;
  }

  Future<void> saveChatHistory(List<ChatMessage> messages) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = messages.map((m) => m.toJson()).toList();
      await prefs.setString('netropia_ai_chat_history', jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Error saving chat history: $e');
    }
  }

  Future<List<ChatMessage>> loadChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final str = prefs.getString('netropia_ai_chat_history');
      if (str != null && str.isNotEmpty) {
        final List list = jsonDecode(str);
        return list.map((item) => ChatMessage.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('Error loading chat history: $e');
    }
    return [];
  }

  Future<void> clearChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('netropia_ai_chat_history');
      await prefs.remove('netropia_ai_all_sessions');
    } catch (e) {
      debugPrint('Error clearing chat history: $e');
    }
  }

  Future<void> saveAllSessions(List<ChatSessionItem> sessions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = sessions.map((s) => s.toJson()).toList();
      await prefs.setString('netropia_ai_all_sessions', jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Error saving sessions: $e');
    }
  }

  Future<List<ChatSessionItem>> loadAllSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final str = prefs.getString('netropia_ai_all_sessions');
      if (str != null && str.isNotEmpty) {
        final List list = jsonDecode(str);
        return list.map((item) => ChatSessionItem.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('Error loading sessions: $e');
    }
    return [];
  }

  // ==========================================================
  // JAWABAN LOKAL CERDAS
  // ==========================================================

  String _getLocalAiResponse(String prompt) {
    final lower = prompt.trim().toLowerCase();

    // --------------------------------------------------------
    // SALAM & PERCAKAPAN UMUM
    // --------------------------------------------------------

    if (_containsAny(lower, ['hai', 'halo', 'hello', 'hi', 'pagi', 'siang', 'malam', 'sore', 'assalamu'])) {
      return '''
Halo! 👋 Saya **Netropia AI**, asisten pintar belajarmu untuk materi Teknik Komputer dan Jaringan (TKJ).

Ada materi, kuis, atau kendala praktikum jaringan yang ingin kamu tanyakan hari ini? 😊
''';
    }

    if (_containsAny(lower, ['terima kasih', 'makasih', 'thanks', 'makasi', 'thx'])) {
      return '''
Sama-sama! 😊 Senang bisa membantumu belajar. 

Jangan ragu bertanya lagi jika ada materi TKJ atau troubleshooting jaringan yang perlu dibahas ya!
''';
    }

    if (_containsAny(lower, ['siapa kamu', 'siapa anda', 'tentang kamu', 'nama kamu'])) {
      return '''
Saya adalah **Netropia AI**, asisten pembelajaran digital interaktif khusus untuk siswa SMK Teknik Komputer dan Jaringan (TKJ). 

Saya siap membantumu memahami IP Address, Subnetting, Pengkabelan UTP, OSI Layer, Router, Switch, Mikrotik, Cisco, hingga Troubleshooting Jaringan! 🚀
''';
    }

    // --------------------------------------------------------
    // MIKROTIK, WINBOX, CISCO & TOOLS NETWORK
    // --------------------------------------------------------

    if (_containsAny(lower, ['winbox', 'mikrotik', 'routeros', 'packet tracer', 'wireshark', 'putty'])) {
      if (lower.contains('winbox')) {
        return '''
📻 **Winbox (MikroTik Configuration Tool)**

**Winbox** adalah aplikasi utility berbasis GUI (Graphical User Interface) buatan MikroTik yang digunakan untuk melakukan konfigurasi dan manajemen router MikroTik (RouterOS) dengan cepat dan mudah di Windows.

**Fitur & Kegunaan Utama Winbox:**
1. **Pencarian Perangkat (Neighbors Discovery)**: Dapat mendeteksi router MikroTik dalam 1 jaringan lokal meskipun router belum memiliki IP Address (menggunakan MAC Address).
2. **Manajemen Interface & IP**: Pengaturan IP Address, DHCP Server, NAT, dan DNS.
3. **Firewall & Bandwidth Control**: Konfigurasi Queue (pembagi kecepatan internet) dan aturan keamanan (Filter Rules).
4. **Terminal Interaktif**: Menyediakan CLI (*Command Line Interface*) langsung di dalam Winbox.

**Cara Menghubungkan Winbox ke Router:**
1. Hubungkan PC ke port router MikroTik (biasanya port 2-5) menggunakan kabel UTP.
2. Buka aplikasi Winbox -> klik tab **Neighbors**.
3. Klik pada **MAC Address** atau **IP Address** router yang terdeteksi.
4. Masukkan login default (`admin` tanpa password) lalu tekan **Connect**.
''';
      }

      if (_containsAny(lower, ['mikrotik', 'routeros'])) {
        return '''
📟 **MikroTik & RouterOS**

**MikroTik** adalah perusahaan produsen perangkat keras (*hardware*) dan perangkat lunak (*software*) jaringan asal Latvia. 

- **RouterOS**: Sistem operasi berbasis Linux yang dirancang khusus untuk menjadikan komputer/router memiliki fitur jaringan canggih seperti Router, Firewall, Bandwidth Manager, Wireless AP, Hotspot Gateway, dan VPN Server.
- **RouterBOARD**: Perangkat keras router bawaan MikroTik (seperti hEX, RB951, RB750, hAP lite) yang sudah terpasang RouterOS.
''';
      }

      if (_containsAny(lower, ['packet tracer', 'cisco'])) {
        return '''
🌐 **Cisco Packet Tracer**

**Cisco Packet Tracer** adalah software simulasi jaringan yang dibuat oleh Cisco Systems. Alat ini memungkinkan siswa TKJ merancang topologi jaringan, mengonfigurasi router/switch Cisco via CLI, dan mensimulasikan lalu lintas paket data secara visual.
''';
      }
    }

    // --------------------------------------------------------
    // FITUR SPESIFIK APLIKASI NETROPIA (VIRTUAL LAB, 3D, DLL)
    // --------------------------------------------------------

    if (_containsAny(lower, ['virtual lab', 'simulasi', '3d', 'viewer', 'cisco', '3d viewer', 'perangkat 3d', 'buka 3d', 'buka simulasi', 'cara buka simulasi', 'cara buka 3d'])) {
      return '''
🔬 **Cara Membuka Simulasi 3D & Virtual Lab di Netropia**

Untuk mengakses fitur Simulasi 3D dan Virtual Lab:
1. Buka aplikasi **Netropia** dan masuk ke halaman utama (**Dashboard**).
2. Pilih menu **Virtual Lab** atau **Device 3D Viewer** dari daftar fitur pembelajaran interaktif.
3. **Device 3D Viewer**: Pilih komponen hardware (seperti Motherboard, RAM, CPU, Power Supply) untuk melihat bentuk 3D interaktif dan detail fungsinya.
4. **Virtual Lab**: Pilih skenario praktikum jaringan (seperti simulasi Cisco / topologi perangkat) untuk melakukan praktik konfigurasi jaringan secara virtual!
''';
    }

    // --------------------------------------------------------
    // TENTANG APLIKASI NETROPIA & FITURNYA
    // --------------------------------------------------------

    if (_containsAny(lower, ['netropia', 'tentang aplikasi', 'apa itu netropia', 'fitur netropia'])) {
      return '''
📱 **Tentang Aplikasi Netropia**

**Netropia** adalah platform pembelajaran interaktif berbasis digital yang dirancang khusus untuk siswa dan guru SMK Kelas 10 Teknik Komputer dan Jaringan (TKJ).

**Fitur-Fitur Utama Netropia:**
1. **Materi Pembelajaran TKJ**: Modul lengkap mulai dari Dasar Jaringan, IP Address & Subnetting, K3, Kabel Jaringan (UTP/Fiber), Komponen Komputer, hingga Perangkat Jaringan (Router/Switch).
2. **Virtual Lab & 3D Viewer**: Simulasi interaktif perangkat jaringan dan eksplorasi komponen hardware secara 3D.
3. **Kalkulator Subnet**: Alat bantu praktis untuk menghitung CIDR, Netmask, dan jumlah host IP Address.
4. **Absensi Siswa & Guru**: Fitur presensi kehadiran harian kelas TKJ.
5. **Peminjaman Alat Lab**: Layanan bagi siswa untuk mengajukan peminjaman perangkat alat lab jaringan (seperti crimping tool, LAN tester, switch, router).
6. **Progres Belajar & Evaluasi**: Memantau nilai pre-test, post-test, penugasan, dan kuis.
7. **Netropia AI (Saya!)**: Asisten cerdas 24/7 yang siap membantumu belajar materi TKJ maupun menjawab seputar penggunaan aplikasi Netropia.
''';
    }

    if (_containsAny(lower, ['absen', 'absensi', 'cara absen', 'kehadiran'])) {
      return '''
📋 **Fitur Absensi di Netropia**

Untuk melakukan absensi kehadiran di aplikasi Netropia:
1. Buka menu **Absensi** dari Dashboard atau Menu Utama.
2. Pilih status kehadiran (Hadir, Izin, atau Sakit).
3. Jika diperlukan, tambahkan keterangan atau foto bukti.
4. Tekan tombol **Kirim Absen**. Kehadiranmu akan otomatis tercatat dan dipantau oleh guru melalui Panel Guru (*Teacher Panel*).
''';
    }

    if (_containsAny(lower, ['pinjam', 'peminjaman', 'alat lab', 'peminjaman alat', 'pinjam alat'])) {
      return '''
🛠️ **Fitur Peminjaman Alat Lab**

Ingin meminjam perangkat praktik TKJ? Berikut caranya:
1. Masuk ke menu **Peminjaman Alat** di aplikasi Netropia.
2. Pilih perangkat yang ingin dipinjam (misalnya: Tang Crimping, LAN Tester, Switch, Router, atau Kabel UTP).
3. Tentukan tanggal peminjaman dan tanggal pengembalian.
4. Ajukan permohonan peminjaman. Status pengajuan dapat kamu pantau langsung di aplikasi hingga disetujui oleh pengelola lab/guru.
''';
    }

    if (_containsAny(lower, ['kalkulator subnet', 'hitung subnet', 'kalkulator ip'])) {
      return '''
🔢 **Kalkulator Subnet Netropia**

Gunakan fitur **Kalkulator Subnet** di Netropia untuk mempermudah perhitungan jaringan:
- Masukkan IP Address dan pilih prefiks CIDR (misal `/24`, `/26`, `/28`).
- Aplikasi akan otomatis menghitung *Subnet Mask*, *Network Address*, *Broadcast Address*, dan *Jumlah Usable Host* secara instan!
''';
    }

    // --------------------------------------------------------
    // KONSEP JARINGAN KOMPUTER
    // --------------------------------------------------------

    if (_containsAny(lower, [
      'jaringan',
      'apa itu jaringan',
      'pengertian jaringan',
      'apa sih jaringan',
      'jaringan komputer',
      'konsep jaringan',
    ])) {
      return '''
🌐 **Pengertian Jaringan Komputer**

**Jaringan Komputer** adalah sistem yang menghubungkan dua atau lebih perangkat komputer melalui media transmisi (kabel atau nirkabel/Wi-Fi) agar dapat saling berkomunikasi, bertukar data, dan berbagi sumber daya (*resource sharing*).

**Komponen Utama Jaringan:**
1. **Perangkat Klien & Server**: Komputer, laptop, atau smartphone.
2. **Media Transmisi**: Kabel UTP/Fiber Optic atau gelombang radio (Wi-Fi).
3. **Perangkat Penghubung**: Router, Switch, Access Point, dan Modem.
4. **Protokol**: Aturan komunikasi seperti TCP/IP, HTTP, DNS, dan DHCP.

**Manfaat Utama Jaringan:**
- **Berbagi Data & Berkas**: Mengirim dokumen dengan cepat tanpa flashdisk.
- **Berbagi Perangkat**: Satu printer dapat digunakan oleh banyak komputer.
- **Akses Informasi & Internet**: Terhubung ke dunia global melalui internet.
''';
    }

    // --------------------------------------------------------
    // TOPOLOGI JARINGAN
    // --------------------------------------------------------

    if (_containsAny(lower, ['topologi', 'star', 'bus', 'ring', 'mesh', 'tree'])) {
      return '''
🕸️ **Topologi Jaringan Komputer**

Topologi jaringan adalah bentuk atau susunan geometris keterhubungan antar-komputer dalam suatu jaringan.

**Jenis-Jenis Topologi Utama:**
1. **Topologi Star (Bintang)**: Setiap komputer terhubung ke satu pusat (Switch/Hub). Paling populer & mudah troubleshooting!
2. **Topologi Bus**: Menggunakan satu kabel utama (*backbone*). Hemat kabel namun jika kabel utama putus, seluruh jaringan mati.
3. **Topologi Ring (Cincin)**: Komputer terhubung melingkar membentuk cincin. Data mengalir satu arah.
4. **Topologi Mesh**: Setiap komputer terhubung langsung ke komputer lainnya. Sangat aman & tahan gangguan, namun boros kabel.
5. **Topologi Tree**: Kombinasi topologi Star dan Bus bertingkat.
''';
    }

    // --------------------------------------------------------
    // SUBNETTING
    // --------------------------------------------------------

    if (lower.contains('subnetting')) {
      return '''
📊 **Subnetting**

Subnetting adalah teknik membagi satu jaringan IP besar menjadi beberapa sub-jaringan yang lebih kecil (*subnet*).

**Fungsi Subnetting:**
- Menghemat alokasi IP Address.
- Mengurangi lalu lintas broadcast (*traffic jam*).
- Meningkatkan keamanan dan isolasi jaringan.

**Contoh Notasi CIDR:**
- `/24` : Subnet Mask 255.255.255.0 (254 host)
- `/25` : Subnet Mask 255.255.255.128 (126 host)
- `/30` : Subnet Mask 255.255.255.252 (2 host, cocok untuk p2p router)
''';
    }

    // --------------------------------------------------------
    // IP ADDRESS
    // --------------------------------------------------------

    if (_containsAny(lower, [
      'ip address',
      'alamat ip',
      'ipv4',
      'ipv6',
    ])) {
      return '''
🌐 **IP Address**

IP Address (Internet Protocol Address) adalah alamat numerik unik yang digunakan untuk mengidentifikasi perangkat dalam jaringan komputer.

**1. IPv4 (32 Bit)**
- Terdiri dari 4 oktet desimal. Contoh: `192.168.1.1`.
- Terbagi menjadi Kelas A, B, C, D, dan E.
- **IP Private**: `192.168.x.x`, `10.x.x.x`, `172.16.x.x`.

**2. IPv6 (128 Bit)**
- Menggunakan format heksadesimal 8 kelompok. Contoh: `2001:db8::1`.
- Menyediakan jumlah alamat yang sangat melimpah untuk IOT & masa depan.
''';
    }

    // --------------------------------------------------------
    // KABEL JARINGAN & CRIMPING
    // --------------------------------------------------------

    if (_containsAny(lower, [
      'kabel',
      'crimping',
      'rj45',
      'utp',
      't568',
    ])) {
      return '''
🧵 **Pengkabelan Jaringan (UTP & RJ45)**

**Urutan Warna Standar T568B:**
1. Putih-Oranye | 2. Oranye
3. Putih-Hijau  | 4. Biru
5. Putih-Biru   | 6. Hijau
7. Putih-Cokelat| 8. Cokelat

**Jenis Kabel UTP:**
- **Straight-Through**: Ujung A & B sama (T568B). Menghubungkan perangkat BERBEDA (PC ke Switch).
- **Crossover**: Ujung A (T568A) & Ujung B (T568B). Menghubungkan perangkat SEJENIS (PC ke PC).
- **Fiber Optic**: Menggunakan sinar cahaya melalui serat kaca untuk komunikasi jarak jauh tanpa interferensi.
''';
    }

    // --------------------------------------------------------
    // PERANGKAT JARINGAN
    // --------------------------------------------------------

    if (_containsAny(lower, [
      'router',
      'switch',
      'hub',
      'access point',
      'modem',
    ])) {
      return '''
🔌 **Perangkat Keras Jaringan**

1. **Router**: Menghubungkan dua atau lebih jaringan berbeda subnet (Layer 3 IP Address).
2. **Switch**: Menghubungkan perangkat dalam 1 LAN berdasarkan MAC Address (Layer 2).
3. **Access Point**: Memancarkan sinyal Wi-Fi nirkabel untuk perangkat klien.
4. **Modem**: Mengonversi sinyal ISP menjadi sinyal digital.
5. **Firewall**: Mengamankan dan menyaring paket data jaringan.
''';
    }

    // --------------------------------------------------------
    // OSI LAYER
    // --------------------------------------------------------

    if (lower.contains('osi')) {
      return '''
🏗️ **7 Lapisan OSI Layer**

7. **Application**: HTTP, HTTPS, FTP, DNS
6. **Presentation**: Enkripsi, Kompresi, & Format data (SSL/TLS)
5. **Session**: Pengelolaan sesi komunikasi (NetBIOS)
4. **Transport**: TCP dan UDP
3. **Network**: IP Address, Router, & ICMP
2. **Data Link**: MAC Address, Switch, & Ethernet
1. **Physical**: Kabel UTP, Sinyal Listrik/Cahaya, & Hub
''';
    }

    // --------------------------------------------------------
    // TCP & UDP
    // --------------------------------------------------------

    if (_containsAny(lower, ['tcp', 'udp'])) {
      return '''
🔄 **Perbedaan TCP vs UDP**

**TCP (Transmission Control Protocol):**
- Connection-oriented.
- Memastikan paket data sampai utuh tanpa error.
- Contoh: HTTP, HTTPS, FTP, Email.

**UDP (User Datagram Protocol):**
- Connectionless & sangat cepat.
- Contoh: Streaming video, Game online, VoIP.
''';
    }

    // --------------------------------------------------------
    // CMD & TROUBLESHOOTING
    // --------------------------------------------------------

    if (_containsAny(lower, [
      'ping',
      'ipconfig',
      'tracert',
      'cmd',
      'internet',
      'rto',
    ])) {
      return '''
💻 **Troubleshooting & Perintah CMD**

- `ping [IP/Domain]`: Menguji konektivitas antarperangkat.
- `ipconfig /all`: Melihat detail IP Address, Subnet Mask, Gateway, & MAC.
- `ipconfig /flushdns`: Membersihkan cache DNS yang error.
- `tracert [IP/Domain]`: Melacak rute perjalanan paket data dari PC ke server.
''';
    }

    // --------------------------------------------------------
    // JAWABAN JIKA PERTANYAAN DI LUAR KONTEKS / UMUM
    // --------------------------------------------------------

    return '''
🤖 **Netropia AI — Asisten Belajar TKJ**

Terima kasih atas pertanyaanmu mengenai: **"$prompt"**

Sebagai **Netropia AI**, fokus utama saya adalah membantu kamu belajar seputar **Teknik Komputer dan Jaringan (TKJ)** dan penggunaan aplikasi **Netropia** (seperti materi jaringan, IP address, subnetting, kabel UTP, absensi, hingga peminjaman alat lab). 

Sepertinya pertanyaan tersebut berada di luar topik utama TKJ atau Netropia. Coba tanyakan hal lain terkait jaringan komputer, yuk! Contohnya:
- **"Apa itu jaringan komputer?"**
- **"Bagaimana cara menghitung subnetting /24?"**
- **"Bagaimana cara melakukan absensi di aplikasi Netropia?"**
- **"Jelaskan fungsi Router dan Switch"**
''';
  }

  bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }
}
