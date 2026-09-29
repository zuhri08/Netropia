import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../services/ai_service.dart';

class NetropiaAiScreen extends StatefulWidget {
  final String? initialMessage;

  const NetropiaAiScreen({
    super.key,
    this.initialMessage,
  });

  @override
  State<NetropiaAiScreen> createState() => _NetropiaAiScreenState();
}

class _NetropiaAiScreenState extends State<NetropiaAiScreen> {
  // ============================================================
  // CONTROLLERS & SERVICES
  // ============================================================

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = [];
  final AiService _aiService = AiService();

  bool _isLoading = false;

  // ============================================================
  // THEME
  // ============================================================

  static const Color _primaryColor = Color(0xFFAD8B73);

  // ============================================================
  // QUICK PROMPTS
  // ============================================================

  final List<String> _quickPrompts = [
    'Jelaskan Subnetting /24',
    'Urutan warna kabel UTP T568B',
    'Troubleshooting RTO Internet',
    'Perbedaan TCP dan UDP',
    'Fungsi Router dan Switch',
    '7 Lapisan OSI Layer',
    'Beri saya kuis TKJ',
  ];

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void initState() {
    super.initState();

    _addWelcomeMessage();

    final initialMessage = widget.initialMessage?.trim();

    if (initialMessage != null && initialMessage.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        _controller.text = initialMessage;
        _handleSend();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  // ============================================================
  // CHAT MANAGEMENT
  // ============================================================

  void _addWelcomeMessage() {
    _messages.add(
      ChatMessage(
        id: DateTime.now().toString(),
        message:
        'Halo! Saya Netropia AI. Asisten pintar belajarmu untuk materi '
            'jaringan komputer, hardware, dan TKJ. Apa yang ingin kamu '
            'diskusikan hari ini?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<void> _handleSend() async {
    final text = _controller.text.trim();

    if (text.isEmpty || _isLoading) return;

    _controller.clear();

    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().toString(),
          message: text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );

      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final response = await _aiService.getChatResponse(text);

      if (!mounted) return;

      setState(() {
        _messages.add(
          ChatMessage(
            id: DateTime.now().toString(),
            message: response,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );

        _isLoading = false;
      });

      _scrollToBottom();
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Maaf, terjadi kesalahan saat menghubungi AI.',
          ),
        ),
      );
    }
  }

  void _clearChat() {
    _aiService.resetChat();

    setState(() {
      _messages.clear();

      _messages.add(
        ChatMessage(
          id: DateTime.now().toString(),
          message:
          'Percakapan dibersihkan. Ada lagi materi TKJ atau '
              'troubleshooting jaringan yang ingin kamu tanyakan?',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });

    _scrollToBottom();
  }

  // ============================================================
  // CHAT UTILITIES
  // ============================================================

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Teks jawaban AI berhasil disalin!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _sendQuickPrompt(String prompt) {
    if (_isLoading) return;

    _controller.text = prompt;
    _handleSend();
  }

  // ============================================================
  // MAIN BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
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

                return _buildChatBubble(
                  _messages[index],
                  isDark,
                );
              },
            ),
          ),

          if (_messages.length <= 2 && !_isLoading)
            _buildQuickPrompts(),

          _buildInputArea(isDark),
        ],
      ),
    );
  }

  // ============================================================
  // APP BAR
  // ============================================================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.psychology_rounded,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Netropia AI',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Colors.lightGreenAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Firebase AI',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_sweep_rounded),
          onPressed: _isLoading ? null : _clearChat,
          tooltip: 'Hapus Chat',
        ),
      ],
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada percakapan',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CHAT BUBBLE
  // ============================================================

  Widget _buildChatBubble(ChatMessage message, bool isDark) {
    final isUser = message.isUser;

    final textColor = isUser
        ? Colors.white
        : (isDark ? Colors.white : Colors.black87);

    final bubbleColor = isUser
        ? _primaryColor
        : (isDark ? const Color(0xFF2C2C2C) : Colors.white);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 18),
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
            // Pesan siswa menggunakan teks biasa.
            // Pesan AI menggunakan Markdown.
            if (isUser)
              Text(
                message.message,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13.5,
                  height: 1.5,
                ),
              )
            else
              MarkdownBody(
                data: message.message,
                selectable: true,
                styleSheet: _buildMarkdownStyle(textColor, isDark),
              ),

            if (!isUser) ...[
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => _copyToClipboard(message.message),
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.copy_rounded,
                          size: 14,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Salin',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MARKDOWN STYLE
  // ============================================================

  MarkdownStyleSheet _buildMarkdownStyle(
      Color textColor,
      bool isDark,
      ) {
    final codeBackground = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFF0EDE9);

    return MarkdownStyleSheet(
      p: TextStyle(
        color: textColor,
        fontSize: 13.5,
        height: 1.55,
      ),
      h1: TextStyle(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        height: 1.4,
      ),
      h2: TextStyle(
        color: textColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        height: 1.4,
      ),
      h3: TextStyle(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        height: 1.4,
      ),
      strong: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
      em: TextStyle(
        color: textColor,
        fontStyle: FontStyle.italic,
      ),
      listBullet: TextStyle(
        color: textColor,
        fontSize: 13.5,
      ),
      code: TextStyle(
        color: textColor,
        fontSize: 12.5,
        fontFamily: 'monospace',
        backgroundColor: codeBackground,
      ),
      codeblockDecoration: BoxDecoration(
        color: codeBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      blockquote: TextStyle(
        color: textColor.withAlpha(190),
        fontSize: 13.5,
        height: 1.5,
      ),
      blockquoteDecoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: _primaryColor,
            width: 3,
          ),
        ),
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white24 : Colors.black12,
          ),
        ),
      ),
      a: const TextStyle(
        color: _primaryColor,
        decoration: TextDecoration.underline,
      ),
    );
  }

  // ============================================================
  // LOADING BUBBLE
  // ============================================================

  Widget _buildLoadingBubble() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: _primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Netropia AI sedang memproses jawaban...',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // QUICK PROMPTS
  // ============================================================

  Widget _buildQuickPrompts() {
    return Container(
      height: 42,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _quickPrompts.length,
        itemBuilder: (context, index) {
          final prompt = _quickPrompts[index];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              avatar: const Icon(
                Icons.auto_awesome_rounded,
                size: 14,
                color: _primaryColor,
              ),
              label: Text(
                prompt,
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: _primaryColor.withAlpha(77),
                ),
              ),
              onPressed: _isLoading
                  ? null
                  : () => _sendQuickPrompt(prompt),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // INPUT AREA
  // ============================================================

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
              enabled: !_isLoading,
              textInputAction: TextInputAction.send,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Tanyakan seputar TKJ & Jaringan...',
                hintStyle: const TextStyle(fontSize: 13.5),
                filled: true,
                fillColor: isDark
                    ? const Color(0xFF1E1E1E)
                    : const Color(0xFFF5F7FA),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
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
              color: _primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: _isLoading ? null : _handleSend,
              tooltip: 'Kirim pesan',
            ),
          ),
        ],
      ),
    );
  }
}