import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'home_effects.dart';

class MagicNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<MagicNavItem> items;

  /// Tab yang "tombolnya pindah ke atas" saat dipilih (mis. AI).
  /// Saat tab ini aktif: bar jadi lurus (tanpa lekukan), tombolnya hilang.
  final int? dockedIndex;

  const MagicNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.dockedIndex,
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
    final int n = items.length;
    final int currentIndex = widget.currentIndex;
    final int? di = widget.dockedIndex;
    final bool docked = di != null && currentIndex == di;
    final double width = MediaQuery.of(context).size.width;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool reduce = MediaQuery.of(context).disableAnimations;

    // Bar lebih terang daripada latar halaman (krem-pasir) supaya jelas terpisah.
    final Color barTop =
        isDark ? const Color(0xFF2E2520) : const Color(0xFFFFFCF6);
    final Color barBottom =
        isDark ? const Color(0xFF231B17) : const Color(0xFFFBEFDF);
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
          // dock: 0 = normal, 1 = tombol sudah "pindah ke atas" (bar lurus)
          tween: Tween<double>(end: docked ? 1.0 : 0.0),
          duration: reduce ? Duration.zero : const Duration(milliseconds: 550),
          curve: Curves.easeInOutCubic,
          builder: (context, dock, _) {
            // Lebar tiap slot (slot yang "docked" menyusut sampai 0)
            final double baseW = width / n;
            final List<double> widths = List<double>.generate(n, (i) {
              if (di == null) return baseW;
              final double dockedW = baseW * (1 - dock);
              return i == di ? dockedW : (width - dockedW) / (n - 1);
            });
            final List<double> lefts = List<double>.filled(n, 0);
            for (int i = 1; i < n; i++) {
              lefts[i] = lefts[i - 1] + widths[i - 1];
            }
            double centerOf(int i) => lefts[i] + widths[i] / 2;

            return TweenAnimationBuilder<double>(
              tween: Tween<double>(end: currentIndex.toDouble()),
              duration:
                  reduce ? Duration.zero : const Duration(milliseconds: 520),
              curve: Curves.easeOutCubic,
              builder: (context, pos, _) {
                final int i0 = pos.floor().clamp(0, n - 1);
                final int i1 = pos.ceil().clamp(0, n - 1);
                final double centerX = centerOf(i0) +
                    (centerOf(i1) - centerOf(i0)) * (pos - i0).clamp(0.0, 1.0);
                final double stretch =
                    (pos - currentIndex).abs().clamp(0.0, 1.0);
                final double dipScale = 1 - dock;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Bar (tanpa bayangan; jadi lurus saat docked)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: CustomPaint(
                        size: Size(width, 70),
                        painter: NavPainter(
                          centerX: centerX,
                          stretch: stretch,
                          dipScale: dipScale,
                          topColor: barTop,
                          bottomColor: barBottom,
                          edgeColor: edgeLine,
                          glowColor: glowColor,
                          glow: _glow,
                        ),
                      ),
                    ),

                    // Percikan kecil saat pindah tab
                    if (!reduce && !docked)
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

                    // Lingkaran aktif (mengecil & hilang saat docked)
                    if (dock < 1)
                      Positioned(
                        left: centerX - 27.5,
                        top: 13,
                        child: Transform.scale(
                          scale: dipScale,
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
                      ),

                    // Item navigasi
                    Row(
                      children: items.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final MagicNavItem item = entry.value;
                        final bool isActive = currentIndex == index;
                        final bool isDockSlot = di != null && index == di;

                        final Icon icon = Icon(
                          item.icon,
                          color: isActive ? Colors.white : inactiveIcon,
                          size: isActive ? 20 : 24,
                        );

                        Widget slot = PressScale(
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
                                        isActive && !reduce && !isDockSlot
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
                        );

                        if (isDockSlot) {
                          slot = IgnorePointer(
                            ignoring: dock > 0.5,
                            child: Opacity(
                              opacity: (1 - dock).clamp(0.0, 1.0),
                              child: slot,
                            ),
                          );
                        }

                        return SizedBox(width: widths[index], child: slot);
                      }).toList(),
                    ),
                  ],
                );
              },
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

    canvas.drawCircle(
      c,
      27.5 + 26 * t,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = a.withOpacity(0.35 * fade),
    );

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
  final double dipScale; // 1 = ada lekukan, 0 = bar lurus
  final Color topColor;
  final Color bottomColor;
  final Color edgeColor;
  final Color glowColor;
  final Animation<double> glow;

  NavPainter({
    required this.centerX,
    required this.stretch,
    required this.dipScale,
    required this.topColor,
    required this.bottomColor,
    required this.edgeColor,
    required this.glowColor,
    required this.glow,
  }) : super(repaint: glow);

  @override
  void paint(Canvas canvas, Size size) {
    // Lekukan melebar & sedikit dangkal saat bergerak (efek "cairan")
    final double dipWidth = 65 * (1 + 0.32 * stretch) * dipScale;
    final double dipHeight = (48 - 7 * stretch) * dipScale;

    final Path top = Path();
    top.moveTo(0, 0);
    top.lineTo(centerX - (dipWidth + 5 * dipScale), 0);
    top.cubicTo(
      centerX - dipWidth / 2, 0,
      centerX - dipWidth / 2, dipHeight,
      centerX, dipHeight,
    );
    top.cubicTo(
      centerX + dipWidth / 2, dipHeight,
      centerX + dipWidth / 2, 0,
      centerX + (dipWidth + 5 * dipScale), 0,
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
      old.dipScale != dipScale ||
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
