import 'dart:async';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class AiService {
  static const String _apiKeyPref = 'gemini_api_key';

  Future<String?> getStoredApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyPref);
  }

  Future<void> saveApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyPref, apiKey.trim());
  }

  Future<void> removeApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_apiKeyPref);
  }

  Future<String> getChatResponse(String prompt) async {
    final apiKey = await getStoredApiKey();

    if (apiKey != null && apiKey.trim().isNotEmpty) {
      try {
        final model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey.trim(),
          systemInstruction: Content.system(
            'Kamu adalah Netropia AI, asisten pintar dan ramah khusus siswa SMK jurusan Teknik Komputer dan Jaringan (TKJ). '
            'Tugasmu adalah memberikan penjelasan yang jelas, mudah dipahami, akurat, dan terstruktur mengenai materi TKJ (Jaringan Komputer, Hardware, Sistem Operasi, Subnetting, Mikrotik, Cisco, Kabel UTP/Fiber, K3LH, dan Troubleshooting). '
            'Gunakan bahasa Indonesia yang ramah, suportif, dan gunakan format poin-poin jika menjelaskan langkah-langkah.',
          ),
        );

        final content = [Content.text(prompt)];
        final response = await model.generateContent(content);

        if (response.text != null && response.text!.trim().isNotEmpty) {
          return response.text!.trim();
        }
      } catch (e) {
        // Log error and provide fallback notice if online mode failed
        final localResponse = _getLocalAiResponse(prompt);
        return '⚠️ **Kendala Mode Online (Gemini AI):**\n_${e.toString().replaceAll("Exception: ", "")}_\n\n---\n\n'
            '🔄 **Jawaban dari Engine Lokal TKJ:**\n\n$localResponse';
      }
    }

    // Local TKJ Engine Fallback
    await Future.delayed(const Duration(milliseconds: 600));
    return _getLocalAiResponse(prompt);
  }

  String _getLocalAiResponse(String prompt) {
    final String lower = prompt.toLowerCase();

    // 1. SUBNETTING & IP ADDRESS
    if (lower.contains('subnetting')) {
      return '📊 **Subnetting** adalah teknik membagi satu jaringan IP besar menjadi beberapa sub-jaringan yang lebih kecil (subnet).\n\n'
          '**Fungsi Utama Subnetting:**\n'
          '• Menghemat alokasi IP Address\n'
          '• Mengurangi lalu lintas broadcast (traffic jam) pada jaringan\n'
          '• Meningkatkan keamanan dan isolasi antar divisi/ruangan\n\n'
          '**Contoh Notasi CIDR:**\n'
          '• **/24**: 255.255.255.0 (254 host)\n'
          '• **/25**: 255.255.255.128 (126 host)\n'
          '• **/30**: 255.255.255.252 (2 host, cocok untuk p2p router)';
    }

    if (lower.contains('ip address') || lower.contains('alamat ip') || lower.contains('ipv4') || lower.contains('ipv6')) {
      return '🌐 **IP Address (Internet Protocol Address)** adalah alamat identitas numerik perangkat dalam jaringan komputer.\n\n'
          '**1. IPv4 (32 bit):**\n'
          '• Terdiri dari 4 oktet, contoh: `192.168.1.1`\n'
          '• Kelas A (1-126), Kelas B (128-191), Kelas C (192-223)\n'
          '• IP Private (Lokal): `192.168.x.x`, `10.x.x.x`, `172.16.x.x`\n\n'
          '**2. IPv6 (128 bit):**\n'
          '• Menggunakan format heksadesimal 8 kelompok, contoh: `fe80::1`';
    }

    // 2. KABEL & CRIMPING
    if (lower.contains('kabel') || lower.contains('crimping') || lower.contains('rj45') || lower.contains('utp') || lower.contains('t568')) {
      return '🧵 **Pengkabelan Jaringan (UTP & RJ45)**\n\n'
          '**Urutan Warna Standar T568B:**\n'
          '1. Putih-Oranye | 2. Oranye\n'
          '3. Putih-Hijau  | 4. Biru\n'
          '5. Putih-Biru   | 6. Hijau\n'
          '7. Putih-Cokelat| 8. Cokelat\n\n'
          '**Tipe Kabel:**\n'
          '• **Straight-Through**: Ujung A (T568B) & Ujung B (T568B) -> Menghubungkan perangkat BERBEDA (PC ke Switch)\n'
          '• **Crossover**: Ujung A (T568A) & Ujung B (T568B) -> Menghubungkan perangkat SEJENIS (PC ke PC)\n'
          '• **Fiber Optic**: Menggunakan serat kaca & sinyal cahaya untuk jarak jauh tanpa interferensi.';
    }

    // 3. PERANGKAT JARINGAN
    if (lower.contains('router') || lower.contains('switch') || lower.contains('hub') || lower.contains('access point') || lower.contains('modem')) {
      return '🔌 **Perangkat Utama Jaringan Komputer:**\n\n'
          '1. **Router**: Menghubungkan 2 atau lebih jaringan beda subnet (Layer 3 IP Address).\n'
          '2. **Switch**: Menghubungkan perangkat dalam 1 LAN berbasis MAC Address (Layer 2).\n'
          '3. **Access Point**: Memancarkan sinyal nirkabel (Wi-Fi) ke perangkat klien.\n'
          '4. **Modem**: Mengonversi sinyal analog ISP menjadi sinyal digital.\n'
          '5. **Firewall**: Mengamankan dan menyaring paket data jaringan.';
    }

    // 4. OSI LAYER & PROTOKOL
    if (lower.contains('osi layer') || lower.contains('osi')) {
      return '🏗️ **7 Lapisan OSI Layer:**\n\n'
          '7. **Application** (HTTP, HTTPS, FTP, DNS)\n'
          '6. **Presentation** (SSL, TLS, Enkripsi)\n'
          '5. **Session** (NetBIOS, PPTP)\n'
          '4. **Transport** (TCP, UDP)\n'
          '3. **Network** (IP Address, Router, ICMP)\n'
          '2. **Data Link** (MAC Address, Switch, Ethernet)\n'
          '1. **Physical** (Kabel UTP, Sinyal Listrik/Cahaya, Hub)';
    }

    if (lower.contains('tcp') || lower.contains('udp')) {
      return '🔄 **Perbedaan TCP vs UDP:**\n\n'
          '• **TCP (Transmission Control Protocol):** Connection-oriented, menjamin data sampai tanpa error. Cocok untuk Web (HTTP), Email (SMTP), File (FTP).\n'
          '• **UDP (User Datagram Protocol):** Connectionless, sangat cepat namun tidak menjamin paket ulang. Cocok untuk Video Streaming, Gaming Online, VoIP.';
    }

    if (lower.contains('dns') || lower.contains('dhcp') || lower.contains('nat')) {
      return '🛠️ **Layanan Jaringan Penting:**\n\n'
          '• **DNS (Domain Name System)**: Menerjemahkan nama domain (`google.com`) menjadi IP Address (`142.250.x.x`).\n'
          '• **DHCP**: Memberikan alamat IP secara otomatis ke komputer klien.\n'
          '• **NAT**: Menerjemahkan IP Private lokal menjadi IP Public agar PC dapat terhubung ke Internet.';
    }

    // 5. TROUBLESHOOTING & COMMANDS
    if (lower.contains('ping') || lower.contains('ipconfig') || lower.contains('tracert') || lower.contains('cmd')) {
      return '💻 **Command Prompt (CMD) Penting untuk TKJ:**\n\n'
          '• `ping [IP/Domain]`: Uji tes konektivitas antarperangkat.\n'
          '• `ipconfig /all`: Melihat detail alamat IP, Subnet, Gateway, & MAC Address PC.\n'
          '• `ipconfig /flushdns`: Membersihkan cache DNS yang error.\n'
          '• `tracert [IP/Domain]`: Melacak rute perjalanan paket data dari PC ke server tujuan.';
    }

    if (lower.contains('internet') || lower.contains('tidak bisa') || lower.contains('troubleshoot') || lower.contains('request time out') || lower.contains('rto')) {
      return '🔧 **Langkah Troubleshooting Internet / RTO:**\n\n'
          '1. **Cek Fisik**: Pastikan kabel LAN klik rapat atau WiFi terhubung.\n'
          '2. **Cek IP**: Ketik `ipconfig` di CMD, pastikan dapat IP & Default Gateway.\n'
          '3. **Ping Gateway**: Ketik `ping [IP_Gateway]` (misal `ping 192.168.1.1`).\n'
          '4. **Ping DNS Public**: Ketik `ping 8.8.8.8` (uji internet).\n'
          '5. **Ping Domain**: Ketik `ping google.com` (uji fungsi DNS).';
    }

    // 6. HARDWARE KOMPUTER
    if (lower.contains('ram') || lower.contains('cpu') || lower.contains('processor') || lower.contains('motherboard') || lower.contains('ssd') || lower.contains('psu')) {
      return '🖥️ **Komponen Komputer (Hardware TKJ):**\n\n'
          '• **CPU (Prosesor)**: Otak pemroses instruksi data sistem.\n'
          '• **RAM**: Memori kerja sementara (Volatile).\n'
          '• **SSD NVMe**: Storage permanen kecepatan tinggi tanpa komponen berputar.\n'
          '• **Motherboard**: Papan sirkuit utama penghubung seluruh komponen.\n'
          '• **PSU**: Penyuplai arus listrik DC berkualitas tinggi ke komponen.';
    }

    // 7. MIKROTIK & CISCO
    if (lower.contains('mikrotik') || lower.contains('winbox') || lower.contains('cisco')) {
      return '🚀 **MikroTik & Cisco Networking:**\n\n'
          '• **MikroTik (RouterOS & Winbox)**: Sangat populer di sekolah & industri untuk manajemen bandwidth (Queue), Hotspot Voucher, Firewall Filter, & NAT.\n'
          '• **Cisco**: Standar industri berskala besar menggunakan Command Line Interface (CLI) IOS (Internetwork Operating System) untuk Switch/Router enterprise.';
    }

    // 8. SOAL / KUIS
    if (lower.contains('soal') || lower.contains('kuis') || lower.contains('latihan')) {
      return '📝 **Latihan Soal TKJ:**\n\n'
          '1. Berapakah jumlah host maksimal pada Subnet Mask `/26`?\n'
          '2. Urutan warna pin ke-3 pada standar kabel UTP T568B adalah?\n'
          '3. Perangkat apakah yang bekerja pada Layer 3 OSI Layer?\n\n'
          '💡 *Cobalah jawab pertanyaan ini, lalu tanyakan jawabanmu ke Netropia AI untuk saya koreksi!*';
    }

    // DYNAMIC INTELLIGENT FALLBACK
    return '🤖 **Netropia AI (Asisten Belajar TKJ)**\n\n'
        'Saya mengerti pertanyaanmu tentang: "*$prompt*".\n\n'
        'Untuk topik tersebut dalam materi **Teknik Komputer dan Jaringan (TKJ)**, kamu dapat mengeksplorasi:\n'
        '1. **Konsep Dasar**: Pahami fungsi utama dan perannya dalam sistem komputer/jaringan.\n'
        '2. **Praktik & Konfigurasi**: Coba simulasikan pada Virtual Lab Netropia atau Cisco Packet Tracer.\n'
        '3. **Troubleshooting**: Periksa konektivitas kabel, konfigurasi IP, dan status perangkat.\n\n'
        '💡 *Tips: Kamu bisa menanyakan topik spesifik seperti "Jelaskan Subnetting /24", "Cara crimping kabel UTP", "Troubleshooting RTO", atau "Fungsi Router".*';
  }
}
