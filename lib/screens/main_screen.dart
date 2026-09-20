import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import '../progress/progress_screen.dart';
import '../ai/netropia_ai_screen.dart';
import '../virtual_lab/virtual_lab_screen.dart';
import '../profile/profile_screen.dart';

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

  Widget _placeholderScreen(String title, IconData icon) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              '$title Sedang Dikembangkan',
              style: const TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up_rounded),
              label: 'Progres',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.psychology_rounded),
              label: 'AI',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.science_rounded),
              label: 'Simulasi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
