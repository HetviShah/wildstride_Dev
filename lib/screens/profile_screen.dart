import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Badge {
  final int id;
  final String name;
  final String description;
  final IconData icon;
  final String rarity; // 'common' | 'rare' | 'epic' | 'legendary'
  final String? earnedAt;
  final int? progress;
  final int? maxProgress;

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.rarity,
    this.earnedAt,
    this.progress,
    this.maxProgress,
  });
}

class TrustedBuddy {
  final int id;
  final String name;
  final String avatar;
  final int trips;
  final double rating;

  TrustedBuddy({
    required this.id,
    required this.name,
    required this.avatar,
    required this.trips,
    required this.rating,
  });
}

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const ProfileScreen({super.key, this.onBack});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Badge> _mockBadges = [
    Badge(
      id: 1,
      name: 'First Steps',
      description: 'Completed your first adventure',
      icon: LucideIcons.mountain,
      rarity: 'common',
      earnedAt: '2024-01-15',
    ),
    Badge(
      id: 2,
      name: 'Photographer',
      description: 'Shared 50 adventure photos',
      icon: LucideIcons.camera,
      rarity: 'rare',
      earnedAt: '2024-03-22',
    ),
    Badge(
      id: 3,
      name: 'Explorer',
      description: 'Visited 10 different locations',
      icon: LucideIcons.compass,
      rarity: 'epic',
      earnedAt: '2024-05-10',
    ),
    Badge(
      id: 4,
      name: 'Trip Leader',
      description: 'Organized 5 successful trips',
      icon: LucideIcons.crown,
      rarity: 'legendary',
      progress: 3,
      maxProgress: 5,
    ),
    Badge(
      id: 5,
      name: 'Safety First',
      description: 'Complete 100 safety check-ins',
      icon: LucideIcons.shield,
      rarity: 'rare',
      earnedAt: '2024-06-30',
    ),
    Badge(
      id: 6,
      name: 'Social Butterfly',
      description: 'Connect with 25 adventure buddies',
      icon: LucideIcons.users,
      rarity: 'rare',
      progress: 18,
      maxProgress: 25,
    ),
  ];

  final List<TrustedBuddy> _mockTrustedBuddies = [
    TrustedBuddy(id: 1, name: 'Alex Chen', avatar: '', trips: 8, rating: 4.9),
    TrustedBuddy(id: 2, name: 'Sarah Kim', avatar: '', trips: 6, rating: 4.8),
    TrustedBuddy(id: 3, name: 'Mike Johnson', avatar: '', trips: 5, rating: 4.7),
    TrustedBuddy(id: 4, name: 'Emma Wilson', avatar: '', trips: 4, rating: 4.9),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getRarityColor(String rarity) {
    switch (rarity) {
      case 'legendary':
        return Colors.orange;
      case 'epic':
        return Colors.purple;
      case 'rare':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getRarityTextColor(String rarity) {
    return rarity == 'legendary' ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final currentLevel = 7;
    final currentXP = 2840;
    final nextLevelXP = 3000;
    final progressToNextLevel = ((currentXP % 1000) / 1000) * 100;
    final streak = 15;

    final earnedBadges = _mockBadges.where((badge) => badge.earnedAt != null).toList();
    final inProgressBadges = _mockBadges.where((badge) => badge.progress != null && badge.earnedAt == null).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE8D9B5).withOpacity(0.1),
      body: Column(
        children: [
          // Header
          if (widget.onBack != null)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.brown.shade200),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(LucideIcons.arrowLeft),
                        onPressed: widget.onBack,
                        color: const Color(0xFF003B2E),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003B2E),
                            ),
                          ),
                          Text(
                            'Your adventure journey and achievements',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Header Card
                  _buildProfileHeader(currentLevel, currentXP, nextLevelXP, progressToNextLevel, streak),

                  const SizedBox(height: 24),

                  // Stats Cards
                  _buildStatsCards(earnedBadges.length),

                  const SizedBox(height: 24),

                  // Tabs Section
                  _buildTabsSection(earnedBadges, inProgressBadges, currentLevel, currentXP, nextLevelXP, progressToNextLevel, streak),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(int currentLevel, int currentXP, int nextLevelXP, double progressToNextLevel, int streak) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF003B2E).withOpacity(0.1), const Color(0xFFE66A00).withOpacity(0.1)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: const Color(0xFFE8D9B5),
                        child: Text(
                          'JD',
                          style: TextStyle(
                            fontSize: 20,
                            color: const Color(0xFF003B2E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(LucideIcons.crown, size: 12, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Jane Doe',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: Icon(LucideIcons.edit3, size: 16),
                              label: Text('Edit'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(LucideIcons.mapPin, size: 16, color: const Color(0xFF6B6B6B)),
                                const SizedBox(width: 8),
                                Text('Vancouver, BC', style: TextStyle(color: const Color(0xFF6B6B6B))),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(LucideIcons.calendar, size: 16, color: const Color(0xFF6B6B6B)),
                                const SizedBox(width: 8),
                                Text('Member since Jan 2024', style: TextStyle(color: const Color(0xFF6B6B6B))),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: [
                            Chip(
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(LucideIcons.shield, size: 12),
                                  const SizedBox(width: 4),
                                  Text('Verified'),
                                ],
                              ),
                              backgroundColor: const Color(0xFF4A90E2),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            Chip(
                              label: Text('Level $currentLevel'),
                              backgroundColor: const Color(0xFFE66A00),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            Chip(
                              label: Text('$streak Day Streak'),
                              backgroundColor: const Color(0xFFD72638),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Level Progress
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Explorer Level $currentLevel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        Text('$currentXP / $nextLevelXP XP', style: TextStyle(fontSize: 14, color: const Color(0xFF6B6B6B))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progressToNextLevel / 100,
                      backgroundColor: Colors.grey.shade300,
                      color: const Color(0xFF003B2E),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${nextLevelXP - currentXP} XP until next level',
                      style: TextStyle(fontSize: 12, color: const Color(0xFF6B6B6B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards(int badgesCount) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildStatCard(LucideIcons.mountain, '12', 'Adventures', const Color(0xFF003B2E)),
        _buildStatCard(LucideIcons.users, '28', 'Buddies', const Color(0xFFE66A00)),
        _buildStatCard(LucideIcons.award, '$badgesCount', 'Badges', const Color(0xFFFFD700)),
        _buildStatCard(LucideIcons.star, '4.9', 'Rating', const Color(0xFF4A90E2)),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: TextStyle(fontSize: 14, color: const Color(0xFF6B6B6B))),
          ],
        ),
      ),
    );
  }

  Widget _buildTabsSection(List<Badge> earnedBadges, List<Badge> inProgressBadges, int currentLevel, int currentXP, int nextLevelXP, double progressToNextLevel, int streak) {
    return Column(
      children: [
        Card(
          child: TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF003B2E),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF003B2E),
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Badges'),
              Tab(text: 'Trusted Buddies'),
            ],
          ),
        ),
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(earnedBadges),
              _buildBadgesTab(earnedBadges, inProgressBadges),
              _buildBuddiesTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab(List<Badge> earnedBadges) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Bio Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About Me', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    'Adventure photographer and hiking enthusiast. Love exploring mountain trails and capturing the beauty of nature. Always looking for new places to discover and amazing people to share the journey with! 📸🏔️',
                    style: TextStyle(color: const Color(0xFF6B6B6B)),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildInterestChip('Photography'),
                      _buildInterestChip('Hiking'),
                      _buildInterestChip('Wildlife'),
                      _buildInterestChip('Camping'),
                      _buildInterestChip('Rock Climbing'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Recent Achievements
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Achievements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Column(
                    children: earnedBadges.take(3).map((badge) => _buildAchievementItem(badge)).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.grey.shade200,
      labelStyle: TextStyle(color: Colors.grey.shade700),
    );
  }

  Widget _buildAchievementItem(Badge badge) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_getRarityColor(badge.rarity), _getRarityColor(badge.rarity).withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(badge.icon, size: 20, color: _getRarityTextColor(badge.rarity)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(badge.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(badge.description, style: TextStyle(fontSize: 12, color: const Color(0xFF6B6B6B))),
              ],
            ),
          ),
          Chip(
            label: Text(_formatDate(badge.earnedAt!)),
            backgroundColor: Colors.transparent,
            side: BorderSide(color: Colors.grey.shade300),
            labelStyle: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesTab(List<Badge> earnedBadges, List<Badge> inProgressBadges) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Earned Badges
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Earned Badges (${earnedBadges.length})', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: earnedBadges.length,
                    itemBuilder: (context, index) => _buildBadgeCard(earnedBadges[index]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // In Progress Badges
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('In Progress (${inProgressBadges.length})', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Column(
                    children: inProgressBadges.map((badge) => _buildProgressBadgeItem(badge)).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(Badge badge) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8D9B5).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_getRarityColor(badge.rarity), _getRarityColor(badge.rarity).withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(badge.icon, size: 32, color: _getRarityTextColor(badge.rarity)),
          ),
          const SizedBox(height: 8),
          Text(badge.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            badge.description,
            style: TextStyle(fontSize: 12, color: const Color(0xFF6B6B6B)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Chip(
            label: Text(badge.rarity),
            backgroundColor: Colors.transparent,
            side: BorderSide(color: Colors.grey.shade300),
            labelStyle: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBadgeItem(Badge badge) {
    final progressPercentage = badge.progress != null && badge.maxProgress != null
        ? (badge.progress! / badge.maxProgress!) * 100
        : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8D9B5).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_getRarityColor(badge.rarity).withOpacity(0.6), _getRarityColor(badge.rarity).withOpacity(0.4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(badge.icon, size: 24, color: _getRarityTextColor(badge.rarity)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(badge.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(badge.description, style: TextStyle(fontSize: 12, color: const Color(0xFF6B6B6B))),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progressPercentage / 100,
                        backgroundColor: Colors.grey.shade300,
                        color: _getRarityColor(badge.rarity),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${badge.progress}/${badge.maxProgress}',
                      style: TextStyle(fontSize: 12, color: const Color(0xFF6B6B6B)),
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

  Widget _buildBuddiesTab() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trusted Buddies (${_mockTrustedBuddies.length})', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Column(
              children: _mockTrustedBuddies.map((buddy) => _buildBuddyItem(buddy)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuddyItem(TrustedBuddy buddy) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFE8D9B5),
            child: Text(
              buddy.name.split(' ').map((n) => n[0]).join(''),
              style: TextStyle(color: const Color(0xFF003B2E), fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(buddy.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text('${buddy.trips} adventures together', style: TextStyle(fontSize: 12, color: const Color(0xFF6B6B6B))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.star, size: 16, color: Colors.yellow.shade700),
                  const SizedBox(width: 4),
                  Text(buddy.rating.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 4),
              Chip(
                label: Text('Trusted', style: TextStyle(fontSize: 12)),
                backgroundColor: Colors.transparent,
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.tryParse(dateString);
    if (date != null) {
      return '${date.month}/${date.day}/${date.year}';
    }
    return dateString;
  }
}