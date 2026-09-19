import 'package:flutter/material.dart';

class LabDetailScreen extends StatefulWidget {
  final String labName;
  const LabDetailScreen({super.key, required this.labName});

  @override
  State<LabDetailScreen> createState() => _LabDetailScreenState();
}

class _LabDetailScreenState extends State<LabDetailScreen> {
  final TextEditingController _terminalController = TextEditingController();
  final List<String> _terminalOutput = ["Netropia Virtual Terminal v1.0", "Type 'help' for commands.", ""];
  String _activeDevice = "None";

  void _processCommand(String cmd) {
    setState(() {
      _terminalOutput.add("> $cmd");
      String input = cmd.toLowerCase().trim();
      
      if (input == "help") {
        _terminalOutput.add("Available commands: ping, ipconfig, help, clear");
      } else if (input == "clear") {
        _terminalOutput.clear();
      } else if (input.startsWith("ping")) {
        _terminalOutput.add("Pinging ${input.split(' ').last} with 32 bytes of data:");
        _terminalOutput.add("Reply from ${input.split(' ').last}: bytes=32 time<1ms TTL=64");
        _terminalOutput.add("Reply from ${input.split(' ').last}: bytes=32 time<1ms TTL=64");
      } else if (input == "ipconfig") {
        _terminalOutput.add("Ethernet adapter Local Area Connection:");
        _terminalOutput.add("   IPv4 Address. . . . . . . . . . . : 192.168.1.10");
        _terminalOutput.add("   Subnet Mask . . . . . . . . . . . : 255.255.255.0");
        _terminalOutput.add("   Default Gateway . . . . . . . . . : 192.168.1.1");
      } else {
        _terminalOutput.add("'$cmd' is not recognized as an internal or external command.");
      }
      _terminalOutput.add("");
      _terminalController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.labName), actions: [
        IconButton(icon: const Icon(Icons.info_outline_rounded), onPressed: () {}),
      ]),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: _buildTopologyView(),
          ),
          const Divider(height: 1, thickness: 1),
          Expanded(
            flex: 3,
            child: _buildTerminalView(),
          ),
          _buildActionFooter(),
        ],
      ),
    );
  }

  Widget _buildTopologyView() {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark ? Colors.black26 : Colors.blue.shade50.withOpacity(0.3),
      child: Stack(
        children: [
          const Center(child: Text("TOPOLOGY VIEW", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10))),
          CustomPaint(painter: TopologyLinkPainter(), size: Size.infinite),
          Positioned(left: 40, top: 100, child: _buildDevice(Icons.computer_rounded, "PC-1", "192.168.1.10")),
          Positioned(left: 160, top: 100, child: _buildDevice(Icons.settings_input_component_rounded, "Switch-1", "VLAN 10")),
          Positioned(right: 40, top: 100, child: _buildDevice(Icons.router_rounded, "Router-1", "192.168.1.1")),
          Positioned(bottom: 20, left: 20, child: _buildInstructionCard()),
        ],
      ),
    );
  }

  Widget _buildDevice(IconData icon, String name, String detail) {
    bool isActive = _activeDevice == name;
    return GestureDetector(
      onTap: () => setState(() => _activeDevice = name),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF1565C0) : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
              border: Border.all(color: isActive ? Colors.white : const Color(0xFF1565C0), width: 2),
            ),
            child: Icon(icon, color: isActive ? Colors.white : const Color(0xFF1565C0), size: 30),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          if (isActive) Text(detail, style: const TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildInstructionCard() {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.blue.shade100)),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Instruksi:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          SizedBox(height: 4),
          Text("1. Klik PC-1 untuk konfigurasi\n2. Lakukan ping ke Gateway\n3. Pastikan reply received", style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildTerminalView() {
    return Container(
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.terminal_rounded, color: Colors.green, size: 16),
              SizedBox(width: 8),
              Text("TERMINAL", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _terminalOutput.length,
              itemBuilder: (context, index) => Text(_terminalOutput[index], style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12)),
            ),
          ),
          Row(
            children: [
              const Text(">", style: TextStyle(color: Colors.white, fontFamily: 'monospace')),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _terminalController,
                  onSubmitted: _processCommand,
                  style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12),
                  cursorColor: Colors.green,
                  decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionFooter() {
    return Container(
      padding: const EdgeInsets.all(15),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text("Reset")),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ElevatedButton(onPressed: _showSuccessDialog, child: const Text("Submit")),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Column(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.green, size: 60),
            SizedBox(height: 15),
            Text("Lab Selesai!", textAlign: TextAlign.center),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Selamat! Anda telah menyelesaikan praktikum Konfigurasi IP Address.", textAlign: TextAlign.center),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ScoreItem(label: "Skor", value: "100"),
                _ScoreItem(label: "XP", value: "+50"),
              ],
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text("Kembali ke Daftar Lab")),
          ),
        ],
      ),
    );
  }
}

class _ScoreItem extends StatelessWidget {
  final String label, value;
  const _ScoreItem({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(children: [Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)), Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))]);
  }
}

class TopologyLinkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue.withOpacity(0.3)..strokeWidth = 2..style = PaintingStyle.stroke;
    // PC to Switch
    canvas.drawLine(const Offset(70, 130), const Offset(160, 130), paint);
    // Switch to Router
    canvas.drawLine(const Offset(210, 130), Offset(size.width - 70, 130), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
