import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

// ============================================================
// MODELS
// ============================================================

class NetworkDevice {
  final int id;
  DeviceType type;
  String name;
  String ip;
  double x;
  double y;
  bool isOnline;

  NetworkDevice({
    required this.id,
    required this.type,
    required this.name,
    this.ip = '',
    required this.x,
    required this.y,
    this.isOnline = true,
  });
}

enum DeviceType { pc, laptop, router, switchDevice, server, accessPoint }

extension DeviceTypeInfo on DeviceType {
  String get label {
    switch (this) {
      case DeviceType.pc: return 'PC';
      case DeviceType.laptop: return 'Laptop';
      case DeviceType.router: return 'Router';
      case DeviceType.switchDevice: return 'Switch';
      case DeviceType.server: return 'Server';
      case DeviceType.accessPoint: return 'AP';
    }
  }

  IconData get icon {
    switch (this) {
      case DeviceType.pc: return Icons.computer;
      case DeviceType.laptop: return Icons.laptop;
      case DeviceType.router: return Icons.router;
      case DeviceType.switchDevice: return Icons.lan;
      case DeviceType.server: return Icons.dns;
      case DeviceType.accessPoint: return Icons.wifi;
    }
  }
}

class Link {
  final int fromId;
  final int toId;
  Link(this.fromId, this.toId);
}

// ============================================================
// SIMULATOR PAGE
// ============================================================

class SimulatorPage extends StatefulWidget {
  const SimulatorPage({super.key});

  @override
  State<SimulatorPage> createState() => _SimulatorPageState();
}

class _SimulatorPageState extends State<SimulatorPage> {
  final List<NetworkDevice> devices = [];
  final List<Link> links = [];
  final List<String> cliHistory = [
    'NETROPIA CLI v1.0 ready.',
    'TIP: Klik perangkat lalu tekan "Config" untuk atur IP.',
    'TIP: Gunakan tombol "Ping" untuk tes koneksi.',
  ];
  final TextEditingController cliController = TextEditingController();
  final TransformationController _transformationController = TransformationController();
  
  int nextId = 1;
  int? selectedDeviceId;
  bool connectMode = false;
  int? firstConnectionId;
  bool showCli = false;
  bool showMiniMap = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetView();
    });
  }

  @override
  void dispose() {
    cliController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void cliPrint(String message) => setState(() => cliHistory.add(message));

  // ==========================================================
  // NAVIGATION METHODS
  // ==========================================================

  void _resetView() {
    if (!mounted) return;
    final size = MediaQuery.of(context).size;
    setState(() {
      _transformationController.value = Matrix4.identity()
        ..translate(size.width / 2 - 1500, (size.height - 200) / 2 - 1500);
    });
  }

  void _zoom(double delta) {
    final currentMatrix = _transformationController.value;
    final scale = currentMatrix.getMaxScaleOnAxis();
    final newScale = (scale + delta).clamp(0.1, 3.0);
    
    final size = MediaQuery.of(context).size;
    final center = Offset(size.width / 2, (size.height - 200) / 2);
    
    setState(() {
      _transformationController.value = Matrix4.identity()
        ..translate(center.dx, center.dy)
        ..scale(newScale)
        ..translate(-center.dx / newScale, -center.dy / newScale);
    });
  }

  void _fitAll() {
    if (devices.isEmpty) {
      _resetView();
      return;
    }

    double minX = 3000, minY = 3000, maxX = 0, maxY = 0;
    for (var d in devices) {
      if (d.x < minX) minX = d.x;
      if (d.y < minY) minY = d.y;
      if (d.x > maxX) maxX = d.x;
      if (d.y > maxY) maxY = d.y;
    }

    final centerX = (minX + maxX) / 2 + 30;
    final centerY = (minY + maxY) / 2 + 25;
    final size = MediaQuery.of(context).size;

    setState(() {
      _transformationController.value = Matrix4.identity()
        ..translate(size.width / 2 - centerX, (size.height - 200) / 2 - centerY);
    });
  }

  // ==========================================================
  // SIMULATION METHODS
  // ==========================================================

  void addDevice(DeviceType type) {
    int number = 1;
    while (devices.any((d) => d.name == '${type.label}$number')) {
      number++;
    }
    
    final matrix = _transformationController.value;
    final inverse = Matrix4.inverted(matrix);
    final size = MediaQuery.of(context).size;
    final center = inverse.transform3(Vector3(size.width/2, (size.height - 200)/2, 0));

    setState(() {
      devices.add(NetworkDevice(
        id: nextId++,
        type: type,
        name: '${type.label}$number',
        x: center.x - 30,
        y: center.y - 25,
      ));
    });
    cliPrint('Added ${type.label}$number');
  }

  void _startConnect() {
    if (selectedDeviceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih perangkat asal dulu')));
      return;
    }
    setState(() {
      connectMode = true;
      firstConnectionId = selectedDeviceId;
    });
    cliPrint('Connect Mode: Pilih perangkat tujuan');
  }

  void _deleteSelected() {
    if (selectedDeviceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih perangkat yang ingin dihapus')));
      return;
    }
    setState(() {
      links.removeWhere((l) => l.fromId == selectedDeviceId || l.toId == selectedDeviceId);
      devices.removeWhere((d) => d.id == selectedDeviceId);
      selectedDeviceId = null;
    });
    cliPrint('Deleted selected device.');
  }

  void _runPingTest() {
    if (selectedDeviceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih perangkat asal untuk Ping')));
      return;
    }
    
    final src = devices.firstWhere((d) => d.id == selectedDeviceId);
    if (src.ip.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perangkat asal belum punya IP')));
      return;
    }

    // Mencari perangkat lain yang punya IP untuk dijadikan target otomatis jika tidak diinput via CLI
    final targets = devices.where((d) => d.id != src.id && d.ip.isNotEmpty).toList();
    if (targets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak ada perangkat tujuan dengan IP')));
      return;
    }

    final dest = targets.first;
    cliPrint('Testing connectivity: ${src.name} -> ${dest.name} (${dest.ip})');
    
    Future.delayed(const Duration(milliseconds: 800), () {
      if (_hasConnection(src.id, dest.id)) {
        cliPrint('Ping SUCCESS: Reply from ${dest.ip}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('Ping ke ${dest.name} Berhasil!')));
      } else {
        cliPrint('Ping FAILED: Destination unreachable');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Ping Gagal! Jalur tidak terhubung')));
      }
    });
  }

  bool _hasConnection(int id1, int id2) {
    final visited = <int>{};
    final queue = [id1];
    visited.add(id1);

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      if (current == id2) return true;

      for (var link in links) {
        if (link.fromId == current && !visited.contains(link.toId)) {
          visited.add(link.toId);
          queue.add(link.toId);
        } else if (link.toId == current && !visited.contains(link.fromId)) {
          visited.add(link.fromId);
          queue.add(link.fromId);
        }
      }
    }
    return false;
  }

  void executeCommand(String input) {
    if (input.trim().isEmpty) return;
    cliPrint('NETROPIA# $input');
    cliController.clear();
    final parts = input.toLowerCase().split(' ');
    final cmd = parts[0];

    if (cmd == 'ping' && parts.length > 1) {
      final targetIp = parts[1];
      final src = devices.where((d) => d.id == selectedDeviceId).cast<NetworkDevice?>().firstOrNull;
      if (src == null || src.ip.isEmpty) {
        cliPrint('Error: Source device invalid or has no IP.');
        return;
      }
      final dest = devices.where((d) => d.ip == targetIp).cast<NetworkDevice?>().firstOrNull;
      if (dest != null && _hasConnection(src.id, dest.id)) cliPrint('Reply from $targetIp: OK');
      else cliPrint('Request timed out.');
    } else if (cmd == 'help') {
      cliPrint('Commands: devices, links, ping <ip>, clear');
    } else if (cmd == 'clear') {
      setState(() => cliHistory.clear());
    } else {
      cliPrint('Unknown command.');
    }
  }

  // ==========================================================
  // DEVICE HANDLERS
  // ==========================================================

  void _handleDeviceTap(NetworkDevice device) {
    if (connectMode) {
      if (firstConnectionId != null && firstConnectionId != device.id) {
        setState(() {
          links.add(Link(firstConnectionId!, device.id));
          connectMode = false;
          firstConnectionId = null;
        });
        cliPrint('Link established.');
      }
      return;
    }
    setState(() => selectedDeviceId = device.id);
  }

  void _openConfig(NetworkDevice device) {
    final nameCtrl = TextEditingController(text: device.name);
    final ipCtrl = TextEditingController(text: device.ip);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0B1726),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Konfigurasi ${device.name}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                IconButton(icon: const Icon(Icons.close, color: Colors.white60), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameCtrl, 
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Nama Perangkat', labelStyle: TextStyle(color: Color(0xFF4CC9F0))),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ipCtrl, 
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'IP Address (IPv4)', labelStyle: TextStyle(color: Color(0xFF4CC9F0))),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0875C9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  setState(() {
                    device.name = nameCtrl.text;
                    device.ip = ipCtrl.text;
                  });
                  Navigator.pop(ctx);
                  cliPrint('IP ${device.name} diatur ke ${device.ip}');
                },
                child: const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050C13),
      appBar: AppBar(
        title: const Text('Cisco Simulator', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0875C9),
        elevation: 0,
        actions: [
          IconButton(tooltip: 'Terminal', icon: Icon(showCli ? Icons.terminal : Icons.terminal_outlined), onPressed: () => setState(() => showCli = !showCli)),
          IconButton(tooltip: 'Hapus', icon: const Icon(Icons.delete_outline, color: Colors.white), onPressed: _deleteSelected),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // TOOLBOX
              Container(
                height: 70,
                decoration: const BoxDecoration(color: Color(0xFF0D1A29), border: Border(bottom: BorderSide(color: Colors.white12))),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  children: [
                    _ToolButton(icon: Icons.computer, label: 'PC', onTap: () => addDevice(DeviceType.pc)),
                    _ToolButton(icon: Icons.router, label: 'Router', onTap: () => addDevice(DeviceType.router)),
                    _ToolButton(icon: Icons.lan, label: 'Switch', onTap: () => addDevice(DeviceType.switchDevice)),
                    _ToolButton(icon: Icons.link, label: 'Hubung', onTap: _startConnect, color: Colors.orange),
                    _ToolButton(icon: Icons.settings, label: 'Config', onTap: () {
                      if (selectedDeviceId != null) {
                        final d = devices.firstWhere((device) => device.id == selectedDeviceId);
                        _openConfig(d);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih perangkat dulu')));
                      }
                    }, color: Colors.blue),
                    _ToolButton(icon: Icons.play_arrow, label: 'Tes Ping', onTap: _runPingTest, color: Colors.green),
                  ],
                ),
              ),
              // CANVAS
              Expanded(
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  boundaryMargin: const EdgeInsets.all(1000),
                  minScale: 0.1, maxScale: 3.0,
                  constrained: false,
                  child: Container(
                    width: 3000, height: 3000,
                    decoration: const BoxDecoration(color: Color(0xFF050C13)),
                    child: Stack(
                      children: [
                        const Positioned.fill(child: NetworkGrid()),
                        CustomPaint(painter: LinkPainter(devices: devices, links: links), size: const Size(3000, 3000)),
                        ...devices.map((d) => Positioned(
                          left: d.x, top: d.y,
                          child: GestureDetector(
                            onTap: () => _handleDeviceTap(d),
                            onDoubleTap: () => _openConfig(d),
                            onPanUpdate: (details) => setState(() { d.x += details.delta.dx; d.y += details.delta.dy; }),
                            child: DeviceWidget(device: d, isSelected: selectedDeviceId == d.id, isConnecting: firstConnectionId == d.id),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
              if (showCli) _buildCliArea(),
            ],
          ),
          // OVERLAYS
          if (showMiniMap) Positioned(right: 16, bottom: showCli ? 216 : 90, child: _buildMiniMap()),
          Positioned(left: 16, bottom: showCli ? 216 : 90, child: _buildNavControls()),
        ],
      ),
    );
  }

  Widget _buildCliArea() => Container(
    height: 200, color: Colors.black,
    child: Column(children: [
      Expanded(child: ListView.builder(padding: const EdgeInsets.all(10), itemCount: cliHistory.length, itemBuilder: (context, i) => Text(cliHistory[i], style: const TextStyle(color: Color(0xFF00D9FF), fontFamily: 'monospace', fontSize: 11)))),
      const Divider(color: Colors.white24, height: 1),
      Padding(padding: const EdgeInsets.all(8), child: Row(children: [
        const Text('NETROPIA# ', style: TextStyle(color: Color(0xFF4CC9F0), fontFamily: 'monospace', fontWeight: FontWeight.bold)),
        Expanded(child: Container(height: 34, decoration: BoxDecoration(color: const Color(0xFF111B24), borderRadius: BorderRadius.circular(10)), child: TextField(controller: cliController, style: const TextStyle(color: Colors.white, fontSize: 12), decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10)), onSubmitted: executeCommand))),
      ])),
    ]),
  );

  Widget _buildMiniMap() => Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white24)), child: Stack(children: [...devices.map((d) => Positioned(left: (d.x/3000)*100, top: (d.y/3000)*100, child: Container(width: 3, height: 3, decoration: BoxDecoration(color: d.id == selectedDeviceId ? Colors.blue : Colors.white54, shape: BoxShape.circle))))]));

  Widget _buildNavControls() => Column(children: [
    _CircleNavBtn(icon: Icons.add, onTap: () => _zoom(0.2)),
    const SizedBox(height: 8),
    _CircleNavBtn(icon: Icons.remove, onTap: () => _zoom(-0.2)),
    const SizedBox(height: 8),
    _CircleNavBtn(icon: Icons.zoom_out_map, onTap: _fitAll),
  ]);
}

class _ToolButton extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap; final Color? color;
  const _ToolButton({required this.icon, required this.label, required this.onTap, this.color});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(right: 8), child: ActionChip(avatar: Icon(icon, size: 16, color: color ?? const Color(0xFF4CC9F0)), label: Text(label, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)), onPressed: onTap, backgroundColor: const Color(0xFF1B2B3A)));
}

class _CircleNavBtn extends StatelessWidget {
  final IconData icon; final VoidCallback onTap;
  const _CircleNavBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFF1B2B3A), shape: BoxShape.circle, border: Border.all(color: Colors.white24)), child: Icon(icon, color: Colors.white70, size: 18)));
}

class DeviceWidget extends StatelessWidget {
  final NetworkDevice device; final bool isSelected; final bool isConnecting;
  const DeviceWidget({super.key, required this.device, required this.isSelected, required this.isConnecting});
  @override
  Widget build(BuildContext context) => Column(mainAxisSize: MainAxisSize.min, children: [
    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent, border: Border.all(color: isConnecting ? Colors.orange : (isSelected ? Colors.blue : Colors.white24), width: 2), borderRadius: BorderRadius.circular(10)), child: Icon(device.type.icon, color: isSelected ? Colors.blue : Colors.white, size: 30)),
    const SizedBox(height: 4),
    Text(device.name, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
  ]);
}

class LinkPainter extends CustomPainter {
  final List<NetworkDevice> devices; final List<Link> links;
  LinkPainter({required this.devices, required this.links});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white38..strokeWidth = 2;
    for (var link in links) {
      try {
        final from = devices.firstWhere((d) => d.id == link.fromId);
        final to = devices.firstWhere((d) => d.id == link.toId);
        canvas.drawLine(Offset(from.x + 25, from.y + 20), Offset(to.x + 25, to.y + 20), paint);
      } catch (_) {}
    }
  }
  @override bool shouldRepaint(covariant CustomPainter old) => true;
}

class NetworkGrid extends StatelessWidget {
  const NetworkGrid({super.key});
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _GridPainter(), child: const SizedBox.expand());
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white10..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 40) canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    for (double i = 0; i < size.height; i += 40) canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
  }
  @override bool shouldRepaint(covariant CustomPainter old) => false;
}
