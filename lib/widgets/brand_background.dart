import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Latar bermerek (dipakai Loading Screen & Login): gradient cokelat yang
/// bergeser pelan, sorotan cahaya lembut, dan gelembung yang naik perlahan.
class BrandBackground extends StatefulWidget {
  const BrandBackground({super.key, this.child});

  final Widget? child;

  @override
  State<BrandBackground> createState() => _BrandBackgroundState();
}

class _BrandBackgroundState extends State<BrandBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 16));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
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
    return RepaintBoundary(
      child: CustomPaint(
        size: Size.infinite,
        painter: _BrandPainter(_controller),
        child: widget.child ?? const SizedBox.expand(),
      ),
    );
  }
}

class _BrandPainter extends CustomPainter {
  _BrandPainter(this.anim) : super(repaint: anim);

  final Animation<double> anim;

  @override
  void paint(Canvas canvas, Size size) {
    final double t = anim.value;
    final double w = size.width;
    final double h = size.height;
    final Rect rect = Offset.zero & size;

    // Gradient dasar (sama dengan warna loading screen), arahnya bergeser pelan
    final double a = math.pi / 4 + math.sin(t * 2 * math.pi) * 0.45;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          colors: const [AppTheme.primaryBrown, AppTheme.darkBrown],
          begin: Alignment(math.cos(a), math.sin(a)),
          end: Alignment(-math.cos(a), -math.sin(a)),
        ).createShader(rect),
    );

    // Sorotan cahaya lembut
    void glow(Offset c, double r, Color color) {
      canvas.drawCircle(
        c,
        r,
        Paint()
          ..shader = RadialGradient(
            colors: [color, color.withOpacity(0)],
          ).createShader(Rect.fromCircle(center: c, radius: r)),
      );
    }

    glow(
      Offset(w * 0.85 + math.sin(t * 2 * math.pi) * w * 0.05, h * 0.12),
      w * 0.85,
      Colors.white.withOpacity(0.22),
    );
    glow(
      Offset(w * 0.1, h * 0.92 + math.cos(t * 2 * math.pi) * h * 0.02),
      w * 0.75,
      const Color(0xFFF0C9A0).withOpacity(0.2),
    );

    // Gelembung yang naik pelan
    const int n = 18;
    final Paint fill = Paint()..style = PaintingStyle.fill;
    final Paint ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    for (int i = 0; i < n; i++) {
      final double speed = (i % 3 + 1).toDouble();
      final double progress = (t * speed + i / n) % 1.0;
      final double x = ((i * 0.211 + 0.07) % 1.0) * w +
          math.sin((t * 2 + i) * 2 * math.pi) * 14;
      final double y = h * (1.08 - progress * 1.2);
      final double r = 5 + (i * 7 % 20).toDouble();
      final double o = 0.08 + 0.12 * math.sin(progress * math.pi);
      if (i % 4 == 0) {
        ring.color = Colors.white.withOpacity(o + 0.04);
        canvas.drawCircle(Offset(x, y), r, ring);
      } else {
        fill.color = Colors.white.withOpacity(o);
        canvas.drawCircle(Offset(x, y), r, fill);
      }
    }
  }

  @override
  bool shouldRepaint(_BrandPainter old) => false;
}
