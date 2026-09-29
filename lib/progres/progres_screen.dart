import 'package:flutter/material.dart';
import '../services/progress_service.dart';
import '../materi/k3/k3_screen.dart';
import '../materi/komponen_komputer/komponen_komputer_screen.dart';
import '../materi/perangkat_jaringan/perangkat_jaringan_screen.dart';
import '../materi/dasar_jaringan/dasar_jaringan_screen.dart';
import '../materi/ip_address/ip_address_screen.dart';
import '../materi/kabel_jaringan/kabel_jaringan_screen.dart';

class ProgresScreen extends StatefulWidget {
  const ProgresScreen({super.key});

  @override
  State<ProgresScreen> createState() => ProgresScreenState();
}

class ProgresScreenState extends State<ProgresScreen> with SingleTickerProviderStateMixin {
  final ProgressService _progressService = ProgressService();
  int _overallProgress = 0;
  List<Map<String, String>> _activities = [];
  Map<String, int> _moduleProgressMap = {};
  Map<String, Map<String, bool>> _moduleDetailsMap = {};
  int _completedFeaturesCount = 0;
  int _completedModulesCount = 0;
  bool _isLoading = true;

  late TabController _tabController;
  String? _expandedModuleId;

  final List<Map<String, dynamic>> _modulesInfo = [
    {
      'id': 'k3',
      'title': 'K3LH',
      'subtitle': 'Keselamatan & Kesehatan Kerja',
      'icon': Icons.health_and_safety_rounded,
      'color': const Color(0xFF2E7D32),
      'screen': const K3Screen(),
    },
    {
      'id': 'komponen_komputer',
      'title': 'Komponen Komputer',
      'subtitle': 'Hardware & Arsitektur Komputer',
      'icon': Icons.memory_rounded,
      'color': const Color(0xFF6A1B9A),
      'screen': const KomponenKomputerScreen(),
    },
    {
      'id': 'perangkat_jaringan',
      'title': 'Perangkat Jaringan',
      'subtitle': 'Router, Switch, Access Point',
      'icon': Icons.router_rounded,
      'color': const Color(0xFFEF6C00),
      'screen': const PerangkatJaringanScreen(),
    },
    {
      'id': 'dasar_jaringan',
      'title': 'Dasar Jaringan',
      'subtitle': 'Konsep LAN, Topologi, Protokol',
      'icon': Icons.account_tree_rounded,
      'color': const Color(0xFF00838F),
      'screen': const DasarJaringanScreen(),
    },
    {
      'id': 'ip_address',
      'title': 'IP Address',
      'subtitle': 'Pengalamatan IPv4, IPv6 & Subnetting',
      'icon': Icons.language_rounded,
      'color': const Color(0xFFC62828),
      'screen': const IpAddressScreen(),
    },
    {
      'id': 'kabel_jaringan',
      'title': 'Kabel Jaringan',
      'subtitle': 'UTP, STP, Crimping & Fiber Optic',
      'icon': Icons.cable_rounded,
      'color': const Color(0xFF5D4037),
      'screen': const KabelJaringanScreen(),
    },
  ];

  final List<Map<String, dynamic>> _featureTypes = [
    {'key': 'pre_test', 'label': 'Pre Test', 'icon': Icons.assignment_rounded},
    {'key': 'post_test', 'label': 'Post Test', 'icon': Icons.assignment_turned_in_rounded},
    {'key': 'penugasan', 'label': 'Penugasan', 'icon': Icons.task_rounded},
    {'key': 'portofolio', 'label': 'Portofolio', 'icon': Icons.folder_shared_rounded},
    {'key': 'peta_konsep', 'label': 'Peta Konsep', 'icon': Icons.account_tree_rounded},
    {'key': 'forum_diskusi', 'label': 'Forum Diskusi', 'icon': Icons.forum_rounded},
    {'key': 'evaluasi', 'label': 'Evaluasi', 'icon': Icons.assessment_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    refreshData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> refreshData() async {
    try {
      final progress = await _progressService.getOverallProgress();
      final activities = await _progressService.getRecentActivities();

      final Map<String, int> moduleProgress = {};
      final Map<String, Map<String, bool>> moduleDetails = {};
      int totalFeaturesDone = 0;
      int finishedModules = 0;

      for (final mod in _modulesInfo) {
        final modId = mod['id'] as String;
        final p = await _progressService.getModuleProgress(modId);
        moduleProgress[modId] = p;

        if (p == 100) {
          finishedModules++;
        }

        final Map<String, bool> featureStatus = {};
        for (final feat in _featureTypes) {
          final featKey = feat['key'] as String;
          final isDone = await _progressService.isLessonCompleted('${modId}_$featKey');
          featureStatus[featKey] = isDone;
          if (isDone) totalFeaturesDone++;
        }
        moduleDetails[modId] = featureStatus;
      }

      if (mounted) {
        setState(() {
          _overallProgress = progress;
          _activities = activities;
          _moduleProgressMap = moduleProgress;
          _moduleDetailsMap = moduleDetails;
          _completedFeaturesCount = totalFeaturesDone;
          _completedModulesCount = finishedModules;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String get _userLevel {
    if (_overallProgress >= 90) return 'Master Netropia';
    if (_overallProgress >= 65) return 'Spesialis Jaringan';
    if (_overallProgress >= 35) return 'Teknisi Muda';
    if (_overallProgress >= 10) return 'Siswa Siswi TKJ';
    return 'Pemula TKJ';
  }

  IconData get _levelIcon {
    if (_overallProgress >= 90) return Icons.military_tech_rounded;
    if (_overallProgress >= 65) return Icons.verified_user_rounded;
    if (_overallProgress >= 35) return Icons.construction_rounded;
    if (_overallProgress >= 10) return Icons.school_rounded;
    return Icons.eco_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Progres Belajar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFAD8B73),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Perbarui Data',
            onPressed: () {
              setState(() => _isLoading = true);
              refreshData();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFAD8B73)),
            )
          : RefreshIndicator(
              onRefresh: refreshData,
              color: const Color(0xFFAD8B73),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // GAMIFIED LEVEL HEADER CARD
                    _buildGamifiedHeader(),

                    const SizedBox(height: 22),

                    // WIDE FULL-WIDTH TAB BAR SELECTOR
                    Container(
                      width: double.infinity,
                      height: 52,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelPadding: EdgeInsets.zero,
                        indicator: BoxDecoration(
                          color: const Color(0xFFAD8B73),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFAD8B73).withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey.shade700,
                        tabs: [
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.menu_book_rounded, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'Modul Belajar',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.emoji_events_rounded, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'Lencana',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.history_rounded, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'Riwayat',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ACTIVE TAB CONTENT (FULL WIDTH & DYNAMIC HEIGHT)
                    _buildActiveTabView(),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildActiveTabView() {
    switch (_tabController.index) {
      case 1:
        return _buildBadgesTabView();
      case 2:
        return _buildActivityHistoryTabView();
      case 0:
      default:
        return _buildModulesTabView();
    }
  }

  // ==========================================
  // GAMIFIED HEADER CARD
  // ==========================================
  Widget _buildGamifiedHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8D6E63), Color(0xFFAD8B73)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAD8B73).withOpacity(0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // LEVEL AVATAR
              Container(
                width: 62,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white70, width: 2),
                ),
                child: Icon(
                  _levelIcon,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _userLevel.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$_overallProgress% Selesai',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _overallProgress / 100,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 16),
          // STATS SUMMARY ROW
          Row(
            children: [
              Expanded(
                child: _buildHeaderStatPill(
                  icon: Icons.checklist_rounded,
                  value: '$_completedFeaturesCount / 49',
                  label: 'Aktivitas',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildHeaderStatPill(
                  icon: Icons.school_rounded,
                  value: '$_completedModulesCount / 7',
                  label: 'Modul Tuntas',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildHeaderStatPill(
                  icon: Icons.history_rounded,
                  value: '${_activities.length}',
                  label: 'Riwayat',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStatPill({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 1: MODUL BELAJAR VIEW
  // ==========================================
  Widget _buildModulesTabView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _modulesInfo.length,
      itemBuilder: (context, index) {
        final mod = _modulesInfo[index];
        final modId = mod['id'] as String;
        final modTitle = mod['title'] as String;
        final modSubtitle = mod['subtitle'] as String;
        final modIcon = mod['icon'] as IconData;
        final modColor = mod['color'] as Color;
        final modScreen = mod['screen'] as Widget;

        final progress = _moduleProgressMap[modId] ?? 0;
        final featureStatus = _moduleDetailsMap[modId] ?? {};
        final isExpanded = _expandedModuleId == modId;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(
              color: isExpanded ? modColor : Colors.grey.shade200,
              width: isExpanded ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  setState(() {
                    _expandedModuleId = isExpanded ? null : modId;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: modColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(modIcon, color: modColor, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  modTitle,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: modColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '$progress%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: modColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              modSubtitle,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: progress / 100,
                                backgroundColor: modColor.withOpacity(0.12),
                                valueColor: AlwaysStoppedAnimation<Color>(modColor),
                                minHeight: 7,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey.shade600,
                        size: 26,
                      ),
                    ],
                  ),
                ),
              ),

              // EXPANDED CHECKLIST SECTION
              if (isExpanded) ...[
                const Divider(height: 1),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: modColor.withOpacity(0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rincian Aktivitas Modul:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _featureTypes.map((feat) {
                          final featKey = feat['key'] as String;
                          final featLabel = feat['label'] as String;
                          final featIcon = feat['icon'] as IconData;
                          final isDone = featureStatus[featKey] ?? false;

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isDone ? Colors.green.withOpacity(0.12) : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDone ? Colors.green : Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isDone ? Icons.check_circle_rounded : featIcon,
                                  size: 16,
                                  color: isDone ? Colors.green : Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  featLabel,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
                                    color: isDone ? Colors.green.shade800 : Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => modScreen),
                            ).then((_) => refreshData());
                          },
                          icon: Icon(
                            progress == 100
                                ? Icons.replay_rounded
                                : (progress > 0
                                    ? Icons.play_circle_fill_rounded
                                    : Icons.arrow_forward_rounded),
                            size: 20,
                          ),
                          label: Text(
                            progress == 100
                                ? 'Pelajari Ulang Modul $modTitle'
                                : (progress > 0
                                    ? 'Lanjutkan Pembelajaran Modul $modTitle'
                                    : 'Mulai Belajar Modul $modTitle'),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: modColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // TAB 2: LENCANA & PENCAPAIAN TAB
  // ==========================================
  Widget _buildBadgesTabView() {
    final List<Map<String, dynamic>> badges = [
      {
        'title': 'Langkah Perdana',
        'desc': 'Selesaikan minimal 1 aktivitas pembelajaran',
        'icon': Icons.flag_rounded,
        'unlocked': _completedFeaturesCount >= 1,
        'progress': _completedFeaturesCount >= 1 ? 1.0 : 0.0,
      },
      {
        'title': 'Peneliti K3',
        'desc': 'Selesaikan modul Keselamatan Kerja (K3LH)',
        'icon': Icons.health_and_safety_rounded,
        'unlocked': (_moduleProgressMap['k3'] ?? 0) == 100,
        'progress': (_moduleProgressMap['k3'] ?? 0) / 100.0,
      },
      {
        'title': 'Pakar Perangkat',
        'desc': 'Selesaikan modul Perangkat Jaringan',
        'icon': Icons.router_rounded,
        'unlocked': (_moduleProgressMap['perangkat_jaringan'] ?? 0) == 100,
        'progress': (_moduleProgressMap['perangkat_jaringan'] ?? 0) / 100.0,
      },
      {
        'title': 'Ahli IP Address',
        'desc': 'Selesaikan modul IP Address & Subnetting',
        'icon': Icons.language_rounded,
        'unlocked': (_moduleProgressMap['ip_address'] ?? 0) == 100,
        'progress': (_moduleProgressMap['ip_address'] ?? 0) / 100.0,
      },
      {
        'title': 'Teknisi Pengkabelan',
        'desc': 'Selesaikan modul Kabel Jaringan',
        'icon': Icons.cable_rounded,
        'unlocked': (_moduleProgressMap['kabel_jaringan'] ?? 0) == 100,
        'progress': (_moduleProgressMap['kabel_jaringan'] ?? 0) / 100.0,
      },
      {
        'title': 'Pencapai 50%',
        'desc': 'Selesaikan 50% dari seluruh modul Netropia',
        'icon': Icons.bolt_rounded,
        'unlocked': _overallProgress >= 50,
        'progress': _overallProgress / 50.0 > 1.0 ? 1.0 : _overallProgress / 50.0,
      },
      {
        'title': 'Bintang Netropia',
        'desc': 'Selesaikan 100% seluruh modul pembelajaran',
        'icon': Icons.emoji_events_rounded,
        'unlocked': _overallProgress == 100,
        'progress': _overallProgress / 100.0,
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final b = badges[index];
        final title = b['title'] as String;
        final desc = b['desc'] as String;
        final icon = b['icon'] as IconData;
        final unlocked = b['unlocked'] as bool;
        final progressVal = (b['progress'] as double).clamp(0.0, 1.0);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(
              color: unlocked ? Colors.amber.shade600 : Colors.grey.shade200,
              width: unlocked ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: unlocked ? Colors.amber.shade100 : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: unlocked ? Colors.amber.shade800 : Colors.grey,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: unlocked ? Colors.amber.shade900 : Colors.grey.shade800,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: unlocked ? Colors.green.shade100 : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              unlocked ? 'TERBUKA' : 'TERKUNCI',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: unlocked ? Colors.green.shade800 : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        desc,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progressVal,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            unlocked ? Colors.amber.shade600 : Colors.grey,
                          ),
                          minHeight: 5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // TAB 3: RIWAYAT AKTIVITAS TAB
  // ==========================================
  Widget _buildActivityHistoryTabView() {
    if (_activities.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_turned_in_outlined,
              size: 52,
              color: Colors.grey,
            ),
            SizedBox(height: 14),
            Text(
              'Belum Ada Riwayat Aktivitas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Kerjakan Pre-Test, Post-Test, atau Tugas di modul untuk mencatat riwayat belajarmu di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: Colors.grey, height: 1.4),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_activities.length} Aktivitas Terekam',
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            TextButton(
              onPressed: () async {
                await _progressService.clearActivities();
                refreshData();
              },
              child: const Text('Hapus Semua', style: TextStyle(fontSize: 12.5, color: Colors.red)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _activities.length,
          itemBuilder: (context, index) {
            final activity = _activities[index];
            final title = activity['title'] ?? '';
            final type = activity['type'] ?? '';

            IconData iconData = Icons.school_rounded;
            Color iconColor = const Color(0xFFAD8B73);

            if (type.contains('pre_test')) {
              iconData = Icons.assignment_rounded;
              iconColor = Colors.orange;
            } else if (type.contains('post_test')) {
              iconData = Icons.assignment_turned_in_rounded;
              iconColor = Colors.green;
            } else if (type.contains('penugasan')) {
              iconData = Icons.task_rounded;
              iconColor = Colors.deepOrange;
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(iconData, color: iconColor, size: 22),
                ),
                title: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    activity['subtitle'] ?? '',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                trailing: Text(
                  activity['time'] ?? '',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
