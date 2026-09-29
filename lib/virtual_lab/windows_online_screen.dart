import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'webview_stub.dart' if (dart.library.html) 'webview_web.dart' as platform_web;

class WindowsOnlineScreen extends StatefulWidget {
  const WindowsOnlineScreen({super.key});

  @override
  State<WindowsOnlineScreen> createState() => _WindowsOnlineScreenState();
}

class _WindowsOnlineScreenState extends State<WindowsOnlineScreen> {
  WebViewController? _controller;
  bool _isLoading = true;
  late final String _viewTypeId;

  @override
  void initState() {
    super.initState();
    _viewTypeId = 'windows-online-${DateTime.now().millisecondsSinceEpoch}';
    const targetUrl = 'https://win7simu.visnalize.com/';

    if (kIsWeb) {
      platform_web.registerWebView(_viewTypeId, targetUrl);
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
        ..loadRequest(Uri.parse(targetUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Windows Simulator (In-App)"),
        backgroundColor: const Color(0xFFAD8B73),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          kIsWeb 
              ? platform_web.getWebView(_viewTypeId) 
              : (_controller != null 
                  ? WebViewWidget(controller: _controller!) 
                  : const Center(child: Text("Gagal memuat Windows Simulator"))),
          if (!kIsWeb && _isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFFAD8B73)),
            ),
        ],
      ),
    );
  }
}
