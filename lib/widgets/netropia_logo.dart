import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Gambar cadangan jika aset logo belum terdaftar di pubspec.yaml.
Widget _fallbackLogo(double size) {
  return Center(
    child: Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.2),
        child: Image.asset(
          'assets/icon/app_icon.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.hub_rounded, color: Color(0xFFAD8B73)),
        ),
      ),
    ),
  );
}

/// Logo animasi (GIF) untuk layar pembuka.
/// GIF diputar sekali (burung hantu melompat masuk -> sinyal muncul -> menyala),
/// lalu berhenti di bingkai terakhir. Cahaya lembut & riak sinyal di belakangnya
/// digambar dengan kode supaya tetap mulus di atas latar yang bergerak.
///
/// Aset: assets/icon/logo_animasi.gif
class NetropiaLogoGif extends StatefulWidget {
  const NetropiaLogoGif({super.key, this.width = 300});

  final double width;

  @override
  State<NetropiaLogoGif> createState() => _NetropiaLogoGifState();
}

class _NetropiaLogoGifState extends State<NetropiaLogoGif>
    with TickerProviderStateMixin {
  // Kanvas GIF 660x572; titik sinyal & pusat logo (fraksi kanvas)
  static const double _ratio = 572 / 660;
  static const Offset _pivot = Offset(0.5747, 0.347);

  late final AnimationController _rings;
  late final AnimationController _vis;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _rings = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _vis = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _timer = Timer(const Duration(milliseconds: 1950), () {
      if (mounted) _vis.forward();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _rings.stop();
    } else if (!_rings.isAnimating) {
      _rings.repeat();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rings.dispose();
    _vis.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double w = widget.width;
    final double h = w * _ratio;
    final double r = w * 0.5;

    return SizedBox(
      width: w,
      height: h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // cahaya lembut di belakang logo
          Positioned(
            left: w * 0.5 - r,
            top: h * 0.55 - r,
            width: r * 2,
            height: r * 2,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOut,
              builder: (context, v, child) =>
                  Opacity(opacity: v, child: child),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.30),
                      Colors.white.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // riak sinyal
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: Listenable.merge([_rings, _vis]),
                builder: (context, _) => CustomPaint(
                  painter: _RingsPainter(_pivot, _rings.value, _vis.value),
                ),
              ),
            ),
          ),

          // GIF animasi logo
          Positioned.fill(
            child: Image.asset(
              'assets/icon/logo_animasi.gif',
              fit: BoxFit.contain,
              gaplessPlayback: true,
              errorBuilder: (_, __, ___) => _fallbackLogo(w * 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

/// Logo statis (PNG) yang melayang pelan — untuk layar login.
class NetropiaLogoStatic extends StatelessWidget {
  const NetropiaLogoStatic({super.key, this.width = 160});

  final double width;

  @override
  Widget build(BuildContext context) {
    final double h = width * 884 / 1024;
    return SizedBox(
      width: width,
      height: h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -width * 0.15,
            right: -width * 0.15,
            top: -h * 0.15,
            bottom: -h * 0.15,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.28),
                    Colors.white.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Floating3(
              child: Image.asset(
                'assets/icon/logo_netropia.png',
                fit: BoxFit.contain,
                filterQuality: FilterQuality.medium,
                errorBuilder: (_, __, ___) => _fallbackLogo(width * 0.55),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Melayang naik-turun pelan (versi ringan, tanpa bergantung pada file lain).
class Floating3 extends StatefulWidget {
  const Floating3({super.key, required this.child});

  final Widget child;

  @override
  State<Floating3> createState() => _Floating3State();
}

class _Floating3State extends State<Floating3>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, math.sin(_c.value * 2 * math.pi) * 4),
        child: child,
      ),
    );
  }
}

class _RingsPainter extends CustomPainter {
  _RingsPainter(this.pivot, this.l, this.vis);

  final Offset pivot;
  final double l;
  final double vis;

  @override
  void paint(Canvas canvas, Size size) {
    if (vis <= 0) return;
    final Offset c = Offset(pivot.dx * size.width, pivot.dy * size.height);
    for (int k = 0; k < 2; k++) {
      final double p = (l + k * 0.5) % 1.0;
      canvas.drawCircle(
        c,
        size.width * (0.05 + 0.40 * p),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2
          ..color = const Color(0xFFFFD9A8).withOpacity((1 - p) * 0.4 * vis),
      );
    }
  }

  @override
  bool shouldRepaint(_RingsPainter old) =>
      old.l != l || old.vis != vis || old.pivot != pivot;
}

/// Garis pemuatan: cahaya amber yang meluncur bolak-balik.
class NetropiaLoadingBar extends StatefulWidget {
  const NetropiaLoadingBar({super.key, this.width = 150});

  final double width;

  @override
  State<NetropiaLoadingBar> createState() => _NetropiaLoadingBarState();
}

class _NetropiaLoadingBarState extends State<NetropiaLoadingBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double w = widget.width;
    final double seg = w * 0.4;
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        width: w,
        height: 5,
        child: Stack(
          children: [
            Container(color: Colors.white.withOpacity(0.22)),
            AnimatedBuilder(
              animation: _c,
              builder: (context, _) {
                final double x =
                    -seg + (w + seg) * Curves.easeInOut.transform(_c.value);
                return Positioned(
                  left: x,
                  width: seg,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0x00FFB347),
                          Color(0xFFFFB347),
                          Color(0x00FFB347),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
