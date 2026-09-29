import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/ai_service.dart';

class NetropiaAiScreen extends StatefulWidget {
  final String? initialMessage;
  const NetropiaAiScreen({super.key, this.initialMessage});

  @override
  State<NetropiaAiScreen> createState() => _NetropiaAiScreenState();
}

class _NetropiaAiScreenState extends State<NetropiaAiScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final AiService _aiService = AiService();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasApiKey = false;

  final List<String> _quickPrompts = [
    "Jelaskan Subnetting /24",
    "Urutan warna kabel UTP T568B",
    "Troubleshooting RTO Internet",
    "Perbedaan TCP dan UDP",
    "Fungsi Router dan Switch",
    "7 Lapisan OSI Layer",
    "Beri saya kuis TKJ",
  ];

  @override
  void initState() {
    super.initState();
    _checkApiKeyStatus();

    _messages.add(ChatMessage(
      id: DateTime.now().toString(),
      message: "Halo! Saya Netropia AI. Asisten pintar belajarmu untuk materi jaringan komputer, hardware, dan TKJ. Apa yang ingin kamu diskusikan hari ini?",
      isUser: false,
      timestamp: DateTime.now(),
    ));

    if (widget.initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.text = widget.initialMessage!;
        _handleSend();
      });
    }
  }

  Future<void> _checkApiKeyStatus() async {
    final key = await _aiService.getStoredApiKey();
    if (mounted) {
      setState(() {
        _hasApiKey = key != null && key.isNotEmpty;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().toString(),
        message: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final response = await _aiService.getChatResponse(text);
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            id: DateTime.now().toString(),
            message: response,
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Maaf, terjadi kesalahan saat menghubungi AI.")),
      );
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Teks jawaban AI berhasil disalin!"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _messages.add(ChatMessage(
        id: DateTime.now().toString(),
        message: "Percakapan dibersihkan. Ada lagi materi TKJ atau troubleshooting jaringan yang ingin kamu tanyakan?",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _showApiKeyDialog() async {
    final currentKey = await _aiService.getStoredApiKey() ?? '';
    final keyController = TextEditingController(text: currentKey);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.key_rounded, color: Color(0xFFAD8B73)),
              SizedBox(width: 10),
              Text("Pengaturan Gemini AI", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Masukkan API Key Google Gemini (Gratis) untuk mengaktifkan AI Generatif tanpa batas.",
                  style: TextStyle(fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: keyController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Gemini API Key",
                    hintText: "AIzaSy...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.vpn_key_rounded),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () async {
                    final Uri url = Uri.parse("https://aistudio.google.com/app/apikey");
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: const Icon(Icons.open_in_new_rounded, size: 16),
                  label: const Text("Dapatkan API Key Gratis di Google AI Studio", style: TextStyle(fontSize: 11)),
                ),
                const SizedBox(height: 8),
                const Text(
                  "💡 Jika API Key kosong, Netropia AI tetap berfungsi secara offline menggunakan Engine Lokal TKJ.",
                  style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          actions: [
            if (currentKey.isNotEmpty)
              TextButton(
                onPressed: () async {
                  final nav = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);
                  await _aiService.removeApiKey();
                  await _checkApiKeyStatus();
                  if (mounted) {
                    nav.pop();
                    messenger.showSnackBar(
                      const SnackBar(content: Text("API Key dihapus. Kembali ke Engine Lokal.")),
                    );
                  }
                },
                child: const Text("Hapus Key", style: TextStyle(color: Colors.red)),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                final nav = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);
                final newKey = keyController.text.trim();
                if (newKey.isNotEmpty) {
                  await _aiService.saveApiKey(newKey);
                } else {
                  await _aiService.removeApiKey();
                }
                await _checkApiKeyStatus();
                if (mounted) {
                  nav.pop();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        newKey.isNotEmpty
                            ? "Gemini API Key berhasil disimpan! AI Online Aktif."
                            : "Menggunakan Engine Lokal TKJ Netropia.",
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFAD8B73),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFAD8B73),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.psychology_rounded, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Netropia AI", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: _hasApiKey ? Colors.lightGreenAccent : Colors.amberAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _hasApiKey ? "Gemini AI Online" : "Engine Lokal TKJ",
                      style: const TextStyle(fontSize: 10, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _hasApiKey ? Icons.key_rounded : Icons.key_off_rounded,
              color: _hasApiKey ? Colors.amberAccent : Colors.white70,
            ),
            onPressed: _showApiKeyDialog,
            tooltip: "Pengaturan Gemini Key",
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded),
            onPressed: _clearChat,
            tooltip: "Hapus Chat",
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length) {
                        return _buildLoadingBubble();
                      }
                      final message = _messages[index];
                      return _buildChatBubble(message, isDark);
                    },
                  ),
          ),
          if (_messages.length <= 2 && !_isLoading) _buildQuickPrompts(),
          _buildInputArea(isDark),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text("Belum ada percakapan", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message, bool isDark) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: message.isUser
              ? const Color(0xFFAD8B73)
              : (isDark ? const Color(0xFF2C2C2C) : Colors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(message.isUser ? 18 : 0),
            bottomRight: Radius.circular(message.isUser ? 0 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: TextStyle(
                color: message.isUser ? Colors.white : (isDark ? Colors.white : Colors.black87),
                fontSize: 13.5,
                height: 1.45,
              ),
            ),
            if (!message.isUser) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => _copyToClipboard(message.message),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Row(
                        children: const [
                          Icon(Icons.copy_rounded, size: 14, color: Colors.grey),
                          SizedBox(width: 4),
                          Text("Salin", style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2C) : Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFAD8B73)),
            ),
            const SizedBox(width: 12),
            Text(
              "Netropia AI sedang memproses jawaban...",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickPrompts() {
    return Container(
      height: 42,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _quickPrompts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              avatar: const Icon(Icons.auto_awesome_rounded, size: 14, color: Color(0xFFAD8B73)),
              label: Text(_quickPrompts[index], style: const TextStyle(fontSize: 12)),
              backgroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: const Color(0xFFAD8B73).withAlpha(77)),
              ),
              onPressed: () {
                _controller.text = _quickPrompts[index];
                _handleSend();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputArea(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 82),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Tanyakan seputar TKJ & Jaringan...",
                hintStyle: const TextStyle(fontSize: 13.5),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F7FA),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _handleSend(),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFAD8B73),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              onPressed: _handleSend,
            ),
          ),
        ],
      ),
    );
  }
}
