import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Kumpulan animasi & efek untuk halaman Beranda.
/// Semua murni Flutter (tanpa package tambahan) dan otomatis berhenti
/// kalau pengguna mengaktifkan "Reduce motion / Remove animations".

bool _reduceMotion(BuildContext context) =>
    MediaQuery.of(context).disableAnimations;

// ---------------------------------------------------------------------------
// 1. FadeSlideIn – muncul dengan fade + geser + (opsional) zoom, ada delay
//    untuk efek berurutan (stagger).
// ---------------------------------------------------------------------------
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.offset = const Offset(0, 28),
    this.scaleFrom = 1.0,
    this.curve = Curves.easeOutCubic,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;
  final double scaleFrom;
  final Curve curve;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    _timer = Timer(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_reduceMotion(context)) return widget.child;

    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) {
        final v = _animation.value;
        return Opacity(
          opacity: v.clamp(0.0, 1.0).toDouble(),
          child: Transform.translate(
            offset: Offset(
              widget.offset.dx * (1 - v),
              widget.offset.dy * (1 - v),
            ),
            child: Transform.scale(
              scale: widget.scaleFrom + (1 - widget.scaleFrom) * v,
              child: child,
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// 2. PressScale – efek mengecil sedikit saat ditekan (tidak mengganggu onTap).
// ---------------------------------------------------------------------------
class PressScale extends StatefulWidget {
  const PressScale({
    super.key,
    required this.child,
    this.pressedScale = 0.95,
  });

  final Widget child;
  final double pressedScale;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _down = false;
  Offset _start = Offset.zero;

  void _set(bool value) {
    if (_down != value) setState(() => _down = value);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) {
        _start = e.localPosition;
        _set(true);
      },
      onPointerMove: (e) {
        // Kalau jari mulai scroll, lepas efek tekan.
        if ((e.localPosition - _start).distance > 12) _set(false);
      },
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _down ? widget.pressedScale : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. CountUpText – angka naik dari 0 ke nilai tujuan.
// ---------------------------------------------------------------------------
class CountUpText extends StatelessWidget {
  const CountUpText({
    super.key,
    required this.value,
    this.suffix = '',
    this.style,
    this.duration = const Duration(milliseconds: 1600),
    this.curve = Curves.easeOutCubic,
  });

  final int value;
  final String suffix;
  final TextStyle? style;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value.toDouble()),
      duration: _reduceMotion(context) ? Duration.zero : duration,
      curve: curve,
      builder: (context, v, _) => Text('${v.round()}$suffix', style: style),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. Pulse – denyut membesar-mengecil terus menerus (api streak, badge, dll).
// ---------------------------------------------------------------------------
class Pulse extends StatefulWidget {
  const Pulse({
    super.key,
    required this.child,
    this.minScale = 0.92,
    this.maxScale = 1.14,
    this.duration = const Duration(milliseconds: 900),
  });

  final Widget child;
  final double minScale;
  final double maxScale;
  final Duration duration;

  @override
  State<Pulse> createState() => _PulseState();
}

class _PulseState extends State<Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scale = Tween<double>(begin: widget.minScale, end: widget.maxScale)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_reduceMotion(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ScaleTransition(scale: _scale, child: widget.child);
}

// ---------------------------------------------------------------------------
// 5. Floating – melayang naik-turun (atau kiri-kanan) pelan.
// ---------------------------------------------------------------------------
class Floating extends StatefulWidget {
  const Floating({
    super.key,
    required this.child,
    this.amplitude = 5,
    this.duration = const Duration(milliseconds: 2800),
    this.axis = Axis.vertical,
  });

  final Widget child;
  final double amplitude;
  final Duration duration;
  final Axis axis;

  @override
  State<Floating> createState() => _FloatingState();
}

class _FloatingState extends State<Floating>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_reduceMotion(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final d = math.sin(_controller.value * 2 * math.pi) * widget.amplitude;
        return Transform.translate(
          offset: widget.axis == Axis.vertical ? Offset(0, d) : Offset(d, 0),
          child: child,
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// 6. RingingBell – lonceng bergoyang berkala (untuk notifikasi belum dibaca).
// ---------------------------------------------------------------------------
class RingingBell extends StatefulWidget {
  const RingingBell({super.key, required this.child});

  final Widget child;

  @override
  State<RingingBell> createState() => _RingingBellState();
}

class _RingingBellState extends State<RingingBell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_reduceMotion(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        const active = 0.28;
        final t = _controller.value;
        final angle = t > active
            ? 0.0
            : math.sin(t / active * math.pi * 6) * 0.38 * (1 - t / active);
        return Transform.rotate(
          angle: angle,
          alignment: Alignment.topCenter,
          child: child,
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// 7. WavingHand – emoji 👋 yang benar-benar melambai.
// ---------------------------------------------------------------------------
class WavingHand extends StatefulWidget {
  const WavingHand({super.key, this.fontSize = 25});

  final double fontSize;

  @override
  State<WavingHand> createState() => _WavingHandState();
}

class _WavingHandState extends State<WavingHand>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2600));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_reduceMotion(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        const active = 0.55;
        final t = _controller.value;
        final angle = t > active
            ? 0.0
            : math.sin(t / active * math.pi * 4) * 0.42 * (1 - 0.35 * t / active);
        return Transform.rotate(
          angle: angle,
          alignment: Alignment.bottomRight,
          child: Text('👋', style: TextStyle(fontSize: widget.fontSize)),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// 8. AnimatedHeroCard – kartu utama dengan gradient yang berputar pelan,
//    gelembung melayang, dan kilau (shimmer) yang menyapu berkala.
// ---------------------------------------------------------------------------
class AnimatedHeroCard extends StatefulWidget {
  const AnimatedHeroCard({
    super.key,
    required this.colors,
    required this.child,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(18),
    this.margin,
    this.shadowColor = const Color(0xFFAD8B73),
    this.shadowOpacity = 0.28,
  });

  final List<Color> colors;
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color shadowColor;
  final double shadowOpacity;

  @override
  State<AnimatedHeroCard> createState() => _AnimatedHeroCardState();
}

class _AnimatedHeroCardState extends State<AnimatedHeroCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 9));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_reduceMotion(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(widget.borderRadius);
    final reduce = _reduceMotion(context);

    return Container(
      margin: widget.margin,
      child: AnimatedBuilder(
        animation: _controller,
        child: Padding(padding: widget.padding, child: widget.child),
        builder: (context, child) {
          final t = reduce ? 0.0 : _controller.value;
          final a = t * 2 * math.pi;
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.colors,
                begin: Alignment(math.cos(a), math.sin(a)),
                end: Alignment(-math.cos(a), -math.sin(a)),
              ),
              borderRadius: radius,
              boxShadow: [
                BoxShadow(
                  color: widget.shadowColor.withOpacity(widget.shadowOpacity),
                  blurRadius: 16 + 6 * math.sin(a),
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: CustomPaint(
                painter: _HeroPainter(t),
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Bubble {
  const _Bubble(this.x, this.y, this.r, this.phase, this.ampX, this.ampY,
      this.speed, this.opacity);

  final double x, y; // posisi dasar (fraksi lebar/tinggi)
  final double r; // radius px
  final double phase; // 0..1
  final double ampX, ampY; // jarak ayun (fraksi)
  final int speed; // harus integer supaya loop mulus
  final double opacity;
}

class _HeroPainter extends CustomPainter {
  _HeroPainter(this.t);

  final double t;

  static const _bubbles = <_Bubble>[
    _Bubble(0.88, 0.18, 46, 0.00, 0.05, 0.10, 1, 0.10),
    _Bubble(0.70, 0.85, 30, 0.30, 0.06, 0.08, 2, 0.09),
    _Bubble(0.10, 0.90, 38, 0.55, 0.05, 0.09, 1, 0.08),
    _Bubble(0.45, 0.10, 14, 0.80, 0.08, 0.12, 3, 0.12),
    _Bubble(0.96, 0.62, 18, 0.15, 0.03, 0.10, 2, 0.12),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Gelembung melayang
    for (final b in _bubbles) {
      final a = (t * b.speed + b.phase) * 2 * math.pi;
      final dx = (b.x + math.sin(a) * b.ampX) * size.width;
      final dy = (b.y + math.cos(a) * b.ampY) * size.height;
      paint.color = Colors.white.withOpacity(b.opacity);
      canvas.drawCircle(Offset(dx, dy), b.r, paint);
    }

    // Kilau yang menyapu dari kiri ke kanan (hanya di awal tiap siklus)
    const active = 0.28;
    if (t <= active) {
      final p = Curves.easeInOut.transform(t / active);
      final bandW = size.width * 0.35;
      final dx = -bandW * 1.5 + (size.width + bandW * 3) * p;
      final rect = Rect.fromLTWH(0, 0, bandW, size.height);

      canvas.save();
      canvas.translate(dx, 0);
      canvas.skew(-0.3, 0);
      final shimmer = Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0x00FFFFFF),
            Color(0x38FFFFFF),
            Color(0x00FFFFFF),
          ],
        ).createShader(rect);
      canvas.drawRect(rect, shimmer);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _HeroPainter oldDelegate) => oldDelegate.t != t;
}


// ---------------------------------------------------------------------------
// 9. AnimatedBackdrop – latar belakang hidup: gumpalan warna lembut yang
//    melayang pelan + titik-titik kecil yang naik seperti gelembung.
// ---------------------------------------------------------------------------
class AnimatedBackdrop extends StatefulWidget {
  const AnimatedBackdrop({super.key});

  @override
  State<AnimatedBackdrop> createState() => _AnimatedBackdropState();
}

class _AnimatedBackdropState extends State<AnimatedBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 28));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_reduceMotion(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          size: Size.infinite,
          painter: _BackdropPainter(_controller, isDark ? 0.35 : 1.0),
        ),
      ),
    );
  }
}

class _Blob {
  const _Blob(this.x, this.y, this.r, this.speed, this.phase, this.ampX,
      this.ampY, this.color, this.opacity);

  final double x, y; // posisi dasar (fraksi)
  final double r; // radius (fraksi lebar)
  final int speed; // integer supaya loop mulus
  final double phase;
  final double ampX, ampY;
  final Color color;
  final double opacity;
}

class _BackdropPainter extends CustomPainter {
  _BackdropPainter(this.anim, this.strength) : super(repaint: anim);

  final Animation<double> anim;
  final double strength;

  static const _blobs = <_Blob>[
    _Blob(0.90, 0.08, 0.62, 1, 0.00, 0.10, 0.05, Color(0xFFF0B993), 0.55),
    _Blob(0.05, 0.32, 0.55, 1, 0.35, 0.12, 0.06, Color(0xFFF6DCA0), 0.60),
    _Blob(0.95, 0.58, 0.58, 2, 0.60, 0.08, 0.06, Color(0xFFE3A99D), 0.40),
    _Blob(0.05, 0.60, 0.50, 1, 0.15, 0.10, 0.04, Color(0xFFD9B79E), 0.45),
    _Blob(0.62, 0.30, 0.45, 2, 0.80, 0.08, 0.04, Color(0xFFF2CDA6), 0.45),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final double t = anim.value;
    final double w = size.width;
    final double h = size.height;

    // Gumpalan warna lembut
    for (final b in _blobs) {
      final double a = (t * b.speed + b.phase) * 2 * math.pi;
      final Offset c = Offset(
        (b.x + math.sin(a) * b.ampX) * w,
        (b.y + math.cos(a) * b.ampY) * h,
      );
      final double r = b.r * w;
      canvas.drawCircle(
        c,
        r,
        Paint()
          ..shader = RadialGradient(
            colors: [
              b.color.withOpacity(b.opacity * strength),
              b.color.withOpacity(0),
            ],
          ).createShader(Rect.fromCircle(center: c, radius: r)),
      );
    }

    // Gelembung kecil yang naik pelan
    const int n = 16;
    final Paint dot = Paint();
    for (int i = 0; i < n; i++) {
      final double progress = (t * (1 + i % 2) + i / n) % 1.0;
      final double x = ((i * 0.137 + 0.05) % 1.0) +
          math.sin((t * 3 + i * 0.3) * 2 * math.pi) * 0.02;
      final double y = 1.05 - progress * 1.1;
      final double edge = ((1.0 - y) * 6).clamp(0.0, 1.0); // pudar sebelum tepi bawah
      final double fade = math.sin(progress * math.pi) * edge;
      final double r = 2 + (i % 3) * 1.3;
      dot.color = const Color(0xFFAD8B73)
          .withOpacity((0.28 * fade * strength).clamp(0.0, 1.0));
      canvas.drawCircle(Offset(x * w, y * h), r, dot);
    }
  }

  @override
  bool shouldRepaint(_BackdropPainter old) => old.strength != strength;
}

// ---------------------------------------------------------------------------
// 10. BottomFade – tepi bawah konten memudar halus (tidak terpotong kasar).
// ---------------------------------------------------------------------------
class BottomFade extends StatelessWidget {
  const BottomFade({super.key, required this.child, this.height = 36});

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) {
        final double h = rect.height <= 0 ? 1.0 : rect.height;
        final double stop = ((h - height) / h).clamp(0.0, 1.0);
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [Colors.white, Colors.white, Colors.transparent],
          stops: [0.0, stop, 1.0],
        ).createShader(rect);
      },
      child: child,
    );
  }
}
