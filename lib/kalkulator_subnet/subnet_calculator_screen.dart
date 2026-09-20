import 'package:flutter/material.dart';

class SubnetCalculatorScreen extends StatefulWidget {
  const SubnetCalculatorScreen({super.key});

  @override
  State<SubnetCalculatorScreen> createState() =>
      _SubnetCalculatorScreenState();
}

class _SubnetCalculatorScreenState
    extends State<SubnetCalculatorScreen> {
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
  String? _integerId;
  String? _hexId;
  String? _arpa;
  String? _ipv4Mapped;
  String? _sixToFourPrefix;

  String? _errorMessage;

  @override
  void dispose() {
    _ipController.dispose();
    _cidrController.dispose();
    super.dispose();
  }

  // ============================================================
  // PERHITUNGAN SUBNET
  // ============================================================

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
        _errorMessage =
        'IP Address tidak valid. Contoh: 192.168.1.10';
      });
      return;
    }

    final int? cidr = int.tryParse(cidrText);

    if (cidr == null || cidr < 0 || cidr > 32) {
      setState(() {
        _errorMessage =
        'CIDR harus berupa angka antara 0 sampai 32.';
      });
      return;
    }

    final int ipValue = _ipToInt(ipParts);
    final int mask = _cidrToMask(cidr);

    final int networkValue = ipValue & mask;

    final int broadcastValue =
    networkValue | (~mask & 0xFFFFFFFF);

    final int totalAddresses = _pow2(32 - cidr);

    // Untuk jaringan IPv4 biasa:
    // /0 sampai /30 = total - 2 host usable.
    // /31 dan /32 memiliki aturan khusus.
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
      // ----------------------------------------------------------
      // HASIL SUBNET UTAMA
      // ----------------------------------------------------------

      _network = _intToIp(networkValue);

      _broadcast = _intToIp(broadcastValue);

      _subnetMask = _intToIp(mask);

      _wildcard = _intToIp(
        ~mask & 0xFFFFFFFF,
      );

      // Tetap dipertahankan
      _firstHost = _intToIp(firstHostValue);

      // Tetap dipertahankan
      _lastHost = _intToIp(lastHostValue);

      _totalHosts = _formatNumber(totalAddresses);

      _usableHosts = _formatNumber(usableHosts);

      // ----------------------------------------------------------
      // INFORMASI IP
      // ----------------------------------------------------------

      _binarySubnetMask =
          _intToBinary(mask);

      _ipClass = _getIpClass(ipParts[0]);

      _cidrNotation = '/$cidr';

      _ipType = _getIpType(ipParts);

      // ----------------------------------------------------------
      // INFORMASI TAMBAHAN
      // ----------------------------------------------------------

      _short = _shortIp(ipParts);

      _binaryId = binaryId;

      _integerId = ipValue.toString();

      _hexId = '0x${ipValue.toRadixString(16).toUpperCase().padLeft(8, '0')}';

      _arpa = _buildArpa(ipParts);

      _ipv4Mapped =
      '::ffff:${_intToIp(ipValue)}';

      _sixToFourPrefix =
      '2002:${_hexGroup(ipParts[0], ipParts[1])}:'
          '${_hexGroup(ipParts[2], ipParts[3])}::/48';
    });
  }

  // ============================================================
  // CLEAR HASIL
  // ============================================================

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
    _integerId = null;
    _hexId = null;
    _arpa = null;
    _ipv4Mapped = null;
    _sixToFourPrefix = null;
  }

  // ============================================================
  // PARSE IP
  // ============================================================

  List<int>? _parseIp(String ip) {
    final List<String> parts = ip.split('.');

    if (parts.length != 4) {
      return null;
    }

    final List<int> result = [];

    for (final String part in parts) {
      final int? value = int.tryParse(part);

      if (value == null || value < 0 || value > 255) {
        return null;
      }

      result.add(value);
    }

    return result;
  }

  // ============================================================
  // IP KE INTEGER
  // ============================================================

  int _ipToInt(List<int> parts) {
    return ((parts[0] << 24) |
    (parts[1] << 16) |
    (parts[2] << 8) |
    parts[3]) &
    0xFFFFFFFF;
  }

  // ============================================================
  // CIDR KE SUBNET MASK
  // ============================================================

  int _cidrToMask(int cidr) {
    if (cidr == 0) {
      return 0;
    }

    return (0xFFFFFFFF << (32 - cidr)) &
    0xFFFFFFFF;
  }

  // ============================================================
  // INTEGER KE IP
  // ============================================================

  String _intToIp(int value) {
    final int a = (value >> 24) & 255;
    final int b = (value >> 16) & 255;
    final int c = (value >> 8) & 255;
    final int d = value & 255;

    return '$a.$b.$c.$d';
  }

  // ============================================================
  // INTEGER KE BINARY
  // ============================================================

  String _intToBinary(int value) {
    final int a = (value >> 24) & 255;
    final int b = (value >> 16) & 255;
    final int c = (value >> 8) & 255;
    final int d = value & 255;

    return '${_byteToBinary(a)}.'
        '${_byteToBinary(b)}.'
        '${_byteToBinary(c)}.'
        '${_byteToBinary(d)}';
  }

  String _byteToBinary(int value) {
    return value.toRadixString(2).padLeft(8, '0');
  }

  // ============================================================
  // PANGKAT 2
  // ============================================================

  int _pow2(int exponent) {
    int result = 1;

    for (int i = 0; i < exponent; i++) {
      result *= 2;
    }

    return result;
  }

  // ============================================================
  // FORMAT ANGKA
  // ============================================================

  String _formatNumber(int number) {
    return number.toString();
  }

  // ============================================================
  // IP CLASS
  // ============================================================

  String _getIpClass(int firstOctet) {
    if (firstOctet >= 1 && firstOctet <= 126) {
      return 'A';
    }

    if (firstOctet >= 128 && firstOctet <= 191) {
      return 'B';
    }

    if (firstOctet >= 192 && firstOctet <= 223) {
      return 'C';
    }

    if (firstOctet >= 224 && firstOctet <= 239) {
      return 'D';
    }

    if (firstOctet >= 240 && firstOctet <= 255) {
      return 'E';
    }

    return 'Unknown';
  }

  // ============================================================
  // IP TYPE
  // ============================================================

  String _getIpType(List<int> ip) {
    final int a = ip[0];
    final int b = ip[1];

    // Private 10.0.0.0/8
    if (a == 10) {
      return 'Private';
    }

    // Private 172.16.0.0/12
    if (a == 172 && b >= 16 && b <= 31) {
      return 'Private';
    }

    // Private 192.168.0.0/16
    if (a == 192 && b == 168) {
      return 'Private';
    }

    // Loopback
    if (a == 127) {
      return 'Loopback';
    }

    // Link-local
    if (a == 169 && b == 254) {
      return 'Link-local';
    }

    // Multicast
    if (a >= 224 && a <= 239) {
      return 'Multicast';
    }

    // Reserved / experimental
    if (a >= 240) {
      return 'Reserved';
    }

    return 'Public';
  }

  // ============================================================
  // SHORT IP
  // ============================================================

  String _shortIp(List<int> ip) {
    return ip.join('.');
  }

  // ============================================================
  // REVERSE DNS / IN-ADDR.ARPA
  // ============================================================

  String _buildArpa(List<int> ip) {
    return '${ip[3]}.${ip[2]}.${ip[1]}.${ip[0]}.in-addr.arpa';
  }

  // ============================================================
  // 6TO4 HEX GROUP
  // ============================================================

  String _hexGroup(int first, int second) {
    final String firstHex =
    first.toRadixString(16).padLeft(2, '0');

    final String secondHex =
    second.toRadixString(16).padLeft(2, '0');

    return '$firstHex$secondHex'.toUpperCase();
  }

  // ============================================================
  // BUILD UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text('Kalkulator Subnet'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 18),

              _buildInputCard(),

              const SizedBox(height: 18),

              if (_errorMessage != null)
                _buildErrorMessage(),

              if (_network != null)
                _buildResultSection(),

              const SizedBox(height: 18),

              _buildLearningCard(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1565C0),
            Color(0xFF1976D2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.calculate_rounded,
            color: Colors.white,
            size: 42,
          ),

          SizedBox(height: 12),

          Text(
            'Kalkulator Subnet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 6),

          Text(
            'Hitung Network Address, Broadcast, '
                'Subnet Mask, Host Range, dan '
                'informasi lengkap jaringan IPv4.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INPUT CARD
  // ============================================================

  Widget _buildInputCard() {
    return _card(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'Masukkan Data Jaringan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Masukkan IP Address dan nilai CIDR.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'IP Address',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: _ipController,
            keyboardType:
            const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: InputDecoration(
              hintText: 'Contoh: 192.168.1.10',
              prefixIcon: const Icon(
                Icons.language_rounded,
              ),
              filled: true,
              fillColor: const Color(0xFFF5F7FA),
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'CIDR',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: _cidrController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixText: '/',
              hintText: '24',
              prefixIcon: const Icon(
                Icons.tag_rounded,
              ),
              filled: true,
              fillColor: const Color(0xFFF5F7FA),
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _calculateSubnet,
              icon: const Icon(
                Icons.calculate_rounded,
              ),
              label: const Text(
                'Hitung Subnet',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildErrorMessage() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFCDD2),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.red,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HASIL PERHITUNGAN
  // ============================================================

  Widget _buildResultSection() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'Hasil Perhitungan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        // --------------------------------------------------------
        // HASIL UTAMA
        // --------------------------------------------------------

        _resultCard(
          icon: Icons.router_rounded,
          title: 'Network Address',
          value: _network!,
          color: const Color(0xFF1565C0),
        ),

        _resultCard(
          icon: Icons.cell_tower_rounded,
          title: 'Broadcast Address',
          value: _broadcast!,
          color: const Color(0xFFE53935),
        ),

        _resultCard(
          icon: Icons.security_rounded,
          title: 'Subnet Mask',
          value: _subnetMask!,
          color: const Color(0xFF43A047),
        ),

        _resultCard(
          icon: Icons.swap_horiz_rounded,
          title: 'Wildcard Mask',
          value: _wildcard!,
          color: const Color(0xFF8E24AA),
        ),

        // --------------------------------------------------------
        // HOST PERTAMA & TERAKHIR
        // --------------------------------------------------------

        _resultCard(
          icon: Icons.first_page_rounded,
          title: 'Host Pertama',
          value: _firstHost!,
          color: const Color(0xFFFF9800),
        ),

        _resultCard(
          icon: Icons.last_page_rounded,
          title: 'Host Terakhir',
          value: _lastHost!,
          color: const Color(0xFF00897B),
        ),

        _resultCard(
          icon: Icons.devices_rounded,
          title: 'Total Number of Hosts',
          value: _totalHosts!,
          color: const Color(0xFF1976D2),
        ),

        _resultCard(
          icon: Icons.people_alt_rounded,
          title: 'Number of Usable Hosts',
          value: _usableHosts!,
          color: const Color(0xFF2E7D32),
        ),

        // --------------------------------------------------------
        // INFORMASI IP
        // --------------------------------------------------------

        const SizedBox(height: 8),

        _buildSectionTitle(
          'Informasi IP',
          Icons.info_outline_rounded,
        ),

        _resultCard(
          icon: Icons.lan_rounded,
          title: 'Binary Subnet Mask',
          value: _binarySubnetMask!,
          color: const Color(0xFF5E35B1),
          smallerText: true,
        ),

        _resultCard(
          icon: Icons.category_rounded,
          title: 'IP Class',
          value: _ipClass!,
          color: const Color(0xFF3949AB),
        ),

        _resultCard(
          icon: Icons.code_rounded,
          title: 'CIDR Notation',
          value: _cidrNotation!,
          color: const Color(0xFF00897B),
        ),

        _resultCard(
          icon: Icons.public_rounded,
          title: 'IP Type',
          value: _ipType!,
          color: const Color(0xFF1E88E5),
        ),

        // --------------------------------------------------------
        // INFORMASI TAMBAHAN
        // --------------------------------------------------------

        const SizedBox(height: 8),

        _buildSectionTitle(
          'Informasi Tambahan',
          Icons.more_horiz_rounded,
        ),

        _resultCard(
          icon: Icons.short_text_rounded,
          title: 'Short',
          value: _short!,
          color: const Color(0xFF546E7A),
        ),

        _resultCard(
          icon: Icons.code_rounded,
          title: 'Binary ID',
          value: _binaryId!,
          color: const Color(0xFF1565C0),
          smallerText: true,
        ),

        _resultCard(
          icon: Icons.numbers_rounded,
          title: 'Integer ID',
          value: _integerId!,
          color: const Color(0xFF6D4C41),
        ),

        _resultCard(
          icon: Icons.tag_rounded,
          title: 'Hex ID',
          value: _hexId!,
          color: const Color(0xFF8E24AA),
        ),

        _resultCard(
          icon: Icons.dns_rounded,
          title: 'in-addr.arpa',
          value: _arpa!,
          color: const Color(0xFF00897B),
          smallerText: true,
        ),

        _resultCard(
          icon: Icons.language_rounded,
          title: 'IPv4 Mapped Address',
          value: _ipv4Mapped!,
          color: const Color(0xFF1976D2),
        ),

        _resultCard(
          icon: Icons.hub_rounded,
          title: '6to4 Prefix',
          value: _sixToFourPrefix!,
          color: const Color(0xFFE65100),
        ),
      ],
    );
  }

  // ============================================================
  // JUDUL SECTION
  // ============================================================

  Widget _buildSectionTitle(
      String title,
      IconData icon,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 12,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius:
              BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1565C0),
              size: 21,
            ),
          ),

          const SizedBox(width: 10),

          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RESULT CARD
  // ============================================================

  Widget _resultCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    bool smallerText = false,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius:
              BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: TextStyle(
                    fontSize:
                    smallerText ? 12 : 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF172B4D),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LEARNING CARD
  // ============================================================

  Widget _buildLearningCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFBBDEFB),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lightbulb_rounded,
                  color: Color(0xFF1565C0),
                ),
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Text(
                  'Tahukah Kamu?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1565C0),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            'CIDR /24 menggunakan 24 bit untuk bagian '
                'network dan menyisakan 8 bit untuk host. '
                'Pada jaringan IPv4 biasa, terdapat 254 alamat '
                'host yang dapat digunakan.',
            style: TextStyle(
              color: Colors.blueGrey.shade800,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CARD UMUM
  // ============================================================

  Widget _card({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}