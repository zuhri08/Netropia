import 'package:flutter/material.dart';

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
    double width = MediaQuery.of(context).size.width;
    double itemWidth = width / items.length;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color barColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color activeColor = const Color(0xFF1565C0);
    final Color slideColor = isDark ? Colors.white.withOpacity(0.05) : Colors.white;

    return Container(
      height: 85,
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(width, 70),
              painter: NavPainter(
                currentIndex: currentIndex,
                itemWidth: itemWidth,
                color: barColor,
              ),
            ),
          ),
          
          // 1. Lingkaran Biru Aktif (Konsep Jump & Slide)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutBack, 
            left: (currentIndex * itemWidth) + (itemWidth / 2) - 27.5,
            top: 13, 
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: activeColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: activeColor.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            ),
          ),

          // Baris Item Navigasi
          Row(
            children: items.asMap().entries.map((entry) {
              int index = entry.key;
              var item = entry.value;
              bool isActive = currentIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    height: 85,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Ikon & Teks yang beranimasi masuk ke lingkaran
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOutBack,
                          margin: EdgeInsets.only(bottom: isActive ? 8 : 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                item.icon,
                                color: isActive 
                                  ? Colors.white 
                                  : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                                size: isActive ? 20 : 24,
                              ),
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
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class NavPainter extends CustomPainter {
  final int currentIndex;
  final double itemWidth;
  final Color color;

  NavPainter({
    required this.currentIndex,
    required this.itemWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double centerX = (currentIndex * itemWidth) + (itemWidth / 2);
    double dipWidth = 65;
    double dipHeight = 48; // Dibuat lebih dalam agar "lubang" lebih terlihat ke bawah

    Path path = Path();
    path.moveTo(0, 0); 
    path.lineTo(centerX - (dipWidth + 5), 0);
    path.cubicTo(
      centerX - dipWidth / 2, 0,
      centerX - dipWidth / 2, dipHeight,
      centerX, dipHeight,
    );
    path.cubicTo(
      centerX + dipWidth / 2, dipHeight,
      centerX + dipWidth / 2, 0,
      centerX + (dipWidth + 5), 0,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(NavPainter oldDelegate) {
    return oldDelegate.currentIndex != currentIndex;
  }
}

class MagicNavItem {
  final IconData icon;
  final String label;

  MagicNavItem({required this.icon, required this.label});
}
