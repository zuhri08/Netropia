import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'home_effects.dart';

class MagicNavBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double itemWidth = width / items.length;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool reduce = MediaQuery.of(context).disableAnimations;

    // Bar krem-latte hangat yang menyatu dengan latar krem aplikasi.
    final Color barTop =
        isDark ? const Color(0xFF2E2520) : const Color(0xFFFFF7EA);
    final Color barBottom =
        isDark ? const Color(0xFF231B17) : const Color(0xFFEFDFCC);
    final Color edgeLine = isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.white.withOpacity(0.9);

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
          // Lekukan & lingkaran bergerak bersama supaya mulus.
          tween: Tween<double>(end: currentIndex.toDouble()),
          duration: reduce ? Duration.zero : const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
          builder: (context, pos, _) {
            final double centerX = pos * itemWidth + itemWidth / 2;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Latar bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CustomPaint(
                    size: Size(width, 70),
                    painter: NavPainter(
                      centerX: centerX,
                      topColor: barTop,
                      bottomColor: barBottom,
                      edgeColor: edgeLine,
                      isDark: isDark,
                    ),
                  ),
                ),

                // Riak halus yang melebar sekali saat pindah tab
                if (!reduce)
                  Positioned(
                    left: centerX - 27.5,
                    top: 13,
                    child: IgnorePointer(
                      child: TweenAnimationBuilder<double>(
                        key: ValueKey(currentIndex),
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 650),
                        curve: Curves.easeOut,
                        builder: (context, t, _) {
                          final double size = 55 + 40 * t;
                          return Transform.translate(
                            offset: Offset(-(size - 55) / 2, -(size - 55) / 2),
                            child: Container(
                              width: size,
                              height: size,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.primaryBrown
                                      .withOpacity(0.35 * (1 - t)),
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        },
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
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryBrown.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
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
                        pressedScale: 0.9,
                        child: GestureDetector(
                          onTap: () => onTap(index),
                          behavior: HitTestBehavior.opaque,
                          child: SizedBox(
                            height: 85,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutBack,
                                  margin: EdgeInsets.only(
                                      bottom: isActive ? 8 : 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Ikon aktif membal kecil saat dipilih
                                      isActive && !reduce
                                          ? TweenAnimationBuilder<double>(
                                              tween: Tween<double>(
                                                  begin: 0.6, end: 1.0),
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.easeOutBack,
                                              builder: (context, v, child) =>
                                                  Transform.scale(
                                                      scale: v, child: child),
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

class NavPainter extends CustomPainter {
  final double centerX;
  final Color topColor;
  final Color bottomColor;
  final Color edgeColor;
  final bool isDark;

  NavPainter({
    required this.centerX,
    required this.topColor,
    required this.bottomColor,
    required this.edgeColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double dipWidth = 65;
    const double dipHeight = 48;

    // Garis tepi atas (dipakai untuk bentuk & highlight)
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
    final Paint fill = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        colors: [topColor, bottomColor],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);

    // Bayangan hangat (cokelat), bukan hitam pekat
    canvas.drawShadow(
      path,
      isDark ? Colors.black : AppTheme.darkBrown,
      7,
      true,
    );
    canvas.drawPath(path, fill);

    // Highlight tipis di tepi atas
    canvas.drawPath(
      top,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = edgeColor,
    );
  }

  @override
  bool shouldRepaint(NavPainter old) =>
      old.centerX != centerX ||
      old.topColor != topColor ||
      old.bottomColor != bottomColor ||
      old.edgeColor != edgeColor ||
      old.isDark != isDark;
}

class MagicNavItem {
  final IconData icon;
  final String label;

  MagicNavItem({required this.icon, required this.label});
}
