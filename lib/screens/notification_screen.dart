import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../materi/materi_screen.dart';
import '../peminjaman/borrowing_screen.dart';
import '../project/project_screen.dart';
import '../absensi/attendance_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notificationService = NotificationService();
  List<AppNotification> _notifications = [];
  bool _isLoading = true;
  String _selectedCategory = 'Semua';

  final List<String> _categories = [
    'Semua',
    'Belajar',
    'Peminjaman',
    'Project',
    'Absensi',
    'Sistem',
  ];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    final data = await _notificationService.getNotifications();
    if (mounted) {
      setState(() {
        _notifications = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _markAllAsRead() async {
    await _notificationService.markAllAsRead();
    await _loadNotifications();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua notifikasi telah ditandai sebagai dibaca.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _handleNotificationTap(AppNotification notif) async {
    if (!notif.isRead) {
      await _notificationService.markAsRead(notif.id);
      await _loadNotifications();
    }

    if (!mounted) return;

    if (notif.route == 'materi') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MateriScreen()),
      );
    } else if (notif.route == 'peminjaman') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BorrowingScreen()),
      );
    } else if (notif.route == 'project') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProjectScreen()),
      );
    } else if (notif.route == 'absensi') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AttendanceScreen()),
      );
    }
  }

  Future<void> _deleteNotification(String id) async {
    await _notificationService.deleteNotification(id);
    await _loadNotifications();
  }

  List<AppNotification> get _filteredNotifications {
    if (_selectedCategory == 'Semua') return _notifications;
    final typeMap = {
      'Belajar': NotificationType.belajar,
      'Peminjaman': NotificationType.peminjaman,
      'Project': NotificationType.project,
      'Absensi': NotificationType.absensi,
      'Sistem': NotificationType.system,
    };
    final targetType = typeMap[_selectedCategory];
    return _notifications.where((n) => n.type == targetType).toList();
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mnt lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hr lalu';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.belajar:
        return Icons.menu_book_rounded;
      case NotificationType.peminjaman:
        return Icons.inventory_2_rounded;
      case NotificationType.absensi:
        return Icons.fact_check_rounded;
      case NotificationType.project:
        return Icons.assignment_rounded;
      case NotificationType.system:
        return Icons.campaign_rounded;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.belajar:
        return const Color(0xFFAD8B73);
      case NotificationType.peminjaman:
        return const Color(0xFF0277BD);
      case NotificationType.absensi:
        return const Color(0xFF7B1FA2);
      case NotificationType.project:
        return const Color(0xFF2E7D32);
      case NotificationType.system:
        return const Color(0xFFE65100);
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Notifikasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          if (unreadCount > 0)
            IconButton(
              tooltip: 'Tandai Semua Dibaca',
              onPressed: _markAllAsRead,
              icon: const Icon(Icons.done_all_rounded),
            ),
        ],
      ),
      body: Column(
        children: [
          // CATEGORY FILTER CHIPS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: const Color(0xFFAD8B73),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                    backgroundColor: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFFAD8B73) : Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategory = category);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // NOTIFICATION LIST
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredNotifications.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadNotifications,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 50),
                          itemCount: _filteredNotifications.length,
                          itemBuilder: (context, index) {
                            final notif = _filteredNotifications[index];
                            final iconColor = _getNotificationColor(notif.type);
                            final iconData = _getNotificationIcon(notif.type);

                            return Dismissible(
                              key: Key(notif.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade400,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                              onDismissed: (direction) {
                                _deleteNotification(notif.id);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Material(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(16),
                                  elevation: notif.isRead ? 0 : 1,
                                  child: InkWell(
                                    onTap: () => _handleNotificationTap(notif),
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: notif.isRead
                                              ? Colors.transparent
                                              : iconColor.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // ICON
                                          Container(
                                            width: 44,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color: iconColor.withOpacity(0.12),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              iconData,
                                              color: iconColor,
                                              size: 22,
                                            ),
                                          ),
                                          const SizedBox(width: 12),

                                          // CONTENT
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        notif.title,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: notif.isRead
                                                              ? FontWeight.w600
                                                              : FontWeight.bold,
                                                          color: Theme.of(context)
                                                              .textTheme
                                                              .bodyLarge
                                                              ?.color,
                                                        ),
                                                      ),
                                                    ),

                                                    // UNREAD RED DOT
                                                    if (!notif.isRead)
                                                      Container(
                                                        width: 8,
                                                        height: 8,
                                                        margin: const EdgeInsets.only(left: 6),
                                                        decoration: const BoxDecoration(
                                                          color: Colors.redAccent,
                                                          shape: BoxShape.circle,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  notif.message,
                                                  style: TextStyle(
                                                    fontSize: 12.5,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.color
                                                        ?.withOpacity(0.8),
                                                    height: 1.3,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  _formatTime(notif.timestamp),
                                                  style: TextStyle(
                                                    fontSize: 10.5,
                                                    color: Colors.grey.shade500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada notifikasi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Notifikasi terbaru kamu akan muncul di sini.',
            style: TextStyle(
              fontSize: 12.5,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
