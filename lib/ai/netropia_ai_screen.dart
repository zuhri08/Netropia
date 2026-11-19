import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../services/ai_service.dart';
import '../services/localization_service.dart';

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
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = [];
  final List<ChatSessionItem> _sessions = [];
  String? _activeSessionId;

  final AiService _aiService = AiService();

  bool _isLoading = false;

  static const Color _primaryColor = Color(0xFFAD8B73);

  List<String> get _quickPrompts {
    if (localizationService.isEnglish) {
      return [
        'Explain Subnetting /24',
        'UTP T568B color order',
        'Troubleshooting Internet RTO',
        'Difference between TCP and UDP',
        'Functions of Router and Switch',
        '7 OSI Layers',
        'Give me a TKJ quiz',
      ];
    }
    return [
      'Jelaskan Subnetting /24',
      'Urutan warna kabel UTP T568B',
      'Troubleshooting RTO Internet',
      'Perbedaan TCP dan UDP',
      'Fungsi Router dan Switch',
      '7 Lapisan OSI Layer',
      'Beri saya kuis TKJ',
    ];
  }

  @override
  void initState() {
    super.initState();

    _loadHistoryOrWelcome();
  }

  Future<void> _loadHistoryOrWelcome() async {
    final loadedSessions = await _aiService.loadAllSessions();
    if (!mounted) return;

    if (loadedSessions.isNotEmpty) {
      setState(() {
        _sessions.clear();
        _sessions.addAll(loadedSessions);
        _activeSessionId = _sessions.first.id;
        _messages.clear();
        _messages.addAll(_sessions.first.messages);
      });
    } else {
      _startNewChat(savePrevious: false);
    }

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

  ChatMessage _createWelcomeMessage() {
    final msg = localizationService.isEnglish
        ? 'Hello! I am Netropia AI. Your smart learning assistant for computer networking, hardware, and TKJ. What would you like to discuss today?'
        : 'Halo! Saya Netropia AI. Asisten pintar belajarmu untuk materi jaringan komputer, hardware, dan TKJ. Apa yang ingin kamu diskusikan hari ini?';

    return ChatMessage(
      id: DateTime.now().toString(),
      message: msg,
      isUser: false,
      timestamp: DateTime.now(),
    );
  }

  void _startNewChat({bool savePrevious = true}) {
    if (_isLoading) return;

    if (savePrevious && _messages.isNotEmpty) {
      _saveCurrentSession();
    }

    _aiService.resetChat();

    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final welcomeMsg = _createWelcomeMessage();

    final newSession = ChatSessionItem(
      id: newId,
      title: localizationService.isEnglish ? 'New Conversation' : 'Percakapan Baru',
      createdAt: DateTime.now(),
      messages: [welcomeMsg],
    );

    setState(() {
      _activeSessionId = newId;
      _messages.clear();
      _messages.add(welcomeMsg);
      _sessions.insert(0, newSession);
    });

    _aiService.saveAllSessions(_sessions);
    _scrollToBottom();
  }

  void _saveCurrentSession() {
    if (_activeSessionId == null) return;
    final index = _sessions.indexWhere((s) => s.id == _activeSessionId);

    String title = localizationService.isEnglish ? 'New Conversation' : 'Percakapan Baru';
    final userMsg = _messages.firstWhere(
      (m) => m.isUser,
      orElse: () => ChatMessage(id: '', message: '', isUser: false, timestamp: DateTime.now()),
    );
    if (userMsg.message.isNotEmpty) {
      title = userMsg.message.length > 28
          ? '${userMsg.message.substring(0, 28)}...'
          : userMsg.message;
    }

    final updatedSession = ChatSessionItem(
      id: _activeSessionId!,
      title: title,
      createdAt: index >= 0 ? _sessions[index].createdAt : DateTime.now(),
      messages: List.from(_messages),
    );

    if (index >= 0) {
      _sessions[index] = updatedSession;
    } else {
      _sessions.insert(0, updatedSession);
    }

    _aiService.saveAllSessions(_sessions);
  }

  void _selectSession(ChatSessionItem session) {
    if (_activeSessionId == session.id) {
      Navigator.of(context).pop();
      return;
    }

    _saveCurrentSession();
    _aiService.resetChat();

    setState(() {
      _activeSessionId = session.id;
      _messages.clear();
      _messages.addAll(session.messages);
    });

    Navigator.of(context).pop();
    _scrollToBottom();
  }

  void _deleteSession(String sessionId) {
    setState(() {
      _sessions.removeWhere((s) => s.id == sessionId);
      if (_activeSessionId == sessionId) {
        if (_sessions.isNotEmpty) {
          _activeSessionId = _sessions.first.id;
          _messages.clear();
          _messages.addAll(_sessions.first.messages);
        } else {
          _startNewChat(savePrevious: false);
        }
      }
    });

    _aiService.saveAllSessions(_sessions);
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

    _saveCurrentSession();
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

      _saveCurrentSession();
      _scrollToBottom();
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizationService.isEnglish
                ? 'Sorry, an error occurred while connecting to AI.'
                : 'Maaf, terjadi kesalahan saat menghubungi AI.',
          ),
        ),
      );
    }
  }

  void _clearChat() {
    _aiService.resetChat();

    if (_activeSessionId != null) {
      _deleteSession(_activeSessionId!);
    } else {
      _startNewChat(savePrevious: false);
    }
  }

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
      SnackBar(
        content: Text(
          localizationService.isEnglish
              ? 'AI response copied to clipboard!'
              : 'Teks jawaban AI berhasil disalin!',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _sendQuickPrompt(String prompt) {
    if (_isLoading) return;

    _controller.text = prompt;
    _handleSend();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: _buildAppBar(),
          endDrawer: _buildHistoryDrawer(isDark),
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
      },
    );
  }

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
              Text(
                localizationService.translate('ai_assistant'),
                style: const TextStyle(
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
          tooltip: localizationService.isEnglish ? 'Clear Session' : 'Hapus Sesi Ini',
        ),
        IconButton(
          icon: const Icon(Icons.add_rounded),
          onPressed: _isLoading ? null : () => _startNewChat(savePrevious: true),
          tooltip: localizationService.isEnglish ? 'New Conversation' : 'Percakapan Baru',
        ),
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            tooltip: localizationService.isEnglish ? 'Chat History' : 'Buka Riwayat',
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryDrawer(bool isDark) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.78,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              color: _primaryColor,
              child: Row(
                children: [
                  const Icon(Icons.history_rounded, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    localizationService.isEnglish ? 'Chat History' : 'Riwayat Chat',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_rounded, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _startNewChat(savePrevious: true);
                    },
                    tooltip: localizationService.isEnglish ? 'New Chat' : 'Percakapan Baru',
                  ),
                ],
              ),
            ),
            Expanded(
              child: _sessions.isEmpty
                  ? Center(
                      child: Text(
                        localizationService.isEnglish ? 'No chat history' : 'Belum ada riwayat',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _sessions.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final session = _sessions[index];
                        final isActive = session.id == _activeSessionId;

                        return ListTile(
                          selected: isActive,
                          selectedTileColor: _primaryColor.withAlpha(30),
                          leading: Icon(
                            isActive ? Icons.chat_rounded : Icons.chat_bubble_outline_rounded,
                            color: isActive ? _primaryColor : Colors.grey,
                            size: 20,
                          ),
                          title: Text(
                            session.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                              fontSize: 13,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            '${session.createdAt.day}/${session.createdAt.month}/${session.createdAt.year} ${session.createdAt.hour.toString().padLeft(2, '0')}:${session.createdAt.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent),
                            onPressed: () => _deleteSession(session.id),
                            tooltip: 'Hapus Sesi',
                          ),
                          onTap: () => _selectSession(session),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

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
          Text(
            localizationService.isEnglish ? 'No conversation yet' : 'Belum ada percakapan',
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message, bool isDark) {
    final isUser = message.isUser;

    final textColor = isUser
        ? Colors.white
        : (isDark ? Colors.white : Colors.black87);

    final bubbleColor = isUser
        ? _primaryColor
        : (isDark ? Theme.of(context).cardColor : Colors.white);

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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.copy_rounded,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          localizationService.isEnglish ? 'Copy' : 'Salin',
                          style: const TextStyle(
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

  MarkdownStyleSheet _buildMarkdownStyle(
      Color textColor,
      bool isDark,
      ) {
    final codeBackground = isDark
        ? const Color(0xFF2C2C2C)
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
      blockquoteDecoration: const BoxDecoration(
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
          color: isDark ? Theme.of(context).cardColor : Colors.white,
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
              localizationService.isEnglish
                  ? 'Netropia AI is processing response...'
                  : 'Netropia AI sedang memproses jawaban...',
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
                hintText: localizationService.translate('ask_ai_placeholder'),
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
              tooltip: localizationService.isEnglish ? 'Send message' : 'Kirim pesan',
            ),
          ),
        ],
      ),
    );
  }
}
