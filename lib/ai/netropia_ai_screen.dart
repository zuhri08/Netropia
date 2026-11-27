import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../services/ai_service.dart';
import '../services/localization_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ai_fly_effect.dart';
import '../widgets/home_effects.dart';

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

  List<String> get _quickPrompts {
    if (localizationService.isEnglish) {
      return [
        'Explain Subnetting /24',
        'UTP T568B color order',
        'Troubleshooting Internet RTO',
        'Difference between TCP and UDP',
        'Functions of Router and Switch',
        '7 OSI Layers',
      ];
    }
    return [
      'Jelaskan Subnetting /24',
      'Urutan warna kabel UTP T568B',
      'Troubleshooting RTO Internet',
      'Perbedaan TCP dan UDP',
      'Fungsi Router dan Switch',
      '7 Lapisan OSI Layer',
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

  void _editSessionTitle(ChatSessionItem session) {
    final TextEditingController editController = TextEditingController(text: session.title);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizationService.isEnglish ? 'Edit Chat Title' : 'Edit Judul Riwayat'),
        content: TextField(
          controller: editController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: localizationService.isEnglish ? 'Enter new title' : 'Masukkan judul baru',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizationService.isEnglish ? 'Cancel' : 'Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBrown,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final newTitle = editController.text.trim();
              if (newTitle.isNotEmpty) {
                setState(() {
                  final index = _sessions.indexWhere((s) => s.id == session.id);
                  if (index >= 0) {
                    _sessions[index] = _sessions[index].copyWith(title: newTitle);
                  }
                });
                _aiService.saveAllSessions(_sessions);
              }
              Navigator.of(context).pop();
            },
            child: Text(localizationService.isEnglish ? 'Save' : 'Simpan'),
          ),
        ],
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
          body: Stack(
            children: [
              const Positioned.fill(child: AnimatedBackdrop()),
              Column(
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
              if (_messages.length <= 2 && !_isLoading) _buildQuickPrompts(),
              _buildInputArea(isDark),
            ],
          ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: const BrandAppBarBackground(),
      title: Row(
        children: [
          AiBarIconSlot(
            child: Container(
              key: aiBarIconKey,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology_rounded,
                size: 20,
                color: Colors.white,
              ),
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
                      color: Color(0xFF4ADE80),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Firebase AI · Siap membantu',
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
      backgroundColor: isDark ? const Color(0xFF241C17) : Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFAD8B73), Color(0xFFC4A58C)],
                ),
              ),
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
                  ? const Center(
                      child: Text(
                        'Belum ada riwayat',
                        style: TextStyle(color: AppTheme.textMuted),
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
                          selectedTileColor: AppTheme.brownTint,
                          leading: Icon(
                            isActive ? Icons.chat_rounded : Icons.chat_bubble_outline_rounded,
                            color: isActive ? AppTheme.primaryBrown : AppTheme.textMuted,
                            size: 20,
                          ),
                          title: Text(
                            session.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                              fontSize: 13,
                              color: isDark ? Colors.white : AppTheme.textDark,
                            ),
                          ),
                          subtitle: Text(
                            '${session.createdAt.day}/${session.createdAt.month}/${session.createdAt.year}',
                            style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18, color: AppTheme.textMuted),
                                onPressed: () => _editSessionTitle(session),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppTheme.accentRed),
                                onPressed: () => _deleteSession(session.id),
                              ),
                            ],
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

  Widget _aiAvatar({double size = 32}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFFC4A58C), AppTheme.primaryBrown],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBrown.withOpacity(0.35),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(Icons.psychology_rounded, color: Colors.white, size: size * 0.58),
    );
  }

  Widget _buildEmptyState() {
    final en = localizationService.isEnglish;
    return Center(
      child: FadeSlideIn(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Floating(
                amplitude: 6,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC4A58C), AppTheme.primaryBrown],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBrown.withOpacity(0.4),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.psychology_rounded,
                      color: Colors.white, size: 54),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                en ? 'Hi, I am Netropia AI' : 'Halo, aku Netropia AI',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.darkBrown,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                en
                    ? 'Ask me anything about TKJ lessons.'
                    : 'Tanyakan apa saja seputar materi TKJ.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message, bool isDark) {
    final isUser = message.isUser;
    final textColor = isUser
        ? Colors.white
        : (isDark ? Colors.white : AppTheme.textDark);

    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * (isUser ? 0.78 : 0.74),
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: isUser
            ? const LinearGradient(
                colors: [Color(0xFFC4A58C), AppTheme.primaryBrown],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isUser
            ? null
            : (isDark ? Theme.of(context).cardColor : Colors.white),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isUser ? 18 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 18),
        ),
        border: isUser
            ? null
            : Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.08)
                    : AppTheme.primaryBrown.withOpacity(0.15),
              ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBrown.withOpacity(isUser ? 0.3 : 0.1),
            blurRadius: 12,
            offset: const Offset(0, 5),
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
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => _copyToClipboard(message.message),
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.copy_rounded,
                        size: 14,
                        color: AppTheme.textMuted,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Salin',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.textMuted,
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
    );

    return FadeSlideIn(
      duration: const Duration(milliseconds: 450),
      offset: Offset(isUser ? 30 : -30, 10),
      scaleFrom: 0.96,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isUser) ...[
              _aiAvatar(),
              const SizedBox(width: 8),
            ],
            Flexible(child: bubble),
          ],
        ),
      ),
    );
  }

  MarkdownStyleSheet _buildMarkdownStyle(Color textColor, bool isDark) {
    final codeBackground = isDark ? const Color(0xFF2E241E) : AppTheme.surfaceCream;
    return MarkdownStyleSheet(
      p: TextStyle(color: textColor, fontSize: 13.5, height: 1.5),
      h1: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
      h2: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
      strong: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      code: TextStyle(color: textColor, fontSize: 12.5, fontFamily: 'monospace', backgroundColor: codeBackground),
      codeblockDecoration: BoxDecoration(color: codeBackground, borderRadius: BorderRadius.circular(8)),
      a: const TextStyle(color: AppTheme.primaryBrown, decoration: TextDecoration.underline),
    );
  }

  Widget _buildLoadingBubble() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _aiAvatar(),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? Theme.of(context).cardColor : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(
                color: AppTheme.primaryBrown.withOpacity(0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBrown.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TypingDots(),
                SizedBox(width: 12),
                Text(
                  'Netropia AI sedang memproses jawaban...',
                  style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPrompts() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 14,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBrown,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'COBA TANYAKAN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 46,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _quickPrompts.length,
            itemBuilder: (context, index) {
              final prompt = _quickPrompts[index];
              final accent = kAccentPalette[index % kAccentPalette.length];
              return FadeSlideIn(
                delay: Duration(milliseconds: 80 * index),
                offset: const Offset(24, 0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 4),
                  child: PressScale(
                    pressedScale: 0.94,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: _isLoading ? null : () => _sendQuickPrompt(prompt),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            gradient: softCardGradient(context, accent),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: accent.withOpacity(0.3)),
                            boxShadow: [
                              BoxShadow(
                                color: accent.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.auto_awesome_rounded,
                                  size: 15, color: accent),
                              const SizedBox(width: 6),
                              Text(
                                prompt,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : AppTheme.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInputArea(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 95),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDark ? Theme.of(context).cardColor : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppTheme.primaryBrown.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBrown.withOpacity(0.16),
              blurRadius: 18,
              offset: const Offset(0, 6),
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
                decoration: const InputDecoration(
                  hintText: 'Tanyakan tentang materi TKJ...',
                  hintStyle: TextStyle(fontSize: 13.5, color: AppTheme.textMuted),
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onSubmitted: (_) => _handleSend(),
              ),
            ),
            const SizedBox(width: 6),
            PressScale(
              pressedScale: 0.9,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: _isLoading
                        ? [Colors.grey.shade400, Colors.grey.shade500]
                        : const [Color(0xFFC4A58C), AppTheme.primaryBrown],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryBrown.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: _isLoading ? null : _handleSend,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tiga titik yang melompat bergantian (indikator "sedang mengetik").
class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final t = (_c.value + (2 - i) * 0.18) % 1.0;
            final v = math.sin(t * math.pi);
            return Transform.translate(
              offset: Offset(0, -5 * v),
              child: Container(
                width: 7,
                height: 7,
                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryBrown.withOpacity(0.4 + 0.6 * v),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
