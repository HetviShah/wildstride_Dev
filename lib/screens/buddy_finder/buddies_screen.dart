import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:logger/logger.dart';
import 'package:wildstride_app/models/buddy_finder/buddy_model.dart';
import 'package:wildstride_app/services/buddy_finder/buddy_service.dart';
import 'package:wildstride_app/widgets/buddy_finder/buddy_card.dart';
import 'package:wildstride_app/widgets/buddy_finder/filter_panel.dart';

// Add logger instance
final Logger _logger = Logger();

class BuddiesScreen extends StatefulWidget {
  const BuddiesScreen({super.key});

  @override
  _BuddiesScreenState createState() => _BuddiesScreenState();
}

class _BuddiesScreenState extends State<BuddiesScreen> with TickerProviderStateMixin {
  final BuddyService _buddyService = BuddyService();
  
  late TabController _tabController;
  late TabController _pendingTabController;
  String _activeTab = 'my-buddies';
  String _activePendingTab = 'incoming';
  String _searchQuery = '';
  Buddy? _selectedBuddy;
  bool _showFilters = false;
  
  // Filter state
  RangeValues _trustScoreRange = const RangeValues(0, 100);
  bool _verifiedOnly = false;
  bool _onlineOnly = false;
  List<String> _selectedLanguages = [];
  List<String> _selectedSafetyStatus = [];
  
  List<Buddy> _buddies = [];
  bool _isLoading = true;
  Map<String, int> _buddyCounts = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pendingTabController = TabController(length: 2, vsync: this);
    _loadBuddies();
    _loadBuddyCounts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pendingTabController.dispose();
    super.dispose();
  }

  Future<void> _loadBuddies() async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);
    try {
      final buddies = await _buddyService.fetchBuddies(searchQuery: _searchQuery);
      if (mounted) {
        setState(() => _buddies = buddies);
      }
    } catch (e) {
      _logger.e('Error loading buddies: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading buddies')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadBuddyCounts() async {
    if (!mounted) return;
    
    try {
      final counts = await _buddyService.getBuddyCounts();
      if (mounted) {
        setState(() => _buddyCounts = counts);
      }
    } catch (e) {
      _logger.e('Error loading buddy counts: $e');
    }
  }

  Future<void> _sendConnectionRequest(int buddyId) async {
    if (!mounted) return;
    
    try {
      final success = await _buddyService.sendConnectionRequest(buddyId);
      if (success && mounted) {
        await _loadBuddies();
        await _loadBuddyCounts();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connection request sent!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send connection request')),
        );
      }
    }
  }

  Future<void> _acceptConnectionRequest(int buddyId) async {
    if (!mounted) return;
    
    try {
      final success = await _buddyService.acceptConnectionRequest(buddyId);
      if (success && mounted) {
        await _loadBuddies();
        await _loadBuddyCounts();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connection request accepted!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to accept connection request')),
        );
      }
    }
  }

  Future<void> _declineConnectionRequest(int buddyId) async {
    if (!mounted) return;
    
    try {
      final success = await _buddyService.declineConnectionRequest(buddyId);
      if (success && mounted) {
        await _loadBuddies();
        await _loadBuddyCounts();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connection request declined')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to decline connection request')),
        );
      }
    }
  }

  Future<void> _sendMessage(int buddyId) async {
    if (!mounted) return;
    
    try {
      final success = await _buddyService.sendMessage(buddyId, 'Hello!');
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message sent!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send message')),
        );
      }
    }
  }

  void _clearFilters() {
    setState(() {
      _trustScoreRange = const RangeValues(0, 100);
      _verifiedOnly = false;
      _onlineOnly = false;
      _selectedLanguages = [];
      _selectedSafetyStatus = [];
    });
  }

  bool get _hasActiveFilters {
    return _trustScoreRange.start > 0 ||
        _trustScoreRange.end < 100 ||
        _verifiedOnly ||
        _onlineOnly ||
        _selectedLanguages.isNotEmpty ||
        _selectedSafetyStatus.isNotEmpty;
  }

  int get _activeFilterCount {
    return (_trustScoreRange.start > 0 || _trustScoreRange.end < 100 ? 1 : 0) +
        (_verifiedOnly ? 1 : 0) +
        (_onlineOnly ? 1 : 0) +
        _selectedLanguages.length +
        _selectedSafetyStatus.length;
  }

  List<Buddy> get _filteredBuddies {
    return _buddies.where((buddy) {
      bool matchesTab = true;
      if (_activeTab == 'my-buddies') matchesTab = buddy.connectionStatus == 'connected';
      if (_activeTab == 'pending') {
        if (_activePendingTab == 'incoming') {
          matchesTab = buddy.connectionStatus == 'pending-incoming';
        } else {
          matchesTab = buddy.connectionStatus == 'pending-outgoing';
        }
      }
      if (_activeTab == 'suggested') matchesTab = buddy.connectionStatus == 'suggested';

      final matchesTrustScore = buddy.trustScore >= _trustScoreRange.start && 
                               buddy.trustScore <= _trustScoreRange.end;
      final matchesVerified = !_verifiedOnly || buddy.isVerified;
      final matchesOnline = !_onlineOnly || buddy.isOnline;
      final matchesLanguages = _selectedLanguages.isEmpty || 
                             _selectedLanguages.any((language) => buddy.languages.contains(language));
      final matchesSafetyStatus = _selectedSafetyStatus.isEmpty || 
                                _selectedSafetyStatus.contains(buddy.safetyStatus);

      return matchesTab && matchesTrustScore && matchesVerified && 
             matchesOnline && matchesLanguages && matchesSafetyStatus;
    }).toList();
  }

  int get _myBuddiesCount => _buddyCounts['connected'] ?? 0;
  int get _incomingRequestsCount => _buddyCounts['pendingIncoming'] ?? 0;
  int get _outgoingRequestsCount => _buddyCounts['pendingOutgoing'] ?? 0;
  int get _totalPendingCount => _incomingRequestsCount + _outgoingRequestsCount;
  int get _suggestedCount => _buddyCounts['suggested'] ?? 0;

  List<FilterSection> get _filterSections {
    final allLanguages = _buddies.expand((b) => b.languages).toSet().toList();
    
    return [
      FilterConfigs.createTrustScoreFilter(
        trustScoreRange: _trustScoreRange,
        onTrustScoreRangeChanged: (range) => setState(() => _trustScoreRange = range),
      ),
      FilterConfigs.createBooleanFilter(
        isEnabled: _verifiedOnly,
        onToggle: (_, selected) => setState(() => _verifiedOnly = selected),
        title: 'Verification',
        optionText: 'Verified profiles only',
      ),
      FilterConfigs.createBooleanFilter(
        isEnabled: _onlineOnly,
        onToggle: (_, selected) => setState(() => _onlineOnly = selected),
        title: 'Online Status',
        optionText: 'Online now only',
      ),
      FilterConfigs.createLanguagesFilter(
        selectedLanguages: _selectedLanguages,
        onLanguageSelected: (language, selected) {
          setState(() {
            if (selected) {
              _selectedLanguages.add(language);
            } else {
              _selectedLanguages.remove(language);
            }
          });
        },
        availableLanguages: allLanguages.take(10).toList(),
      ),
      FilterConfigs.createSafetyStatusFilter(
        selectedStatuses: _selectedSafetyStatus,
        onStatusSelected: (status, selected) {
          setState(() {
            if (selected) {
              _selectedSafetyStatus.add(status);
            } else {
              _selectedSafetyStatus.remove(status);
            }
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedBuddy != null) {
      return _buildBuddyProfile();
    }

    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Title
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Travel Buddies',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                ),

                // Search and Filter
                Row(
                  children: [
                    // Search
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by name, location, or interests...',
                          prefixIcon: const Icon(LucideIcons.search, size: 16),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        onChanged: (value) {
                          setState(() => _searchQuery = value);
                          _loadBuddies();
                        },
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Filter Button
                    OutlinedButton(
                      onPressed: () => setState(() => _showFilters = !_showFilters),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _hasActiveFilters ? Colors.orange : Colors.grey[700],
                        side: BorderSide(
                          color: _hasActiveFilters ? Colors.orange : Colors.grey[300]!,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.filter, size: 16),
                          const SizedBox(width: 4),
                          const Text('Filter'),
                          if (_hasActiveFilters) ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$_activeFilterCount',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),

                // Filter Panel
                if (_showFilters) 
                  FilterPanel(
                    sections: _filterSections,
                    onClearAll: _clearFilters,
                    onClose: () => setState(() => _showFilters = false),
                    hasActiveFilters: _hasActiveFilters,
                    activeFilterCount: _activeFilterCount,
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  onTap: (index) {
                    setState(() {
                      _activeTab = ['my-buddies', 'pending', 'suggested'][index];
                    });
                  },
                  tabs: [
                    Tab(text: 'My Buddies ($_myBuddiesCount)'),
                    Tab(text: 'Pending ($_totalPendingCount)'),
                    Tab(text: 'Suggested ($_suggestedCount)'),
                  ],
                  labelColor: Colors.green[900],
                  unselectedLabelColor: Colors.grey[600],
                  indicatorColor: Colors.green[900],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildMyBuddiesTab(),
                      _buildPendingTab(),
                      _buildSuggestedTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyBuddiesTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_filteredBuddies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.users, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No Buddies Yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Start connecting with fellow travelers to build your adventure network!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredBuddies.length,
      itemBuilder: (context, index) {
        final buddy = _filteredBuddies[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: BuddyCard(
            buddy: buddy,
            onTap: () => setState(() => _selectedBuddy = buddy),
            onConnect: () => _sendConnectionRequest(buddy.id),
            onMessage: () => _sendMessage(buddy.id),
            compact: false,
          ),
        );
      },
    );
  }

  Widget _buildPendingTab() {
    return Column(
      children: [
        TabBar(
          controller: _pendingTabController,
          onTap: (index) {
            setState(() {
              _activePendingTab = ['incoming', 'outgoing'][index];
            });
          },
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.arrowDown, size: 16),
                  const SizedBox(width: 4),
                  Text('Received ($_incomingRequestsCount)'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.arrowUp, size: 16),
                  const SizedBox(width: 4),
                  Text('Sent ($_outgoingRequestsCount)'),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _pendingTabController,
            children: [
              _buildPendingList('incoming'),
              _buildPendingList('outgoing'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPendingList(String type) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final buddies = _filteredBuddies.where((b) => 
      type == 'incoming' ? b.connectionStatus == 'pending-incoming' : b.connectionStatus == 'pending-outgoing'
    ).toList();

    if (buddies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.users, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No ${type == 'incoming' ? 'Incoming' : 'Outgoing'} Requests', 
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              type == 'incoming' 
                  ? 'No pending buddy requests received yet.' 
                  : 'No pending buddy requests sent yet.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: buddies.length,
      itemBuilder: (context, index) {
        final buddy = buddies[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: BuddyCard(
            buddy: buddy,
            onTap: () => setState(() => _selectedBuddy = buddy),
            onAccept: type == 'incoming' ? () => _acceptConnectionRequest(buddy.id) : null,
            onDecline: type == 'incoming' ? () => _declineConnectionRequest(buddy.id) : null,
            compact: true,
          ),
        );
      },
    );
  }

  Widget _buildSuggestedTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_filteredBuddies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.users, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No Suggestions Available', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'We\'ll suggest travel buddies based on your interests and travel history.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredBuddies.length,
      itemBuilder: (context, index) {
        final buddy = _filteredBuddies[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: BuddyCard(
            buddy: buddy,
            onTap: () => setState(() => _selectedBuddy = buddy),
            onConnect: () => _sendConnectionRequest(buddy.id),
            compact: false,
          ),
        );
      },
    );
  }

  Widget _buildBuddyProfile() {
    final buddy = _selectedBuddy!;
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => setState(() => _selectedBuddy = null),
        ),
        title: const Text('Buddy Profile'),
        backgroundColor: Colors.green[900],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // Profile Header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[900]!, Colors.orange[700]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(buddy.avatar),
                      child: buddy.avatar.isEmpty 
                          ? const Icon(LucideIcons.user, size: 40, color: Colors.white)
                          : null,
                    ),
                    if (buddy.isOnline)
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      buddy.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (buddy.isVerified) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(LucideIcons.shield, size: 12, color: Colors.white),
                            SizedBox(width: 4),
                            Text('Verified', style: TextStyle(fontSize: 12, color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.mapPin, size: 16, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(buddy.location, style: const TextStyle(color: Colors.white70)),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 4,
                  children: [
                    Text(
                      '${buddy.completedTrips} trips completed',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const Text('•', style: TextStyle(color: Colors.white70)),
                    Text(
                      '${buddy.mutualConnections} mutual connections',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const Text('•', style: TextStyle(color: Colors.white70)),
                    Text(
                      '${buddy.trustScore}% trust score',
                      style: TextStyle(
                        color: _getTrustScoreColor(buddy.trustScore),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              if (buddy.connectionStatus == 'connected') ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _sendMessage(buddy.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[900],
                      foregroundColor: Colors.white,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.messageCircle, size: 16),
                        SizedBox(width: 4),
                        Text('Message'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Implement plan trip functionality
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.calendar, size: 16),
                        SizedBox(width: 4),
                        Text('Plan Trip'),
                      ],
                    ),
                  ),
                ),
              ] else if (buddy.connectionStatus == 'suggested') 
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _sendConnectionRequest(buddy.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.userPlus, size: 16),
                        SizedBox(width: 4),
                        Text('Send Connection Request'),
                      ],
                    ),
                  ),
                ),
            ]),
          ),

          // Bio Section
          _buildProfileSection(
            icon: LucideIcons.users,
            title: 'About',
            child: Text(
              buddy.bio,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),

          // Interests Section
          if (buddy.interests.isNotEmpty)
            _buildProfileSection(
              icon: LucideIcons.heart,
              title: 'Interests',
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: buddy.interests.map((interest) => Chip(
                  label: Text(interest),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                )).toList(),
              ),
            ),

          // Languages Section
          if (buddy.languages.isNotEmpty)
            _buildProfileSection(
              icon: LucideIcons.languages,
              title: 'Languages',
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: buddy.languages.map((language) => Chip(
                  label: Text(language),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: Colors.blue[50],
                )).toList(),
              ),
            ),

          // Next Trip Section
          if (buddy.nextTrip != null)
            _buildProfileSection(
              icon: LucideIcons.mapPin,
              title: 'Next Adventure',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    buddy.nextTrip!.destination,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    buddy.nextTrip!.dates,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: Colors.green[900]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Color _getTrustScoreColor(int score) {
    if (score >= 95) return Colors.green;
    if (score >= 85) return Colors.blue;
    if (score >= 70) return Colors.orange;
    return Colors.red;
  }
}