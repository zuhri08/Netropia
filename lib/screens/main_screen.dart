import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import '../progress/progress_screen.dart';
import '../ai/netropia_ai_screen.dart';
import '../virtual_lab/virtual_lab_screen.dart';
import '../profile/profile_screen.dart';
import '../widgets/magic_nav_bar.dart';

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

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardScreen(username: widget.username, role: widget.role),
      const ProgressScreen(),
      const NetropiaAiScreen(),
      const VirtualLabScreen(),
      ProfileScreen(username: widget.username, role: widget.role),
    ];
  }

  @override
  Widget build(BuildContext context) {
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
        },
        items: [
          MagicNavItem(icon: Icons.home_rounded, label: 'Beranda'),
          MagicNavItem(icon: Icons.trending_up_rounded, label: 'Progres'),
          MagicNavItem(icon: Icons.psychology_rounded, label: 'AI'),
          MagicNavItem(icon: Icons.science_rounded, label: 'Simulasi'),
          MagicNavItem(icon: Icons.person_rounded, label: 'Profil'),
        ],
      ),
    );
  }
}
