import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

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
  late String _finalUrl;

  @override
  void initState() {
    super.initState();
    // Otomatis play model 3D (menggunakan parameter Sketchfab autostart)
    _finalUrl = _getAutoPlayUrl(widget.embedUrl);

    // Unique ID agar tidak terjadi tabrakan iFrame saat berpindah layar
    _viewTypeId = '3d-viewer-${widget.deviceName.replaceAll(' ', '-')}-${DateTime.now().millisecondsSinceEpoch}';
    
    if (kIsWeb) {
      // Registrasi iFrame melalui helper platform_web dengan URL auto-play
      platform_web.registerWebView(_viewTypeId, _finalUrl);
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
        ..loadRequest(Uri.parse(_finalUrl));
    }
  }

  String _getAutoPlayUrl(String url) {
    if (url.contains('?')) {
      if (!url.contains('autostart')) {
        return '$url&autostart=1&preload=1';
      }
    } else {
      return '$url?autostart=1&preload=1';
    }
    return url;
  }

  String _getShortDeviceDescription() {
    final name = widget.deviceName.toLowerCase();
    if (name.contains('wifi repeater') || name.contains('repeater')) {
      return 'Memperluas jangkauan sinyal Wi-Fi dari router utama ke area dead zone agar koneksi tetap stabil dan merata.';
    } else if (name.contains('router')) {
      return 'Meneruskan paket data antar dua atau lebih jaringan komputer (menghubungkan LAN ke internet WAN).';
    } else if (name.contains('switch')) {
      return 'Menghubungkan berbagai perangkat komputer dalam satu Local Area Network (LAN) berdasarkan alamat MAC.';
    } else {
      return 'Perangkat keras penting dalam infrastruktur Teknik Komputer dan Jaringan (TKJ) untuk transmisi data.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. 3D View di belakang sendiri (Full screen 100% dari atas ke bawah)
          Positioned.fill(child: _buildView()),

          if (!kIsWeb && _isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFFAD8B73)),
            ),

          // 2. Floating Top Navigation Bar di atas 3D (Dilindungi PointerInterceptor)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: PointerInterceptor(
              child: Container(
                color: const Color(0xFFAD8B73),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                          tooltip: 'Kembali',
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "3D View: ${widget.deviceName}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 3. Bottom Card (Mentok bawah & kiri-kanan, sudut atas melengkung, langsung isi pengertian)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: PointerInterceptor(
              child: Material(
                color: Theme.of(context).cardColor,
                elevation: 16,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFAD8B73).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.wifi_tethering_rounded, color: Color(0xFFAD8B73), size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.deviceName,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.titleLarge?.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getShortDeviceDescription(),
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.5,
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
