import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../theme/app_theme.dart';

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
  final TransformationController _transformationController = TransformationController();
  final FocusNode _keyboardFocusNode = FocusNode();

  List<Uint8List> _pageImages = [];
  bool _isLoading = true;
  String? _errorMessage;

  int _currentPage = 0;
  int _totalPages = 0;
  bool _isFullscreen = false;
  bool _isSoundMuted = false;
  bool _showToolbar = true;
  double _zoomLevel = 1.0;

  final TextEditingController _pageInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPdfPages();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    _keyboardFocusNode.dispose();
    _pageInputController.dispose();
    super.dispose();
  }

  Future<void> _loadPdfPages() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _pageImages = [];
      });

      final ByteData data = await rootBundle.load(widget.assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      final List<Uint8List> renderedPages = [];
      await for (final page in Printing.raster(bytes, dpi: 100)) {
        final imageBytes = await page.toPng();
        renderedPages.add(imageBytes);

        // Tampilkan halaman pertama secara instan (<0.3 detik)
        if (renderedPages.length == 1 && mounted) {
          setState(() {
            _pageImages = List.from(renderedPages);
            _totalPages = 1;
            _isLoading = false;
            _pageInputController.text = '1';
          });
        }
      }

      if (mounted) {
        setState(() {
          _pageImages = renderedPages;
          _totalPages = renderedPages.length;
          _isLoading = false;
        });
      }
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

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
      _pageInputController.text = '${index + 1}';
    });
    if (!_isSoundMuted) {
      HapticFeedback.lightImpact();
    }
  }

  void _goToPage(int pageNumber) {
    if (pageNumber < 1 || pageNumber > _totalPages) return;
    final index = pageNumber - 1;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  void _toggleZoom(bool zoomIn) {
    setState(() {
      if (zoomIn) {
        _zoomLevel = (_zoomLevel + 0.25).clamp(1.0, 3.0);
      } else {
        _zoomLevel = (_zoomLevel - 0.25).clamp(1.0, 3.0);
      }
      _transformationController.value = Matrix4.identity()..scale(_zoomLevel);
    });
  }

  void _resetZoom() {
    setState(() {
      _zoomLevel = 1.0;
      _transformationController.value = Matrix4.identity();
    });
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        if (_currentPage < _totalPages - 1) {
          _goToPage(_currentPage + 2);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        if (_currentPage > 0) {
          _goToPage(_currentPage);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return RawKeyboardListener(
      focusNode: _keyboardFocusNode,
      autofocus: true,
      onKey: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF1E1815) : const Color(0xFFF3EBE1),
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
                    tooltip: _isSoundMuted ? 'Suara Di-mute' : 'Suara Efek Membalik',
                    onPressed: () {
                      setState(() => _isSoundMuted = !_isSoundMuted);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_isSoundMuted ? 'Efek suara dimatikan' : 'Efek suara diaktifkan'),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(_isFullscreen ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded),
                    tooltip: 'Mode Layar Penuh',
                    onPressed: () {
                      setState(() => _isFullscreen = !_isFullscreen);
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              setState(() => _showToolbar = !_showToolbar);
            },
            child: Stack(
              children: [
                if (_isLoading)
                  _buildLoadingSkeleton()
                else if (_errorMessage != null)
                  _buildErrorView()
                else
                  _buildFlipbookView(isDark),

                if (!_isLoading && _errorMessage == null && _showToolbar)
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: _buildMinimalToolbar(isDark),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBrown.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_stories_rounded, size: 50, color: AppTheme.primaryBrown),
                SizedBox(height: 12),
                CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBrown),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Mempersiapkan Flipbook E-Book...',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBrown,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Merender halaman berkualitas tinggi untuk pengalaman membaca interaktif.',
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
              onPressed: _loadPdfPages,
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
    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: 1.0,
      maxScale: 3.0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktopSpread = constraints.maxWidth >= 700;

          return PageView.builder(
            controller: _pageController,
            itemCount: isDesktopSpread ? (_totalPages / 2).ceil() : _totalPages,
            onPageChanged: (spreadIndex) {
              final actualIndex = isDesktopSpread ? spreadIndex * 2 : spreadIndex;
              _onPageChanged(actualIndex);
            },
            itemBuilder: (context, index) {
              if (isDesktopSpread) {
                final leftPageIndex = index * 2;
                final rightPageIndex = leftPageIndex + 1;

                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 0.0;
                    if (_pageController.position.haveDimensions) {
                      value = (_pageController.page ?? 0) - index;
                    }

                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(value * math.pi * 0.15),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        child: _buildSpreadView(leftPageIndex, rightPageIndex, isDark),
                      ),
                    );
                  },
                );
              } else {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 0.0;
                    if (_pageController.position.haveDimensions) {
                      value = (_pageController.page ?? 0) - index;
                    }

                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(value * math.pi * 0.20),
                      alignment: value < 0 ? Alignment.centerLeft : Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: _buildSinglePageCard(index, isDark),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildSpreadView(int leftIndex, int rightIndex, bool isDark) {
    final hasRightPage = rightIndex < _totalPages;

    return Center(
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
            Expanded(
              child: _buildSinglePageCard(leftIndex, isDark, isLeftInSpread: true),
            ),
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
                  ? _buildSinglePageCard(rightIndex, isDark, isRightInSpread: true)
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
    );
  }

  Widget _buildSinglePageCard(int pageIndex, bool isDark,
      {bool isLeftInSpread = false, bool isRightInSpread = false}) {
    if (pageIndex < 0 || pageIndex >= _totalPages) {
      return const SizedBox();
    }

    final imageBytes = _pageImages[pageIndex];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isRightInSpread ? 0 : 16),
          bottomLeft: Radius.circular(isRightInSpread ? 0 : 16),
          topRight: Radius.circular(isLeftInSpread ? 0 : 16),
          bottomRight: Radius.circular(isLeftInSpread ? 0 : 16),
        ),
        boxShadow: isLeftInSpread || isRightInSpread
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isRightInSpread ? 0 : 16),
          bottomLeft: Radius.circular(isRightInSpread ? 0 : 16),
          topRight: Radius.circular(isLeftInSpread ? 0 : 16),
          bottomRight: Radius.circular(isLeftInSpread ? 0 : 16),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.memory(
                imageBytes,
                fit: BoxFit.contain,
              ),
            ),
            Positioned.fill(
              child: Container(
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalToolbar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: (isDark ? Colors.grey.shade900 : Colors.white).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : AppTheme.borderCream,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            tooltip: 'Halaman Sebelumnya',
            onPressed: _currentPage > 0 ? () => _goToPage(_currentPage) : null,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 36,
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
                '/ $_totalPages',
                style: const TextStyle(fontSize: 12, color: AppTheme.textMuted, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.zoom_out_rounded, size: 20),
                tooltip: 'Perkecil',
                onPressed: () => _toggleZoom(false),
              ),
              GestureDetector(
                onTap: _resetZoom,
                child: Text(
                  '${(_zoomLevel * 100).round()}%',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryBrown),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.zoom_in_rounded, size: 20),
                tooltip: 'Perbesar',
                onPressed: () => _toggleZoom(true),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
            tooltip: 'Halaman Berikutnya',
            onPressed: _currentPage < _totalPages - 1 ? () => _goToPage(_currentPage + 2) : null,
          ),
        ],
      ),
    );
  }
}
