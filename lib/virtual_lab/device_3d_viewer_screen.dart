import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Menggunakan conditional import untuk menghindari error kompilasi di Mobile
import 'webview_stub.dart' if (dart.library.html) 'webview_web.dart' as platform_web;

class Device3DViewerScreen extends StatefulWidget {
  final String deviceName;
  final String embedUrl;

  const Device3DViewerScreen({
    super.key,
    required this.deviceName,
    required this.embedUrl,
  });

  @override
  State<Device3DViewerScreen> createState() => _Device3DViewerScreenState();
}

class _Device3DViewerScreenState extends State<Device3DViewerScreen> {
  WebViewController? _controller;
  bool _isLoading = true;
  late String _viewTypeId;

  @override
  void initState() {
    super.initState();
    // Unique ID agar tidak terjadi tabrakan iFrame saat berpindah layar
    _viewTypeId = '3d-viewer-${widget.deviceName.replaceAll(' ', '-')}-${DateTime.now().millisecondsSinceEpoch}';
    
    if (kIsWeb) {
      // Registrasi iFrame melalui helper platform_web
      platform_web.registerWebView(_viewTypeId, widget.embedUrl);
      setState(() {
        _isLoading = false;
      });
    } else {
      // Konfigurasi WebView untuk Mobile (Android/iOS)
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
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
        ..loadRequest(Uri.parse(widget.embedUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("3D View: ${widget.deviceName}"),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          _buildView(),
          if (!kIsWeb && _isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFF1565C0)),
            ),
        ],
      ),
    );
  }

  Widget _buildView() {
    if (kIsWeb) {
      // Memanggil widget iFrame dari helper platform_web
      return platform_web.getWebView(_viewTypeId);
    }
    
    return _controller != null 
        ? WebViewWidget(controller: _controller!) 
        : const Center(child: Text("Gagal memuat viewer 3D (Mobile)"));
  }
}
