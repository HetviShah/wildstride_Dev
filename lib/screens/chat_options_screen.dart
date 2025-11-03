import 'package:flutter/material.dart';

class ChatOptionsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final ConversationData? conversationData;

  const ChatOptionsScreen({
    super.key,
    this.onBack,
    this.conversationData,
  });

  @override
  State<ChatOptionsScreen> createState() => _ChatOptionsScreenState();
}

class ConversationData {
  final int id;
  final List<Participant> participants;
  final String type; // 'direct', 'group', 'trip-room'
  final TripInfo? tripInfo;

  ConversationData({
    required this.id,
    required this.participants,
    required this.type,
    this.tripInfo,
  });
}

class Participant {
  final int id;
  final String name;
  final String avatar;
  final bool? isOnline;

  Participant({
    required this.id,
    required this.name,
    required this.avatar,
    this.isOnline,
  });
}

class TripInfo {
  final String title;
  final String location;

  TripInfo({
    required this.title,
    required this.location,
  });
}

class _ChatOptionsScreenState extends State<ChatOptionsScreen> {
  bool _notifications = true;
  bool _isPinned = false;
  bool _sounds = true;

  ConversationData get _conversation => widget.conversationData ?? ConversationData(
    id: 1,
    participants: [
      Participant(id: 1, name: 'Marcus Johnson', avatar: '/placeholder-avatar.jpg', isOnline: true),
      Participant(id: 2, name: 'You', avatar: '/placeholder-avatar.jpg'),
    ],
    type: 'direct',
  );

  List<Participant> get _otherParticipants => 
      _conversation.participants.where((p) => p.name != 'You').toList();

  bool get _isDirectChat => _conversation.type == 'direct';
  bool get _isTripRoom => _conversation.type == 'trip-room';

  void _handleDeleteChat() {
    print('Delete chat confirmed');
    widget.onBack?.call();
  }

  void _handleBlockUser() {
    print('Block user confirmed');
    widget.onBack?.call();
  }

  void _handleReportSpam() {
    print('Report spam confirmed');
    widget.onBack?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6), // earth-sand/10
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.arrow_back),
                  color: const Color(0xFF2E5E4E), // forest-green
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chat Options',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2E5E4E),
                        ),
                      ),
                      Text(
                        _isTripRoom ? _conversation.tripInfo?.title ?? '' :
                        _isDirectChat ? 'Chat with ${_otherParticipants.firstOrNull?.name}' :
                        'Group chat with ${_otherParticipants.length} members',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF6B7280), // mountain-gray
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Chat Info
                  _buildChatInfoCard(theme),
                  const SizedBox(height: 16),

                  // Chat Settings
                  _buildChatSettingsCard(theme),
                  const SizedBox(height: 16),

                  // Chat Actions
                  _buildChatActionsCard(theme),
                  const SizedBox(height: 16),

                  // Safety & Privacy
                  if (_isDirectChat) ...[
                    _buildSafetyPrivacyCard(theme),
                    const SizedBox(height: 16),
                  ],

                  // Danger Zone
                  _buildDangerZoneCard(theme),
                  const SizedBox(height: 16),

                  // App Info
                  _buildAppInfo(theme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatInfoCard(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: const Color(0xFFD1C7B7).withOpacity(0.3)), // earth-sand/30
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Stack(
              children: [
                for (int i = 0; i < _otherParticipants.length; i++)
                  if (i < 2)
                    Container(
                      margin: EdgeInsets.only(left: (i * 24).toDouble()),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(_otherParticipants[i].avatar),
                          child: _otherParticipants[i].avatar.isEmpty
                              ? Text(
                                  _otherParticipants[i].name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').join(''),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2E5E4E),
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                if (_otherParticipants.length > 2)
                  Container(
                    margin: const EdgeInsets.only(left: 48),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFF6B7280), // mountain-gray
                      child: Text(
                        '+${_otherParticipants.length - 2}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isTripRoom ? _conversation.tripInfo?.title ?? '' :
                    _isDirectChat ? _otherParticipants.firstOrNull?.name ?? '' :
                    '${_otherParticipants.length} Participants',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2E5E4E),
                    ),
                  ),
                  if (_isTripRoom && _conversation.tripInfo != null)
                    Text(
                      _conversation.tripInfo!.location,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  if (_isDirectChat && (_otherParticipants.firstOrNull?.isOnline == true))
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Online',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatSettingsCard(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: const Color(0xFFD1C7B7).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Text(
                  'Chat Settings',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF2E5E4E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                _buildSettingRow(
                  icon: Icons.notifications_off,
                  title: 'Mute notifications',
                  subtitle: 'You won\'t get notifications for new messages',
                  value: !_notifications,
                  onChanged: (value) => setState(() => _notifications = !value),
                ),
                const Divider(height: 1, color: Color(0xFFD1C7B7)),
                _buildSettingRow(
                  icon: _isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                  title: 'Pin conversation',
                  subtitle: 'Keep this chat at the top of your messages',
                  value: _isPinned,
                  onChanged: (value) => setState(() => _isPinned = value),
                ),
                const Divider(height: 1, color: Color(0xFFD1C7B7)),
                _buildSettingRow(
                  icon: _sounds ? Icons.volume_up : Icons.volume_off,
                  title: 'Message sounds',
                  subtitle: 'Play sounds for messages in this chat',
                  value: _sounds,
                  onChanged: (value) => setState(() => _sounds = value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF6B7280)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2E5E4E),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF2E5E4E),
          ),
        ],
      ),
    );
  }

  Widget _buildChatActionsCard(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: const Color(0xFFD1C7B7).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Text(
                  'Chat Actions',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF2E5E4E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                _buildActionButton(
                  icon: Icons.search,
                  text: 'Search in conversation',
                  onTap: () {},
                ),
                _buildActionButton(
                  icon: Icons.download,
                  text: 'Export chat history',
                  onTap: () {},
                ),
                _buildActionButton(
                  icon: Icons.archive,
                  text: 'Archive conversation',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 20, color: const Color(0xFF2E5E4E)),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF2E5E4E),
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 16, color: Color(0xFF6B7280)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minLeadingWidth: 0,
    );
  }

  Widget _buildSafetyPrivacyCard(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: const Color(0xFFD1C7B7).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                const Icon(Icons.security, size: 20, color: Color(0xFF2E5E4E)),
                const SizedBox(width: 8),
                Text(
                  'Safety & Privacy',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF2E5E4E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                _buildDangerActionButton(
                  icon: Icons.block,
                  text: 'Block ${_otherParticipants.firstOrNull?.name}',
                  color: const Color(0xFFD35400), // fox-orange
                  onTap: () => _showBlockUserDialog(),
                ),
                _buildDangerActionButton(
                  icon: Icons.flag,
                  text: 'Report spam or abuse',
                  color: const Color(0xFFD35400),
                  onTap: () => _showReportSpamDialog(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZoneCard(ThemeData theme) {
    return Card(
      elevation: 0,
      color: const Color(0xFFDC3545).withOpacity(0.05), // lucky-red/5
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: const Color(0xFFDC3545).withOpacity(0.3)), // lucky-red/30
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                const Icon(Icons.warning, size: 20, color: Color(0xFFDC3545)),
                const SizedBox(width: 8),
                Text(
                  'Danger Zone',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFFDC3545),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _buildDangerActionButton(
              icon: Icons.delete,
              text: 'Delete conversation',
              color: const Color(0xFFDC3545),
              onTap: () => _showDeleteChatDialog(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 20, color: color),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: color,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 16, color: Color(0xFF6B7280)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minLeadingWidth: 0,
    );
  }

  Widget _buildAppInfo(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 32),
      child: Column(
        children: [
          Text(
            'Your conversations are end-to-end encrypted for your safety and privacy.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD700), // gold
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Secure • Private • Adventure-Ready',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this conversation?'),
        content: const Text(
          'This action cannot be undone. All messages, media, and shared content '
          'will be permanently deleted from your device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleDeleteChat();
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFDC3545),
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete Conversation'),
          ),
        ],
      ),
    );
  }

  void _showBlockUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block this user?'),
        content: Text(
          '${_otherParticipants.firstOrNull?.name} won\'t be able to message you or see when you\'re online. '
          'You can unblock them anytime from your blocked users list.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleBlockUser();
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFD35400),
              foregroundColor: Colors.white,
            ),
            child: const Text('Block User'),
          ),
        ],
      ),
    );
  }

  void _showReportSpamDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report this conversation?'),
        content: const Text(
          'This will report the conversation content to our safety team for review. '
          'The user won\'t be notified of your report.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleReportSpam();
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFD35400),
              foregroundColor: Colors.white,
            ),
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }
}