import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'cisco.dart';
import '../services/localization_service.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_pressable.dart';

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
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text(
              'Virtual Lab',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppTheme.primaryBrown,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 100),
            children: [
              // Hero Banner Card from PDF
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppTheme.primaryBrown,
                      AppTheme.darkBrown,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryBrown.withOpacity(0.22),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.science_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      localizationService.isEnglish ? 'Learn Through Direct Practice' : 'Belajar lewat praktik langsung.',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      localizationService.isEnglish
                          ? 'Hone your technical skills through virtual laboratories.'
                          : 'Asah kemampuan teknismu melalui laboratorium virtual.',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Simulation 01: Simulasi Jaringan
              _buildSimulationCard(
                context,
                isDark: isDark,
                number: '01',
                title: localizationService.isEnglish ? 'Network Simulation' : 'Simulasi Jaringan',
                subtitle: localizationService.isEnglish
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

              // Simulation 02: Rakit PC
              _buildSimulationCard(
                context,
                isDark: isDark,
                number: '02',
                title: localizationService.isEnglish ? 'PC Building' : 'Rakit PC',
                subtitle: localizationService.isEnglish
                    ? 'Simulate assembling computer hardware components.'
                    : 'Simulasi merakit komponen perangkat keras komputer.',
                icon: Icons.settings_input_component_rounded,
                onTap: () => _showInfoDialog(context, localizationService.isEnglish ? 'PC Building' : 'Rakit PC'),
              ),

              // Simulation 03: Windows Simulator
              _buildSimulationCard(
                context,
                isDark: isDark,
                number: '03',
                title: 'Windows Simulator',
                subtitle: localizationService.isEnglish
                    ? 'Practice Windows OS and system administration.'
                    : 'Praktik sistem operasi dan administrasi Windows.',
                icon: Icons.window_rounded,
                onTap: () => _launchUrl('https://win7simu.visnalize.com/'),
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
    required String number,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return AnimatedPressable(
      onTap: onTap,
      scaleFactor: 0.96,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.brownTint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: AppTheme.primaryBrown, size: 24),
                  ),
                  Text(
                    number,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBrown,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(
                    localizationService.isEnglish ? 'Start simulation' : 'Mulai simulasi',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBrown,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: AppTheme.primaryBrown,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
