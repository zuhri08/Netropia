import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'cisco.dart';
import '../services/localization_service.dart';

class VirtualLabScreen extends StatelessWidget {
  const VirtualLabScreen({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              localizationService.translate('virtual_lab'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFFAD8B73),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                localizationService.isEnglish ? 'Select Practice Simulation' : 'Pilih Simulasi Praktik',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                localizationService.isEnglish
                    ? 'Hone your technical skills through virtual laboratories.'
                    : 'Asah kemampuan teknismu melalui laboratorium virtual.',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 25),
              _buildMenuCard(
                context,
                title: localizationService.isEnglish ? 'Network Simulation (Cisco)' : 'Simulasi Jaringan (Cisco)',
                subtitle: localizationService.isEnglish
                    ? 'Build topology and configure Cisco devices.'
                    : 'Bangun topologi dan konfigurasi perangkat Cisco.',
                icon: Icons.hub_rounded,
                color: const Color(0xFFAD8B73),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SimulatorPage()),
                  );
                },
              ),
              _buildMenuCard(
                context,
                title: localizationService.isEnglish ? 'PC Building' : 'Rakit PC',
                subtitle: localizationService.isEnglish
                    ? 'Simulate assembling computer hardware components.'
                    : 'Simulasi merakit komponen perangkat keras komputer.',
                icon: Icons.settings_input_component_rounded,
                color: Colors.orange,
                onTap: () => _showComingSoon(context, localizationService.isEnglish ? 'PC Building' : 'Rakit PC'),
              ),
              _buildMenuCard(
                context,
                title: 'Windows Simulator',
                subtitle: localizationService.isEnglish
                    ? 'Practice Windows OS and system administration.'
                    : 'Praktik sistem operasi dan administrasi Windows.',
                icon: Icons.window_rounded,
                color: const Color(0xFFAD8B73),
                onTap: () => _launchUrl('https://win7simu.visnalize.com/'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature ${localizationService.translate('coming_soon')}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
