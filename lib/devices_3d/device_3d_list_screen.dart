import 'package:flutter/material.dart';
import '../virtual_lab/device_3d_viewer_screen.dart';

class Device3DListScreen extends StatelessWidget {
  const Device3DListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final devices = [
      {
        'name': 'Wifi Repeater',
        'icon': Icons.wifi_tethering_rounded,
        'url': 'https://sketchfab.com/models/defc9bc6ae30485985fdde4f2fab6eed/embed'
      },
      {
        'name': 'TP-Link AX23',
        'icon': Icons.router_rounded,
        'url': 'https://sketchfab.com/models/41ff5f5fe0774f43a5896e33ecbe7ad0/embed'
      },
      {
        'name': 'MikroTik RB5009',
        'icon': Icons.settings_input_component_rounded,
        'url': 'https://sketchfab.com/models/0888c1540bd049c1b40ccd01f159f324/embed'
      },
      {
        'name': 'CCR1072-1G-8S+',
        'icon': Icons.dns_rounded,
        'url': 'https://sketchfab.com/models/054e2e270bb54f08a494c98b182e77bb/embed'
      },
      {
        'name': 'Network Switch',
        'icon': Icons.settings_input_hdmi_rounded,
        'url': 'https://sketchfab.com/models/90636d8681c84b84a3fb2df6ebb6d461/embed?ui_infos=0'
      },
      {
        'name': 'Server Cabinet',
        'icon': Icons.storage_rounded,
        'url': 'https://sketchfab.com/models/5532b05f53504abeb8fb8646a6a68e16/embed'
      },
      {
        'name': 'FiberLan Rack',
        'icon': Icons.lan_rounded,
        'url': 'https://sketchfab.com/models/b13195f60ce142039dc22e208fd0b7a4/embed'
      },
      {
        'name': 'Antennas',
        'icon': Icons.settings_input_antenna_rounded,
        'url': 'https://sketchfab.com/models/b06c79711c4d49aca5c53aec157ef873/embed'
      },
      {
        'name': 'WIFI PCI Card',
        'icon': Icons.memory_rounded,
        'url': 'https://sketchfab.com/models/1ae13e4a364849f0ac213f26b101f71e/embed'
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Perangkat Jaringan (3D)', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.black.withOpacity(0.05)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1565C0).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(device['icon'] as IconData, color: const Color(0xFF1565C0), size: 28),
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
