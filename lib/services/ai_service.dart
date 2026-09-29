import 'package:firebase_ai/firebase_ai.dart';
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
  // Konfigurasi model Gemini
  late final GenerativeModel _model =
  FirebaseAI.googleAI().generativeModel(
    model: 'gemini-3.5-flash-lite',
    systemInstruction: Content.system(_systemInstruction),
  );

  ChatSession? _chatSession;

  // Pengaturan percobaan ulang
  static const int _maxAttempts = 3;

  // ==========================================================
  // SYSTEM INSTRUCTION
  // ==========================================================

  static const String _systemInstruction = '''
Kamu adalah Netropia AI, asisten belajar yang ramah untuk siswa SMK kelas 10.
Kamu dapat menjawab pertanyaan umum dan membantu siswa belajar TKJ.

Panduan menjawab:
1. Gunakan bahasa Indonesia yang mudah dipahami.
2. Jelaskan materi secara bertahap, mulai dari konsep dasar.
3. Untuk praktik jaringan, bantu siswa menganalisis gejala, kemungkinan penyebab,
   cara pemeriksaan, dan langkah perbaikan.
4. Berikan contoh dan langkah penyelesaian, bukan hanya jawaban akhir.
5. Jika pertanyaan kurang jelas, tanyakan informasi yang diperlukan.
6. Jika tidak yakin, sampaikan ketidakpastian dan jangan mengarang.
7. Untuk topik di luar TKJ, tetap jawab dengan wajar dan informatif.
8. Jangan meminta atau membagikan kata sandi, API key, atau data pribadi siswa.
9. Gunakan format poin atau tahapan jika membuat penjelasan lebih mudah dibaca.
''';

  // ==========================================================
  // MENGIRIM PESAN KE GEMINI
  // ==========================================================

  Future<String> getChatResponse(String prompt) async {
    for (int attempt = 1; attempt <= _maxAttempts; attempt++) {
      try {
        // Memulai sesi jika belum tersedia.
        _chatSession ??= _model.startChat();

        final response = await _chatSession!.sendMessage(
          Content.text(prompt),
        );

        final answer = response.text?.trim();

        if (answer != null && answer.isNotEmpty) {
          return answer;
        }

        return 'Maaf, AI belum menghasilkan jawaban. '
            'Coba tuliskan pertanyaan dengan lebih spesifik.';
      } catch (error, stackTrace) {
        debugPrint(
          'NETROPIA AI ERROR (percobaan $attempt): $error',
        );

        // Mencoba kembali jika masih ada kesempatan.
        if (attempt < _maxAttempts) {
          final delaySeconds = attempt * 2;

          debugPrint(
            'Mencoba kembali dalam $delaySeconds detik...',
          );

          await Future.delayed(
            Duration(seconds: delaySeconds),
          );

          continue;
        }

        debugPrint('STACK TRACE: $stackTrace');

        // Menggunakan jawaban lokal jika semua percobaan gagal.
        return _getFallbackResponse(prompt);
      }
    }

    return _getFallbackResponse(prompt);
  }

  // ==========================================================
  // RESET PERCAKAPAN
  // ==========================================================

  void resetChat() {
    _chatSession = null;
  }

  // ==========================================================
  // FALLBACK RESPONSE
  // ==========================================================

  String _getFallbackResponse(String prompt) {
    final localResponse = _getLocalAiResponse(prompt);

    return 'Netropia AI sedang mengalami gangguan pada layanan AI. '
        'Berikut bantuan dari materi lokal Netropia:\n\n'
        '$localResponse';
  }

  // ==========================================================
  // JAWABAN LOKAL BERDASARKAN MATERI TKJ
  // ==========================================================

  String _getLocalAiResponse(String prompt) {
    final lower = prompt.toLowerCase();

    // --------------------------------------------------------
    // 1. SUBNETTING
    // --------------------------------------------------------

    if (lower.contains('subnetting')) {
      return '''
📊 **Subnetting**

Subnetting adalah teknik membagi satu jaringan IP besar menjadi beberapa sub-jaringan yang lebih kecil.

**Fungsi subnetting:**
- Menghemat alokasi IP Address.
- Mengurangi lalu lintas broadcast.
- Meningkatkan keamanan dan isolasi jaringan.

**Contoh notasi CIDR:**
- `/24` : 255.255.255.0 (254 host)
- `/25` : 255.255.255.128 (126 host)
- `/30` : 255.255.255.252 (2 host)
''';
    }

    // --------------------------------------------------------
    // 2. IP ADDRESS
    // --------------------------------------------------------

    if (_containsAny(lower, [
      'ip address',
      'alamat ip',
      'ipv4',
      'ipv6',
    ])) {
      return '''
🌐 **IP Address**

IP Address adalah alamat numerik yang digunakan untuk mengidentifikasi perangkat dalam jaringan komputer.

**1. IPv4**
- Memiliki panjang 32 bit.
- Terdiri dari 4 oktet.
- Contoh: `192.168.1.1`.

**2. IPv6**
- Memiliki panjang 128 bit.
- Menggunakan format heksadesimal.
- Contoh: `fe80::1`.
''';
    }

    // --------------------------------------------------------
    // 3. KABEL JARINGAN
    // --------------------------------------------------------

    if (_containsAny(lower, [
      'kabel',
      'crimping',
      'rj45',
      'utp',
      't568',
    ])) {
      return '''
🧵 **Pengkabelan Jaringan**

**Urutan warna standar T568B:**

1. Putih-Oranye
2. Oranye
3. Putih-Hijau
4. Biru
5. Putih-Biru
6. Hijau
7. Putih-Cokelat
8. Cokelat

**Jenis kabel:**

- **Straight-Through:** kedua ujung menggunakan standar yang sama, umumnya untuk menghubungkan perangkat berbeda.
- **Crossover:** kedua ujung menggunakan standar berbeda, yaitu T568A dan T568B.
- **Fiber Optic:** menggunakan cahaya untuk mengirimkan data melalui serat optik.
''';
    }

    // --------------------------------------------------------
    // 4. PERANGKAT JARINGAN
    // --------------------------------------------------------

    if (_containsAny(lower, [
      'router',
      'switch',
      'hub',
      'access point',
      'modem',
    ])) {
      return '''
🔌 **Perangkat Jaringan**

1. **Router:** menghubungkan jaringan yang berbeda.
2. **Switch:** menghubungkan perangkat dalam jaringan LAN menggunakan MAC Address.
3. **Access Point:** menyediakan koneksi jaringan nirkabel.
4. **Modem:** menghubungkan jaringan pengguna dengan layanan penyedia internet.
5. **Firewall:** menyaring lalu lintas jaringan berdasarkan aturan keamanan.
''';
    }

    // --------------------------------------------------------
    // 5. OSI LAYER
    // --------------------------------------------------------

    if (lower.contains('osi')) {
      return '''
🏗️ **7 Lapisan OSI**

7. Application — HTTP, HTTPS, FTP
6. Presentation — Enkripsi dan format data
5. Session — Pengelolaan sesi komunikasi
4. Transport — TCP dan UDP
3. Network — IP Address dan Router
2. Data Link — MAC Address dan Switch
1. Physical — Kabel dan sinyal
''';
    }

    // --------------------------------------------------------
    // 6. TCP DAN UDP
    // --------------------------------------------------------

    if (_containsAny(lower, ['tcp', 'udp'])) {
      return '''
🔄 **Perbedaan TCP dan UDP**

**TCP (Transmission Control Protocol):**
- Berorientasi koneksi.
- Memastikan data diterima secara berurutan dan dapat mengirim ulang data yang hilang.
- Contoh penggunaan: HTTP, HTTPS, dan FTP.

**UDP (User Datagram Protocol):**
- Tidak memerlukan koneksi terlebih dahulu.
- Tidak menjamin pengiriman ulang paket.
- Contoh penggunaan: streaming, VoIP, dan game online.
''';
    }

    // --------------------------------------------------------
    // 7. DNS, DHCP, DAN NAT
    // --------------------------------------------------------

    if (_containsAny(lower, ['dns', 'dhcp', 'nat'])) {
      return '''
🛠️ **Layanan Jaringan**

- **DNS:** menerjemahkan nama domain menjadi IP Address.
- **DHCP:** memberikan konfigurasi IP secara otomatis kepada perangkat klien.
- **NAT:** menerjemahkan alamat IP agar perangkat dalam jaringan dapat berkomunikasi dengan jaringan lain.
''';
    }

    // --------------------------------------------------------
    // 8. PERINTAH CMD
    // --------------------------------------------------------

    if (_containsAny(lower, [
      'ping',
      'ipconfig',
      'tracert',
      'cmd',
    ])) {
      return '''
💻 **Perintah CMD untuk TKJ**

- `ping [IP/Domain]` — menguji konektivitas.
- `ipconfig` — melihat konfigurasi IP.
- `ipconfig /all` — melihat informasi jaringan secara lengkap.
- `ipconfig /flushdns` — membersihkan cache DNS.
- `tracert [IP/Domain]` — melacak rute menuju tujuan.
''';
    }

    // --------------------------------------------------------
    // 9. TROUBLESHOOTING INTERNET
    // --------------------------------------------------------

    if (_containsAny(lower, [
      'internet',
      'tidak bisa',
      'troubleshoot',
      'request time out',
      'rto',
    ])) {
      return '''
🔧 **Troubleshooting Internet**

Jika komputer tidak dapat terhubung ke internet, lakukan pemeriksaan berikut:

1. Periksa kabel LAN atau koneksi Wi-Fi.
2. Jalankan `ipconfig` untuk melihat konfigurasi IP.
3. Pastikan komputer memiliki Default Gateway.
4. Jalankan `ping [IP_Gateway]` untuk menguji koneksi ke router.
5. Jalankan `ping 8.8.8.8` untuk menguji koneksi ke alamat IP publik.
6. Jalankan `ping google.com` untuk menguji resolusi DNS.
''';
    }

    // --------------------------------------------------------
    // 10. HARDWARE KOMPUTER
    // --------------------------------------------------------

    if (_containsAny(lower, [
      'ram',
      'cpu',
      'processor',
      'motherboard',
      'ssd',
      'psu',
    ])) {
      return '''
🖥️ **Komponen Hardware Komputer**

- **CPU:** memproses instruksi dan data.
- **RAM:** menyimpan data sementara saat komputer bekerja.
- **SSD:** menyimpan data secara permanen.
- **Motherboard:** menghubungkan komponen utama komputer.
- **PSU:** menyuplai daya listrik ke komponen komputer.
''';
    }

    // --------------------------------------------------------
    // 11. MIKROTIK DAN CISCO
    // --------------------------------------------------------

    if (_containsAny(lower, [
      'mikrotik',
      'winbox',
      'cisco',
    ])) {
      return '''
🚀 **MikroTik dan Cisco**

**MikroTik:**
- Menggunakan RouterOS.
- Dapat dikonfigurasi melalui Winbox atau terminal.
- Digunakan untuk routing, firewall, hotspot, dan manajemen bandwidth.

**Cisco:**
- Banyak digunakan pada jaringan skala perusahaan.
- Perangkatnya dapat dikonfigurasi melalui Cisco IOS.
- Menggunakan CLI untuk konfigurasi router dan switch.
''';
    }

    // --------------------------------------------------------
    // 12. SOAL DAN KUIS
    // --------------------------------------------------------

    if (_containsAny(lower, [
      'soal',
      'kuis',
      'latihan',
    ])) {
      return '''
📝 **Latihan Soal TKJ**

1. Berapakah jumlah host maksimal pada subnet `/26`?
2. Apa warna kabel pada pin ke-3 standar T568B?
3. Perangkat jaringan apakah yang bekerja pada Layer 3 OSI?

Cobalah jawab terlebih dahulu, kemudian kirimkan jawabanmu untuk dibahas.
''';
    }

    // --------------------------------------------------------
    // 13. JAWABAN UMUM
    // --------------------------------------------------------

    return '''
🤖 **Netropia AI — Asisten Belajar TKJ**

Saya memahami pertanyaanmu tentang:

**"$prompt"**

Layanan AI sedang tidak tersedia, sehingga saya belum dapat memberikan penjelasan khusus untuk pertanyaan tersebut.

Kamu dapat mencoba menanyakan topik yang lebih spesifik, seperti:

- Jelaskan subnetting `/24`.
- Bagaimana cara melakukan crimping kabel UTP?
- Apa penyebab Request Time Out?
- Apa fungsi router dan switch?
- Bagaimana cara melakukan troubleshooting jaringan?
''';
  }

  // ==========================================================
  // FUNGSI PEMBANTU
  // ==========================================================

  bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }
}