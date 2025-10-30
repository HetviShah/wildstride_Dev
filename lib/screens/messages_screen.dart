import 'package:flutter/material.dart';

class Message {
  final int id;
  final int senderId;
  final String content;
  final String timestamp;
  final MessageType type;
  final Map<String, dynamic>? metadata;

  Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.type,
    this.metadata,
  });
}

enum MessageType {
  text,
  image,
  location,
  tripInvite,
  safetyCheckin,
}

class Participant {
  final int id;
  final String name;
  final String avatar;
  final bool? isOnline;
  final SafetyStatus? safetyStatus;

  Participant({
    required this.id,
    required this.name,
    required this.avatar,
    this.isOnline,
    this.safetyStatus,
  });
}

enum SafetyStatus {
  safe,
  checkingIn,
  overdue,
  unknown,
}

class Conversation {
  final int id;
  final List<Participant> participants;
  final Message lastMessage;
  final int unreadCount;
  final ConversationType type;

  Conversation({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.unreadCount,
    required this.type,
  });
}

enum ConversationType {
  direct,
  group,
}

class MessagesScreen extends StatefulWidget {
  final Function(String)? onNavigate;

  const MessagesScreen({Key? key, this.onNavigate}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  Conversation? _selectedConversation;
  String _newMessage = '';
  String _searchQuery = '';
  List<Message> _messages = [];
  bool _showEmojiPicker = false;
  bool _showCameraMenu = false;
  bool _showAttachMenu = false;

  final List<Conversation> _mockConversations = [
    Conversation(
      id: 1,
      participants: [
        Participant(
          id: 1,
          name: 'Alex Chen',
          avatar: '/api/placeholder/40/40',
          isOnline: true,
          safetyStatus: SafetyStatus.safe,
        ),
        Participant(
          id: 2,
          name: 'You',
          avatar: '/api/placeholder/40/40',
        ),
      ],
      lastMessage: Message(
        id: 1,
        senderId: 1,
        content: 'Perfect! See you at the trailhead at 7 AM 🥾',
        timestamp: '2:30 PM',
        type: MessageType.text,
      ),
      unreadCount: 2,
      type: ConversationType.direct,
    ),
    Conversation(
      id: 3,
      participants: [
        Participant(
          id: 5,
          name: 'Emma Wilson',
          avatar: '/api/placeholder/40/40',
          isOnline: false,
          safetyStatus: SafetyStatus.safe,
        ),
        Participant(
          id: 2,
          name: 'You',
          avatar: '/api/placeholder/40/40',
        ),
      ],
      lastMessage: Message(
        id: 3,
        senderId: 5,
        content: 'Thanks for the safety tips! Really helpful 🙏',
        timestamp: '11:20 AM',
        type: MessageType.text,
      ),
      unreadCount: 0,
      type: ConversationType.direct,
    ),
    Conversation(
      id: 5,
      participants: [
        Participant(
          id: 8,
          name: 'Jordan Liu',
          avatar: '/api/placeholder/40/40',
          isOnline: true,
          safetyStatus: SafetyStatus.safe,
        ),
        Participant(
          id: 2,
          name: 'You',
          avatar: '/api/placeholder/40/40',
        ),
      ],
      lastMessage: Message(
        id: 5,
        senderId: 8,
        content: 'Found a great hiking spot for our weekend trip!',
        timestamp: '9:45 AM',
        type: MessageType.text,
      ),
      unreadCount: 0,
      type: ConversationType.direct,
    ),
    Conversation(
      id: 6,
      participants: [
        Participant(
          id: 9,
          name: 'Maya Patel',
          avatar: '/api/placeholder/40/40',
          isOnline: false,
          safetyStatus: SafetyStatus.safe,
        ),
        Participant(
          id: 2,
          name: 'You',
          avatar: '/api/placeholder/40/40',
        ),
      ],
      lastMessage: Message(
        id: 6,
        senderId: 9,
        content: 'Let\'s plan our next adventure together!',
        timestamp: 'Yesterday',
        type: MessageType.text,
      ),
      unreadCount: 1,
      type: ConversationType.direct,
    ),
  ];

  final List<Message> _mockMessages = [
    Message(
      id: 1,
      senderId: 1,
      content: 'Hey! Excited about our hike tomorrow. Did you check the weather forecast?',
      timestamp: '2:15 PM',
      type: MessageType.text,
    ),
    Message(
      id: 2,
      senderId: 2,
      content: 'Yes! Looks perfect - sunny with 22°C. I\'ve got my gear ready 🎒',
      timestamp: '2:20 PM',
      type: MessageType.text,
    ),
    Message(
      id: 3,
      senderId: 1,
      content: 'Awesome! Meet at the Lake Louise parking lot?',
      timestamp: '2:25 PM',
      type: MessageType.text,
    ),
    Message(
      id: 4,
      senderId: 2,
      content: 'Perfect! See you at the trailhead at 7 AM 🥾',
      timestamp: '2:30 PM',
      type: MessageType.text,
    ),
    Message(
      id: 5,
      senderId: 1,
      content: 'Great! Don\'t forget to enable location sharing for safety 📍',
      timestamp: '2:32 PM',
      type: MessageType.safetyCheckin,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _messages = _mockMessages;
  }

  List<Conversation> get _filteredConversations {
    return _mockConversations.where((conv) => conv.participants.any((p) => 
        p.name.toLowerCase().contains(_searchQuery.toLowerCase()))).toList();
  }

  void _sendMessage() {
    if (_newMessage.trim().isNotEmpty) {
      final newMsg = Message(
        id: _messages.length + 1,
        senderId: 2, // Current user ID
        content: _newMessage.trim(),
        timestamp: _formatTime(DateTime.now()),
        type: MessageType.text,
      );
      
      setState(() {
        _messages = [..._messages, newMsg];
        _newMessage = '';
        _showCameraMenu = false;
        _showAttachMenu = false;
        _showEmojiPicker = false;
      });
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Color _getSafetyStatusColor(SafetyStatus? status) {
    switch (status) {
      case SafetyStatus.safe:
        return Colors.green;
      case SafetyStatus.checkingIn:
        return Colors.orange;
      case SafetyStatus.overdue:
        return Colors.red;
      case SafetyStatus.unknown:
      default:
        return Colors.grey;
    }
  }

  // Add this helper method to show safety status indicators in the conversation list
  Widget _buildSafetyStatusIndicator(SafetyStatus? status) {
    if (status == null) return const SizedBox.shrink();
    
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        color: _getSafetyStatusColor(status),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildConversationHeader() {
    final otherParticipants = _selectedConversation!.participants.where((p) => p.name != 'You').toList();
    
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _selectedConversation = null;
              });
            },
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 12),
          Stack(
            children: [
              Row(
                children: otherParticipants.asMap().entries.map((entry) {
                  final index = entry.key;
                  final participant = entry.value;
                  return Container(
                    margin: EdgeInsets.only(left: index > 0 ? -8 : 0),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(participant.avatar),
                      child: participant.avatar.isEmpty 
                          ? Text(
                              participant.name.split(' ').map((n) => n[0]).join(''),
                              style: const TextStyle(color: Color(0xFF003B2E)),
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
              ...otherParticipants.map((participant) {
                final index = otherParticipants.indexOf(participant);
                return Positioned(
                  right: index * 12.0,
                  bottom: 0,
                  child: participant.isOnline == true 
                      ? Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            border: Border.all(color: Colors.white, width: 2),
                            shape: BoxShape.circle,
                          ),
                        )
                      : Container(),
                );
              }),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      otherParticipants.map((p) => p.name).join(', '),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    // Add safety status indicator to header
                    if (otherParticipants.any((p) => p.safetyStatus != null))
                      _buildSafetyStatusIndicator(otherParticipants.firstWhere((p) => p.safetyStatus != null).safetyStatus),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      otherParticipants.any((p) => p.isOnline == true) ? 'Online' : 'Offline',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    if (otherParticipants.any((p) => p.safetyStatus == SafetyStatus.safe)) ...[
                      const Text(' • ', style: TextStyle(color: Colors.grey)),
                      Text(
                        'Safe', 
                        style: TextStyle(
                          fontSize: 12, 
                          color: _getSafetyStatusColor(SafetyStatus.safe),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    if (otherParticipants.any((p) => p.safetyStatus == SafetyStatus.checkingIn)) ...[
                      const Text(' • ', style: TextStyle(color: Colors.grey)),
                      Text(
                        'Checking In', 
                        style: TextStyle(
                          fontSize: 12, 
                          color: _getSafetyStatusColor(SafetyStatus.checkingIn),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    if (otherParticipants.any((p) => p.safetyStatus == SafetyStatus.overdue)) ...[
                      const Text(' • ', style: TextStyle(color: Colors.grey)),
                      Text(
                        'Overdue', 
                        style: TextStyle(
                          fontSize: 12, 
                          color: _getSafetyStatusColor(SafetyStatus.overdue),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => widget.onNavigate?.call('call'),
            icon: const Icon(Icons.phone),
          ),
          IconButton(
            onPressed: () => widget.onNavigate?.call('video-call'),
            icon: const Icon(Icons.videocam),
          ),
          IconButton(
            onPressed: () => widget.onNavigate?.call('chat-options'),
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isCurrentUser = message.senderId == 2;
    
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCurrentUser 
              ? const Color(0xFFE66A00)
              : message.type == MessageType.safetyCheckin
                  ? Colors.blue[50]
                  : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: message.type == MessageType.safetyCheckin && !isCurrentUser
              ? Border.all(color: Colors.blue[200]!)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.type == MessageType.safetyCheckin && !isCurrentUser)
              Row(
                children: [
                  Icon(Icons.security, color: Colors.blue[400], size: 16),
                  const SizedBox(width: 4),
                  const Text(
                    'Safety Message',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            if (message.type == MessageType.safetyCheckin && !isCurrentUser)
              const SizedBox(height: 4),
            Text(
              message.content,
              style: TextStyle(
                color: isCurrentUser ? Colors.white : const Color(0xFF003B2E),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.timestamp,
              style: TextStyle(
                fontSize: 10,
                color: isCurrentUser ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputOptionsMenu() {
    final List<Widget> menus = [];

    if (_showCameraMenu) {
      menus.add(_buildCameraMenu());
    }

    if (_showAttachMenu) {
      menus.add(_buildAttachMenu());
    }

    if (_showEmojiPicker) {
      menus.add(_buildEmojiPicker());
    }

    return Column(children: menus);
  }

  Widget _buildCameraMenu() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Camera Options',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF003B2E),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildOptionButton('📷 Take Photo', () {
                _addMessage('📸 Shared a trail photo from camera', MessageType.image);
              }),
              _buildOptionButton('🎥 Record Video', () {
                _addMessage('🎥 Shared a video from adventure', MessageType.image);
              }),
              _buildOptionButton('🖼️ From Gallery', () {
                _addMessage('🖼️ Shared photos from gallery', MessageType.image);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachMenu() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Attach File',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF003B2E),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildOptionButton('📍 Location', () {
                _addMessage('📍 Shared current location: Lake Louise Trailhead', MessageType.location);
              }),
              _buildOptionButton('📄 Document', () {
                _addMessage('📄 Shared itinerary.pdf', MessageType.text);
              }),
              _buildOptionButton('🎵 Audio', () {
                _addMessage('🎵 Shared hiking-playlist.mp3', MessageType.text);
              }),
              _buildOptionButton('☎️ Contact', () {
                _addMessage('☎️ Shared contact: Mountain Rescue (403-762-1111)', MessageType.text);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiPicker() {
    final emojis = [
      '😊', '👍', '❤️', '😂', '🎉', '🏔️', '🥾', '📍', '🌲', '🏕️', 
      '🎒', '🧗', '🚶', '🌄', '⛰️', '🗺️', '📸', '🔥', '⭐', '✅', 
      '🙌', '💪', '🌟', '🎯'
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Travel Emojis',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF003B2E),
            ),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: emojis.length,
            itemBuilder: (context, index) {
              return IconButton(
                onPressed: () {
                  setState(() {
                    _newMessage += emojis[index];
                    _showEmojiPicker = false;
                  });
                },
                icon: Text(emojis[index]),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  hoverColor: const Color(0xFFE66A00).withOpacity(0.2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String text, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
      ),
      child: Text(text),
    );
  }

  void _addMessage(String content, MessageType type) {
    final newMsg = Message(
      id: _messages.length + 1,
      senderId: 2,
      content: content,
      timestamp: _formatTime(DateTime.now()),
      type: type,
    );
    
    setState(() {
      _messages = [..._messages, newMsg];
      _showCameraMenu = false;
      _showAttachMenu = false;
      _showEmojiPicker = false;
    });
  }

  Widget _buildConversationView() {
    return Column(
      children: [
        _buildConversationHeader(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return _buildMessageBubble(_messages[index]);
            },
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildInputOptionsMenu(),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showCameraMenu = !_showCameraMenu;
                        _showAttachMenu = false;
                        _showEmojiPicker = false;
                      });
                    },
                    icon: const Icon(Icons.camera_alt),
                    style: IconButton.styleFrom(
                      backgroundColor: _showCameraMenu 
                          ? const Color(0xFFE66A00).withOpacity(0.2)
                          : null,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showAttachMenu = !_showAttachMenu;
                        _showCameraMenu = false;
                        _showEmojiPicker = false;
                      });
                    },
                    icon: const Icon(Icons.attach_file),
                    style: IconButton.styleFrom(
                      backgroundColor: _showAttachMenu 
                          ? const Color(0xFFE66A00).withOpacity(0.2)
                          : null,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(text: _newMessage),
                      onChanged: (value) {
                        setState(() {
                          _newMessage = value;
                        });
                      },
                      onSubmitted: (value) {
                        _sendMessage();
                      },
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showEmojiPicker = !_showEmojiPicker;
                        _showCameraMenu = false;
                        _showAttachMenu = false;
                      });
                    },
                    icon: const Icon(Icons.emoji_emotions),
                    style: IconButton.styleFrom(
                      backgroundColor: _showEmojiPicker 
                          ? const Color(0xFFE66A00).withOpacity(0.2)
                          : null,
                    ),
                  ),
                  IconButton(
                    onPressed: _newMessage.trim().isNotEmpty ? _sendMessage : null,
                    icon: const Icon(Icons.send),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFE66A00),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConversationsList() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003B2E),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => widget.onNavigate?.call('new-chat'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE66A00),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add, size: 16),
                        SizedBox(width: 4),
                        Text('New Chat'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: _searchQuery),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search conversations...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredConversations.length,
            itemBuilder: (context, index) {
              final conversation = _filteredConversations[index];
              return _buildConversationCard(conversation);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildConversationCard(Conversation conversation) {
    final otherParticipants = conversation.participants.where((p) => p.name != 'You').toList();
    
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Stack(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: otherParticipants.asMap().entries.map((entry) {
                final index = entry.key;
                final participant = entry.value;
                return Container(
                  margin: EdgeInsets.only(left: index > 0 ? -8 : 0),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(participant.avatar),
                    child: participant.avatar.isEmpty 
                        ? Text(
                            participant.name.split(' ').map((n) => n[0]).join(''),
                            style: const TextStyle(color: Color(0xFF003B2E)),
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
            ...otherParticipants.map((participant) {
              final index = otherParticipants.indexOf(participant);
              return Positioned(
                right: index * 12.0,
                bottom: 0,
                child: participant.isOnline == true 
                    ? Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(color: Colors.white, width: 2),
                          shape: BoxShape.circle,
                        ),
                      )
                    : Container(),
              );
            }),
            // Add safety status indicators
            ...otherParticipants.map((participant) {
              final index = otherParticipants.indexOf(participant);
              return Positioned(
                right: index * 12.0,
                top: 0,
                child: _buildSafetyStatusIndicator(participant.safetyStatus),
              );
            }),
          ],
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    otherParticipants.map((p) => p.name).join(', '),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Add safety status indicator next to name
                  if (otherParticipants.any((p) => p.safetyStatus != null))
                    _buildSafetyStatusIndicator(otherParticipants.firstWhere((p) => p.safetyStatus != null).safetyStatus),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  conversation.lastMessage.timestamp,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                if (conversation.unreadCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD72638),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        conversation.unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        subtitle: Text(
          '${conversation.lastMessage.type == MessageType.safetyCheckin ? '🛡️ ' : ''}${conversation.lastMessage.content}',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.grey),
        ),
        onTap: () {
          setState(() {
            _selectedConversation = conversation;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6), // earth-sand/10 equivalent
      body: _selectedConversation != null 
          ? _buildConversationView()
          : _buildConversationsList(),
    );
  }
}