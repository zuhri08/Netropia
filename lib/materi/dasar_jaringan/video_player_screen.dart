import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../virtual_lab/webview_stub.dart' if (dart.library.html) '../../virtual_lab/webview_web.dart' as platform_web;

class VideoPlayerScreen extends StatefulWidget {
  final String title;
  final String videoId;

  const VideoPlayerScreen({
    super.key,
    required this.title,
    required this.videoId,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  WebViewController? _controller;
  bool _isLoading = true;
  late String _viewTypeId;

  @override
  void initState() {
    super.initState();
    final embedUrl = 'https://www.youtube.com/embed/${widget.videoId}?autoplay=1';
    _viewTypeId = 'youtube-player-${widget.videoId}-${DateTime.now().millisecondsSinceEpoch}';

    if (kIsWeb) {
      platform_web.registerWebView(_viewTypeId, embedUrl);
      setState(() {
        _isLoading = false;
      });
    } else {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0xFF000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              setState(() => _isLoading = true);
            },
            onPageFinished: (String url) {
              setState(() => _isLoading = false);
            },
          ),
        )
        ..loadRequest(Uri.parse(embedUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFAD8B73),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Center(
            child: kIsWeb
                ? platform_web.getWebView(_viewTypeId)
                : (_controller != null
                    ? WebViewWidget(controller: _controller!)
                    : const Center(child: Text("Gagal memuat pemutar video"))),
          ),
          if (!kIsWeb && _isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFFAD8B73)),
            ),
        ],
      ),
    );
  }
}
