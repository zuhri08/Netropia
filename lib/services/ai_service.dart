import 'package:firebase_ai/firebase_ai.dart' as fbai;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';

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
}

// ============================================================
// NETROPIA AI SERVICE
// ============================================================

class AiService {
  // Google Gemini API Key dari Project 641151113525
  static const String _apiKey = 'AQ.Ab8RN6Kkl4tanMPv4Q2-r1Ss2Bjd4tmZkxFmUDsmIXbvKS5psw';

  late final GenerativeModel _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: _apiKey,
    systemInstruction: Content.system(_systemInstruction),
  );

  ChatSession? _chatSession;

  // ==========================================================
  // SYSTEM INSTRUCTION
  // ==========================================================

  static const String _systemInstruction = '''
Kamu adalah Netropia AI, asisten belajar yang ramah dan cerdas untuk siswa SMK kelas 10 Teknik Komputer dan Jaringan (TKJ).
Kamu dapat menjawab pertanyaan umum dan membantu siswa belajar TKJ secara mendalam.

Panduan menjawab:
1. Gunakan bahasa Indonesia yang mudah dipahami, ramah, dan solutif.
2. Jelaskan konsep materi secara bertahap dan rinci.
3. Untuk pertanyaan seperti "apa itu jaringan", jelaskan definisi, komponen utama, dan kegunaannya dalam kehidupan sehari-hari.
4. Berikan contoh konkret dan langkah penyelesaian.
''';

  // ==========================================================
  // MENGIRIM PESAN KE GEMINI LIVE
  // ==========================================================

  Future<String> getChatResponse(String prompt) async {
    // 1. Percobaan Sesi Chat Live (gemini-1.5-flash)
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

    // 2. Percobaan Standalone Content (gemini-1.5-flash-latest)
    try {
      final modelFlash = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: _apiKey,
        systemInstruction: Content.system(_systemInstruction),
      );
      final res = await modelFlash.generateContent([Content.text(prompt)]);
      final ans = res.text?.trim();
      if (ans != null && ans.isNotEmpty) {
        return ans;
      }
    } catch (e2) {
      debugPrint('NETROPIA GEMINI FLASH LATEST ERROR: $e2');
    }

    // 3. Percobaan Standalone Content (gemini-pro)
    try {
      final modelPro = GenerativeModel(
        model: 'gemini-pro',
        apiKey: _apiKey,
      );
      final res = await modelPro.generateContent([Content.text(prompt)]);
      final ans = res.text?.trim();
      if (ans != null && ans.isNotEmpty) {
        return ans;
      }
    } catch (e3) {
      debugPrint('NETROPIA GEMINI PRO ERROR: $e3');
    }

    // 4. Percobaan Firebase AI Plugin
    try {
      final fbModel = fbai.FirebaseAI.googleAI().generativeModel(
        model: 'gemini-1.5-flash',
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
    // JAWABAN UMUM MATERI TKJ
    // --------------------------------------------------------

    return '''
🤖 **Netropia AI — Asisten Belajar TKJ**

Saya memahami pertanyaanmu tentang: **"$prompt"**

Jaringan komputer adalah sistem yang menghubungkan dua atau lebih perangkat komputer agar dapat saling berkomunikasi, bertukar berkas, dan berbagi sumber daya (*resource sharing*).

Kamu dapat menanyakan topik spesifik seperti:
- **"Apa itu jaringan komputer?"**
- **"Jelaskan subnetting /24"**
- **"Urutan warna kabel UTP T568B"**
- **"Perbedaan Router dan Switch"**
- **"Apa fungsi 7 OSI Layer?"**
''';
  }

  bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }
}
