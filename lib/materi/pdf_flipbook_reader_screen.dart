import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

// ─────────────────────────── Konfigurasi ───────────────────────────
const double _kBaseWidth = 800; // lebar render halaman normal (px)
const double _kHiResWidth = 1400; // lebar render saat di-zoom (px)
const double _kThumbWidth = 180; // lebar render thumbnail (px)
const int _kCacheCapacity = 10; // maksimal halaman normal di RAM
const double _kMinutesPerPage = 1.5; // asumsi waktu baca per halaman
const double _kMaxZoom = 4.0;

enum ReadingMode { light, sepia, dark }

const ColorFilter _filterLight = ColorFilter.mode(Colors.transparent, BlendMode.dst);
const ColorFilter _filterSepia = ColorFilter.matrix(<double>[
  0.393, 0.769, 0.189, 0, 0, //
  0.349, 0.686, 0.168, 0, 0,
  0.272, 0.534, 0.131, 0, 0,
  0, 0, 0, 1, 0,
]);
const ColorFilter _filterDark = ColorFilter.matrix(<double>[
  -0.9, 0, 0, 0, 230, //
  0, -0.9, 0, 0, 230,
  0, 0, -0.9, 0, 230,
  0, 0, 0, 1, 0,
]);

ColorFilter _filterFor(ReadingMode m) {
  switch (m) {
    case ReadingMode.sepia:
      return _filterSepia;
    case ReadingMode.dark:
      return _filterDark;
    case ReadingMode.light:
      return _filterLight;
  }
}

class _RenderJob {
  final Future<void> Function() run;
  final bool high;
  _RenderJob(this.run, this.high);
}

class PdfFlipbookReaderScreen extends StatefulWidget {
  final String assetPath;
  final String title;

  const PdfFlipbookReaderScreen({
    super.key,
    required this.assetPath,
    required this.title,
  });

  @override
  State<PdfFlipbookReaderScreen> createState() => _PdfFlipbookReaderScreenState();
}

class _PdfFlipbookReaderScreenState extends State<PdfFlipbookReaderScreen> {
  final PageController _pageController = PageController();
  final TransformationController _zoomController = TransformationController();
  final FocusNode _keyboardFocusNode = FocusNode();
  final TextEditingController _pageInputController = TextEditingController();

  // Dokumen
  Uint8List? _pdfBytes;
  SharedPreferences? _prefs;
  bool _isLoading = true;
  bool _disposed = false;
  String? _errorMessage;
  int _totalPages = 0;
  double _aspect = 0.707; // lebar / tinggi halaman

  // Posisi & layout
  int _currentPage = 0; // index halaman PDF (0-based); di mode spread selalu genap
  bool _spread = false;
  bool? _lastSpread;
  Size _viewport = Size.zero;

  // UI
  bool _isFullscreen = false;
  bool _isSoundMuted = false;
  bool _showToolbar = true;
  double? _dragPage;
  Offset _doubleTapPos = Offset.zero;
  ReadingMode _mode = ReadingMode.light;
  double _brightness = 1.0;

  // Zoom
  final ValueNotifier<double> _zoom = ValueNotifier<double>(1.0);
  final ValueNotifier<bool> _zoomed = ValueNotifier<bool>(false);
  Timer? _hiResTimer;

  // Cache
  final Map<int, Uint8List> _cache = {}; // LRU
  final Map<int, Uint8List> _hiRes = {};
  final Map<int, Uint8List> _thumbs = {};
  final Set<int> _loading = {};
  final Set<int> _hiLoading = {};
  final Set<int> _thumbLoading = {};
  final Set<int> _failed = {};
  Set<int> _wanted = {};
  final ValueNotifier<int> _tick = ValueNotifier<int>(0);
  final ValueNotifier<int> _thumbTick = ValueNotifier<int>(0);

  // Antrian render
  final List<_RenderJob> _jobs = [];
  bool _pumping = false;

  // Bookmark
  final ValueNotifier<Set<int>> _bookmarks = ValueNotifier<Set<int>>(<int>{});

  String get _kLastPage => 'ebook.${widget.assetPath}.lastPage';
  String get _kBookmarks => 'ebook.${widget.assetPath}.bookmarks';
  static const String _kModeKey = 'ebook.readingMode';
  static const String _kBrightnessKey = 'ebook.brightness';

  @override
  void initState() {
    super.initState();
    _zoomController.addListener(_onZoomChanged);
    _init();
  }

  @override
  void dispose() {
    _disposed = true;
    _hiResTimer?.cancel();
    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    }
    _pageController.dispose();
    _zoomController.removeListener(_onZoomChanged);
    _zoomController.dispose();
    _keyboardFocusNode.dispose();
    _pageInputController.dispose();
    _zoom.dispose();
    _zoomed.dispose();
    _tick.dispose();
    _thumbTick.dispose();
    _bookmarks.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      final p = _prefs!;

      _jobs.clear();
      _cache.clear();
      _hiRes.clear();
      _thumbs.clear();
      _loading.clear();
      _hiLoading.clear();
      _thumbLoading.clear();
      _failed.clear();
      _lastSpread = null;

      final ByteData data = await rootBundle.load(widget.assetPath);
      final Uint8List pdfBytes = data.buffer.asUint8List();

      if (_disposed) return;
      _pdfBytes = pdfBytes;

      int total = 0;
      double aspect = 0.707;
      await for (final page in Printing.raster(pdfBytes, dpi: 72)) {
        if (total == 0) {
          aspect = page.width / page.height;
        }
        total++;
      }

      if (total == 0) {
        throw Exception('File E-Book PDF kosong.');
      }

      final saved = (p.getInt(_kLastPage) ?? 0).clamp(0, math.max(0, total - 1));
      final bookmarks = (p.getStringList(_kBookmarks) ?? [])
          .map(int.tryParse)
          .whereType<int>()
          .where((e) => e >= 0 && e < total)
          .toSet();

      if (!mounted) return;
      setState(() {
        _totalPages = total;
        _aspect = aspect;
        _currentPage = (saved as num).toInt();
        _bookmarks.value = bookmarks;
        _mode = ReadingMode.values[(p.getInt(_kModeKey) ?? 0).clamp(0, ReadingMode.values.length - 1)];
        _brightness = (p.getDouble(_kBrightnessKey) ?? 1.0).clamp(0.3, 1.0);
        _pageInputController.text = '${saved + 1}';
        _isLoading = false;
        _errorMessage = null;
      });

      _prefetch();
    } catch (e) {
      debugPrint('Error loading flipbook PDF: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal memuat file E-Book PDF.\nDetail error: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<T> _enqueue<T>(Future<T> Function() task, {bool high = false}) {
    final c = Completer<T>();
    final job = _RenderJob(() async {
      try {
        c.complete(await task());
      } catch (e, s) {
        c.completeError(e, s);
      }
    }, high);
    if (high) {
      final idx = _jobs.indexWhere((j) => !j.high);
      _jobs.insert(idx == -1 ? _jobs.length : idx, job);
    } else {
      _jobs.add(job);
    }
    _pump();
    return c.future;
  }

  Future<void> _pump() async {
    if (_pumping) return;
    _pumping = true;
    while (_jobs.isNotEmpty && !_disposed) {
      await _jobs.removeAt(0).run();
    }
    _pumping = false;
  }

  Future<Uint8List?> _renderBytes(int index, double targetDpi) async {
    final bytes = _pdfBytes;
    if (bytes == null || _disposed) return null;
    await for (final page in Printing.raster(bytes, pages: [index], dpi: targetDpi)) {
      return await page.toPng();
    }
    return null;
  }

  Future<void> _render(int i) async {
    if (_pdfBytes == null || _cache.containsKey(i) || !_loading.add(i)) return;
    _failed.remove(i);
    try {
      final bytes = await _enqueue(() async {
        if (!_wanted.contains(i)) return null;
        return _renderBytes(i, 110);
      }, high: true);
      if (_disposed) return;
      if (bytes != null) {
        _cache[i] = bytes;
        _evict();
      } else if (_wanted.contains(i)) {
        _failed.add(i);
      }
    } catch (e) {
      debugPrint('Render halaman $i gagal: $e');
      _failed.add(i);
    } finally {
      _loading.remove(i);
      if (!_disposed) _tick.value++;
    }
  }

  void _evict() {
    while (_cache.length > _kCacheCapacity) {
      final victim = _cache.keys.firstWhere((k) => !_wanted.contains(k), orElse: () => -1);
      if (victim == -1) break;
      _cache.remove(victim);
    }
  }

  List<int> _visiblePages() {
    final base = _spread ? (_currentPage ~/ 2) * 2 : _currentPage;
    final n = _spread ? 2 : 1;
    return [for (var i = base; i < base + n && i < _totalPages; i++) i];
  }

  void _prefetch() {
    if (_pdfBytes == null || _totalPages == 0) return;
    final vis = _visiblePages();
    if (vis.isEmpty) return;

    final order = <int>[...vis];
    for (var d = 1; d <= 2; d++) {
      final after = vis.last + d;
      final before = vis.first - d;
      if (after < _totalPages) order.add(after);
      if (before >= 0) order.add(before);
    }
    _wanted = order.toSet();

    for (final i in order) {
      final b = _cache.remove(i);
      if (b != null) _cache[i] = b;
      _render(i);
    }
    _hiRes.removeWhere((k, _) => !vis.contains(k));
  }

  Future<void> _loadHiRes() async {
    if (_pdfBytes == null) return;
    for (final i in _visiblePages()) {
      if (_hiRes.containsKey(i) || !_hiLoading.add(i)) continue;
      try {
        final b = await _enqueue(() => _renderBytes(i, 160), high: true);
        if (_disposed) return;
        if (b != null && _visiblePages().contains(i)) {
          _hiRes[i] = b;
          _tick.value++;
        }
      } catch (e) {
        debugPrint('Render hi-res $i gagal: $e');
      } finally {
        _hiLoading.remove(i);
      }
    }
  }

  void _requestThumb(int i) {
    if (_pdfBytes == null || _thumbs.containsKey(i) || !_thumbLoading.add(i)) return;
    _enqueue(() => _renderBytes(i, 50)).then((b) {
      if (_disposed) return;
      if (b != null) {
        _thumbs[i] = b;
        _thumbTick.value++;
      }
    }).catchError((_) {}).whenComplete(() => _thumbLoading.remove(i));
  }

  int _pageToSpread(int page) => _spread ? page ~/ 2 : page;
  int get _spreadCount => _spread ? (_totalPages / 2).ceil() : _totalPages;

  void _goToSpread(int s) {
    if (s < 0 || s >= _spreadCount || !_pageController.hasClients) return;
    final current = _pageController.page?.round() ?? 0;
    if ((s - current).abs() > 3) {
      _pageController.jumpToPage(s);
    } else {
      _pageController.animateToPage(
        s,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _next() => _goToSpread(_pageToSpread(_currentPage) + 1);
  void _prev() => _goToSpread(_pageToSpread(_currentPage) - 1);

  void _goToPage(int pageNumber) {
    if (pageNumber < 1 || pageNumber > _totalPages) return;
    _goToSpread(_pageToSpread(pageNumber - 1));
  }

  void _onPageChanged(int spreadIndex) {
    final actual = _spread ? spreadIndex * 2 : spreadIndex;
    setState(() => _currentPage = actual);
    _pageInputController.text = '${actual + 1}';
    _zoomController.value = Matrix4.identity();
    _prefetch();
    _prefs?.setInt(_kLastPage, actual);
    if (!_isSoundMuted) HapticFeedback.lightImpact();
  }

  void _syncLayout(bool spread) {
    if (_lastSpread == spread) return;
    _lastSpread = spread;
    _spread = spread;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_pageController.hasClients) return;
      if (_spread) _currentPage = (_currentPage ~/ 2) * 2;
      _pageController.jumpToPage(_pageToSpread(_currentPage));
      _pageInputController.text = '${_currentPage + 1}';
      _prefetch();
      setState(() {});
    });
  }

  void _onZoomChanged() {
    final s = _zoomController.value.getMaxScaleOnAxis();
    if ((s - _zoom.value).abs() > 0.005) _zoom.value = s;
    final z = s > 1.01;
    if (z != _zoomed.value) _zoomed.value = z;
    _hiResTimer?.cancel();
    if (s > 1.4) {
      _hiResTimer = Timer(const Duration(milliseconds: 300), _loadHiRes);
    }
  }

  void _zoomAround(double target, Offset focal) {
    final cur = _zoomController.value.getMaxScaleOnAxis();
    if (target <= 1.001) {
      _zoomController.value = Matrix4.identity();
      return;
    }
    final k = target / cur;
    _zoomController.value = Matrix4.identity()
      ..setTranslationRaw(focal.dx, focal.dy, 0)
      ..multiply(Matrix4.diagonal3Values(k, k, 1))
      ..multiply(Matrix4.translationValues(-focal.dx, -focal.dy, 0))
      ..multiply(_zoomController.value);
  }

  void _zoomBy(double delta) {
    final cur = _zoomController.value.getMaxScaleOnAxis();
    final target = (cur + delta).clamp(1.0, _kMaxZoom).toDouble();
    _zoomAround(target, _viewport.center(Offset.zero));
  }

  void _resetZoom() => _zoomController.value = Matrix4.identity();

  void _saveBookmarks(Set<int> set) {
    _bookmarks.value = set;
    _prefs?.setStringList(_kBookmarks, (set.toList()..sort()).map((e) => '$e').toList());
  }

  bool get _currentIsBookmarked => _visiblePages().any(_bookmarks.value.contains);

  void _toggleBookmark() {
    final vis = _visiblePages();
    if (vis.isEmpty) return;
    final set = {..._bookmarks.value};
    final removing = vis.any(set.contains);
    if (removing) {
      set.removeAll(vis);
    } else {
      set.add(vis.first);
    }
    _saveBookmarks(set);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(removing ? 'Bookmark dihapus' : 'Halaman ${vis.first + 1} di-bookmark'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _setMode(ReadingMode m) {
    setState(() => _mode = m);
    _prefs?.setInt(_kModeKey, m.index);
  }

  void _setBrightness(double v) {
    setState(() => _brightness = v);
    _prefs?.setDouble(_kBrightnessKey, v);
  }

  void _toggleFullscreen() {
    setState(() => _isFullscreen = !_isFullscreen);
    SystemChrome.setEnabledSystemUIMode(
      _isFullscreen ? SystemUiMode.immersiveSticky : SystemUiMode.manual,
      overlays: _isFullscreen ? null : SystemUiOverlay.values,
    );
  }

  String _remainingLabel() {
    final vis = _visiblePages();
    if (vis.isEmpty) return '';
    final remaining = ((_totalPages - (vis.last + 1)) * _kMinutesPerPage).round();
    if (remaining <= 0) return 'Halaman terakhir';
    if (remaining < 60) return '± $remaining mnt lagi';
    return '± ${remaining ~/ 60} j ${remaining % 60} mnt lagi';
  }

  void _handleKey(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return;
    final k = event.logicalKey;
    if (k == LogicalKeyboardKey.arrowRight || k == LogicalKeyboardKey.pageDown) {
      _next();
    } else if (k == LogicalKeyboardKey.arrowLeft || k == LogicalKeyboardKey.pageUp) {
      _prev();
    } else if (k == LogicalKeyboardKey.home) {
      _goToPage(1);
    } else if (k == LogicalKeyboardKey.end) {
      _goToPage(_totalPages);
    } else if (k == LogicalKeyboardKey.escape && _isFullscreen) {
      _toggleFullscreen();
    }
  }

  void _handleTapUp(TapUpDetails d) {
    final w = _viewport.width;
    final x = d.localPosition.dx;
    FocusScope.of(context).unfocus();
    if (_zoomed.value || (x >= w * 0.25 && x <= w * 0.75)) {
      setState(() => _showToolbar = !_showToolbar);
    } else if (x < w * 0.25) {
      _prev();
    } else {
      _next();
    }
  }

  void _handleDoubleTap() {
    final cur = _zoomController.value.getMaxScaleOnAxis();
    _zoomAround(cur > 1.05 ? 1.0 : 2.5, _doubleTapPos);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = _mode == ReadingMode.dark
        ? const Color(0xFF121212)
        : _mode == ReadingMode.sepia
        ? const Color(0xFFE9DCC3)
        : (isDark ? const Color(0xFF1E1815) : const Color(0xFFF3EBE1));

    return KeyboardListener(
      focusNode: _keyboardFocusNode,
      autofocus: true,
      onKeyEvent: _handleKey,
      child: Scaffold(
        backgroundColor: bg,
        appBar: _isFullscreen
            ? null
            : AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
          backgroundColor: AppTheme.primaryBrown,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(_isSoundMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded),
              tooltip: _isSoundMuted ? 'Getar Di-mute' : 'Getar Saat Membalik',
              onPressed: () {
                setState(() => _isSoundMuted = !_isSoundMuted);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_isSoundMuted ? 'Efek getar dimatikan' : 'Efek getar diaktifkan'),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.fullscreen_rounded),
              tooltip: 'Mode Layar Penuh',
              onPressed: _toggleFullscreen,
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              _viewport = Size(constraints.maxWidth, constraints.maxHeight);
              final ready = !_isLoading && _errorMessage == null;
              if (ready) _syncLayout(constraints.maxWidth >= 700);

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: ready ? _handleTapUp : null,
                onDoubleTapDown: ready ? (d) => _doubleTapPos = d.localPosition : null,
                onDoubleTap: ready ? _handleDoubleTap : null,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_isLoading)
                      _buildLoadingSkeleton()
                    else if (_errorMessage != null)
                      _buildErrorView()
                    else
                      _buildFlipbookView(isDark),

                    if (ready && _brightness < 1.0)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: ColoredBox(color: Colors.black.withValues(alpha: 1 - _brightness)),
                        ),
                      ),

                    if (ready && _isFullscreen && _showToolbar)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton.filled(
                          style: IconButton.styleFrom(backgroundColor: Colors.black54),
                          icon: const Icon(Icons.fullscreen_exit_rounded, color: Colors.white),
                          tooltip: 'Keluar Layar Penuh',
                          onPressed: _toggleFullscreen,
                        ),
                      ),

                    if (ready && _showToolbar)
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 12,
                        child: _buildToolbar(isDark),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_stories_rounded, size: 50, color: AppTheme.primaryBrown),
          SizedBox(height: 12),
          CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBrown),
          ),
          SizedBox(height: 20),
          Text(
            'Membuka E-Book...',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryBrown),
          ),
          SizedBox(height: 4),
          Text(
            'Halaman dirender saat dibutuhkan.',
            style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 60, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Gagal memuat PDF',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppTheme.textDark),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _init();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBrown,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlipbookView(bool isDark) {
    return ValueListenableBuilder<bool>(
      valueListenable: _zoomed,
      builder: (context, zoomed, _) {
        return PageView.builder(
          controller: _pageController,
          physics: zoomed ? const NeverScrollableScrollPhysics() : const PageScrollPhysics(),
          itemCount: _spreadCount,
          onPageChanged: _onPageChanged,
          itemBuilder: (context, index) {
            final isCurrent = index == _pageToSpread(_currentPage);

            return AnimatedBuilder(
              animation: _pageController,
              builder: (context, _) {
                double value = 0.0;
                if (_pageController.position.haveDimensions) {
                  value = (_pageController.page ?? 0) - index;
                }

                final Widget content = _spread
                    ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: _buildSpreadView(index * 2, isDark),
                )
                    : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: _aspect,
                      child: _buildPageTile(index, isDark, singleShadow: true),
                    ),
                  ),
                );

                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(value * math.pi * (_spread ? 0.15 : 0.20)),
                  alignment: _spread
                      ? Alignment.center
                      : (value < 0 ? Alignment.centerLeft : Alignment.centerRight),
                  child: isCurrent
                      ? InteractiveViewer(
                    transformationController: _zoomController,
                    minScale: 1.0,
                    maxScale: _kMaxZoom,
                    child: content,
                  )
                      : content,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSpreadView(int leftIndex, bool isDark) {
    final rightIndex = leftIndex + 1;
    final hasRightPage = rightIndex < _totalPages;

    return Center(
      child: AspectRatio(
        aspectRatio: _aspect * 2,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(child: _buildPageTile(leftIndex, isDark, isLeftInSpread: true)),
              Container(
                width: 12,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.18),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.18),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: hasRightPage
                    ? _buildPageTile(rightIndex, isDark, isRightInSpread: true)
                    : Container(
                  color: isDark ? const Color(0xFF2A231F) : const Color(0xFFFAF6F0),
                  child: const Center(
                    child: Text(
                      'Halaman Terakhir',
                      style: TextStyle(color: AppTheme.textMuted, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageTile(
      int pageIndex,
      bool isDark, {
        bool isLeftInSpread = false,
        bool isRightInSpread = false,
        bool singleShadow = false,
      }) {
    if (pageIndex < 0 || pageIndex >= _totalPages) return const SizedBox();

    final radius = BorderRadius.only(
      topLeft: Radius.circular(isRightInSpread ? 0 : 16),
      bottomLeft: Radius.circular(isRightInSpread ? 0 : 16),
      topRight: Radius.circular(isLeftInSpread ? 0 : 16),
      bottomRight: Radius.circular(isLeftInSpread ? 0 : 16),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius,
        boxShadow: singleShadow
            ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ]
            : const [],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ValueListenableBuilder<int>(
              valueListenable: _tick,
              builder: (_, __, ___) => _buildPageContent(pageIndex),
            ),
            IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.04),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.03),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: isLeftInSpread ? null : 14,
              left: isLeftInSpread ? 14 : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${pageIndex + 1}',
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(int i) {
    final bytes = _hiRes[i] ?? _cache[i];
    if (bytes != null) {
      return ColorFiltered(
        colorFilter: _filterFor(_mode),
        child: Image.memory(
          bytes,
          fit: BoxFit.contain,
          gaplessPlayback: true,
          filterQuality: FilterQuality.medium,
        ),
      );
    }

    if (_failed.contains(i)) {
      return InkWell(
        onTap: () {
          _failed.remove(i);
          _render(i);
          _tick.value++;
        },
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh_rounded, color: AppTheme.primaryBrown),
                SizedBox(height: 6),
                Text(
                  'Gagal memuat.\nKetuk untuk coba lagi',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ColoredBox(
      color: _mode == ReadingMode.dark ? const Color(0xFF2A231F) : const Color(0xFFFAF6F0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBrown),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Halaman ${i + 1}',
              style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar(bool isDark) {
    final total = _totalPages;
    final double sliderValue = (_dragPage ?? (_currentPage + 1).toDouble()).clamp(1.0, math.max(1.0, total.toDouble()));
    final canPrev = _pageToSpread(_currentPage) > 0;
    final canNext = _pageToSpread(_currentPage) < _spreadCount - 1;

    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: (isDark ? Colors.grey.shade900 : Colors.white).withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.18), blurRadius: 16, offset: const Offset(0, 6)),
          ],
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.1) : AppTheme.borderCream,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  tooltip: 'Halaman Sebelumnya',
                  onPressed: canPrev ? _prev : null,
                ),
                Expanded(
                  child: total > 1
                      ? Slider(
                    value: sliderValue,
                    min: 1,
                    max: total.toDouble(),
                    divisions: total - 1,
                    label: '${sliderValue.round()}',
                    activeColor: AppTheme.primaryBrown,
                    onChanged: (v) => setState(() => _dragPage = v),
                    onChangeEnd: (v) {
                      setState(() => _dragPage = null);
                      _goToPage(v.round());
                    },
                  )
                      : const SizedBox(),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                  tooltip: 'Halaman Berikutnya',
                  onPressed: canNext ? _next : null,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    height: 32,
                    child: TextField(
                      controller: _pageInputController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppTheme.borderCream),
                        ),
                      ),
                      onSubmitted: (value) {
                        final p = int.tryParse(value);
                        if (p != null) _goToPage(p);
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '/ $total',
                    style: const TextStyle(fontSize: 12, color: AppTheme.textMuted, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    _remainingLabel(),
                    style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.grid_view_rounded, size: 20),
                  tooltip: 'Thumbnail & Bookmark',
                  onPressed: _showContents,
                ),
                ValueListenableBuilder<Set<int>>(
                  valueListenable: _bookmarks,
                  builder: (_, __, ___) => IconButton(
                    icon: Icon(
                      _currentIsBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      size: 22,
                      color: _currentIsBookmarked ? AppTheme.primaryBrown : null,
                    ),
                    tooltip: 'Bookmark Halaman Ini',
                    onPressed: _toggleBookmark,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.zoom_out_rounded, size: 20),
                  tooltip: 'Perkecil',
                  onPressed: () => _zoomBy(-0.5),
                ),
                ValueListenableBuilder<double>(
                  valueListenable: _zoom,
                  builder: (_, z, __) => GestureDetector(
                    onTap: _resetZoom,
                    child: SizedBox(
                      width: 40,
                      child: Text(
                        '${(z * 100).round()}%',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBrown,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.zoom_in_rounded, size: 20),
                  tooltip: 'Perbesar',
                  onPressed: () => _zoomBy(0.5),
                ),
                IconButton(
                  icon: const Icon(Icons.tune_rounded, size: 20),
                  tooltip: 'Mode Baca & Kecerahan',
                  onPressed: _showReadingSettings,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReadingSettings() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Mode Baca', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<ReadingMode>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(value: ReadingMode.light, label: Text('Terang'), icon: Icon(Icons.light_mode_rounded)),
                    ButtonSegment(value: ReadingMode.sepia, label: Text('Sepia'), icon: Icon(Icons.menu_book_rounded)),
                    ButtonSegment(value: ReadingMode.dark, label: Text('Gelap'), icon: Icon(Icons.dark_mode_rounded)),
                  ],
                  selected: {_mode},
                  onSelectionChanged: (s) {
                    _setMode(s.first);
                    setSheet(() {});
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text('Kecerahan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Row(
                children: [
                  const Icon(Icons.brightness_low_rounded, size: 20),
                  Expanded(
                    child: Slider(
                      value: _brightness,
                      min: 0.3,
                      max: 1.0,
                      activeColor: AppTheme.primaryBrown,
                      onChanged: (v) {
                        _setBrightness(v);
                        setSheet(() {});
                      },
                    ),
                  ),
                  const Icon(Icons.brightness_high_rounded, size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContents() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(ctx).size.height * 0.7,
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(
                labelColor: AppTheme.primaryBrown,
                indicatorColor: AppTheme.primaryBrown,
                tabs: [Tab(text: 'Halaman'), Tab(text: 'Bookmark')],
              ),
              Expanded(
                child: TabBarView(
                  children: [_buildThumbGrid(ctx), _buildBookmarkList(ctx)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _thumbImage(int i) {
    final bytes = _thumbs[i];
    if (bytes == null) {
      return const ColoredBox(
        color: Color(0xFFFAF6F0),
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    return Image.memory(bytes, fit: BoxFit.cover, gaplessPlayback: true);
  }

  Widget _buildThumbGrid(BuildContext sheetCtx) {
    final vis = _visiblePages();
    return ValueListenableBuilder<int>(
      valueListenable: _thumbTick,
      builder: (_, __, ___) => GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 110,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: _aspect * 0.85,
        ),
        itemCount: _totalPages,
        itemBuilder: (_, i) {
          _requestThumb(i);
          final isCurrent = vis.contains(i);
          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              Navigator.pop(sheetCtx);
              _goToPage(i + 1);
            },
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isCurrent ? AppTheme.primaryBrown : AppTheme.borderCream,
                        width: isCurrent ? 2.5 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox.expand(child: _thumbImage(i)),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${i + 1}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCurrent ? AppTheme.primaryBrown : AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookmarkList(BuildContext sheetCtx) {
    return AnimatedBuilder(
      animation: Listenable.merge([_bookmarks, _thumbTick]),
      builder: (_, __) {
        final list = _bookmarks.value.toList()..sort();
        if (list.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Belum ada bookmark.\nKetuk ikon bookmark di toolbar untuk menandai halaman.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textMuted),
              ),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: list.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, idx) {
            final page = list[idx];
            _requestThumb(page);
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(width: 40, height: 52, child: _thumbImage(page)),
              ),
              title: Text('Halaman ${page + 1}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                tooltip: 'Hapus bookmark',
                onPressed: () => _saveBookmarks({..._bookmarks.value}..remove(page)),
              ),
              onTap: () {
                Navigator.pop(sheetCtx);
                _goToPage(page + 1);
              },
            );
          },
        );
      },
    );
  }
}
