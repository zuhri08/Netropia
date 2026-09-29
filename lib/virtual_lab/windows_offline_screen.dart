import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'webview_stub.dart' if (dart.library.html) 'webview_web.dart' as platform_web;

class WindowsOfflineScreen extends StatefulWidget {
  const WindowsOfflineScreen({super.key});

  @override
  State<WindowsOfflineScreen> createState() => _WindowsOfflineScreenState();
}

class _WindowsOfflineScreenState extends State<WindowsOfflineScreen> {
  WebViewController? _controller;
  bool _isLoading = true;
  late final String _viewTypeId;

  @override
  void initState() {
    super.initState();
    _viewTypeId = 'windows-offline-${DateTime.now().millisecondsSinceEpoch}';
    const assetPath = 'lib/virtual_lab/windows/bsod.html';

    if (kIsWeb) {
      platform_web.registerWebView(_viewTypeId, 'assets/$assetPath');
      setState(() => _isLoading = false);
    } else {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) => setState(() => _isLoading = true),
            onPageFinished: (String url) => setState(() => _isLoading = false),
          ),
        )
        ..loadFlutterAsset(assetPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Windows Simulator (Offline)"),
        backgroundColor: const Color(0xFFAD8B73),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          kIsWeb 
              ? platform_web.getWebView(_viewTypeId) 
              : (_controller != null 
                  ? WebViewWidget(controller: _controller!) 
                  : const Center(child: Text("Gagal memuat Windows Offline"))),
          if (!kIsWeb && _isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFFAD8B73)),
            ),
        ],
      ),
    );
  }
}
