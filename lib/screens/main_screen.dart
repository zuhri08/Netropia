import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import '../progres/progres_screen.dart';
import '../ai/netropia_ai_screen.dart';
import '../virtual_lab/virtual_lab_screen.dart';
import '../profile/profile_screen.dart';
import '../widgets/magic_nav_bar.dart';
import '../widgets/ai_fly_effect.dart';
import '../services/localization_service.dart';
import '../services/settings_service.dart';

class MainScreen extends StatefulWidget {
  final String username;
  final String role;

  const MainScreen({
    super.key,
    required this.username,
    required this.role,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ProgresScreenState> _progresKey = GlobalKey<ProgresScreenState>();
  final GlobalKey _navKey = GlobalKey();

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _initStreak();
    _pages = [
      DashboardScreen(username: widget.username, role: widget.role),
      ProgresScreen(key: _progresKey),
      const NetropiaAiScreen(),
      const VirtualLabScreen(),
      ProfileScreen(username: widget.username, role: widget.role),
    ];
  }

  /// Ikon AI terpental dari tombol navigasi ke kiri atas (sebelah judul).
  void _flyAiIcon() {
    if (!mounted || MediaQuery.of(context).disableAnimations) return;
    final navBox = _navKey.currentContext?.findRenderObject() as RenderBox?;
    if (navBox == null || !navBox.hasSize) return;

    final itemW = MediaQuery.of(context).size.width / 5;
    final navTopLeft = navBox.localToGlobal(Offset.zero);
    // titik awal = ikon AI di slotnya pada bar (bukan lingkaran aktif)
    final start = Offset(
      navTopLeft.dx + 2 * itemW + itemW / 2,
      navTopLeft.dy + 42.5,
    );

    Offset end = Offset(32, MediaQuery.of(context).padding.top + 28);
    final iconBox = aiBarIconKey.currentContext?.findRenderObject() as RenderBox?;
    if (iconBox != null && iconBox.hasSize && iconBox.attached) {
      end = iconBox.localToGlobal(iconBox.size.center(Offset.zero));
    }

    flyAiIcon(context, start: start, end: end);
  }

  Future<void> _initStreak() async {
    await SettingsService().checkAndUpdateStreak();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        return Scaffold(
          extendBody: true,
          body: IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
          bottomNavigationBar: MagicNavBar(
            key: _navKey,
            dockedIndex: 2, // tab AI: tombol pindah ke atas, bar jadi lurus
            currentIndex: _selectedIndex,
            onTap: (index) {
              final goingToAi = index == 2 && _selectedIndex != 2;
              setState(() {
                _selectedIndex = index;
              });
              if (goingToAi) {
                WidgetsBinding.instance.addPostFrameCallback((_) => _flyAiIcon());
              }
              if (index == 1) {
                _progresKey.currentState?.refreshData();
              }
            },
            items: [
              MagicNavItem(icon: Icons.home_rounded, label: localizationService.translate('home')),
              MagicNavItem(icon: Icons.trending_up_rounded, label: localizationService.translate('progress')),
              MagicNavItem(icon: Icons.psychology_rounded, label: localizationService.translate('ai')),
              MagicNavItem(icon: Icons.science_rounded, label: localizationService.translate('simulation')),
              MagicNavItem(icon: Icons.person_rounded, label: localizationService.translate('profile')),
            ],
          ),
        );
      },
    );
  }
}
