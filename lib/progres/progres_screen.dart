import 'package:flutter/material.dart';
import '../services/progress_service.dart';
import '../services/settings_service.dart';
import '../services/notification_service.dart';
import '../services/localization_service.dart';
import '../theme/app_theme.dart';
import '../widgets/home_effects.dart';
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
      'color': AppTheme.primaryBrown,
      'screen': const K3Screen(),
    },
    {
      'id': 'komponen_komputer',
      'title': 'Komponen Komputer',
      'subtitle': 'Hardware & Arsitektur Komputer',
      'icon': Icons.memory_rounded,
      'color': AppTheme.primaryBrown,
      'screen': const KomponenKomputerScreen(),
    },
    {
      'id': 'perangkat_jaringan',
      'title': 'Perangkat Jaringan',
      'subtitle': 'Router, Switch, Access Point',
      'icon': Icons.router_rounded,
      'color': AppTheme.primaryBrown,
      'screen': const PerangkatJaringanScreen(),
    },
    {
      'id': 'dasar_jaringan',
      'title': 'Dasar Jaringan',
      'subtitle': 'Konsep LAN, Topologi, Protokol',
      'icon': Icons.account_tree_rounded,
      'color': AppTheme.primaryBrown,
      'screen': const DasarJaringanScreen(),
    },
    {
      'id': 'ip_address',
      'title': 'IP Address',
      'subtitle': 'Pengalamatan IPv4, IPv6 & Subnetting',
      'icon': Icons.language_rounded,
      'color': AppTheme.primaryBrown,
      'screen': const IpAddressScreen(),
    },
    {
      'id': 'kabel_jaringan',
      'title': 'Kabel Jaringan',
      'subtitle': 'UTP, STP, Crimping & Fiber Optic',
      'icon': Icons.cable_rounded,
      'color': AppTheme.primaryBrown,
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
    _tabController = TabController(length: 4, vsync: this);
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
    return 'PEMULA TKJ';
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
              color: AppTheme.accentAmber,
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
              '$streak ${localizationService.translate('streak_days')} 🔥',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.accentAmber,
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
            title: const Text(
              'Progress Belajar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            flexibleSpace: const BrandAppBarBackground(),
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
                  final streak = snapshot.data ?? 1;
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
                                color: AppTheme.accentAmber,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Streak $streak',
                                style: const TextStyle(
                                  color: AppTheme.darkBrown,
                                  fontSize: 12.5,
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
                              color: AppTheme.accentRed,
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
          body: Stack(
            children: [
              const Positioned.fill(child: AnimatedBackdrop()),
              _isLoading
              ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryBrown))
              : RefreshIndicator(
                  color: AppTheme.primaryBrown,
                  onRefresh: refreshData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeSlideIn(child: _buildHeroCard(context)),
                        const SizedBox(height: 18),
                        FadeSlideIn(
                          delay: const Duration(milliseconds: 120),
                          child: _buildStatGrid(context),
                        ),
                        const SizedBox(height: 20),
                        FadeSlideIn(
                          delay: const Duration(milliseconds: 220),
                          child: _buildTabBar(context),
                        ),
                        const SizedBox(height: 16),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          switchInCurve: Curves.easeOutCubic,
                          transitionBuilder: (child, anim) => FadeTransition(
                            opacity: anim,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.06, 0),
                                end: Offset.zero,
                              ).animate(anim),
                              child: child,
                            ),
                          ),
                          child: KeyedSubtree(
                            key: ValueKey(_tabController.index),
                            child: _buildTabContent(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return AnimatedHeroCard(
      colors: const [Color(0xFFAD8B73), Color(0xFFC4A58C)],
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
      shadowColor: AppTheme.primaryBrown,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_levelIcon, color: AppTheme.accentAmber, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      _userLevel,
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
              CountUpText(
                value: _overallProgress,
                suffix: '%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Progres',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_completedModulesCount dari ${_modulesInfo.length} modul selesai penuh',
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
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: _overallProgress / 100.0),
              duration: const Duration(milliseconds: 1400),
              curve: Curves.easeOutCubic,
              builder: (context, v, _) => LinearProgressIndicator(
                value: v,
                minHeight: 10,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
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
            title: 'Aktivitas Selesai',
            value: '$_completedFeaturesCount',
            subtitle: 'dari total 42 fitur',
            icon: Icons.task_alt_rounded,
            color: kAccentPalette[0],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            title: 'Modul Tuntas',
            value: '$_completedModulesCount',
            subtitle: 'dari total 6 modul',
            icon: Icons.check_circle_rounded,
            color: kAccentPalette[1],
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final int? number = int.tryParse(value);
    final TextStyle valueStyle = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w800,
      color: isDark ? Colors.white : AppTheme.textDark,
    );

    return SoftCard(
      accent: color,
      radius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AccentChip(icon: icon, accent: color, size: 42),
              Icon(Icons.north_east_rounded,
                  size: 16, color: color.withOpacity(0.5)),
            ],
          ),
          const SizedBox(height: 14),
          number != null
              ? CountUpText(value: number, style: valueStyle)
              : Text(value, style: valueStyle),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textDark,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10.5,
              color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 46,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF241C17) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryBrown.withOpacity(0.18)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBrown.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFC4A58C), AppTheme.primaryBrown],
          ),
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBrown.withOpacity(0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
        labelStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: 'Per Modul'),
          Tab(text: 'Aktivitas'),
          Tab(text: 'Lencana'),
          Tab(text: 'Peringkat'),
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
      case 3:
        return _buildRankingsList(context);
      default:
        return _buildModuleProgressList(context);
    }
  }

  Widget _buildModuleProgressList(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: _modulesInfo.asMap().entries.map((entry) {
        final mod = entry.value;
        final index = entry.key;
        final accent = kAccentPalette[index % kAccentPalette.length];
        final modId = mod['id'] as String;
        final p = _moduleProgressMap[modId] ?? 0;
        final details = _moduleDetailsMap[modId] ?? {};
        final isExpanded = _expandedModuleId == modId;

        return FadeSlideIn(
          delay: Duration(milliseconds: 60 * index),
          offset: const Offset(0, 22),
          child: SoftCard(
          accent: accent,
          radius: 20,
          padding: EdgeInsets.zero,
          margin: const EdgeInsets.only(bottom: 12),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: AccentChip(
                  icon: (mod['icon'] as IconData?) ?? Icons.book_rounded,
                  accent: accent,
                  size: 46,
                ),
                title: Text(
                  mod['title'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.5,
                    color: isDark ? Colors.white : AppTheme.textDark,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: p / 100.0),
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeOutCubic,
                        builder: (context, v, _) => LinearProgressIndicator(
                          value: v,
                          minHeight: 7,
                          backgroundColor: isDark
                              ? Colors.grey.shade800
                              : accent.withOpacity(0.15),
                          valueColor: AlwaysStoppedAnimation<Color>(accent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$p% selesai',
                      style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade400 : AppTheme.textMuted),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: AppTheme.textMuted,
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
                                  ? AppTheme.brownTint
                                  : Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isDone
                                    ? AppTheme.primaryBrown.withOpacity(0.3)
                                    : AppTheme.borderCream,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                  size: 14,
                                  color: isDone ? AppTheme.primaryBrown : AppTheme.textMuted,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  feat['label'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
                                    color: isDone
                                        ? AppTheme.primaryBrown
                                        : AppTheme.textMuted,
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
          ),
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
              Icon(Icons.history_rounded, size: 44, color: AppTheme.textMuted),
              const SizedBox(height: 10),
              const Text(
                'Belum ada riwayat aktivitas',
                style: TextStyle(color: AppTheme.textMuted),
              ),
            ],
          ),
        ),
      );
    }

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: _activities.asMap().entries.map((entry) {
        final act = entry.value;
        final index = entry.key;
        final accent = kAccentPalette[index % kAccentPalette.length];
        return FadeSlideIn(
          delay: Duration(milliseconds: 50 * index),
          offset: const Offset(30, 0),
          child: SoftCard(
          accent: accent,
          radius: 18,
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              AccentChip(
                icon: Icons.check_circle_rounded,
                accent: accent,
                size: 42,
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
                        color: isDark ? Colors.white : AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      act['time'] ?? 'Baru saja',
                      style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBadgesList(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final badges = [
      {'title': 'Network Beginner', 'desc': 'Selesaikan modul K3LH', 'unlocked': _overallProgress >= 15, 'icon': Icons.lan_rounded, 'color': AppTheme.primaryBrown},
      {'title': 'First Lesson', 'desc': 'Selesaikan Pre Test pertama', 'unlocked': _completedFeaturesCount >= 1, 'icon': Icons.school_rounded, 'color': kAccentPalette[3]},
      {'title': 'Subnet Master', 'desc': 'Selesaikan modul IP Address', 'unlocked': (_moduleProgressMap['ip_address'] ?? 0) == 100, 'icon': Icons.calculate_rounded, 'color': AppTheme.accentAmber},
      {'title': 'Lab Explorer', 'desc': 'Gunakan 3D Simulator', 'unlocked': true, 'icon': Icons.science_rounded, 'color': kAccentPalette[2]},
      {'title': '7 Day Streak', 'desc': 'Belajar 7 hari berturut-turut', 'unlocked': false, 'icon': Icons.local_fire_department_rounded, 'color': AppTheme.accentRed},
      {'title': 'Master Netropia', 'desc': 'Capai 90% total progres', 'unlocked': _overallProgress >= 90, 'icon': Icons.military_tech_rounded, 'color': AppTheme.accentAmber},
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: badges.asMap().entries.map((entry) {
        final badge = entry.value;
        final index = entry.key;
        final unlocked = badge['unlocked'] as bool;
        final color = badge['color'] as Color;

        return FadeSlideIn(
          delay: Duration(milliseconds: 70 * index),
          offset: const Offset(0, 20),
          scaleFrom: 0.85,
          child: Opacity(
          opacity: unlocked ? 1.0 : 0.62,
          child: SoftCard(
          accent: unlocked ? color : AppTheme.textMuted,
          highlighted: unlocked,
          radius: 20,
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              unlocked
                  ? Floating(
                      amplitude: 2.5,
                      child: AccentChip(
                        icon: badge['icon'] as IconData,
                        accent: color,
                        size: 46,
                      ),
                    )
                  : const AccentChip(
                      icon: Icons.lock_outline_rounded,
                      accent: AppTheme.textMuted,
                      size: 46,
                    ),
              const SizedBox(height: 8),
              Text(
                badge['title'] as String,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: unlocked ? (isDark ? Colors.white : AppTheme.textDark) : AppTheme.textMuted,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                badge['desc'] as String,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
              ),
            ],
          ),
          ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRankingsList(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final ranks = [
      {'rank': 1, 'name': 'Ahmad Fauzi', 'xp': '1,250 XP', 'isUser': false},
      {'rank': 2, 'name': 'Siti Rahma', 'xp': '1,100 XP', 'isUser': false},
      {'rank': 3, 'name': 'Azer', 'xp': '850 XP', 'isUser': true},
      {'rank': 4, 'name': 'Budi Santoso', 'xp': '720 XP', 'isUser': false},
      {'rank': 5, 'name': 'Dina Maria', 'xp': '690 XP', 'isUser': false},
    ];

    return Column(
      children: ranks.asMap().entries.map((entry) {
        final r = entry.value;
        final index = entry.key;
        final isUser = r['isUser'] as bool;
        final rankNum = r['rank'] as int;

        Color rankColor = AppTheme.textMuted;
        if (rankNum == 1) rankColor = AppTheme.accentAmber;
        if (rankNum == 2) rankColor = Colors.grey.shade400;
        if (rankNum == 3) rankColor = const Color(0xFFCD7F32);

        return FadeSlideIn(
          delay: Duration(milliseconds: 60 * index),
          offset: const Offset(30, 0),
          child: SoftCard(
          accent: rankNum <= 3 ? rankColor : AppTheme.primaryBrown,
          highlighted: isUser,
          radius: 18,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: rankNum <= 3 ? rankColor.withOpacity(0.2) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '#$rankNum',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: rankNum <= 3 ? rankColor : AppTheme.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  r['name'] as String,
                  style: TextStyle(
                    fontWeight: isUser ? FontWeight.bold : FontWeight.w600,
                    fontSize: 14,
                    color: isDark ? Colors.white : AppTheme.textDark,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentAmber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  r['xp'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11.5,
                    color: AppTheme.accentAmber,
                  ),
                ),
              ),
            ],
          ),
          ),
        );
      }).toList(),
    );
  }
}
