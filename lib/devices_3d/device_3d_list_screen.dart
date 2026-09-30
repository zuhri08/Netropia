import 'package:flutter/material.dart';
import '../virtual_lab/device_3d_viewer_screen.dart';
import '../services/localization_service.dart';

class Device3DListScreen extends StatelessWidget {
  const Device3DListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              localizationService.translate('device_3d'),
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
                localizationService.isEnglish ? '3D Device Categories' : 'Kategori Perangkat 3D',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                localizationService.isEnglish
                    ? 'Select a device category to view interactive 3D models.'
                    : 'Pilih kategori perangkat untuk melihat model 3D interaktif.',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 25),
              _buildCategoryCard(
                context,
                title: localizationService.isEnglish ? 'Network Devices' : 'Perangkat Jaringan',
                subtitle: localizationService.isEnglish
                    ? 'Routers, Switches, Servers, Repeaters, Cables, and other network equipment.'
                    : 'Router, Switch, Server, Repeater, Kabel, dan perangkat jaringan lainnya.',
                icon: Icons.router_rounded,
                color: const Color(0xFFAD8B73),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Device3DSubGridScreen(
                        categoryTitle: localizationService.isEnglish ? 'Network Devices' : 'Perangkat Jaringan',
                        devices: const [
                          {
                            'name': 'WiFi Repeater',
                            'icon': Icons.wifi_tethering_rounded,
                            'url': 'https://sketchfab.com/models/defc9bc6ae30485985fdde4f2fab6eed/embed'
                          },
                          {
                            'name': 'Router Wi-Fi',
                            'icon': Icons.router_rounded,
                            'url': 'https://sketchfab.com/models/41ff5f5fe0774f43a5896e33ecbe7ad0/embed'
                          },
                          {
                            'name': 'Router Jaringan',
                            'icon': Icons.settings_input_component_rounded,
                            'url': 'https://sketchfab.com/models/0888c1540bd049c1b40ccd01f159f324/embed'
                          },
                          {
                            'name': 'Core Router',
                            'icon': Icons.dns_rounded,
                            'url': 'https://sketchfab.com/models/054e2e270bb54f08a494c98b182e77bb/embed'
                          },
                          {
                            'name': 'Switch Jaringan',
                            'icon': Icons.settings_input_hdmi_rounded,
                            'url': 'https://sketchfab.com/models/90636d8681c84b84a3fb2df6ebb6d461/embed?ui_infos=0'
                          },
                          {
                            'name': 'Rack Server',
                            'icon': Icons.storage_rounded,
                            'url': 'https://sketchfab.com/models/5532b05f53504abeb8fb8646a6a68e16/embed'
                          },
                          {
                            'name': 'Patch Panel',
                            'icon': Icons.lan_rounded,
                            'url': 'https://sketchfab.com/models/b13195f60ce142039dc22e208fd0b7a4/embed'
                          },
                          {
                            'name': 'Antena Jaringan',
                            'icon': Icons.settings_input_antenna_rounded,
                            'url': 'https://sketchfab.com/models/b06c79711c4d49aca5c53aec157ef873/embed'
                          },
                          {
                            'name': 'Wireless Adapter',
                            'icon': Icons.memory_rounded,
                            'url': 'https://sketchfab.com/models/1ae13e4a364849f0ac213f26b101f71e/embed'
                          },
                        ],
                      ),
                    ),
                  );
                },
              ),
              _buildCategoryCard(
                context,
                title: localizationService.isEnglish ? 'Computer Devices' : 'Perangkat Komputer',
                subtitle: localizationService.isEnglish
                    ? 'CPU, Motherboard, Power Supply, RAM, Monitor, Keyboard, Storage, and Printers.'
                    : 'CPU, Motherboard, Power Supply, RAM, Monitor, Keyboard, Storage, dan Printer.',
                icon: Icons.computer_rounded,
                color: const Color(0xFFCEAB93),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Device3DSubGridScreen(
                        categoryTitle: localizationService.isEnglish ? 'Computer Devices' : 'Perangkat Komputer',
                        devices: const [
                          {
                            'name': 'CPU Komputer',
                            'icon': Icons.memory_rounded,
                            'url': 'https://sketchfab.com/models/2e11c4583ebe4fc98c073fd8a2690a06/embed'
                          },
                          {
                            'name': 'Motherboard',
                            'icon': Icons.developer_board_rounded,
                            'url': 'https://sketchfab.com/models/3bc94057328243d4b341a55f59160f8a/embed'
                          },
                          {
                            'name': 'Power Supply Unit',
                            'icon': Icons.power_rounded,
                            'url': 'https://sketchfab.com/models/ee1527ef0c164fc98971f11a88a03c05/embed'
                          },
                          {
                            'name': 'Memori RAM',
                            'icon': Icons.memory_rounded,
                            'url': 'https://sketchfab.com/models/3a232f3f4c0a4e5cae2840d710f6e520/embed'
                          },
                          {
                            'name': 'Harddisk Drive',
                            'icon': Icons.storage_rounded,
                            'url': 'https://sketchfab.com/models/b237f8f94df6461a9c37cbef7946caec/embed'
                          },
                          {
                            'name': 'Keyboard PC',
                            'icon': Icons.keyboard_rounded,
                            'url': 'https://sketchfab.com/models/4d2a1a8c3d9c490f8bfd90ee85890737/embed'
                          },
                          {
                            'name': 'Monitor PC',
                            'icon': Icons.desktop_windows_rounded,
                            'url': 'https://sketchfab.com/models/95465ef0b9bb47ceba7f0931536b04a8/embed'
                          },
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(
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
}

class Device3DSubGridScreen extends StatelessWidget {
  final String categoryTitle;
  final List<Map<String, dynamic>> devices;

  const Device3DSubGridScreen({
    super.key,
    required this.categoryTitle,
    required this.devices,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(categoryTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFAD8B73),
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Device3DViewerScreen(
                    deviceName: device['name'],
                    embedUrl: device['url'],
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(device['icon'] as IconData, size: 40, color: const Color(0xFFAD8B73)),
                  const SizedBox(height: 12),
                  Text(
                    device['name'] as String,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
