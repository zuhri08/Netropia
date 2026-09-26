import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// ===============================================================
/// NETROPIA NETWORK SIMULATOR
/// Mobile-first Android UI
/// ===============================================================

/// ===============================================================
/// ENUMS
/// ===============================================================

enum DeviceType {
  pc,
  laptop,
  server,
  switchDevice,
  router,
  accessPoint,
  hub,
}

extension DeviceTypeInfo on DeviceType {
  String get label {
    switch (this) {
      case DeviceType.pc:
        return 'PC';
      case DeviceType.laptop:
        return 'Laptop';
      case DeviceType.server:
        return 'Server';
      case DeviceType.switchDevice:
        return 'Switch';
      case DeviceType.router:
        return 'Router';
      case DeviceType.accessPoint:
        return 'Access Point';
      case DeviceType.hub:
        return 'Hub';
    }
  }

  IconData get icon {
    switch (this) {
      case DeviceType.pc:
        return Icons.computer;
      case DeviceType.laptop:
        return Icons.laptop;
      case DeviceType.server:
        return Icons.dns;
      case DeviceType.switchDevice:
        return Icons.lan;
      case DeviceType.router:
        return Icons.router;
      case DeviceType.accessPoint:
        return Icons.wifi;
      case DeviceType.hub:
        return Icons.device_hub;
    }
  }
}

enum CableType {
  copperStraight,
  copperCross,
  console,
  fiber,
  serialDce,
  serialDte,
}

extension CableTypeInfo on CableType {
  String get label {
    switch (this) {
      case CableType.copperStraight:
        return 'Straight';
      case CableType.copperCross:
        return 'Cross';
      case CableType.console:
        return 'Console';
      case CableType.fiber:
        return 'Fiber';
      case CableType.serialDce:
        return 'Serial DCE';
      case CableType.serialDte:
        return 'Serial DTE';
    }
  }

  String get shortLabel {
    switch (this) {
      case CableType.copperStraight:
        return 'Straight';
      case CableType.copperCross:
        return 'Cross';
      case CableType.console:
        return 'Console';
      case CableType.fiber:
        return 'Fiber';
      case CableType.serialDce:
        return 'DCE';
      case CableType.serialDte:
        return 'DTE';
    }
  }

  IconData get icon {
    switch (this) {
      case CableType.copperStraight:
        return Icons.cable;
      case CableType.copperCross:
        return Icons.sync_alt;
      case CableType.console:
        return Icons.settings_ethernet;
      case CableType.fiber:
        return Icons.fiber_manual_record;
      case CableType.serialDce:
        return Icons.swap_horiz;
      case CableType.serialDte:
        return Icons.swap_vert;
    }
  }
}

enum PortType {
  ethernet,
  fastEthernet,
  gigabitEthernet,
  fiber,
  serialDce,
  serialDte,
  console,
}

enum DeviceStatus {
  normal,
  warning,
  error,
  disabled,
}

extension DeviceStatusInfo on DeviceStatus {
  Color get color {
    switch (this) {
      case DeviceStatus.normal:
        return Colors.green;
      case DeviceStatus.warning:
        return Colors.amber;
      case DeviceStatus.error:
        return Colors.red;
      case DeviceStatus.disabled:
        return Colors.grey;
    }
  }

  String get label {
    switch (this) {
      case DeviceStatus.normal:
        return 'Normal';
      case DeviceStatus.warning:
        return 'Warning';
      case DeviceStatus.error:
        return 'Error';
      case DeviceStatus.disabled:
        return 'Disabled';
    }
  }
}

/// ===============================================================
/// MODELS
/// ===============================================================

class NetworkPort {
  final String id;
  final String name;
  final PortType type;
  bool enabled;
  int? connectionId;

  NetworkPort({
    required this.id,
    required this.name,
    required this.type,
    this.enabled = true,
    this.connectionId,
  });

  bool get isAvailable => enabled && connectionId == null;
}

class NetworkDevice {
  final int id;
  DeviceType type;
  String name;
  String ip;
  String subnetMask;
  String gateway;
  double x;
  double y;
  bool powerOn;
  List<NetworkPort> ports;

  NetworkDevice({
    required this.id,
    required this.type,
    required this.name,
    this.ip = '',
    this.subnetMask = '255.255.255.0',
    this.gateway = '',
    required this.x,
    required this.y,
    this.powerOn = true,
    required this.ports,
  });

  DeviceStatus status(List<NetworkConnection> connections) {
    if (!powerOn) {
      return DeviceStatus.disabled;
    }

    final hasBadConnection = connections.any(
          (c) =>
      !c.valid &&
          (c.fromDeviceId == id || c.toDeviceId == id),
    );

    if (hasBadConnection) {
      return DeviceStatus.error;
    }

    if (ip.isEmpty) {
      return DeviceStatus.warning;
    }

    if (!_validIpv4(ip)) {
      return DeviceStatus.error;
    }

    return DeviceStatus.normal;
  }

  String statusMessage(List<NetworkConnection> connections) {
    if (!powerOn) {
      return 'Perangkat mati';
    }

    final bad = connections.where(
          (c) =>
      !c.valid &&
          (c.fromDeviceId == id || c.toDeviceId == id),
    );

    if (bad.isNotEmpty) {
      return bad.first.errorMessage;
    }

    if (ip.isEmpty) {
      return 'IP belum diatur';
    }

    if (!_validIpv4(ip)) {
      return 'IP tidak valid';
    }

    return '';
  }

  bool _validIpv4(String ip) {
    final parts = ip.split('.');
    if (parts.length != 4) return false;
    for (final p in parts) {
      final n = int.tryParse(p);
      if (n == null || n < 0 || n > 255) return false;
    }
    return true;
  }
}

class NetworkConnection {
  final int id;
  final int fromDeviceId;
  final int toDeviceId;

  final String fromPortId;
  final String toPortId;

  final CableType cableType;

  bool valid;
  String errorMessage;

  NetworkConnection({
    required this.id,
    required this.fromDeviceId,
    required this.toDeviceId,
    required this.fromPortId,
    required this.toPortId,
    required this.cableType,
    this.valid = true,
    this.errorMessage = '',
  });
}

/// ===============================================================
/// MAIN PAGE
/// ===============================================================

class SimulatorPage extends StatefulWidget {
  const SimulatorPage({super.key});

  @override
  State<SimulatorPage> createState() => _SimulatorPageState();
}

/// Alias agar nama lain tetap bisa dipakai.
/// Tidak perlu diubah kalau virtual_lab_screen.dart
/// sudah memanggil SimulatorPage.
class SimulasiJaringanScreen extends SimulatorPage {
  const SimulasiJaringanScreen({super.key});
}

class _SimulatorPageState extends State<SimulatorPage> {
  final TransformationController transformationController =
  TransformationController();

  final TextEditingController cliController =
  TextEditingController();

  final List<NetworkDevice> devices = [];
  final List<NetworkConnection> connections = [];

  final List<String> cliHistory = [
    'NETROPIA NETWORK SIMULATOR v2.0',
    'Siap digunakan.',
    'Pilih perangkat lalu Config.',
  ];

  int nextDeviceId = 1;
  int nextConnectionId = 1;

  int? selectedDeviceId;

  CableType? selectedCable;

  bool connectMode = false;
  int? sourceDeviceId;

  bool showCli = false;
  bool showPortPanel = false;

  int? pendingTargetDeviceId;

  @override
  void initState() {
    super.initState();

    _createInitialTopology();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fitAll();
    });
  }

  @override
  void dispose() {
    transformationController.dispose();
    cliController.dispose();
    super.dispose();
  }

  /// =============================================================
  /// INITIAL TOPOLOGY
  /// =============================================================

  void _createInitialTopology() {
    devices.add(
      _createDevice(
        DeviceType.pc,
        'PC-01',
        350,
        450,
      ),
    );

    devices.add(
      _createDevice(
        DeviceType.switchDevice,
        'SW-01',
        800,
        450,
      ),
    );

    devices.add(
      _createDevice(
        DeviceType.pc,
        'PC-02',
        1200,
        450,
      ),
    );

    devices.add(
      _createDevice(
        DeviceType.router,
        'R-01',
        800,
        750,
      ),
    );
  }

  NetworkDevice _createDevice(
      DeviceType type,
      String name,
      double x,
      double y,
      ) {
    final id = nextDeviceId++;

    return NetworkDevice(
      id: id,
      type: type,
      name: name,
      x: x,
      y: y,
      ports: _portsFor(type),
    );
  }

  List<NetworkPort> _portsFor(DeviceType type) {
    switch (type) {
      case DeviceType.pc:
      case DeviceType.laptop:
      case DeviceType.server:
        return [
          NetworkPort(
            id: 'eth0',
            name: 'Ethernet0',
            type: PortType.ethernet,
          ),
          NetworkPort(
            id: 'console',
            name: 'Console',
            type: PortType.console,
          ),
        ];

      case DeviceType.switchDevice:
        return [
          for (int i = 1; i <= 8; i++)
            NetworkPort(
              id: 'fa$i',
              name: 'FastEthernet$i',
              type: PortType.fastEthernet,
            ),
          NetworkPort(
            id: 'gi1',
            name: 'GigabitEthernet0/1',
            type: PortType.gigabitEthernet,
          ),
          NetworkPort(
            id: 'sfp1',
            name: 'SFP1',
            type: PortType.fiber,
          ),
          NetworkPort(
            id: 'console',
            name: 'Console',
            type: PortType.console,
          ),
        ];

      case DeviceType.router:
        return [
          NetworkPort(
            id: 'gi0',
            name: 'GigabitEthernet0/0',
            type: PortType.gigabitEthernet,
          ),
          NetworkPort(
            id: 'gi1',
            name: 'GigabitEthernet0/1',
            type: PortType.gigabitEthernet,
          ),
          NetworkPort(
            id: 'sfp0',
            name: 'SFP0',
            type: PortType.fiber,
          ),
          NetworkPort(
            id: 's0',
            name: 'Serial0/0/0',
            type: PortType.serialDce,
          ),
          NetworkPort(
            id: 's1',
            name: 'Serial0/0/1',
            type: PortType.serialDte,
          ),
          NetworkPort(
            id: 'console',
            name: 'Console',
            type: PortType.console,
          ),
        ];

      case DeviceType.accessPoint:
        return [
          NetworkPort(
            id: 'eth0',
            name: 'Ethernet0',
            type: PortType.ethernet,
          ),
        ];

      case DeviceType.hub:
        return [
          for (int i = 1; i <= 6; i++)
            NetworkPort(
              id: 'eth$i',
              name: 'Ethernet$i',
              type: PortType.ethernet,
            ),
        ];
    }
  }

  /// =============================================================
  /// HELPERS
  /// =============================================================

  NetworkDevice? _deviceById(int id) {
    for (final device in devices) {
      if (device.id == id) {
        return device;
      }
    }
    return null;
  }

  NetworkPort? _portById(
      NetworkDevice device,
      String portId,
      ) {
    for (final port in device.ports) {
      if (port.id == portId) {
        return port;
      }
    }
    return null;
  }

  String _ipError(String ip) {
    if (ip.trim().isEmpty) {
      return '';
    }

    final parts = ip.trim().split('.');

    if (parts.length != 4) {
      return 'Format IPv4 harus x.x.x.x';
    }

    for (final part in parts) {
      final value = int.tryParse(part);

      if (value == null || value < 0 || value > 255) {
        return 'IP IPv4 tidak valid';
      }
    }

    return '';
  }

  bool _validIpv4(String ip) {
    return _ipError(ip).isEmpty && ip.trim().isNotEmpty;
  }

  int? _ipv4ToInt(String ip) {
    if (!_validIpv4(ip)) {
      return null;
    }

    final p = ip.split('.').map(int.parse).toList();

    return (p[0] << 24) |
    (p[1] << 16) |
    (p[2] << 8) |
    p[3];
  }

  bool _sameSubnet(
      String ip1,
      String ip2,
      String mask,
      ) {
    final a = _ipv4ToInt(ip1);
    final b = _ipv4ToInt(ip2);
    final m = _ipv4ToInt(mask);

    if (a == null || b == null || m == null) {
      return false;
    }

    return (a & m) == (b & m);
  }

  /// =============================================================
  /// DEVICE ADD
  /// =============================================================

  void _addDevice(DeviceType type) {
    final index = devices.where((d) => d.type == type).length + 1;

    final name = '${type.label}-$index';

    final positions = [
      const Offset(350, 250),
      const Offset(800, 250),
      const Offset(1200, 250),
      const Offset(350, 700),
      const Offset(1200, 700),
      const Offset(500, 950),
      const Offset(1100, 950),
    ];

    final position =
    positions[(devices.length) % positions.length];

    final device = _createDevice(
      type,
      name,
      position.dx,
      position.dy,
    );

    setState(() {
      devices.add(device);
      selectedDeviceId = device.id;
    });

    _log('Tambah perangkat ${device.name}');
    _fitAll();
  }

  /// =============================================================
  /// DELETE
  /// =============================================================

  void _deleteSelected() {
    final id = selectedDeviceId;

    if (id == null) {
      _snack('Pilih perangkat terlebih dahulu.');
      return;
    }

    final device = _deviceById(id);

    if (device == null) {
      return;
    }

    setState(() {
      connections.removeWhere(
            (c) => c.fromDeviceId == id || c.toDeviceId == id,
      );

      devices.removeWhere((d) => d.id == id);

      selectedDeviceId = null;
      connectMode = false;
      sourceDeviceId = null;
    });

    _refreshPortUsage();

    _log('Menghapus ${device.name}');
  }

  /// =============================================================
  /// CABLE SELECTION
  /// =============================================================

  void _selectCable(CableType cable) {
    setState(() {
      selectedCable = cable;
      connectMode = false;
      sourceDeviceId = null;
    });

    _snack(
      '${cable.label} dipilih. Tap perangkat sumber.',
    );
  }

  void _startConnect() {
    if (selectedCable == null) {
      _openCablePicker();
      return;
    }

    setState(() {
      connectMode = true;
      sourceDeviceId = null;
    });

    _snack(
      '${selectedCable!.label}: pilih perangkat sumber.',
    );
  }

  void _handleDeviceTap(NetworkDevice device) {
    if (!connectMode) {
      setState(() {
        selectedDeviceId = device.id;
      });

      return;
    }

    if (sourceDeviceId == null) {
      setState(() {
        sourceDeviceId = device.id;
        selectedDeviceId = device.id;
      });

      _openPortPicker(
        device,
        isSource: true,
      );

      return;
    }

    if (sourceDeviceId == device.id) {
      _snack(
        'Perangkat sumber dan tujuan tidak boleh sama.',
      );
      return;
    }

    setState(() {
      pendingTargetDeviceId = device.id;
    });

    _openPortPicker(
      device,
      isSource: false,
    );
  }

  /// =============================================================
  /// PORT PICKER
  /// =============================================================

  void _openPortPicker(
      NetworkDevice device, {
        required bool isSource,
      }) {
    final cable = selectedCable;

    if (cable == null) {
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B1726),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              18,
              18,
              18,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      cable.icon,
                      color: Colors.cyanAccent,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${isSource ? 'Port sumber' : 'Port tujuan'} • ${device.name}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Kabel: ${cable.label}',
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 14),
                ...device.ports.map(
                      (port) {
                    final compatible =
                    _portCompatibleWithCable(
                      port,
                      cable,
                    );

                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF122235),
                        borderRadius:
                        BorderRadius.circular(14),
                        border: Border.all(
                          color: compatible
                              ? Colors.white12
                              : Colors.red.withOpacity(.18),
                        ),
                      ),
                      child: ListTile(
                        dense: true,
                        leading: Icon(
                          _portIcon(port.type),
                          color: compatible
                              ? Colors.greenAccent
                              : Colors.redAccent,
                        ),
                        title: Text(
                          port.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${_portTypeLabel(port.type)} • '
                              '${!port.enabled ? 'Disabled' : port.connectionId != null ? 'Terpakai' : 'Kosong'}',
                          style: TextStyle(
                            color: compatible
                                ? Colors.white54
                                : Colors.redAccent,
                            fontSize: 11,
                          ),
                        ),
                        trailing: compatible &&
                            port.isAvailable
                            ? const Icon(
                          Icons.chevron_right,
                          color: Colors.white54,
                        )
                            : const Icon(
                          Icons.block,
                          color: Colors.redAccent,
                        ),
                        onTap: compatible &&
                            port.isAvailable
                            ? () {
                          Navigator.pop(context);

                          if (isSource) {
                            _selectSourcePort(
                              device,
                              port,
                            );
                          } else {
                            _selectTargetPort(
                              device,
                              port,
                            );
                          }
                        }
                            : null,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _selectSourcePort(
      NetworkDevice device,
      NetworkPort port,
      ) {
    _snack(
      'Sumber ${device.name} • ${port.name}. Sekarang pilih perangkat tujuan.',
    );

    setState(() {
      sourceDeviceId = device.id;
      selectedDeviceId = device.id;
    });

    /// Setelah source port dipilih,
    /// user kembali tap device tujuan.
  }

  void _selectTargetPort(
      NetworkDevice device,
      NetworkPort port,
      ) {
    final sourceId = sourceDeviceId;

    if (sourceId == null) {
      return;
    }

    final source = _deviceById(sourceId);

    if (source == null || selectedCable == null) {
      return;
    }

    final sourcePort = _findFreeCompatiblePort(
      source,
      selectedCable!,
    );

    /// Source port sebenarnya sudah dipilih melalui
    /// bottom sheet. Kita perlu memilih ulang agar akurat.
    /// Untuk itu user harus memilih source port terlebih dahulu
    /// dan nilainya disimpan sementara.
    if (sourcePort == null) {
      _createInvalidConnection(
        source,
        device,
        'Port sumber tidak ditemukan/terpakai.',
      );
      return;
    }

    _connectDevices(
      source,
      device,
      sourcePort,
      port,
      selectedCable!,
    );
  }

  String? _pendingSourcePortId;

  void _connectDevices(
      NetworkDevice source,
      NetworkDevice target,
      NetworkPort sourcePort,
      NetworkPort targetPort,
      CableType cable,
      ) {
    final result = _validateConnection(
      source,
      target,
      sourcePort,
      targetPort,
      cable,
    );

    final connection = NetworkConnection(
      id: nextConnectionId++,
      fromDeviceId: source.id,
      toDeviceId: target.id,
      fromPortId: sourcePort.id,
      toPortId: targetPort.id,
      cableType: cable,
      valid: result.$1,
      errorMessage: result.$2,
    );

    setState(() {
      connections.add(connection);

      if (result.$1) {
        sourcePort.connectionId = connection.id;
        targetPort.connectionId = connection.id;
      }

      connectMode = false;
      sourceDeviceId = null;
      pendingTargetDeviceId = null;
      selectedDeviceId = target.id;
    });

    if (result.$1) {
      _log(
        '${cable.label}: '
            '${source.name}:${sourcePort.name} <-> '
            '${target.name}:${targetPort.name}',
      );

      _snack(
        'Koneksi berhasil dibuat.',
        color: Colors.green,
      );
    } else {
      _log(
        'ERROR: ${result.$2}',
      );

      _snack(
        result.$2,
        color: Colors.red,
      );
    }
  }

  void _createInvalidConnection(
      NetworkDevice source,
      NetworkDevice target,
      String message,
      ) {
    if (selectedCable == null) {
      return;
    }

    final connection = NetworkConnection(
      id: nextConnectionId++,
      fromDeviceId: source.id,
      toDeviceId: target.id,
      fromPortId: '',
      toPortId: '',
      cableType: selectedCable!,
      valid: false,
      errorMessage: message,
    );

    setState(() {
      connections.add(connection);
      connectMode = false;
      sourceDeviceId = null;
      pendingTargetDeviceId = null;
    });

    _log('ERROR: $message');

    _snack(
      message,
      color: Colors.red,
    );
  }

  /// =============================================================
  /// CONNECTION VALIDATION
  /// =============================================================

  (bool, String) _validateConnection(
      NetworkDevice from,
      NetworkDevice to,
      NetworkPort fromPort,
      NetworkPort toPort,
      CableType cable,
      ) {
    if (!from.powerOn || !to.powerOn) {
      return (
      false,
      'Perangkat harus dalam kondisi ON.',
      );
    }

    if (!fromPort.enabled || !toPort.enabled) {
      return (
      false,
      'Port dalam keadaan disabled.',
      );
    }

    if (fromPort.connectionId != null ||
        toPort.connectionId != null) {
      return (
      false,
      'Salah satu port sudah digunakan.',
      );
    }

    if (cable == CableType.console) {
      final validPair =
          _isConsoleDevice(from) &&
              _isConsoleDevice(to);

      final validPorts =
          fromPort.type == PortType.console &&
              toPort.type == PortType.console;

      if (!validPair || !validPorts) {
        return (
        false,
        'Console Cable hanya untuk Console PC/Laptop ke Console Router/Switch.',
        );
      }

      return (true, '');
    }

    if (cable == CableType.fiber) {
      if (fromPort.type != PortType.fiber ||
          toPort.type != PortType.fiber) {
        return (
        false,
        'Fiber Optic harus memakai port Fiber/SFP.',
        );
      }

      return (true, '');
    }

    if (cable == CableType.serialDce ||
        cable == CableType.serialDte) {
      if (from.type != DeviceType.router ||
          to.type != DeviceType.router) {
        return (
        false,
        'Serial Cable hanya untuk Router ke Router.',
        );
      }

      if (!_isSerialPort(fromPort.type) ||
          !_isSerialPort(toPort.type)) {
        return (
        false,
        'Serial harus terhubung ke port serial.',
        );
      }

      if (cable == CableType.serialDce) {
        if (fromPort.type != PortType.serialDce) {
          return (
          false,
          'Serial DCE membutuhkan port Serial DCE.',
          );
        }

        if (toPort.type != PortType.serialDte) {
          return (
          false,
          'Ujung kedua harus Serial DTE.',
          );
        }
      }

      if (cable == CableType.serialDte) {
        if (fromPort.type != PortType.serialDte) {
          return (
          false,
          'Serial DTE membutuhkan port Serial DTE.',
          );
        }

        if (toPort.type != PortType.serialDce) {
          return (
          false,
          'Ujung kedua harus Serial DCE.',
          );
        }
      }

      return (true, '');
    }

    if (cable == CableType.copperStraight) {
      final valid = _straightCompatible(
        from,
        to,
      );

      if (!valid) {
        return (
        false,
        'Copper Straight-Through tidak cocok untuk kombinasi perangkat ini.',
        );
      }

      if (!_copperPort(fromPort.type) ||
          !_copperPort(toPort.type)) {
        return (
        false,
        'Straight-Through harus menggunakan port Ethernet.',
        );
      }

      return (true, '');
    }

    if (cable == CableType.copperCross) {
      final valid = _crossCompatible(
        from,
        to,
      );

      if (!valid) {
        return (
        false,
        'Copper Cross-Over tidak cocok untuk kombinasi perangkat ini.',
        );
      }

      if (!_copperPort(fromPort.type) ||
          !_copperPort(toPort.type)) {
        return (
        false,
        'Cross-Over harus menggunakan port Ethernet.',
        );
      }

      return (true, '');
    }

    return (
    false,
    'Jenis kabel tidak dikenali.',
    );
  }

  bool _isConsoleDevice(NetworkDevice d) {
    return d.type == DeviceType.pc ||
        d.type == DeviceType.laptop ||
        d.type == DeviceType.router ||
        d.type == DeviceType.switchDevice;
  }

  bool _copperPort(PortType type) {
    return type == PortType.ethernet ||
        type == PortType.fastEthernet ||
        type == PortType.gigabitEthernet;
  }

  bool _isSerialPort(PortType type) {
    return type == PortType.serialDce ||
        type == PortType.serialDte;
  }

  bool _straightCompatible(
      NetworkDevice a,
      NetworkDevice b,
      ) {
    final endpointA =
        a.type == DeviceType.pc ||
            a.type == DeviceType.laptop ||
            a.type == DeviceType.server;

    final endpointB =
        b.type == DeviceType.pc ||
            b.type == DeviceType.laptop ||
            b.type == DeviceType.server;

    if (endpointA &&
        (b.type == DeviceType.switchDevice ||
            b.type == DeviceType.hub ||
            b.type == DeviceType.router ||
            b.type == DeviceType.accessPoint)) {
      return true;
    }

    if (endpointB &&
        (a.type == DeviceType.switchDevice ||
            a.type == DeviceType.hub ||
            a.type == DeviceType.router ||
            a.type == DeviceType.accessPoint)) {
      return true;
    }

    if ((a.type == DeviceType.router &&
        b.type == DeviceType.switchDevice) ||
        (b.type == DeviceType.router &&
            a.type == DeviceType.switchDevice)) {
      return true;
    }

    if ((a.type == DeviceType.accessPoint &&
        b.type == DeviceType.switchDevice) ||
        (b.type == DeviceType.accessPoint &&
            a.type == DeviceType.switchDevice)) {
      return true;
    }

    return false;
  }

  bool _crossCompatible(
      NetworkDevice a,
      NetworkDevice b,
      ) {
    final endA =
        a.type == DeviceType.pc ||
            a.type == DeviceType.laptop ||
            a.type == DeviceType.server;

    final endB =
        b.type == DeviceType.pc ||
            b.type == DeviceType.laptop ||
            b.type == DeviceType.server;

    if (endA && endB) {
      return true;
    }

    if ((a.type == DeviceType.router &&
        b.type == DeviceType.router)) {
      return true;
    }

    if ((a.type == DeviceType.switchDevice &&
        b.type == DeviceType.switchDevice) ||
        (a.type == DeviceType.switchDevice &&
            b.type == DeviceType.hub) ||
        (a.type == DeviceType.hub &&
            b.type == DeviceType.switchDevice) ||
        (a.type == DeviceType.hub &&
            b.type == DeviceType.hub)) {
      return true;
    }

    if ((a.type == DeviceType.pc &&
        b.type == DeviceType.router) ||
        (a.type == DeviceType.router &&
            b.type == DeviceType.pc) ||
        (a.type == DeviceType.laptop &&
            b.type == DeviceType.router) ||
        (a.type == DeviceType.router &&
            b.type == DeviceType.laptop)) {
      return true;
    }

    return false;
  }

  bool _portCompatibleWithCable(
      NetworkPort port,
      CableType cable,
      ) {
    if (!port.enabled) {
      return false;
    }

    switch (cable) {
      case CableType.copperStraight:
      case CableType.copperCross:
        return _copperPort(port.type);

      case CableType.console:
        return port.type == PortType.console;

      case CableType.fiber:
        return port.type == PortType.fiber;

      case CableType.serialDce:
        return port.type == PortType.serialDce ||
            port.type == PortType.serialDte;

      case CableType.serialDte:
        return port.type == PortType.serialDce ||
            port.type == PortType.serialDte;
    }
  }

  NetworkPort? _findFreeCompatiblePort(
      NetworkDevice device,
      CableType cable,
      ) {
    for (final port in device.ports) {
      if (port.isAvailable &&
          _portCompatibleWithCable(
            port,
            cable,
          )) {
        return port;
      }
    }

    return null;
  }

  /// =============================================================
  /// DRAG DEVICE
  /// =============================================================

  void _moveDevice(
      NetworkDevice device,
      DragUpdateDetails details,
      ) {
    setState(() {
      device.x += details.delta.dx;
      device.y += details.delta.dy;
    });
  }

  /// =============================================================
  /// CONFIG
  /// =============================================================

  void _openConfig(NetworkDevice device) {
    final nameController =
    TextEditingController(text: device.name);

    final ipController =
    TextEditingController(text: device.ip);

    final maskController =
    TextEditingController(text: device.subnetMask);

    final gatewayController =
    TextEditingController(text: device.gateway);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0B1726),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 18,
              bottom:
              MediaQuery.of(context)
                  .viewInsets
                  .bottom +
                  20,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        device.type.icon,
                        color: Colors.cyanAccent,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Config ${device.name}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed:
                            () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _field(
                    controller: nameController,
                    label: 'Nama Perangkat',
                  ),
                  const SizedBox(height: 12),
                  _field(
                    controller: ipController,
                    label: 'IPv4 Address',
                    keyboardType:
                    TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    controller: maskController,
                    label: 'Subnet Mask',
                    keyboardType:
                    TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    controller: gatewayController,
                    label: 'Default Gateway',
                    keyboardType:
                    TextInputType.number,
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding:
                    const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF122235),
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          device.status(
                            connections,
                          ).color ==
                              Colors.red
                              ? Icons.error
                              : Icons.info_outline,
                          color: device
                              .status(connections)
                              .color,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            device.statusMessage(
                              connections,
                            ).isEmpty
                                ? 'Konfigurasi terlihat normal.'
                                : device.statusMessage(
                              connections,
                            ),
                            style:
                            const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final ip =
                        ipController.text.trim();

                        final mask =
                        maskController.text.trim();

                        final gateway =
                        gatewayController.text
                            .trim();

                        final ipError =
                        _ipError(ip);

                        final maskError =
                        _ipError(mask);

                        final gatewayError =
                        _ipError(gateway);

                        if (ipError.isNotEmpty) {
                          _snack(
                            ipError,
                            color: Colors.red,
                          );
                          return;
                        }

                        if (mask.isNotEmpty &&
                            maskError.isNotEmpty) {
                          _snack(
                            'Subnet mask tidak valid.',
                            color: Colors.red,
                          );
                          return;
                        }

                        if (gateway.isNotEmpty &&
                            gatewayError.isNotEmpty) {
                          _snack(
                            'Gateway tidak valid.',
                            color: Colors.red,
                          );
                          return;
                        }

                        setState(() {
                          device.name =
                          nameController.text
                              .trim()
                              .isEmpty
                              ? device.name
                              : nameController
                              .text
                              .trim();

                          device.ip = ip;
                          device.subnetMask =
                          mask.isEmpty
                              ? '255.255.255.0'
                              : mask;
                          device.gateway =
                              gateway;
                        });

                        Navigator.pop(context);

                        _log(
                          'Config ${device.name}: '
                              'IP=${device.ip} '
                              'MASK=${device.subnetMask} '
                              'GW=${device.gateway}',
                        );
                      },
                      icon: const Icon(
                        Icons.save,
                      ),
                      label: const Text(
                        'Simpan Konfigurasi',
                        style: TextStyle(
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(
                          0xFF0875C9,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.cyanAccent,
        ),
        filled: true,
        fillColor: const Color(0xFF122235),
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// =============================================================
  /// PING
  /// =============================================================

  Future<void> _pingDialog() async {
    if (devices.length < 2) {
      _snack('Minimal ada 2 perangkat.');
      return;
    }

    int? sourceId = selectedDeviceId;
    int? targetId;

    final result = await showModalBottomSheet<
        List<int>>(
      context: context,
      backgroundColor: const Color(0xFF0B1726),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ping Test',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _deviceDropdown(
                      value: sourceId,
                      label: 'Source',
                      onChanged: (value) {
                        setModalState(() {
                          sourceId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _deviceDropdown(
                      value: targetId,
                      label: 'Destination',
                      onChanged: (value) {
                        setModalState(() {
                          targetId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed:
                        sourceId != null &&
                            targetId !=
                                null
                            ? () {
                          Navigator.pop(
                            context,
                            [
                              sourceId!,
                              targetId!,
                            ],
                          );
                        }
                            : null,
                        icon: const Icon(
                          Icons.network_check,
                        ),
                        label: const Text(
                          'Jalankan Ping',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result == null) {
      return;
    }

    final source = _deviceById(result[0]);
    final target = _deviceById(result[1]);

    if (source == null || target == null) {
      return;
    }

    await _runPing(
      source,
      target,
    );
  }

  Widget _deviceDropdown({
    required int? value,
    required String label,
    required ValueChanged<int?> onChanged,
  }) {
    return DropdownButtonFormField<int>(
      value: value,
      dropdownColor:
      const Color(0xFF16293E),
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
        const TextStyle(
          color: Colors.cyanAccent,
        ),
        filled: true,
        fillColor:
        const Color(0xFF122235),
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),
          borderSide:
          BorderSide.none,
        ),
      ),
      items: devices
          .map(
            (device) => DropdownMenuItem<int>(
          value: device.id,
          child: Text(
            '${device.name} ${device.ip.isEmpty ? "(no IP)" : device.ip}',
            style:
            const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      )
          .toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _runPing(
      NetworkDevice source,
      NetworkDevice target,
      ) async {
    _log(
      'PING ${target.ip} dari ${source.name}',
    );

    if (!_validIpv4(source.ip)) {
      _snack(
        'Source belum memiliki IPv4 valid.',
        color: Colors.red,
      );
      return;
    }

    if (!_validIpv4(target.ip)) {
      _snack(
        'Destination belum memiliki IPv4 valid.',
        color: Colors.red,
      );
      return;
    }

    final connected = _hasPath(
      source.id,
      target.id,
    );

    if (!connected) {
      _log(
        'Request timeout - network path tidak tersedia.',
      );

      _snack(
        'Ping GAGAL • Jalur tidak tersedia.',
        color: Colors.red,
      );

      return;
    }

    if (!_sameSubnet(
      source.ip,
      target.ip,
      source.subnetMask,
    )) {
      _log(
        'Destination berbeda subnet.',
      );

      _snack(
        'Ping GAGAL • Berbeda subnet.',
        color: Colors.red,
      );

      return;
    }

    await Future.delayed(
      const Duration(
        milliseconds: 500,
      ),
    );

    if (!mounted) {
      return;
    }

    _log(
      'Reply from ${target.ip}: bytes=32 time<1ms TTL=64',
    );

    _snack(
      'Ping BERHASIL • ${source.name} → ${target.name}',
      color: Colors.green,
    );
  }

  bool _hasPath(
      int source,
      int destination,
      ) {
    final visited = <int>{};
    final queue = <int>[source];

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);

      if (current == destination) {
        return true;
      }

      if (visited.contains(current)) {
        continue;
      }

      visited.add(current);

      for (final connection in connections) {
        if (!connection.valid) {
          continue;
        }

        if (connection.fromDeviceId ==
            current) {
          queue.add(
            connection.toDeviceId,
          );
        }

        if (connection.toDeviceId ==
            current) {
          queue.add(
            connection.fromDeviceId,
          );
        }
      }
    }

    return false;
  }

  /// =============================================================
  /// ANALYZER
  /// =============================================================

  void _openAnalyzer() {
    final errors = connections
        .where((c) => !c.valid)
        .toList();

    final warnings = devices
        .where(
          (d) =>
      d.status(connections) ==
          DeviceStatus.warning,
    )
        .toList();

    final normal = devices
        .where(
          (d) =>
      d.status(connections) ==
          DeviceStatus.normal,
    )
        .toList();

    showModalBottomSheet(
      context: context,
      backgroundColor:
      const Color(0xFF0B1726),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Network Analyzer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                _analysisRow(
                  Icons.devices,
                  'Total perangkat',
                  '${devices.length}',
                  Colors.blue,
                ),
                _analysisRow(
                  Icons.cable,
                  'Koneksi valid',
                  '${connections.where((c) => c.valid).length}',
                  Colors.green,
                ),
                _analysisRow(
                  Icons.error,
                  'Koneksi error',
                  '${errors.length}',
                  Colors.red,
                ),
                _analysisRow(
                  Icons.warning,
                  'Warning',
                  '${warnings.length}',
                  Colors.amber,
                ),
                _analysisRow(
                  Icons.check_circle,
                  'Perangkat normal',
                  '${normal.length}',
                  Colors.green,
                ),
                const SizedBox(height: 10),
                if (errors.isNotEmpty)
                  ...errors.map(
                        (e) => Padding(
                      padding:
                      const EdgeInsets.only(
                        bottom: 8,
                      ),
                      child: Text(
                        '• ${e.cableType.label}: ${e.errorMessage}',
                        style:
                        const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                if (errors.isEmpty)
                  const Text(
                    'Tidak ada error kabel.',
                    style: TextStyle(
                      color: Colors.greenAccent,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _analysisRow(
      IconData icon,
      String title,
      String value,
      Color color,
      ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor:
        color.withOpacity(.15),
        child: Icon(
          icon,
          color: color,
        ),
      ),
      title: Text(
        title,
        style:
        const TextStyle(
          color: Colors.white70,
        ),
      ),
      trailing: Text(
        value,
        style: TextStyle(
          color: color,
          fontWeight:
          FontWeight.bold,
        ),
      ),
    );
  }

  /// =============================================================
  /// PDF EXPORT
  /// =============================================================

  Future<void> _exportTopologyPdf() async {
    final document = pw.Document();

    document.addPage(
      pw.Page(
        pageFormat:
        PdfPageFormat.a4.landscape,
        margin:
        const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment:
            pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'NETROPIA',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight:
                  pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'Interactive TKJ Learning',
                style: const pw.TextStyle(
                  fontSize: 11,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Topologi Jaringan',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight:
                  pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),

              /// TOPOLOGY VISUAL
              pw.Container(
                width: double.infinity,
                height: 270,
                padding:
                const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    color: PdfColors.grey400,
                  ),
                  borderRadius:
                  pw.BorderRadius.circular(
                    10,
                  ),
                ),
                child: pw.Stack(
                  children: [
                    /// CONNECTIONS
                    ...connections.map(
                          (connection) {
                        final from =
                        _deviceById(
                          connection
                              .fromDeviceId,
                        );

                        final to =
                        _deviceById(
                          connection
                              .toDeviceId,
                        );

                        if (from == null ||
                            to == null) {
                          return pw.SizedBox();
                        }

                        final x1 =
                        (from.x / 5)
                            .clamp(
                          20,
                          520,
                        );

                        final y1 =
                        (from.y / 5)
                            .clamp(
                          30,
                          210,
                        );

                        final x2 =
                        (to.x / 5)
                            .clamp(
                          20,
                          520,
                        );

                        final y2 =
                        (to.y / 5)
                            .clamp(
                          30,
                          210,
                        );

                        return pw.Positioned(
                          left: math.min(
                            x1.toDouble(),
                            x2.toDouble(),
                          ) -
                              1,
                          top: math.min(
                            y1.toDouble(),
                            y2.toDouble(),
                          ) -
                              1,
                          child: pw.Container(
                            width: (x2 - x1)
                                .abs()
                                .clamp(
                              2,
                              520,
                            )
                                .toDouble(),
                            height: 2,
                            color: connection
                                .valid
                                ? PdfColors
                                .green
                                : PdfColors
                                .red,
                          ),
                        );
                      },
                    ),

                    /// DEVICES
                    ...devices.map(
                          (device) {
                        final dx =
                        (device.x / 5)
                            .clamp(
                          10,
                          530,
                        );

                        final dy =
                        (device.y / 5)
                            .clamp(
                          10,
                          220,
                        );

                        final status =
                        device.status(
                          connections,
                        );

                        return pw.Positioned(
                          left:
                          dx.toDouble(),
                          top:
                          dy.toDouble(),
                          child: pw.Container(
                            width: 85,
                            padding:
                            const pw.EdgeInsets
                                .all(
                              6,
                            ),
                            decoration:
                            pw.BoxDecoration(
                              border: pw.Border.all(
                                color:
                                _pdfStatusColor(
                                  status,
                                ),
                                width: 2,
                              ),
                              borderRadius:
                              pw.BorderRadius
                                  .circular(
                                6,
                              ),
                            ),
                            child: pw.Column(
                              children: [
                                pw.Text(
                                  device.name,
                                  style:
                                  pw.TextStyle(
                                    fontSize: 8,
                                    fontWeight:
                                    pw.FontWeight
                                        .bold,
                                  ),
                                  maxLines: 1,
                                ),
                                pw.SizedBox(
                                    height: 2),
                                pw.Text(
                                  device.type
                                      .label,
                                  style:
                                  const pw.TextStyle(
                                    fontSize: 7,
                                  ),
                                ),
                                pw.Text(
                                  device.ip
                                      .isEmpty
                                      ? '-'
                                      : device.ip,
                                  style:
                                  const pw.TextStyle(
                                    fontSize: 6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 18),

              pw.Text(
                'Daftar Perangkat',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight:
                  pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 8),

              pw.Table.fromTextArray(
                headers: [
                  'Nama',
                  'Tipe',
                  'IP',
                  'Subnet',
                  'Gateway',
                  'Status',
                ],
                data: devices
                    .map(
                      (device) => [
                    device.name,
                    device.type.label,
                    device.ip.isEmpty
                        ? '-'
                        : device.ip,
                    device.subnetMask,
                    device.gateway.isEmpty
                        ? '-'
                        : device.gateway,
                    device.status(
                      connections,
                    ).label,
                  ],
                )
                    .toList(),
              ),

              pw.SizedBox(height: 14),

              pw.Text(
                'Koneksi: ${connections.length}',
                style: const pw.TextStyle(
                  fontSize: 10,
                ),
              ),

              pw.SizedBox(height: 4),

              pw.Text(
                'Dibuat menggunakan Netropia Network Simulator.',
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey,
                ),
              ),
            ],
          );
        },
      ),
    );

    final Uint8List bytes =
    await document.save();

    await Printing.sharePdf(
      bytes: bytes,
      filename:
      'netropia_topologi.pdf',
    );
  }

  PdfColor _pdfStatusColor(
      DeviceStatus status,
      ) {
    switch (status) {
      case DeviceStatus.normal:
        return PdfColors.green;
      case DeviceStatus.warning:
        return PdfColors.orange;
      case DeviceStatus.error:
        return PdfColors.red;
      case DeviceStatus.disabled:
        return PdfColors.grey;
    }
  }

  /// =============================================================
  /// CLI
  /// =============================================================

  void _log(String message) {
    if (!mounted) return;

    setState(() {
      cliHistory.add(message);
    });
  }

  void _executeCommand(String input) {
    final command = input.trim();

    if (command.isEmpty) {
      return;
    }

    _log('NETROPIA# $command');
    cliController.clear();

    final parts =
    command.toLowerCase().split(
      RegExp(r'\s+'),
    );

    final cmd = parts.first;

    switch (cmd) {
      case 'help':
        _log(
          'Commands: help, devices, links, clear',
        );
        break;

      case 'devices':
        for (final device in devices) {
          _log(
            '${device.name} '
                '${device.type.label} '
                '${device.ip.isEmpty ? '-' : device.ip}',
          );
        }
        break;

      case 'links':
        for (final connection
        in connections) {
          final a = _deviceById(
            connection.fromDeviceId,
          );

          final b = _deviceById(
            connection.toDeviceId,
          );

          _log(
            '${a?.name ?? '?'} <-> '
                '${b?.name ?? '?'} '
                '${connection.cableType.label} '
                '${connection.valid ? 'OK' : 'ERROR'}',
          );
        }
        break;

      case 'clear':
        setState(() {
          cliHistory.clear();
        });
        break;

      default:
        _log(
          'Unknown command. Ketik help.',
        );
    }
  }

  /// =============================================================
  /// TOOLBAR UI
  /// =============================================================

  Widget _buildTopToolbar() {
    return Container(
      height: 62,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xEE0B1726),
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white12,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ListView(
        scrollDirection:
        Axis.horizontal,
        children: [
          _tool(
            Icons.computer,
            'PC',
                () => _addDevice(
              DeviceType.pc,
            ),
          ),
          _tool(
            Icons.laptop,
            'Laptop',
                () => _addDevice(
              DeviceType.laptop,
            ),
          ),
          _tool(
            Icons.dns,
            'Server',
                () => _addDevice(
              DeviceType.server,
            ),
          ),
          _tool(
            Icons.lan,
            'Switch',
                () => _addDevice(
              DeviceType.switchDevice,
            ),
          ),
          _tool(
            Icons.router,
            'Router',
                () => _addDevice(
              DeviceType.router,
            ),
          ),
          _tool(
            Icons.wifi,
            'AP',
                () => _addDevice(
              DeviceType.accessPoint,
            ),
          ),
          _tool(
            Icons.device_hub,
            'Hub',
                () => _addDevice(
              DeviceType.hub,
            ),
          ),
          const VerticalDivider(
            color: Colors.white24,
            indent: 10,
            endIndent: 10,
          ),
          _tool(
            Icons.cable,
            'Kabel',
            _openCablePicker,
          ),
          _tool(
            Icons.link,
            'Hubung',
            _startConnect,
          ),
          _tool(
            Icons.settings,
            'Config',
            _configSelected,
          ),
          _tool(
            Icons.network_check,
            'Ping',
            _pingDialog,
          ),
          _tool(
            Icons.analytics,
            'Analyze',
            _openAnalyzer,
          ),
          _tool(
            Icons.picture_as_pdf,
            'PDF',
            _exportTopologyPdf,
          ),
          _tool(
            Icons.fit_screen,
            'Fit',
            _fitAll,
          ),
          _tool(
            showCli
                ? Icons.terminal
                : Icons.terminal_outlined,
            'CLI',
                () {
              setState(() {
                showCli = !showCli;
              });
            },
          ),
          _tool(
            Icons.delete_outline,
            'Hapus',
            _deleteSelected,
          ),
        ],
      ),
    );
  }

  Widget _tool(
      IconData icon,
      String text,
      VoidCallback onTap,
      ) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 2,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(14),
        child: SizedBox(
          width: 60,
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: Colors.cyanAccent,
              ),
              const SizedBox(height: 3),
              Text(
                text,
                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,
                style:
                const TextStyle(
                  color: Colors.white70,
                  fontSize: 9,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// =============================================================
  /// CABLE PICKER
  /// =============================================================

  void _openCablePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor:
      const Color(0xFF0B1726),
      shape:
      const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding:
            const EdgeInsets.all(18),
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pilih Jenis Kabel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                ...CableType.values.map(
                      (cable) {
                    final active =
                        selectedCable ==
                            cable;

                    return Container(
                      margin:
                      const EdgeInsets
                          .only(
                        bottom: 8,
                      ),
                      decoration:
                      BoxDecoration(
                        color: active
                            ? const Color(
                          0xFF123F5D,
                        )
                            : const Color(
                          0xFF122235,
                        ),
                        borderRadius:
                        BorderRadius
                            .circular(14),
                        border:
                        Border.all(
                          color: active
                              ? Colors.cyanAccent
                              : Colors.white10,
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          cable.icon,
                          color: Colors
                              .cyanAccent,
                        ),
                        title: Text(
                          cable.label,
                          style:
                          const TextStyle(
                            color: Colors.white,
                            fontWeight:
                            FontWeight
                                .w600,
                          ),
                        ),
                        subtitle: Text(
                          _cableDescription(
                            cable,
                          ),
                          style:
                          const TextStyle(
                            color:
                            Colors.white54,
                            fontSize: 11,
                          ),
                        ),
                        trailing:
                        active
                            ? const Icon(
                          Icons
                              .check_circle,
                          color: Colors
                              .greenAccent,
                        )
                            : null,
                        onTap: () {
                          Navigator.pop(
                            context,
                          );

                          setState(() {
                            selectedCable =
                                cable;
                            connectMode = true;
                            sourceDeviceId =
                            null;
                          });

                          _snack(
                            '${cable.label} dipilih. Tap perangkat sumber.',
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _cableDescription(
      CableType cable,
      ) {
    switch (cable) {
      case CableType.copperStraight:
        return 'PC ↔ Switch, Router ↔ Switch, Server ↔ Switch';
      case CableType.copperCross:
        return 'PC ↔ PC, Router ↔ Router, Switch ↔ Switch';
      case CableType.console:
        return 'PC/Laptop ↔ Console Router/Switch';
      case CableType.fiber:
        return 'Fiber/SFP ↔ Fiber/SFP';
      case CableType.serialDce:
        return 'Router Serial DCE ↔ Router Serial DTE';
      case CableType.serialDte:
        return 'Router Serial DTE ↔ Router Serial DCE';
    }
  }

  /// =============================================================
  /// CONFIG SELECTED
  /// =============================================================

  void _configSelected() {
    final id = selectedDeviceId;

    if (id == null) {
      _snack(
        'Pilih perangkat dahulu.',
      );
      return;
    }

    final device = _deviceById(id);

    if (device != null) {
      _openConfig(device);
    }
  }

  /// =============================================================
  /// ZOOM
  /// =============================================================

  void _zoom(double amount) {
    final matrix =
        transformationController.value;

    final currentScale =
    matrix.getMaxScaleOnAxis();

    final newScale = (currentScale + amount)
        .clamp(
      0.20,
      3.00,
    )
        .toDouble();

    final center = Offset(
      MediaQuery.of(context).size.width /
          2,
      MediaQuery.of(context).size.height /
          2 -
          40,
    );

    final scaleRatio =
        newScale / currentScale;

    final newMatrix =
    Matrix4.identity()
      ..translate(
        center.dx,
        center.dy,
      )
      ..scale(scaleRatio)
      ..translate(
        -center.dx,
        -center.dy,
      );

    transformationController.value =
        newMatrix * matrix;
  }

  void _fitAll() {
    if (!mounted) {
      return;
    }

    if (devices.isEmpty) {
      transformationController.value =
          Matrix4.identity();

      return;
    }

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = 0;
    double maxY = 0;

    for (final d in devices) {
      minX = math.min(minX, d.x);
      minY = math.min(minY, d.y);
      maxX = math.max(maxX, d.x + 90);
      maxY = math.max(maxY, d.y + 80);
    }

    const padding = 100.0;

    final contentWidth =
        (maxX - minX) + padding * 2;

    final contentHeight =
        (maxY - minY) + padding * 2;

    final size =
        MediaQuery.of(context).size;

    final availableWidth =
        size.width;

    final availableHeight =
        size.height - 130;

    final scale = math.min(
      availableWidth / contentWidth,
      availableHeight / contentHeight,
    ).clamp(
      0.20,
      1.20,
    );

    final centerX =
        minX + (maxX - minX) / 2;

    final centerY =
        minY + (maxY - minY) / 2;

    final targetX =
        availableWidth / 2 -
            centerX * scale;

    final targetY =
        availableHeight / 2 -
            centerY * scale;

    transformationController.value =
    Matrix4.identity()
      ..translate(
        targetX,
        targetY,
      )
      ..scale(scale);
  }

  /// =============================================================
  /// CLI PANEL
  /// =============================================================

  Widget _buildCliPanel() {
    return Container(
      height: 210,
      decoration:
      const BoxDecoration(
        color: Color(0xFF020508),
        border: Border(
          top: BorderSide(
            color: Colors.white12,
          ),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child:
            ListView.builder(
              padding:
              const EdgeInsets
                  .all(10),
              itemCount:
              cliHistory.length,
              itemBuilder:
                  (context, index) {
                return Text(
                  cliHistory[index],
                  style:
                  const TextStyle(
                    color:
                    Color(0xFF00D9FF),
                    fontFamily:
                    'monospace',
                    fontSize: 11,
                  ),
                );
              },
            ),
          ),
          const Divider(
            color: Colors.white12,
            height: 1,
          ),
          Padding(
            padding:
            const EdgeInsets.all(8),
            child: Row(
              children: [
                const Text(
                  'NETROPIA# ',
                  style:
                  TextStyle(
                    color:
                    Colors.cyanAccent,
                    fontFamily:
                    'monospace',
                    fontWeight:
                    FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller:
                    cliController,
                    onSubmitted:
                    _executeCommand,
                    style:
                    const TextStyle(
                      color: Colors.white,
                      fontFamily:
                      'monospace',
                      fontSize: 11,
                    ),
                    decoration:
                    InputDecoration(
                      hintText:
                      'ketik help',
                      hintStyle:
                      const TextStyle(
                        color:
                        Colors.white24,
                      ),
                      filled: true,
                      fillColor:
                      const Color(
                        0xFF101A23,
                      ),
                      border:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                          10,
                        ),
                        borderSide:
                        BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// =============================================================
  /// ZOOM BUTTONS
  /// =============================================================

  Widget _buildZoomButtons() {
    return Column(
      children: [
        _zoomButton(
          Icons.add,
              () => _zoom(.20),
        ),
        const SizedBox(height: 8),
        _zoomButton(
          Icons.remove,
              () => _zoom(-.20),
        ),
        const SizedBox(height: 8),
        _zoomButton(
          Icons.center_focus_strong,
          _fitAll,
        ),
      ],
    );
  }

  Widget _zoomButton(
      IconData icon,
      VoidCallback onTap,
      ) {
    return Material(
      color: const Color(0xEE0B1726),
      borderRadius:
      BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(15),
        child: Container(
          width: 46,
          height: 46,
          decoration:
          BoxDecoration(
            borderRadius:
            BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white12,
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// =============================================================
  /// STATUS BAR
  /// =============================================================

  Widget _buildStatusBar() {
    final selected =
    selectedDeviceId == null
        ? null
        : _deviceById(
      selectedDeviceId!,
    );

    return Container(
      height: 48,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      decoration:
      BoxDecoration(
        color: const Color(
          0xEE0B1726,
        ),
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white12,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 9,
            height: 9,
            decoration:
            const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              selected == null
                  ? '${devices.length} perangkat • ${connections.length} koneksi'
                  : '${selected.name} • ${selected.status(connections).label}',
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              style:
              const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),
          if (selectedCable != null)
            Text(
              selectedCable!.shortLabel,
              style:
              const TextStyle(
                color:
                Colors.cyanAccent,
                fontSize: 10,
                fontWeight:
                FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  /// =============================================================
  /// DEVICE NODE
  /// =============================================================

  Widget _buildDeviceNode(
      NetworkDevice device,
      ) {
    final status =
    device.status(connections);

    final selected =
        selectedDeviceId == device.id;

    return GestureDetector(
      onTap: () =>
          _handleDeviceTap(device),
      onDoubleTap: () =>
          _openConfig(device),
      onPanUpdate: (details) =>
          _moveDevice(
            device,
            details,
          ),
      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Container(
            width: 78,
            height: 64,
            decoration:
            BoxDecoration(
              color: selected
                  ? const Color(
                0xFF123F5D,
              )
                  : const Color(
                0xFF0F1E2D,
              ),
              borderRadius:
              BorderRadius.circular(
                16,
              ),
              border: Border.all(
                color: status.color,
                width: selected
                    ? 3
                    : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: status.color
                      .withOpacity(.18),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    device.type.icon,
                    size: 32,
                    color:
                    Colors.white,
                  ),
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration:
                    BoxDecoration(
                      color:
                      status.color,
                      shape:
                      BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            device.name,
            style:
            const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight:
              FontWeight.bold,
            ),
          ),
          if (device.ip.isNotEmpty)
            Text(
              device.ip,
              style:
              const TextStyle(
                color: Colors.white54,
                fontSize: 8,
              ),
            ),
        ],
      ),
    );
  }

  /// =============================================================
  /// LINK PAINTER
  /// =============================================================

  Widget _buildCanvas() {
    return SizedBox(
      width: 3600,
      height: 2400,
      child: Stack(
        children: [
          const Positioned.fill(
            child: _NetworkGrid(),
          ),

          Positioned.fill(
            child: CustomPaint(
              painter:
              _ConnectionPainter(
                devices: devices,
                connections:
                connections,
              ),
            ),
          ),

          ...devices.map(
                (device) => Positioned(
              left: device.x,
              top: device.y,
              child:
              _buildDeviceNode(
                device,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// =============================================================
  /// PORT ICON
  /// =============================================================

  IconData _portIcon(
      PortType type,
      ) {
    switch (type) {
      case PortType.ethernet:
      case PortType.fastEthernet:
      case PortType.gigabitEthernet:
        return Icons.settings_ethernet;

      case PortType.fiber:
        return Icons.fiber_manual_record;

      case PortType.serialDce:
      case PortType.serialDte:
        return Icons.swap_horiz;

      case PortType.console:
        return Icons.terminal;
    }
  }

  String _portTypeLabel(
      PortType type,
      ) {
    switch (type) {
      case PortType.ethernet:
        return 'Ethernet';
      case PortType.fastEthernet:
        return 'FastEthernet';
      case PortType.gigabitEthernet:
        return 'GigabitEthernet';
      case PortType.fiber:
        return 'Fiber / SFP';
      case PortType.serialDce:
        return 'Serial DCE';
      case PortType.serialDte:
        return 'Serial DTE';
      case PortType.console:
        return 'Console';
    }
  }

  /// =============================================================
  /// PORT USAGE
  /// =============================================================

  void _refreshPortUsage() {
    for (final device in devices) {
      for (final port in device.ports) {
        port.connectionId = null;
      }
    }

    for (final connection in connections) {
      if (!connection.valid) {
        continue;
      }

      final a =
      _deviceById(
        connection.fromDeviceId,
      );

      final b =
      _deviceById(
        connection.toDeviceId,
      );

      if (a != null) {
        final port =
        _portById(
          a,
          connection.fromPortId,
        );

        port?.connectionId =
            connection.id;
      }

      if (b != null) {
        final port =
        _portById(
          b,
          connection.toPortId,
        );

        port?.connectionId =
            connection.id;
      }
    }
  }

  /// =============================================================
  /// SNACK
  /// =============================================================

  void _snack(
      String message, {
        Color? color,
      }) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        duration:
        const Duration(
          seconds: 2,
        ),
        backgroundColor:
        color ??
            const Color(
              0xFF1B2B3A,
            ),
        content: Text(
          message,
          style:
          const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight:
            FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// =============================================================
  /// BUILD
  /// =============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    return Scaffold(
      backgroundColor:
      const Color(0xFF050C13),
      appBar: AppBar(
        backgroundColor:
        const Color(0xFF0875C9),
        elevation: 0,
        title: const Text(
          'Netropia Simulator',
          style:
          TextStyle(
            fontSize: 17,
            fontWeight:
            FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Kabel',
            onPressed:
            _openCablePicker,
            icon: const Icon(
              Icons.cable,
            ),
          ),
          IconButton(
            tooltip: 'PDF',
            onPressed:
            _exportTopologyPdf,
            icon: const Icon(
              Icons.picture_as_pdf,
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          /// ====================================================
          /// CANVAS
          /// ====================================================
          Positioned.fill(
            child: InteractiveViewer(
              transformationController:
              transformationController,

              constrained: false,

              minScale: .20,

              maxScale: 3.0,

              boundaryMargin:
              const EdgeInsets.all(
                2400,
              ),

              child: _buildCanvas(),
            ),
          ),

          /// ====================================================
          /// FLOATING TOOLBAR
          /// ====================================================
          Positioned(
            left: 8,
            right: 8,
            top: 8,
            child: SafeArea(
              child:
              _buildTopToolbar(),
            ),
          ),

          /// ====================================================
          /// ZOOM
          /// ====================================================
          Positioned(
            right: 12,
            bottom:
            showCli ? 230 : 82,
            child:
            _buildZoomButtons(),
          ),

          /// ====================================================
          /// STATUS
          /// ====================================================
          Positioned(
            left: 10,
            right: 10,
            bottom:
            showCli ? 170 : 12,
            child:
            _buildStatusBar(),
          ),

          /// ====================================================
          /// CLI
          /// ====================================================
          if (showCli)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child:
              _buildCliPanel(),
            ),
        ],
      ),

      floatingActionButton:
      FloatingActionButton(
        backgroundColor:
        const Color(0xFF0875C9),
        onPressed:
        _openDevicePicker,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  /// =============================================================
  /// DEVICE PICKER
  /// =============================================================

  void _openDevicePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor:
      const Color(0xFF0B1726),
      shape:
      const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding:
            const EdgeInsets.all(18),
            child: GridView.builder(
              shrinkWrap: true,
              itemCount:
              DeviceType.values.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.1,
              ),
              itemBuilder:
                  (context, index) {
                final type =
                DeviceType.values[
                index];

                return InkWell(
                  onTap: () {
                    Navigator.pop(
                      context,
                    );

                    _addDevice(type);
                  },
                  borderRadius:
                  BorderRadius.circular(
                    16,
                  ),
                  child: Container(
                    decoration:
                    BoxDecoration(
                      color:
                      const Color(
                        0xFF122235,
                      ),
                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),
                      border: Border.all(
                        color:
                        Colors.white12,
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        Icon(
                          type.icon,
                          color: Colors
                              .cyanAccent,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            type.label,
                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/// ===============================================================
/// GRID
/// ===============================================================

class _NetworkGrid
    extends StatelessWidget {
  const _NetworkGrid();

  @override
  Widget build(
      BuildContext context,
      ) {
    return CustomPaint(
      painter:
      _GridPainter(),
    );
  }
}

class _GridPainter
    extends CustomPainter {
  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final paint = Paint()
      ..color =
      Colors.white.withOpacity(.05)
      ..strokeWidth = 1;

    const distance = 40.0;

    for (
    double x = 0;
    x <= size.width;
    x += distance
    ) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (
    double y = 0;
    y <= size.height;
    y += distance
    ) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ) {
    return false;
  }
}

/// ===============================================================
/// CONNECTION PAINTER
/// ===============================================================

class _ConnectionPainter
    extends CustomPainter {
  final List<NetworkDevice> devices;
  final List<NetworkConnection>
  connections;

  _ConnectionPainter({
    required this.devices,
    required this.connections,
  });

  NetworkDevice? _findDevice(
      int id,
      ) {
    for (final device in devices) {
      if (device.id == id) {
        return device;
      }
    }

    return null;
  }

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    for (final connection
    in connections) {
      final from = _findDevice(
        connection.fromDeviceId,
      );

      final to = _findDevice(
        connection.toDeviceId,
      );

      if (from == null ||
          to == null) {
        continue;
      }

      final paint = Paint()
        ..color = connection.valid
            ? Colors.greenAccent
            : Colors.redAccent
        ..strokeWidth =
        connection.valid
            ? 4
            : 5
        ..style =
            PaintingStyle.stroke;

      final start = Offset(
        from.x + 39,
        from.y + 32,
      );

      final end = Offset(
        to.x + 39,
        to.y + 32,
      );

      canvas.drawLine(
        start,
        end,
        paint,
      );

      /// ERROR dot
      if (!connection.valid) {
        final middle = Offset(
          (start.dx + end.dx) / 2,
          (start.dy + end.dy) / 2,
        );

        final errorPaint = Paint()
          ..color =
              Colors.redAccent;

        canvas.drawCircle(
          middle,
          7,
          errorPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ) {
    return true;
  }
}