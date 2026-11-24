import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'home_effects.dart';

class MagicNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<MagicNavItem> items;

  const MagicNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  State<MagicNavBar> createState() => _MagicNavBarState();
}

class _MagicNavBarState extends State<MagicNavBar>
    with SingleTickerProviderStateMixin {
  // Mengatur cahaya yang berjalan di tepi atas bar.
  late final AnimationController _glow;

  @override
  void initState() {
    super.initState();
    _glow = AnimationController(vsync: this, duration: const Duration(seconds: 5));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _glow.stop();
    } else if (!_glow.isAnimating) {
      _glow.repeat();
    }
  }

  @override
  void dispose() {
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    final int currentIndex = widget.currentIndex;
    final double width = MediaQuery.of(context).size.width;
    final double itemWidth = width / items.length;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool reduce = MediaQuery.of(context).disableAnimations;

    final Color barTop =
        isDark ? const Color(0xFF2E2520) : const Color(0xFFFFF4E3);
    final Color barBottom =
        isDark ? const Color(0xFF231B17) : const Color(0xFFEBD8C3);
    final Color edgeLine = isDark
        ? Colors.white.withOpacity(0.08)
        : AppTheme.primaryBrown.withOpacity(0.28);
    final Color glowColor = isDark
        ? AppTheme.secondaryBeige.withOpacity(0.9)
        : AppTheme.primaryBrown.withOpacity(0.85);

    final Color inactiveIcon = isDark
        ? AppTheme.accentTan.withOpacity(0.55)
        : AppTheme.darkBrown.withOpacity(0.62);
    final Color inactiveLabel = isDark
        ? AppTheme.accentTan.withOpacity(0.45)
        : AppTheme.darkBrown.withOpacity(0.55);

    return FadeSlideIn(
      delay: const Duration(milliseconds: 200),
      duration: const Duration(milliseconds: 650),
      offset: const Offset(0, 40),
      child: SizedBox(
        height: 85,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(end: currentIndex.toDouble()),
          duration: reduce ? Duration.zero : const Duration(milliseconds: 520),
          curve: Curves.easeOutCubic,
          builder: (context, pos, _) {
            final double centerX = pos * itemWidth + itemWidth / 2;
            // Seberapa jauh lekukan masih "bergerak" (0 = diam, 1 = jauh).
            final double stretch = (pos - currentIndex).abs().clamp(0.0, 1.0);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Bar (tanpa bayangan)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CustomPaint(
                    size: Size(width, 70),
                    painter: NavPainter(
                      centerX: centerX,
                      stretch: stretch,
                      topColor: barTop,
                      bottomColor: barBottom,
                      edgeColor: edgeLine,
                      glowColor: glowColor,
                      glow: _glow,
                    ),
                  ),
                ),

                // Percikan kecil saat pindah tab
                if (!reduce)
                  Positioned(
                    left: centerX - 60,
                    top: 40.5 - 60,
                    width: 120,
                    height: 120,
                    child: IgnorePointer(
                      child: TweenAnimationBuilder<double>(
                        key: ValueKey(currentIndex),
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 750),
                        curve: Curves.easeOutCubic,
                        builder: (context, t, _) => CustomPaint(
                          painter: _BurstPainter(
                            t,
                            AppTheme.primaryBrown,
                            AppTheme.secondaryBeige,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Lingkaran aktif
                Positioned(
                  left: centerX - 27.5,
                  top: 13,
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          AppTheme.secondaryBeige,
                          AppTheme.primaryBrown,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.55),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                // Item navigasi
                Row(
                  children: items.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final MagicNavItem item = entry.value;
                    final bool isActive = currentIndex == index;

                    final Icon icon = Icon(
                      item.icon,
                      color: isActive ? Colors.white : inactiveIcon,
                      size: isActive ? 20 : 24,
                    );

                    return Expanded(
                      child: PressScale(
                        pressedScale: 0.88,
                        child: GestureDetector(
                          onTap: () => widget.onTap(index),
                          behavior: HitTestBehavior.opaque,
                          child: SizedBox(
                            height: 85,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 320),
                                  curve: Curves.easeOutBack,
                                  margin: EdgeInsets.only(
                                      bottom: isActive ? 8 : 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Ikon aktif: putar + membal saat dipilih
                                      isActive && !reduce
                                          ? TweenAnimationBuilder<double>(
                                              key: ValueKey('pop$currentIndex'),
                                              tween: Tween<double>(
                                                  begin: 0, end: 1),
                                              duration: const Duration(
                                                  milliseconds: 650),
                                              curve: Curves.easeOutBack,
                                              builder: (context, v, child) =>
                                                  Transform.rotate(
                                                angle: (1 - v) * -0.9,
                                                child: Transform.scale(
                                                  scale: 0.5 + 0.5 * v,
                                                  child: child,
                                                ),
                                              ),
                                              child: icon,
                                            )
                                          : icon,
                                      if (isActive) ...[
                                        const SizedBox(height: 1),
                                        Text(
                                          item.label,
                                          style: const TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                if (!isActive)
                                  Positioned(
                                    bottom: 12,
                                    child: Text(
                                      item.label,
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: inactiveLabel,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Percikan titik yang memancar dari lingkaran aktif lalu memudar.
class _BurstPainter extends CustomPainter {
  final double t;
  final Color a;
  final Color b;

  _BurstPainter(this.t, this.a, this.b);

  @override
  void paint(Canvas canvas, Size size) {
    final Offset c = size.center(Offset.zero);
    final double fade = (1 - t).clamp(0.0, 1.0);

    // cincin tipis yang melebar
    canvas.drawCircle(
      c,
      27.5 + 26 * t,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = a.withOpacity(0.35 * fade),
    );

    // titik-titik memancar
    const int n = 8;
    for (int i = 0; i < n; i++) {
      final double ang = (i / n) * 2 * math.pi + 0.4;
      final double r = 30 + 26 * t;
      final Offset p = c + Offset(math.cos(ang) * r, math.sin(ang) * r);
      canvas.drawCircle(
        p,
        3.2 * fade + 0.4,
        Paint()..color = (i.isEven ? a : b).withOpacity(0.85 * fade),
      );
    }
  }

  @override
  bool shouldRepaint(_BurstPainter old) => old.t != t;
}

class NavPainter extends CustomPainter {
  final double centerX;
  final double stretch;
  final Color topColor;
  final Color bottomColor;
  final Color edgeColor;
  final Color glowColor;
  final Animation<double> glow;

  NavPainter({
    required this.centerX,
    required this.stretch,
    required this.topColor,
    required this.bottomColor,
    required this.edgeColor,
    required this.glowColor,
    required this.glow,
  }) : super(repaint: glow);

  @override
  void paint(Canvas canvas, Size size) {
    // Lekukan melebar & sedikit dangkal saat bergerak (efek "cairan")
    final double dipWidth = 65 * (1 + 0.32 * stretch);
    final double dipHeight = 48 - 7 * stretch;

    final Path top = Path();
    top.moveTo(0, 0);
    top.lineTo(centerX - (dipWidth + 5), 0);
    top.cubicTo(
      centerX - dipWidth / 2, 0,
      centerX - dipWidth / 2, dipHeight,
      centerX, dipHeight,
    );
    top.cubicTo(
      centerX + dipWidth / 2, dipHeight,
      centerX + dipWidth / 2, 0,
      centerX + (dipWidth + 5), 0,
    );
    top.lineTo(size.width, 0);

    final Path path = Path.from(top)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final Rect rect = Offset.zero & size;
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.fill
        ..shader = LinearGradient(
          colors: [topColor, bottomColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rect),
    );

    // Garis tepi tipis
    canvas.drawPath(
      top,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = edgeColor,
    );

    // Cahaya yang berjalan di tepi atas dari kiri ke kanan
    final double gx = -80 + (size.width + 160) * glow.value;
    final Rect gr = Rect.fromLTWH(gx - 70, 0, 140, dipHeight + 4);
    canvas.drawPath(
      top,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round
        ..shader = LinearGradient(
          colors: [
            glowColor.withOpacity(0),
            glowColor,
            glowColor.withOpacity(0),
          ],
        ).createShader(gr),
    );
  }

  @override
  bool shouldRepaint(NavPainter old) =>
      old.centerX != centerX ||
      old.stretch != stretch ||
      old.topColor != topColor ||
      old.bottomColor != bottomColor ||
      old.edgeColor != edgeColor ||
      old.glowColor != glowColor;
}

class MagicNavItem {
  final IconData icon;
  final String label;

  MagicNavItem({required this.icon, required this.label});
}
