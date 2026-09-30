import 'package:flutter/material.dart';
import '../services/progress_service.dart';
import '../services/settings_service.dart';
import '../services/notification_service.dart';
import '../services/localization_service.dart';
import '../screens/notification_screen.dart';
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

  void _showStreakDialog(BuildContext context, int streak) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(
              Icons.local_fire_department_rounded,
              color: Colors.orange,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(localizationService.translate('streak')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$streak${localizationService.translate('streak_days')} 🔥',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              localizationService.translate('streak_desc'),
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizationService.translate('close')),
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
              localizationService.translate('learning_progress'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFFAD8B73),
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                tooltip: localizationService.translate('refresh'),
                onPressed: () {
                  setState(() => _isLoading = true);
                  refreshData();
                },
              ),
              const SizedBox(width: 2),
              FutureBuilder<int>(
                future: SettingsService().getStreak(),
                builder: (context, snapshot) {
                  final streak = snapshot.data ?? 3;
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: InkWell(
                        onTap: () => _showStreakDialog(context, streak),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.local_fire_department_rounded,
                                color: Colors.orange,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$streak',
                                style: const TextStyle(
                                  color: Color(0xFF5C3D2E),
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 4),
              FutureBuilder<int>(
                future: NotificationService().getUnreadCount(),
                builder: (context, snapshot) {
                  final unreadCount = snapshot.data ?? 0;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.notifications_none_rounded),
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFFAD8B73)))
              : RefreshIndicator(
                  color: const Color(0xFFAD8B73),
                  onRefresh: refreshData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeroCard(context),
                        const SizedBox(height: 20),
                        _buildStatGrid(context),
                        const SizedBox(height: 24),
                        _buildTabBar(context),
                        const SizedBox(height: 16),
                        _buildTabContent(context),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFAD8B73), Color(0xFFCEAB93)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAD8B73).withOpacity(0.22),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_levelIcon, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      _userLevel.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                '$_overallProgress%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizationService.translate('overall_progress'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      localizationService.isEnglish
                          ? '$_completedModulesCount of ${_modulesInfo.length} modules completed'
                          : '$_completedModulesCount dari ${_modulesInfo.length} modul selesai penuh',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _overallProgress / 100.0,
              minHeight: 10,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            title: localizationService.isEnglish ? 'Feature Progress' : 'Aktivitas Selesai',
            value: '$_completedFeaturesCount',
            subtitle: localizationService.isEnglish ? 'Out of 42 tasks' : 'dari total 42 fitur',
            icon: Icons.task_alt_rounded,
            color: const Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            title: localizationService.isEnglish ? 'Finished Modules' : 'Modul Tuntas',
            value: '$_completedModulesCount',
            subtitle: localizationService.isEnglish ? 'Out of 6 modules' : 'dari total 6 modul',
            icon: Icons.check_circle_rounded,
            color: const Color(0xFF00838F),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFFAD8B73),
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        tabs: [
          Tab(text: localizationService.isEnglish ? 'By Module' : 'Per Modul'),
          Tab(text: localizationService.isEnglish ? 'Activities' : 'Aktivitas'),
          Tab(text: localizationService.translate('badges_prestasi')),
        ],
      ),
    );
  }

  Widget _buildTabContent(BuildContext context) {
    switch (_tabController.index) {
      case 0:
        return _buildModuleProgressList(context);
      case 1:
        return _buildActivityHistoryList(context);
      case 2:
        return _buildBadgesList(context);
      default:
        return _buildModuleProgressList(context);
    }
  }

  Widget _buildModuleProgressList(BuildContext context) {
    return Column(
      children: _modulesInfo.map((mod) {
        final modId = mod['id'] as String;
        final p = _moduleProgressMap[modId] ?? 0;
        final details = _moduleDetailsMap[modId] ?? {};
        final isExpanded = _expandedModuleId == modId;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
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
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: (mod['color'] as Color).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(mod['icon'] as IconData, color: mod['color'] as Color, size: 24),
                ),
                title: Text(
                  mod['title'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: p / 100.0,
                        minHeight: 6,
                        backgroundColor: Colors.grey.withOpacity(0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(mod['color'] as Color),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$p% selesai',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _expandedModuleId = isExpanded ? null : modId;
                    });
                  },
                ),
              ),
              if (isExpanded)
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: [
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _featureTypes.map((feat) {
                          final featKey = feat['key'] as String;
                          final isDone = details[featKey] ?? false;

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isDone
                                  ? (mod['color'] as Color).withOpacity(0.12)
                                  : Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isDone
                                    ? (mod['color'] as Color).withOpacity(0.3)
                                    : Colors.grey.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                  size: 14,
                                  color: isDone ? mod['color'] as Color : Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  feat['label'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
                                    color: isDone
                                        ? (mod['color'] as Color)
                                        : Theme.of(context).textTheme.bodySmall?.color,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActivityHistoryList(BuildContext context) {
    if (_activities.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Icon(Icons.history_rounded, size: 50, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                localizationService.isEnglish ? 'No activity history yet' : 'Belum ada riwayat aktivitas',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: _activities.map((act) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFAD8B73).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.check_circle_rounded, color: Color(0xFFAD8B73), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      act['title'] ?? 'Aktivitas Belajar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      act['time'] ?? 'Baru saja',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBadgesList(BuildContext context) {
    final badges = [
      {'title': 'Network Beginner', 'desc': 'Selesaikan modul K3LH', 'unlocked': _overallProgress >= 15, 'icon': Icons.lan_rounded, 'color': const Color(0xFFAD8B73)},
      {'title': 'First Lesson', 'desc': 'Selesaikan Pre Test pertama', 'unlocked': _completedFeaturesCount >= 1, 'icon': Icons.school_rounded, 'color': Colors.green},
      {'title': 'Subnet Master', 'desc': 'Selesaikan modul IP Address', 'unlocked': (_moduleProgressMap['ip_address'] ?? 0) == 100, 'icon': Icons.calculate_rounded, 'color': Colors.orange},
      {'title': 'Lab Explorer', 'desc': 'Gunakan 3D Simulator', 'unlocked': true, 'icon': Icons.science_rounded, 'color': Colors.purple},
      {'title': '7 Day Streak', 'desc': 'Belajar 7 hari berturut-turut', 'unlocked': false, 'icon': Icons.local_fire_department_rounded, 'color': Colors.red},
      {'title': 'Master Netropia', 'desc': 'Capai 90% total progres', 'unlocked': _overallProgress >= 90, 'icon': Icons.military_tech_rounded, 'color': Colors.amber},
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: badges.map((badge) {
        final unlocked = badge['unlocked'] as bool;
        final color = badge['color'] as Color;

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: unlocked ? color.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                unlocked ? (badge['icon'] as IconData) : Icons.lock_outline_rounded,
                color: unlocked ? color : Colors.grey,
                size: 36,
              ),
              const SizedBox(height: 10),
              Text(
                badge['title'] as String,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: unlocked ? Theme.of(context).textTheme.bodyLarge?.color : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                badge['desc'] as String,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
