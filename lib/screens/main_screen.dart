import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import '../progres/progres_screen.dart';
import '../ai/netropia_ai_screen.dart';
import '../virtual_lab/virtual_lab_screen.dart';
import '../profile/profile_screen.dart';
import '../widgets/magic_nav_bar.dart';
import '../services/localization_service.dart';

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

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardScreen(username: widget.username, role: widget.role),
      ProgresScreen(key: _progresKey),
      const NetropiaAiScreen(),
      const VirtualLabScreen(),
      ProfileScreen(username: widget.username, role: widget.role),
    ];
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
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
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
