import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'settings_screen.dart';
import 'edit_profile_screen.dart';
import 'help_support_screen.dart';
import 'about_app_screen.dart';
import '../progres/progres_screen.dart';
import '../services/localization_service.dart';
import '../theme/app_theme.dart';
import '../widgets/home_effects.dart';

class ProfileScreen extends StatelessWidget {
  final String username;
  final String role;

  const ProfileScreen({
    super.key,
    required this.username,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        final user = FirebaseAuth.instance.currentUser;
        final email = user?.email ?? "No Email";

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Stack(
            children: [
              const Positioned.fill(child: AnimatedBackdrop()),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildHeader(context, email),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
                      child: Column(
                        children: [
                          FadeSlideIn(
                            delay: const Duration(milliseconds: 250),
                            child: _buildStatsSection(context),
                          ),
                          const SizedBox(height: 22),
                          _buildTeacherAwardsSection(context),
                          _buildAchievementsSection(context),
                          const SizedBox(height: 24),
                          _buildMenuSection(context),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, String email) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;
    final double top = MediaQuery.of(context).padding.top;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, top + 12, 16, 0),
      child: FadeSlideIn(
        offset: const Offset(0, 24),
        child: AnimatedHeroCard(
          colors: isDark
              ? const [Color(0xFF3A2D26), Color(0xFF2A211C)]
              : const [Color(0xFFAD8B73), Color(0xFFC4A58C)],
          borderRadius: 30,
          padding: const EdgeInsets.fromLTRB(20, 26, 20, 22),
          shadowColor: AppTheme.primaryBrown,
          shadowOpacity: 0.3,
          child: Column(
            children: [
              Floating(
                amplitude: 3,
                duration: const Duration(milliseconds: 3600),
                child: _SpinRingAvatar(photoUrl: user?.photoURL),
              ),
              const SizedBox(height: 14),
              Text(
                username,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                email,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.88),
                  fontSize: 13.5,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Text(
                  role.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              PressScale(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditProfileScreen(username: username, role: role),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_rounded, size: 16),
                  label: Text(
                    localizationService.translate('edit_profile'),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.darkBrown,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 11),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text, int delayMs) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return FadeSlideIn(
      delay: Duration(milliseconds: delayMs),
      offset: const Offset(-20, 0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: AppTheme.primaryBrown,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 1,
              color: AppTheme.primaryBrown.withOpacity(0.18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return SoftCard(
      accent: AppTheme.primaryBrown,
      radius: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(context, 'Materi', 12, '', Icons.menu_book_rounded, kAccentPalette[0]),
          ),
          Expanded(
            child: _buildStatItem(context, 'Lab', 8, '', Icons.science_rounded, kAccentPalette[1]),
          ),
          Expanded(
            child: _buildStatItem(context, 'Jam', 14, 'h', Icons.timer_rounded, kAccentPalette[2]),
          ),
          Expanded(
            child: _buildStatItem(context, 'XP', 850, '', Icons.bolt_rounded, kAccentPalette[4]),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    int value,
    String suffix,
    IconData icon,
    Color accent,
  ) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        AccentChip(icon: icon, accent: accent, size: 36),
        const SizedBox(height: 8),
        CountUpText(
          value: value,
          suffix: suffix,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted),
        ),
      ],
    );
  }

  Widget _buildAchievementsSection(BuildContext context) {
    final badges = <_BadgeData>[
      _BadgeData('Network Beginner', Icons.lan_rounded, kAccentPalette[0], true),
      _BadgeData('First Lesson', Icons.school_rounded, kAccentPalette[3], true),
      _BadgeData('Subnet Master', Icons.calculate_rounded, kAccentPalette[1], false),
      _BadgeData('Lab Explorer', Icons.science_rounded, kAccentPalette[2], true),
      _BadgeData('7 Day Streak', Icons.local_fire_department_rounded, kAccentPalette[5], false),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(context, 'PENCAPAIAN', 350),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              for (int i = 0; i < badges.length; i++)
                _buildBadge(context, badges[i], i),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(BuildContext context, _BadgeData b, int index) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return FadeSlideIn(
      delay: Duration(milliseconds: 420 + index * 80),
      offset: const Offset(30, 0),
      scaleFrom: 0.9,
      child: Opacity(
        opacity: b.unlocked ? 1.0 : 0.6,
        child: Container(
          width: 104,
          margin: const EdgeInsets.only(right: 12),
          child: SoftCard(
            accent: b.unlocked ? b.color : AppTheme.textMuted,
            highlighted: b.unlocked,
            radius: 20,
            padding: const EdgeInsets.fromLTRB(10, 14, 10, 12),
            child: Column(
              children: [
                b.unlocked
                    ? Floating(
                        amplitude: 2.5,
                        duration: Duration(milliseconds: 2600 + index * 300),
                        child: AccentChip(icon: b.icon, accent: b.color, size: 46),
                      )
                    : const AccentChip(
                        icon: Icons.lock_outline_rounded,
                        accent: AppTheme.textMuted,
                        size: 46,
                      ),
                const SizedBox(height: 10),
                Text(
                  b.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                    color: b.unlocked
                        ? (isDark ? Colors.white : AppTheme.textDark)
                        : AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final items = <_MenuData>[
      _MenuData(Icons.person_outline_rounded, localizationService.translate('edit_profile'), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(username: username, role: role)));
      }),
      _MenuData(Icons.trending_up_rounded, localizationService.translate('learning_progress'), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProgresScreen()));
      }),
      _MenuData(Icons.settings_outlined, localizationService.translate('settings'), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
      }),
      _MenuData(Icons.help_outline_rounded, localizationService.translate('help'), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen()));
      }),
      _MenuData(Icons.info_outline_rounded, localizationService.translate('about_netropia'), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutAppScreen()));
      }),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(context, 'AKUN & PENGATURAN', 600),
        const SizedBox(height: 12),
        FadeSlideIn(
          delay: const Duration(milliseconds: 650),
          offset: const Offset(0, 24),
          child: SoftCard(
            accent: AppTheme.primaryBrown,
            radius: 22,
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Column(
                children: [
                  for (int i = 0; i < items.length; i++) ...[
                    _buildMenuItem(context, items[i], i),
                    if (i < items.length - 1)
                      Divider(
                        height: 1,
                        indent: 66,
                        endIndent: 16,
                        color: AppTheme.primaryBrown.withOpacity(0.14),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, _MenuData item, int index) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color accent = kAccentPalette[index % kAccentPalette.length];
    return PressScale(
      pressedScale: 0.98,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: item.onTap,
          splashColor: accent.withOpacity(0.12),
          highlightColor: accent.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                AccentChip(icon: item.icon, accent: accent, size: 38),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppTheme.textDark,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: accent.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeacherAwardsSection(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox();

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        final data = snapshot.data?.data() as Map<String, dynamic>?;
        final awards = (data?['awards'] as List<dynamic>?) ?? [];

        if (awards.isEmpty) return const SizedBox();

        return FadeSlideIn(
          delay: const Duration(milliseconds: 300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionLabel(context, 'APRESIASI & BINTANG DARI GURU ⭐', 300),
              const SizedBox(height: 12),
              SoftCard(
                accent: AppTheme.accentAmber,
                radius: 22,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: awards.map((award) {
                    final badge = award['badge']?.toString() ?? '⭐ Bintang Apresiasi';
                    final guruName = award['guruName']?.toString() ?? 'Guru';
                    final catatan = award['catatan']?.toString() ?? '';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Pulse(
                            minScale: 0.92,
                            maxScale: 1.12,
                            child: AccentChip(
                              icon: Icons.star_rounded,
                              accent: AppTheme.accentAmber,
                              size: 38,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  badge,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: AppTheme.textDark),
                                ),
                                Text(
                                  'Diberikan oleh: $guruName',
                                  style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                ),
                                if (catatan.isNotEmpty) ...[
                                  const SizedBox(height: 3),
                                  Text(
                                    '"$catatan"',
                                    style: const TextStyle(fontSize: 11.5, fontStyle: FontStyle.italic, color: AppTheme.textDark),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 22),
            ],
          ),
        );
      },
    );
  }
}

class _BadgeData {
  final String label;
  final IconData icon;
  final Color color;
  final bool unlocked;

  _BadgeData(this.label, this.icon, this.color, this.unlocked);
}

class _MenuData {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _MenuData(this.icon, this.title, this.onTap);
}

/// Foto profil dengan cincin gradien yang berputar pelan + lencana edit.
class _SpinRingAvatar extends StatefulWidget {
  const _SpinRingAvatar({required this.photoUrl});

  final String? photoUrl;

  @override
  State<_SpinRingAvatar> createState() => _SpinRingAvatarState();
}

class _SpinRingAvatarState extends State<_SpinRingAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 7));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: const [
                    Colors.white,
                    Color(0x55FFFFFF),
                    Color(0xFFFFE0C2),
                    Color(0x55FFFFFF),
                    Colors.white,
                  ],
                  transform: GradientRotation(_controller.value * 6.2831853),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: child,
            );
          },
          child: CircleAvatar(
            radius: 46,
            backgroundColor: Colors.white,
            backgroundImage: widget.photoUrl != null
                ? NetworkImage(widget.photoUrl!)
                : null,
            child: widget.photoUrl == null
                ? const Icon(Icons.person_rounded,
                    size: 56, color: AppTheme.primaryBrown)
                : null,
          ),
        ),
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFE0A24A), AppTheme.accentAmber],
              ),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.edit_rounded, size: 13, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
