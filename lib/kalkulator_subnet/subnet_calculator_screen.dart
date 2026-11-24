import 'package:flutter/material.dart';
import '../services/localization_service.dart';
import '../theme/app_theme.dart';

class SubnetCalculatorScreen extends StatefulWidget {
  const SubnetCalculatorScreen({super.key});

  @override
  State<SubnetCalculatorScreen> createState() =>
      _SubnetCalculatorScreenState();
}

class _SubnetCalculatorScreenState extends State<SubnetCalculatorScreen> {
  final TextEditingController _ipController =
      TextEditingController(text: '192.168.1.10');

  final TextEditingController _cidrController =
      TextEditingController(text: '24');

  String? _network;
  String? _broadcast;
  String? _subnetMask;
  String? _wildcard;
  String? _firstHost;
  String? _lastHost;
  String? _totalHosts;
  String? _usableHosts;

  String? _binarySubnetMask;
  String? _ipClass;
  String? _cidrNotation;
  String? _ipType;

  String? _short;
  String? _binaryId;
  String? _hexId;
  String? _arpa;

  String? _errorMessage;

  @override
  void dispose() {
    _ipController.dispose();
    _cidrController.dispose();
    super.dispose();
  }

  void _calculateSubnet() {
    FocusScope.of(context).unfocus();

    final String ip = _ipController.text.trim();
    final String cidrText = _cidrController.text.trim();

    setState(() {
      _clearResults();
      _errorMessage = null;
    });

    final List<int>? ipParts = _parseIp(ip);

    if (ipParts == null) {
      setState(() {
        _errorMessage = 'IP Address tidak valid. Contoh: 192.168.1.10';
      });
      return;
    }

    final int? cidr = int.tryParse(cidrText);

    if (cidr == null || cidr < 0 || cidr > 32) {
      setState(() {
        _errorMessage = 'CIDR harus berupa angka antara 0 sampai 32.';
      });
      return;
    }

    final int ipValue = _ipToInt(ipParts);
    final int mask = _cidrToMask(cidr);
    final int networkValue = ipValue & mask;
    final int broadcastValue = networkValue | (~mask & 0xFFFFFFFF);
    final int totalAddresses = _pow2(32 - cidr);

    int usableHosts;
    if (cidr == 32) {
      usableHosts = 1;
    } else if (cidr == 31) {
      usableHosts = 2;
    } else {
      usableHosts = totalAddresses - 2;
    }

    final int firstHostValue;
    final int lastHostValue;

    if (cidr >= 31) {
      firstHostValue = networkValue;
      lastHostValue = broadcastValue;
    } else {
      firstHostValue = networkValue + 1;
      lastHostValue = broadcastValue - 1;
    }

    final String binaryId = _intToBinary(ipValue);

    setState(() {
      _network = _intToIp(networkValue);
      _broadcast = _intToIp(broadcastValue);
      _subnetMask = _intToIp(mask);
      _wildcard = _intToIp(~mask & 0xFFFFFFFF);
      _firstHost = _intToIp(firstHostValue);
      _lastHost = _intToIp(lastHostValue);
      _totalHosts = _formatNumber(totalAddresses);
      _usableHosts = _formatNumber(usableHosts);

      _binarySubnetMask = _intToBinary(mask);
      _ipClass = _getIpClass(ipParts[0]);
      _cidrNotation = '/$cidr';
      _ipType = _getIpType(ipParts);

      _short = '$_network /$cidr';
      _binaryId = binaryId;
      _hexId = '0x${ipValue.toRadixString(16).padLeft(8, '0').toUpperCase()}';
      _arpa = _buildArpa(ipParts);
    });
  }

  void _clearResults() {
    _network = null;
    _broadcast = null;
    _subnetMask = null;
    _wildcard = null;
    _firstHost = null;
    _lastHost = null;
    _totalHosts = null;
    _usableHosts = null;
    _binarySubnetMask = null;
    _ipClass = null;
    _cidrNotation = null;
    _ipType = null;
    _short = null;
    _binaryId = null;
    _hexId = null;
    _arpa = null;
  }

  List<int>? _parseIp(String ip) {
    final List<String> parts = ip.split('.');
    if (parts.length != 4) return null;
    final List<int> result = [];
    for (final String part in parts) {
      final int? value = int.tryParse(part);
      if (value == null || value < 0 || value > 255) return null;
      result.add(value);
    }
    return result;
  }

  int _ipToInt(List<int> parts) {
    return ((parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8) | parts[3]) & 0xFFFFFFFF;
  }

  int _cidrToMask(int cidr) {
    if (cidr == 0) return 0;
    return (0xFFFFFFFF << (32 - cidr)) & 0xFFFFFFFF;
  }

  String _intToIp(int value) {
    final int a = (value >> 24) & 255;
    final int b = (value >> 16) & 255;
    final int c = (value >> 8) & 255;
    final int d = value & 255;
    return '$a.$b.$c.$d';
  }

  String _intToBinary(int value) {
    final int a = (value >> 24) & 255;
    final int b = (value >> 16) & 255;
    final int c = (value >> 8) & 255;
    final int d = value & 255;
    return '${_byteToBinary(a)}.${_byteToBinary(b)}.${_byteToBinary(c)}.${_byteToBinary(d)}';
  }

  String _byteToBinary(int value) {
    return value.toRadixString(2).padLeft(8, '0');
  }

  int _pow2(int exponent) {
    int result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= 2;
    }
    return result;
  }

  String _formatNumber(int number) {
    return number.toString();
  }

  String _getIpClass(int firstOctet) {
    if (firstOctet >= 1 && firstOctet <= 126) return 'A';
    if (firstOctet >= 128 && firstOctet <= 191) return 'B';
    if (firstOctet >= 192 && firstOctet <= 223) return 'C';
    if (firstOctet >= 224 && firstOctet <= 239) return 'D';
    if (firstOctet >= 240 && firstOctet <= 255) return 'E';
    return 'Unknown';
  }

  String _getIpType(List<int> ip) {
    final int a = ip[0];
    final int b = ip[1];

    if (a == 10 || (a == 172 && b >= 16 && b <= 31) || (a == 192 && b == 168)) {
      return 'Private (Lokal)';
    }
    if (a == 127) return 'Loopback';
    return 'Public (Internet)';
  }

  String _buildArpa(List<int> ip) {
    return '${ip[3]}.${ip[2]}.${ip[1]}.${ip[0]}.in-addr.arpa';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text('Kalkulator Subnet', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: AppTheme.primaryBrown,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 18),
                  _buildInputCard(isDark),
                  const SizedBox(height: 18),
                  if (_errorMessage != null) _buildErrorMessage(),
                  if (_network != null) _buildResultSection(),
                  const SizedBox(height: 18),
                  _buildLearningCard(isDark),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryBrown, AppTheme.darkBrown],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
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
            child: const Icon(Icons.calculate_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 14),
          const Text(
            'Kalkulator Subnet',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Hitung Network Address, Broadcast, Subnet Mask, Host Range, dan informasi lengkap jaringan IPv4.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Masukkan Data Jaringan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Masukkan IP Address dan nilai CIDR.',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 16),
          const Text('IP Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: AppTheme.textMuted)),
          const SizedBox(height: 6),
          TextField(
            controller: _ipController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(color: isDark ? Colors.white : AppTheme.textDark),
            decoration: InputDecoration(
              hintText: '192.168.1.10',
              filled: true,
              fillColor: isDark ? const Color(0xFF2E241E) : AppTheme.surfaceCream,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 14),
          const Text('CIDR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: AppTheme.textMuted)),
          const SizedBox(height: 6),
          TextField(
            controller: _cidrController,
            keyboardType: TextInputType.number,
            style: TextStyle(color: isDark ? Colors.white : AppTheme.textDark),
            decoration: InputDecoration(
              prefixText: '/',
              hintText: '24',
              filled: true,
              fillColor: isDark ? const Color(0xFF2E241E) : AppTheme.surfaceCream,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _calculateSubnet,
              icon: const Icon(Icons.calculate_rounded),
              label: const Text('Hitung Subnet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBrown,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.accentRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.accentRed.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppTheme.accentRed),
          const SizedBox(width: 10),
          Expanded(child: Text(_errorMessage!, style: const TextStyle(color: AppTheme.accentRed, fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildResultSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('HASIL KALKULASI SUBNET', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1, color: AppTheme.textMuted)),
        const SizedBox(height: 10),
        _resultCard('IP Address / CIDR', '$_short ($_ipType)', AppTheme.primaryBrown),
        _resultCard('Kelas IP', 'Kelas $_ipClass', AppTheme.primaryBrown),
        _resultCard('Network Address', _network!, AppTheme.primaryBrown),
        _resultCard('Broadcast Address', _broadcast!, AppTheme.accentRed),
        _resultCard('Subnet Mask', '$_subnetMask ($_cidrNotation)', Colors.green),
        _resultCard('Wildcard Mask', _wildcard ?? '-', Colors.orange),
        _resultCard('Subnet Biner', _binarySubnetMask ?? '-', const Color(0xFF8E6F5B)),
        _resultCard('IP Biner', _binaryId ?? '-', Colors.blue),
        _resultCard('Host Usable Range', '$_firstHost - $_lastHost', AppTheme.accentAmber),
        _resultCard('Jumlah Total IP', _totalHosts ?? '-', AppTheme.primaryBrown),
        _resultCard('Jumlah Host Usable', _usableHosts!, AppTheme.primaryBrown),
        _resultCard('Reverse DNS (ARPA)', _arpa ?? '-', AppTheme.textMuted),
        _resultCard('Format Heksadesimal', _hexId ?? '-', AppTheme.textMuted),
      ],
    );
  }

  Widget _resultCard(String title, String value, Color color) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 38,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.textDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_rounded, color: AppTheme.accentAmber, size: 20),
              SizedBox(width: 8),
              Text('Tahukah Kamu?', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'CIDR /24 menggunakan 24 bit untuk bagian network dan menyisakan 8 bit untuk host. Pada jaringan IPv4, tersedia 254 alamat host yang dapat digunakan.',
            style: TextStyle(color: Colors.amber.shade900, fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }
}
