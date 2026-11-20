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
              // Hero Banner Card from Untitled.pdf
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFAD8B73),
                      Color(0xFFCEAB93),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFAD8B73).withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.science_rounded,
                      color: Colors.white,
                      size: 38,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      localizationService.isEnglish ? 'Learn Through Direct Practice' : 'Belajar lewat praktik langsung',
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
                        fontSize: 13.5,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Simulation 01: Simulasi Jaringan
              _buildSimulationCard(
                context,
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
    required String number,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFAD8B73).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFAD8B73).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: const Color(0xFFAD8B73), size: 26),
                    ),
                    Text(
                      number,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFAD8B73),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      localizationService.isEnglish ? 'Start simulation' : 'Mulai simulasi',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFAD8B73),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: Color(0xFFAD8B73),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
