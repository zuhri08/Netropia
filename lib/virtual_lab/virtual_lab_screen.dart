import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'cisco.dart';
import '../services/localization_service.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_pressable.dart';
import '../widgets/home_effects.dart';

class VirtualLabScreen extends StatelessWidget {
  const VirtualLabScreen({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $urlString');
    }
  }

  void _showInfoDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(title),
        content: const Text('Fitur simulasi ini siap digunakan untuk praktik laboratorium TKJ.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        final bool en = localizationService.isEnglish;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text(
              'Virtual Lab',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            flexibleSpace: const BrandAppBarBackground(),
          ),
          body: Stack(
            children: [
              const Positioned.fill(child: AnimatedBackdrop()),
              ListView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 100),
                children: [
                  // Banner utama
                  FadeSlideIn(
                    child: AnimatedHeroCard(
                      colors: const [Color(0xFFAD8B73), Color(0xFFC4A58C)],
                      borderRadius: 24,
                      padding: const EdgeInsets.all(20),
                      shadowColor: AppTheme.primaryBrown,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.22),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'VIRTUAL LAB',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  en
                                      ? 'Learn Through Direct Practice'
                                      : 'Belajar lewat praktik langsung.',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 21,
                                    height: 1.2,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  en
                                      ? 'Hone your technical skills through virtual laboratories.'
                                      : 'Asah kemampuan teknismu melalui laboratorium virtual.',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 12.5,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.22),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.35),
                              ),
                            ),
                            child: const Floating(
                              amplitude: 4,
                              child: Icon(
                                Icons.science_rounded,
                                color: Colors.white,
                                size: 38,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  FadeSlideIn(
                    delay: const Duration(milliseconds: 150),
                    offset: const Offset(-20, 0),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 18,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBrown,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          en ? 'Choose a Simulation' : 'Pilih Simulasi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: AppTheme.primaryBrown.withOpacity(0.18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 01: Simulasi Jaringan
                  _buildSimulationCard(
                    context,
                    isDark: isDark,
                    index: 0,
                    number: '01',
                    title: en ? 'Network Simulation' : 'Simulasi Jaringan',
                    subtitle: en
                        ? 'Build topology and configure network devices.'
                        : 'Bangun topologi dan konfigurasi perangkat jaringan.',
                    icon: Icons.hub_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SimulatorPage()),
                      );
                    },
                  ),

                  // 02: Rakit PC
                  _buildSimulationCard(
                    context,
                    isDark: isDark,
                    index: 1,
                    number: '02',
                    title: en ? 'PC Building' : 'Rakit PC',
                    subtitle: en
                        ? 'Simulate assembling computer hardware components.'
                        : 'Simulasi merakit komponen perangkat keras komputer.',
                    icon: Icons.settings_input_component_rounded,
                    onTap: () => _showInfoDialog(context, en ? 'PC Building' : 'Rakit PC'),
                  ),

                  // 03: Windows Simulator
                  _buildSimulationCard(
                    context,
                    isDark: isDark,
                    index: 2,
                    number: '03',
                    title: 'Windows Simulator',
                    subtitle: en
                        ? 'Practice Windows OS and system administration.'
                        : 'Praktik sistem operasi dan administrasi Windows.',
                    icon: Icons.window_rounded,
                    onTap: () => _launchUrl('https://win7simu.visnalize.com/'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSimulationCard(
    BuildContext context, {
    required bool isDark,
    required int index,
    required String number,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    // 0 terakota, 1 madu, 2 rose clay
    final Color accent = kAccentPalette[index % 3 == 0 ? 0 : (index % 3 == 1 ? 1 : 2)];

    return FadeSlideIn(
      delay: Duration(milliseconds: 250 + index * 130),
      offset: const Offset(0, 28),
      scaleFrom: 0.94,
      duration: const Duration(milliseconds: 650),
      child: AnimatedPressable(
        onTap: onTap,
        scaleFactor: 0.96,
        child: SoftCard(
          accent: accent,
          radius: 22,
          padding: EdgeInsets.zero,
          margin: const EdgeInsets.only(bottom: 14),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                // angka besar samar sebagai hiasan
                Positioned(
                  right: 14,
                  top: -4,
                  child: Text(
                    number,
                    style: TextStyle(
                      fontSize: 76,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      color: accent.withOpacity(isDark ? 0.18 : 0.10),
                    ),
                  ),
                ),
                Positioned(
                  right: -26,
                  bottom: -34,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent.withOpacity(0.08),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AccentChip(icon: icon, accent: accent, size: 58),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? Colors.grey.shade400
                                    : AppTheme.textMuted,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [accentLightOf(accent), accent],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: accent.withOpacity(0.35),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    localizationService.isEnglish
                                        ? 'Start simulation'
                                        : 'Mulai simulasi',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
