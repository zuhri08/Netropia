import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Kunci untuk ikon di AppBar layar AI (tujuan pendaratan animasi).
final GlobalKey aiBarIconKey = GlobalKey();

/// true selama ikon terbang masih di udara (ikon asli di AppBar disembunyikan).
final ValueNotifier<bool> aiBarIconHidden = ValueNotifier<bool>(false);

/// Bungkus ikon di AppBar layar AI: disembunyikan saat animasi terbang,
/// lalu "pop" membal begitu ikon terbang mendarat.
class AiBarIconSlot extends StatelessWidget {
  const AiBarIconSlot({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: aiBarIconHidden,
      child: child,
      builder: (context, hidden, ch) {
        if (hidden) return Opacity(opacity: 0, child: ch);
        return TweenAnimationBuilder<double>(
          key: const ValueKey('ai-icon-landed'),
          tween: Tween<double>(begin: 0.55, end: 1.0),
          duration: const Duration(milliseconds: 750),
          curve: Curves.elasticOut,
          builder: (context, v, c) => Transform.scale(scale: v, child: c),
          child: ch,
        );
      },
    );
  }
}

/// Jalankan animasi: ikon AI terpental dari tombol navigasi ke kiri atas,
/// di sebelah judul "Netropia AI".
void flyAiIcon(BuildContext context, {required Offset start, required Offset end}) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;
  aiBarIconHidden.value = true;

  entry = OverlayEntry(
    builder: (_) => _AiFlyer(
      start: start,
      end: end,
      onLanded: () => aiBarIconHidden.value = false,
      onDone: () {
        entry.remove();
        aiBarIconHidden.value = false;
      },
    ),
  );
  overlay.insert(entry);
}

class _AiFlyer extends StatefulWidget {
  const _AiFlyer({
    required this.start,
    required this.end,
    required this.onLanded,
    required this.onDone,
  });

  final Offset start;
  final Offset end;
  final VoidCallback onLanded;
  final VoidCallback onDone;

  @override
  State<_AiFlyer> createState() => _AiFlyerState();
}

class _AiFlyerState extends State<_AiFlyer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  bool _landed = false;

  static const double _startD = 55;
  static const double _endD = 32;
  static const double _landAt = 0.84;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1050),
    )..addListener(() {
        if (!_landed && _c.value >= _landAt) {
          _landed = true;
          widget.onLanded();
        }
      });
    _c.forward().whenComplete(widget.onDone);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  // Lintasan melengkung (kurva Bezier) naik lalu ke kiri atas.
  Offset _pos(double p) {
    final s = widget.start;
    final e = widget.end;
    final ctrl = Offset(
      e.dx + (s.dx - e.dx) * 0.35,
      math.min(s.dy, e.dy) - 70,
    );
    final q = 1 - p;
    return Offset(
      q * q * s.dx + 2 * q * p * ctrl.dx + p * p * e.dx,
      q * q * s.dy + 2 * q * p * ctrl.dy + p * p * e.dy,
    );
  }

  Widget _bubble(double d, double opacity, {bool withIcon = true}) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [AppTheme.secondaryBeige, AppTheme.primaryBrown],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBrown.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: withIcon
            ? Icon(Icons.psychology_rounded, color: Colors.white, size: d * 0.5)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final t = _c.value;
          final p = Curves.easeOutBack.transform(t);
          final pos = _pos(p);
          // kecil (seukuran ikon di bar) -> membesar saat melesat -> 32 saat mendarat
          final double d = t < 0.3
              ? 28 + (_startD - 28) * Curves.easeOut.transform(t / 0.3)
              : _startD +
                  (_endD - _startD) * Curves.easeInOut.transform((t - 0.3) / 0.7);

          // peregangan & penyempitan saat melesat (squash & stretch)
          final stretch = math.sin(math.pi * t);
          final sx = 1 - 0.16 * stretch;
          final sy = 1 + 0.22 * stretch;
          final spin = -2 * math.pi * Curves.easeOutCubic.transform(t);

          // memudar di akhir (ikon asli di AppBar muncul menggantikan)
          final fade = t < _landAt ? 1.0 : 1 - (t - _landAt) / (1 - _landAt);

          final children = <Widget>[];

          // jejak bayangan di belakang
          for (int k = 3; k >= 1; k--) {
            final tk = (t - 0.05 * k).clamp(0.0, 1.0);
            if (tk <= 0 || t > 0.9) continue;
            final pk = _pos(Curves.easeOutBack.transform(tk));
            final dk = d * (1 - 0.12 * k);
            children.add(Positioned(
              left: pk.dx - dk / 2,
              top: pk.dy - dk / 2,
              child: _bubble(dk, 0.22 * (1 - k / 4), withIcon: false),
            ));
          }

          // cincin kecil saat mendarat
          if (t >= _landAt) {
            final r = (t - _landAt) / (1 - _landAt);
            final rd = _endD + 34 * r;
            children.add(Positioned(
              left: widget.end.dx - rd / 2,
              top: widget.end.dy - rd / 2,
              child: Container(
                width: rd,
                height: rd,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.6 * (1 - r)),
                    width: 2,
                  ),
                ),
              ),
            ));
          }

          // ikon utama
          children.add(Positioned(
            left: pos.dx - d / 2,
            top: pos.dy - d / 2,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..scale(sx, sy)
                ..rotateZ(spin),
              child: _bubble(d, fade),
            ),
          ));

          return Stack(clipBehavior: Clip.none, children: children);
        },
      ),
    );
  }
}
