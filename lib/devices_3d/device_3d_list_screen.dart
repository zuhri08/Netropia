import 'package:flutter/material.dart';
import '../virtual_lab/device_3d_viewer_screen.dart';

class Device3DListScreen extends StatelessWidget {
  const Device3DListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Perangkat 3D', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Kategori Perangkat 3D',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pilih kategori perangkat untuk melihat model 3D interaktif.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 25),

          _buildCategoryCard(
            context,
            title: 'Perangkat Jaringan',
            subtitle: 'Router, Switch, Server, Repeater, Kabel, dan perangkat jaringan lainnya.',
            icon: Icons.router_rounded,
            color: const Color(0xFFAD8B73),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Device3DSubGridScreen(
                    categoryTitle: 'Perangkat Jaringan',
                    devices: [
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
            title: 'Perangkat Komputer',
            subtitle: 'CPU, Motherboard, Power Supply, RAM, Monitor, Keyboard, Storage, dan Printer.',
            icon: Icons.computer_rounded,
            color: const Color(0xFFCEAB93),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Device3DSubGridScreen(
                    categoryTitle: 'Perangkat Komputer',
                    devices: [
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
                        'name': 'Power Supply',
                        'icon': Icons.bolt_rounded,
                        'url': 'https://sketchfab.com/models/bfb1f77fffb0410f9ee0d0be6fb5fc88/embed'
                      },
                      {
                        'name': 'Monitor',
                        'icon': Icons.desktop_windows_rounded,
                        'url': 'https://sketchfab.com/models/fd0a3a8fcb2d4732b32e5029f330dfe3/embed'
                      },
                      {
                        'name': 'RAM Memori',
                        'icon': Icons.sd_storage_rounded,
                        'url': 'https://sketchfab.com/models/3a032229faa84790abdb75e349594b6a/embed'
                      },
                      {
                        'name': 'Processor',
                        'icon': Icons.settings_suggest_rounded,
                        'url': 'https://sketchfab.com/models/912c9c42d2dc40fe95574345aae51ea0/embed'
                      },
                      {
                        'name': 'Keyboard',
                        'icon': Icons.keyboard_rounded,
                        'url': 'https://sketchfab.com/models/c1e5e07153d84978a1ad7256d720220a/embed'
                      },
                      {
                        'name': 'Media Penyimpanan',
                        'icon': Icons.storage_rounded,
                        'url': 'https://sketchfab.com/models/bdd5fd67a7674359ab8648204b5c0575/embed'
                      },
                      {
                        'name': 'Printer',
                        'icon': Icons.print_rounded,
                        'url': 'https://sketchfab.com/models/0842a4c0d76746ee8c9290733f209694/embed'
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
            color: Colors.black.withAlpha(8),
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
                    color: color.withAlpha(26),
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
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
                    deviceName: device['name'] as String,
                    embedUrl: device['url'] as String,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.black.withAlpha(13)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFAD8B73).withAlpha(26),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(device['icon'] as IconData, color: const Color(0xFFAD8B73), size: 28),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    device['name'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
