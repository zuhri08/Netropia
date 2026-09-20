import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

// Fungsi khusus platform Web untuk registrasi iFrame Sketchfab
void registerWebView(String viewId, String url) {
  // Menggunakan dart:ui_web untuk registrasi iFrame di Flutter Web versi baru
  ui_web.platformViewRegistry.registerViewFactory(
    viewId,
    (int viewId) => html.IFrameElement()
      ..src = url
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..allowFullscreen = true,
  );
}

Widget getWebView(String viewId) {
  return HtmlElementView(viewType: viewId);
}
