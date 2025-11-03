import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

// Notification Model
class Notification {
  final int id;
  final NotificationType type;
  final String title;
  final String message;
  final String timestamp;
  bool isRead; // Changed from final to mutable
  final NotificationPriority priority;
  final Map<String, dynamic>? actionData;
  final NotificationSender? sender;

  Notification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
    required this.priority,
    this.actionData,
    this.sender,
  });
}

enum NotificationType {
  message,
  tripInvite,
  safetyAlert,
  badgeEarned,
  buddyRequest,
  tripReminder,
  checkIn,
  weatherAlert,
}

enum NotificationPriority {
  low,
  medium,
  high,
  urgent,
}

class NotificationSender {
  final int id;
  final String name;
  final String avatar;

  NotificationSender({
    required this.id,
    required this.name,
    required this.avatar,
  });
}

// Notification Settings
class NotificationSettings {
  bool messages;
  bool safetyAlerts;
  bool tripUpdates;
  bool badgeEarned;
  bool buddyRequests;
  bool weatherAlerts;

  NotificationSettings({
    required this.messages,
    required this.safetyAlerts,
    required this.tripUpdates,
    required this.badgeEarned,
    required this.buddyRequests,
    required this.weatherAlerts,
  });
}

// Mock Data
final mockNotifications = [
  Notification(
    id: 1,
    type: NotificationType.safetyAlert,
    title: 'Safety Check-In Required',
    message: 'Your scheduled safety check-in for the Banff hiking trip is due in 15 minutes.',
    timestamp: '2 minutes ago',
    isRead: false,
    priority: NotificationPriority.urgent,
    actionData: {'tripId': 1, 'checkInId': 1},
  ),
  Notification(
    id: 2,
    type: NotificationType.message,
    title: 'New message from Alex Chen',
    message: 'Perfect! See you at the trailhead at 7 AM 🥾',
    timestamp: '5 minutes ago',
    isRead: false,
    priority: NotificationPriority.medium,
    sender: NotificationSender(
      id: 1,
      name: 'Alex Chen',
      avatar: '/api/placeholder/32/32',
    ),
  ),
  // Add other mock notifications here...
];

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Notification> _notifications = mockNotifications;
  String _activeTab = 'all';
  final NotificationSettings _notificationSettings = NotificationSettings(
    messages: true,
    safetyAlerts: true,
    tripUpdates: true,
    badgeEarned: true,
    buddyRequests: true,
    weatherAlerts: true,
  );

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return LucideIcons.messageSquare;
      case NotificationType.safetyAlert:
        return LucideIcons.alertTriangle;
      case NotificationType.tripInvite:
        return LucideIcons.mapPin;
      case NotificationType.badgeEarned:
        return LucideIcons.trophy;
      case NotificationType.buddyRequest:
        return LucideIcons.users;
      case NotificationType.tripReminder:
        return LucideIcons.calendar;
      case NotificationType.checkIn:
        return LucideIcons.shield;
      case NotificationType.weatherAlert:
        return LucideIcons.cloudRain;
    }
  }

  Color _getNotificationColor(NotificationType type, NotificationPriority priority) {
    if (priority == NotificationPriority.urgent) return Colors.red.shade600;
    if (priority == NotificationPriority.high) return Colors.orange.shade600;

    switch (type) {
      case NotificationType.safetyAlert:
        return const Color(0xFFD72638); // lucky-red
      case NotificationType.badgeEarned:
        return const Color(0xFFFFD700); // gold
      case NotificationType.tripInvite:
        return const Color(0xFF87CEEB); // sky-blue
      case NotificationType.buddyRequest:
        return const Color(0xFF228B22); // forest-green
      case NotificationType.weatherAlert:
        return const Color(0xFFE66A00); // fox-orange
      default:
        return const Color(0xFF228B22); // forest-green
    }
  }

  Color _getPriorityBadgeColor(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.urgent:
        return Colors.red;
      case NotificationPriority.high:
        return Colors.orange;
      case NotificationPriority.medium:
        return Colors.blue;
      case NotificationPriority.low:
        return Colors.grey;
    }
  }

  String _getPriorityText(NotificationPriority priority) {
    return priority.toString().split('.').last;
  }

  void _markAsRead(int id) {
    setState(() {
      for (var notif in _notifications) {
        if (notif.id == id) {
          notif.isRead = true;
        }
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notif in _notifications) {
        notif.isRead = true;
      }
    });
  }

  void _deleteNotification(int id) {
    setState(() {
      _notifications.removeWhere((notif) => notif.id == id);
    });
  }

  List<Notification> get _filteredNotifications {
    return _notifications.where((notif) {
      switch (_activeTab) {
        case 'unread':
          return !notif.isRead;
        case 'safety':
          return notif.type == NotificationType.safetyAlert || notif.type == NotificationType.checkIn;
        case 'social':
          return notif.type == NotificationType.message ||
              notif.type == NotificationType.buddyRequest ||
              notif.type == NotificationType.tripInvite;
        default:
          return true;
      }
    }).toList();
  }

  int get _unreadCount {
    return _notifications.where((n) => !n.isRead).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6).withOpacity(0.1), // earth-sand/10
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF003B2E), // forest-green
                          ),
                        ),
                        if (_unreadCount > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD72638), // lucky-red
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$_unreadCount new',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Row(
                      children: [
                        if (_unreadCount > 0) ...[
                          ElevatedButton(
                            onPressed: _markAllAsRead,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(LucideIcons.checkCircle, size: 16),
                                SizedBox(width: 4),
                                Text('Mark all read'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(LucideIcons.settings),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tabs
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildTab('all', 'All (${_notifications.length})'),
                      _buildTab('unread', 'Unread ($_unreadCount)'),
                      _buildTab('safety', 'Safety'),
                      _buildTab('social', 'Social'),
                    ],
                  ),
                ),

                // Notifications List
                Expanded(
                  child: _filteredNotifications.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredNotifications.length,
                          itemBuilder: (context, index) {
                            final notification = _filteredNotifications[index];
                            return _buildNotificationCard(notification);
                          },
                        ),
                ),
              ],
            ),
          ),

          // Quick Settings Panel
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quick Settings',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.settings, size: 16),
                    ),
                  ],
                ),
                const Divider(height: 16),
                _buildSettingSwitch('Safety Alerts', _notificationSettings.safetyAlerts, (value) {
                  setState(() {
                    _notificationSettings.safetyAlerts = value;
                  });
                }),
                _buildSettingSwitch('Message Notifications', _notificationSettings.messages, (value) {
                  setState(() {
                    _notificationSettings.messages = value;
                  });
                }),
                _buildSettingSwitch('Weather Alerts', _notificationSettings.weatherAlerts, (value) {
                  setState(() {
                    _notificationSettings.weatherAlerts = value;
                  });
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String value, String label) {
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _activeTab = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: _activeTab == value
                ? Border(
                    bottom: BorderSide(
                      color: const Color(0xFF003B2E), // forest-green
                      width: 2,
                    ),
                  )
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: _activeTab == value ? FontWeight.w600 : FontWeight.w500,
              color: _activeTab == value ? const Color(0xFF003B2E) : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFE8D9B5),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(
              LucideIcons.bell,
              size: 32,
              color: const Color(0xFF003B2E),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _activeTab == 'unread' ? "You're all caught up!" : "New notifications will appear here.",
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Notification notification) {
    final iconColor = _getNotificationColor(notification.type, notification.priority);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => !notification.isRead ? _markAsRead(notification.id) : null,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: !notification.isRead ? Colors.blue.shade50.withOpacity(0.3) : null,
            border: !notification.isRead
                ? Border(
                    left: BorderSide(
                      color: const Color(0xFFE66A00),
                      width: 4,
                    ),
                  )
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            children: [
                              Text(
                                notification.title,
                                style: TextStyle(
                                  fontWeight: !notification.isRead ? FontWeight.w600 : FontWeight.w500,
                                ),
                              ),
                              if (!notification.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE66A00),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _getPriorityBadgeColor(notification.priority),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _getPriorityText(notification.priority),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          notification.timestamp,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (notification.sender != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundImage: NetworkImage(notification.sender!.avatar),
                            child: Text(
                              notification.sender!.name.split(' ').map((n) => n[0]).join(),
                              style: const TextStyle(fontSize: 8),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'from ${notification.sender!.name}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 12),
                    _buildActionButtons(notification),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _deleteNotification(notification.id),
                icon: const Icon(LucideIcons.x, size: 16),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(Notification notification) {
    switch (notification.type) {
      case NotificationType.buddyRequest:
        return Row(
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003B2E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              ),
              child: const Text('Accept'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              ),
              child: const Text('Decline'),
            ),
          ],
        );
      case NotificationType.tripInvite:
        return Row(
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE66A00),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              ),
              child: const Text('View Trip'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              ),
              child: const Text('Decline'),
            ),
          ],
        );
      case NotificationType.safetyAlert:
        return ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD72638),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          ),
          child: const Text('Check In Now'),
        );
      case NotificationType.badgeEarned:
        return OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          ),
          child: const Text('View Badge'),
        );
      case NotificationType.message:
        return OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          ),
          child: const Text('Reply'),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildSettingSwitch(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}