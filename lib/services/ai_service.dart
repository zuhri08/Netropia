import 'dart:async';

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
  // Mock response logic for Netropia AI
  Future<String> getChatResponse(String prompt) async {
    // Simulasi delay jaringan
    await Future.delayed(const Duration(seconds: 1));

    String lowerPrompt = prompt.toLowerCase();

    if (lowerPrompt.contains('subnetting')) {
      return 'Subnetting adalah proses membagi sebuah jaringan IP menjadi beberapa sub-jaringan yang lebih kecil (subnet). Tujuannya adalah untuk meningkatkan efisiensi penggunaan IP Address dan meningkatkan keamanan serta kinerja jaringan.';
    } else if (lowerPrompt.contains('ip address')) {
      return 'IP Address (Internet Protocol Address) adalah label numerik yang ditetapkan untuk setiap perangkat yang terhubung ke jaringan komputer yang menggunakan Protokol Internet untuk komunikasi. Ada dua versi utama: IPv4 (32-bit) dan IPv6 (128-bit).';
    } else if (lowerPrompt.contains('osi layer')) {
      return 'OSI Layer adalah model referensi untuk komunikasi jaringan yang terdiri dari 7 lapisan: 1. Physical, 2. Data Link, 3. Network, 4. Transport, 5. Session, 6. Presentation, dan 7. Application.';
    } else if (lowerPrompt.contains('tcp') && lowerPrompt.contains('udp')) {
      return 'TCP (Transmission Control Protocol) bersifat connection-oriented dan menjamin pengiriman data, cocok untuk HTTP/Email. Sedangkan UDP (User Datagram Protocol) bersifat connectionless dan lebih cepat namun tidak menjamin pengiriman, cocok untuk streaming/gaming.';
    } else if (lowerPrompt.contains('ping')) {
      return 'Command "ping" digunakan untuk menguji konektivitas antar perangkat dalam jaringan dengan mengirim paket ICMP Echo Request dan menunggu Echo Reply.';
    } else if (lowerPrompt.contains('soal') || lowerPrompt.contains('kuis')) {
      return 'Tentu! Ini 3 soal singkat tentang Subnetting:\n1. Apa fungsi dari Subnet Mask?\n2. Berapa jumlah host yang tersedia pada prefix /24?\n3. Apa perbedaan Network Address dan Broadcast Address?';
    } else if (lowerPrompt.contains('internet tidak terhubung')) {
      return 'Troubleshooting Internet:\n1. Cek lampu indikator pada Router/Modem.\n2. Pastikan kabel LAN terpasang kencang atau WiFi terhubung.\n3. Coba lakukan "ping 8.8.8.8" di CMD.\n4. Restart perangkat jaringan Anda.';
    }

    return 'Saya mengerti Anda bertanya tentang "$prompt". Sebagai asisten TKJ, saya sarankan kita fokus pada konsep jaringan, troubleshooting, atau konfigurasi perangkat. Apa ada bagian spesifik yang ingin Anda diskusikan?';
  }
}
