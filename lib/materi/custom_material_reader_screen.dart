import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class CustomMaterialReaderScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const CustomMaterialReaderScreen({
    super.key,
    required this.data,
  });

  @override
  State<CustomMaterialReaderScreen> createState() => _CustomMaterialReaderScreenState();
}

class _CustomMaterialReaderScreenState extends State<CustomMaterialReaderScreen> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkBookmarkStatus();
  }

  Future<void> _checkBookmarkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> bookmarks = prefs.getStringList('bookmarked_materials') ?? [];
    final String title = widget.data['judul'] ?? 'Materi Pembelajaran';

    if (mounted) {
      setState(() {
        _isBookmarked = bookmarks.contains(title);
      });
    }
  }

  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> bookmarks = prefs.getStringList('bookmarked_materials') ?? [];
    final String title = widget.data['judul'] ?? 'Materi Pembelajaran';
    final String content = widget.data['isi'] ?? '';

    if (_isBookmarked) {
      bookmarks.remove(title);
      await prefs.remove('cached_material_$title');
      if (mounted) {
        setState(() => _isBookmarked = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Materi dihapus dari bookmark.'), behavior: SnackBarBehavior.floating),
        );
      }
    } else {
      bookmarks.add(title);
      await prefs.setString('cached_material_$title', content);
      if (mounted) {
        setState(() => _isBookmarked = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Materi disimpan offline ke bookmark!'), behavior: SnackBarBehavior.floating),
        );
      }
    }
    await prefs.setStringList('bookmarked_materials', bookmarks);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final title = widget.data['judul'] ?? 'Materi Pembelajaran';
    final category = widget.data['kategori'] ?? 'Umum';
    final guruName = widget.data['guruName'] ?? 'Guru Netropia';
    final content = widget.data['isi'] ?? '';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Bacaan Materi', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryBrown,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: _isBookmarked ? AppTheme.accentAmber : Colors.white,
            ),
            tooltip: _isBookmarked ? 'Dihapus dari Bookmark' : 'Simpan Offline (Bookmark)',
            onPressed: _toggleBookmark,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.brownTint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.person_rounded, color: AppTheme.primaryBrown, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Diterbitkan oleh: $guruName',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                            color: isDark ? Colors.white : AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Kategori: $category',
                          style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.brownTint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'MATERI TEKS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBrown,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              content,
              style: TextStyle(
                fontSize: 14.5,
                height: 1.6,
                color: isDark ? Colors.grey.shade300 : AppTheme.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
