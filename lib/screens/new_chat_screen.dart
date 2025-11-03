import 'package:flutter/material.dart';

class User {
  final int id;
  final String name;
  final String avatar;
  final String location;
  final bool isOnline;
  final bool isBuddy;
  final int mutualTrips;
  final double safetyRating;
  final List<String> languages;
  final String? lastSeen;
  final String? bio;

  User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.location,
    required this.isOnline,
    required this.isBuddy,
    required this.mutualTrips,
    required this.safetyRating,
    required this.languages,
    this.lastSeen,
    this.bio,
  });
}

class TripGroup {
  final int id;
  final String title;
  final String location;
  final String dates;
  final List<User> participants;
  final bool hasGroupChat;

  TripGroup({
    required this.id,
    required this.title,
    required this.location,
    required this.dates,
    required this.participants,
    required this.hasGroupChat,
  });
}

class NewChatScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final Function(dynamic userId, {Map<String, dynamic>? groupData})? onStartChat;

  const NewChatScreen({Key? key, this.onBack, this.onStartChat}) : super(key: key);

  @override
  _NewChatScreenState createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final Set<int> _selectedUsers = {};
  final List<User> _mockRecentContacts = [
    User(
      id: 1,
      name: 'Alex Chen',
      avatar: '/api/placeholder/40/40',
      location: 'Vancouver, BC',
      isOnline: true,
      isBuddy: true,
      mutualTrips: 3,
      safetyRating: 4.9,
      languages: ['English', 'Mandarin'],
    ),
    User(
      id: 2,
      name: 'Sarah Kim',
      avatar: '/api/placeholder/40/40',
      location: 'Toronto, ON',
      isOnline: false,
      isBuddy: true,
      mutualTrips: 1,
      safetyRating: 4.8,
      languages: ['English', 'Korean'],
      lastSeen: '2h ago',
    ),
    User(
      id: 3,
      name: 'Emma Wilson',
      avatar: '/api/placeholder/40/40',
      location: 'Calgary, AB',
      isOnline: true,
      isBuddy: true,
      mutualTrips: 2,
      safetyRating: 4.9,
      languages: ['English', 'French'],
    ),
  ];

  final List<User> _mockSuggestedBuddies = [
    User(
      id: 4,
      name: 'Marcus Johnson',
      avatar: '/api/placeholder/40/40',
      location: 'Seattle, WA',
      isOnline: true,
      isBuddy: false,
      mutualTrips: 0,
      safetyRating: 4.7,
      languages: ['English'],
      bio: 'Mountain hiking enthusiast, photographer',
    ),
    User(
      id: 5,
      name: 'Lisa Zhang',
      avatar: '/api/placeholder/40/40',
      location: 'Vancouver, BC',
      isOnline: false,
      isBuddy: false,
      mutualTrips: 0,
      safetyRating: 4.8,
      languages: ['English', 'Mandarin'],
      bio: 'Solo traveler, loves backpacking and camping',
      lastSeen: '1d ago',
    ),
    User(
      id: 6,
      name: 'Jordan Liu',
      avatar: '/api/placeholder/40/40',
      location: 'Portland, OR',
      isOnline: true,
      isBuddy: false,
      mutualTrips: 0,
      safetyRating: 4.9,
      languages: ['English'],
      bio: 'Rock climbing and outdoor adventure guide',
    ),
  ];

  final List<TripGroup> _mockTripGroups = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Initialize trip groups after contacts are created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _mockTripGroups.addAll([
          TripGroup(
            id: 1,
            title: 'Banff Adventure',
            location: 'Banff National Park',
            dates: 'Jul 15-20',
            participants: _mockRecentContacts.sublist(0, 3),
            hasGroupChat: true,
          ),
          TripGroup(
            id: 2,
            title: 'Pacific Coast Trail',
            location: 'Oregon Coast',
            dates: 'Aug 5-12',
            participants: [_mockRecentContacts[0], _mockSuggestedBuddies[0]],
            hasGroupChat: false,
          ),
        ]);
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<User> get _filteredContacts => _mockRecentContacts.where((user) =>
      user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      user.location.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

  List<User> get _filteredSuggested => _mockSuggestedBuddies.where((user) =>
      user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      user.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      (user.bio?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)).toList();

  void _handleUserSelect(int userId) {
    setState(() {
      if (_selectedUsers.contains(userId)) {
        _selectedUsers.remove(userId);
      } else {
        _selectedUsers.add(userId);
      }
    });
  }

  void _handleStartDirectChat(int userId) {
    widget.onStartChat?.call(userId);
    widget.onBack?.call();
  }

  void _handleCreateGroupChat() {
    if (_selectedUsers.length >= 2) {
      widget.onStartChat?.call('group', groupData: {'userIds': _selectedUsers.toList()});
      widget.onBack?.call();
    }
  }

  void _handleStartTripChat(TripGroup tripGroup) {
    widget.onStartChat?.call('group', groupData: {'tripId': tripGroup.id, 'tripData': tripGroup});
    widget.onBack?.call();
  }

  Widget _buildUserCard(User user, {bool showCheckbox = false}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _selectedUsers.contains(user.id) 
              ? const Color(0xFFFF6B35) // fox-orange
              : const Color(0xFFA8A8A8).withOpacity(0.3), // mountain-gray
          width: _selectedUsers.contains(user.id) ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => showCheckbox ? _handleUserSelect(user.id) : _handleStartDirectChat(user.id),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (showCheckbox) ...[
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: _selectedUsers.contains(user.id) 
                          ? const Color(0xFFFF6B35)
                          : const Color(0xFFA8A8A8),
                      width: 2,
                    ),
                    color: _selectedUsers.contains(user.id) ? const Color(0xFFFF6B35) : Colors.transparent,
                  ),
                  child: _selectedUsers.contains(user.id)
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
              ],
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(user.avatar),
                    child: user.avatar.isEmpty
                        ? Text(
                            user.name.split(' ').map((n) => n[0]).join(''),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D5A27), // forest-green
                            ),
                          )
                        : null,
                  ),
                  if (user.isOnline)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(6),
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xFF2D5A27), // forest-green
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            if (user.isBuddy)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFD700), // gold
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Buddy',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF2D5A27), // forest-green
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            else
                              IconButton(
                                icon: const Icon(Icons.person_add, size: 16, color: Color(0xFFFF6B35)),
                                onPressed: () => print('Add buddy: ${user.id}'),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                const Icon(Icons.star, size: 14, color: Color(0xFFFFD700)),
                                const SizedBox(width: 2),
                                Text(
                                  user.safetyRating.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFA8A8A8), // mountain-gray
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 12, color: Color(0xFFA8A8A8)),
                        const SizedBox(width: 4),
                        Text(
                          user.location,
                          style: const TextStyle(fontSize: 12, color: Color(0xFFA8A8A8)),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (!user.isOnline && user.lastSeen != null) ...[
                          const Text(' • ', style: TextStyle(color: Color(0xFFA8A8A8))),
                          Text(user.lastSeen!, style: const TextStyle(fontSize: 12, color: Color(0xFFA8A8A8))),
                        ],
                      ],
                    ),
                    if (user.bio != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        user.bio!,
                        style: const TextStyle(fontSize: 12, color: Color(0xFFA8A8A8)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.language, size: 12, color: Color(0xFF87CEEB)),
                        const SizedBox(width: 4),
                        Text(
                          user.languages.join(', '),
                          style: const TextStyle(fontSize: 12, color: Color(0xFFA8A8A8)),
                        ),
                        if (user.mutualTrips > 0) ...[
                          const Text(' • ', style: TextStyle(color: Color(0xFFA8A8A8))),
                          Text(
                            '${user.mutualTrips} mutual trips',
                            style: const TextStyle(fontSize: 12, color: Color(0xFFA8A8A8)),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (!showCheckbox)
                const Icon(Icons.chevron_right, size: 16, color: Color(0xFFA8A8A8)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripGroupCard(TripGroup trip) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFA8A8A8), width: 0.3),
      ),
      child: InkWell(
        onTap: () => _handleStartTripChat(trip),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2D5A27), Color(0xFFFF6B35)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.location_on, size: 24, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            trip.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xFF2D5A27),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: trip.hasGroupChat 
                                ? Colors.green.shade100 
                                : const Color(0xFFFF6B35).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            trip.hasGroupChat ? 'Active Chat' : 'Create Chat',
                            style: TextStyle(
                              fontSize: 12,
                              color: trip.hasGroupChat ? Colors.green.shade700 : const Color(0xFFFF6B35),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 12, color: Color(0xFFA8A8A8)),
                        const SizedBox(width: 4),
                        Text(trip.location, style: const TextStyle(fontSize: 12, color: Color(0xFFA8A8A8))),
                        const SizedBox(width: 8),
                        const Icon(Icons.calendar_today, size: 12, color: Color(0xFFA8A8A8)),
                        const SizedBox(width: 4),
                        Text(trip.dates, style: const TextStyle(fontSize: 12, color: Color(0xFFA8A8A8))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Stack(
                          children: [
                            for (int i = 0; i < trip.participants.length && i < 3; i++)
                              Positioned(
                                left: i * 16.0,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundImage: NetworkImage(trip.participants[i].avatar),
                                  child: trip.participants[i].avatar.isEmpty
                                      ? Text(
                                          trip.participants[i].name.split(' ').map((n) => n[0]).join(''),
                                          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600),
                                        )
                                      : null,
                                ),
                              ),
                            if (trip.participants.length > 3)
                              Positioned(
                                left: 48.0,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFA8A8A8),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '+${trip.participants.length - 3}',
                                      style: const TextStyle(fontSize: 8, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${trip.participants.length} participants',
                          style: const TextStyle(fontSize: 12, color: Color(0xFFA8A8A8)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 16, color: Color(0xFFA8A8A8)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5).withOpacity(0.1),
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF2D5A27)),
                      onPressed: widget.onBack,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'New Chat',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D5A27),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Start a conversation with your adventure buddies',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search buddies, locations, or interests...',
                    prefixIcon: const Icon(Icons.search, size: 16, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ],
            ),
          ),

          // Create Group Chat Button
          if (_selectedUsers.length >= 2)
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFFF6B35).withOpacity(0.1),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleCreateGroupChat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.group, size: 16, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Create Group Chat (${_selectedUsers.length} selected)',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF2D5A27),
              unselectedLabelColor: Colors.grey.shade600,
              indicatorColor: const Color(0xFF2D5A27),
              tabs: const [
                Tab(text: 'My Buddies'),
                Tab(text: 'Discover'),
                Tab(text: 'Trip Groups'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // My Buddies Tab
                _buildContactsTab(),
                
                // Discover Tab
                _buildDiscoverTab(),
                
                // Trip Groups Tab
                _buildTripGroupsTab(),
              ],
            ),
          ),

          // Safety Footer
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Text(
                  'Your safety is our priority. All conversations are encrypted.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Secure • Verified • Adventure-Ready',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Quick Actions
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300, width: 0.3),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.chat_bubble, color: Color(0xFF2D5A27)),
                      const SizedBox(width: 8),
                      const Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF2D5A27),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => _tabController.animateTo(2),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.group, color: Color(0xFFFF6B35)),
                        SizedBox(width: 12),
                        Expanded(child: Text('Create Trip Group Chat')),
                        Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => _tabController.animateTo(1),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add, color: Color(0xFFFF6B35)),
                        SizedBox(width: 12),
                        Expanded(child: Text('Find New Travel Buddies')),
                        Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Recent Contacts
          if (_filteredContacts.isNotEmpty) ...[
            Row(
              children: [
                const Text(
                  'Recent Conversations',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF2D5A27)),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (_selectedUsers.isNotEmpty) {
                        _selectedUsers.clear();
                      } else {
                        _selectedUsers.addAll(_filteredContacts.map((u) => u.id));
                      }
                    });
                  },
                  child: Text(
                    _selectedUsers.isNotEmpty ? 'Deselect All' : 'Select All',
                    style: const TextStyle(color: Color(0xFFFF6B35)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Column(
              children: _filteredContacts.map((user) => _buildUserCard(user, showCheckbox: true)).toList(),
            ),
          ],

          if (_filteredContacts.isEmpty && _searchQuery.isNotEmpty)
            Column(
              children: [
                const Icon(Icons.chat_bubble, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                const Text(
                  'No buddies found',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF2D5A27)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Try searching with different keywords or explore new buddies.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDiscoverTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Safety Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF87CEEB).withOpacity(0.1),
              border: Border.all(color: const Color(0xFF87CEEB).withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.security, color: Color(0xFF87CEEB)),
                    const SizedBox(width: 8),
                    const Text(
                      'Safety First',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF87CEEB)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'All suggested buddies are verified members with safety ratings. '
                  'Always meet in public places and share your plans.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (_filteredSuggested.isNotEmpty) ...[
            Row(
              children: [
                const Text(
                  'Suggested Travel Buddies',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF2D5A27)),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withOpacity(0.2),
                    border: Border.all(color: const Color(0xFFFFD700)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'New',
                    style: TextStyle(fontSize: 12, color: Color(0xFFFFD700), fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Column(
              children: _filteredSuggested.map((user) => _buildUserCard(user)).toList(),
            ),
          ],

          if (_filteredSuggested.isEmpty)
            Column(
              children: [
                const Icon(Icons.group, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                const Text(
                  'No suggestions found',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF2D5A27)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Try searching for specific interests or locations.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTripGroupsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Trip Groups Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35).withOpacity(0.1),
              border: Border.all(color: const Color(0xFFFF6B35).withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFFFF6B35)),
                    const SizedBox(width: 8),
                    const Text(
                      'Trip Group Chats',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFFF6B35)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Create group chats for your upcoming trips to coordinate plans and stay connected.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (_mockTripGroups.isNotEmpty) ...[
            Column(
              children: _mockTripGroups.map((trip) => _buildTripGroupCard(trip)).toList(),
            ),
          ],

          if (_mockTripGroups.isEmpty)
            Column(
              children: [
                const Icon(Icons.calendar_today, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                const Text(
                  'No trips yet',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF2D5A27)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Create a trip to start organizing group chats with your travel buddies.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => print('Navigate to create trip'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B35)),
                  child: const Text('Create Your First Trip'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}