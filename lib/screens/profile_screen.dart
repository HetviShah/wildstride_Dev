import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Badge {
  final int id;
  final String name;
  final String description;
  final IconData icon;
  final String rarity;
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
    Badge(id: 1, name: 'First Steps', description: 'Completed your first adventure', icon: LucideIcons.mountain, rarity: 'common', earnedAt: '2024-01-15'),
    Badge(id: 2, name: 'Photographer', description: 'Shared 50 adventure photos', icon: LucideIcons.camera, rarity: 'rare', earnedAt: '2024-03-22'),
    Badge(id: 3, name: 'Explorer', description: 'Visited 10 different locations', icon: LucideIcons.compass, rarity: 'epic', earnedAt: '2024-05-10'),
    Badge(id: 4, name: 'Trip Leader', description: 'Organized 5 successful trips', icon: LucideIcons.crown, rarity: 'legendary', progress: 3, maxProgress: 5),
    Badge(id: 5, name: 'Safety First', description: 'Complete 100 safety check-ins', icon: LucideIcons.shield, rarity: 'rare', earnedAt: '2024-06-30'),
    Badge(id: 6, name: 'Social Butterfly', description: 'Connect with 25 adventure buddies', icon: LucideIcons.users, rarity: 'rare', progress: 18, maxProgress: 25),
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

  Color _getRarityTextColor(String rarity) => rarity == 'legendary' ? Colors.black : Colors.white;

  @override
  Widget build(BuildContext context) {
    final currentLevel = 7;
    final currentXP = 2840;
    final nextLevelXP = 3000;
    final progressToNextLevel = ((currentXP % 1000) / 1000) * 100;
    final streak = 15;

    final earnedBadges = _mockBadges.where((b) => b.earnedAt != null).toList();
    final inProgressBadges = _mockBadges.where((b) => b.progress != null && b.earnedAt == null).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: NestedScrollView( // ✅ fixes overflow with TabBar
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  if (widget.onBack != null)
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
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
                                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  // Profile Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildProfileHeader(currentLevel, currentXP, nextLevelXP, progressToNextLevel, streak),
                  ),

                  // Stats
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildStatsCards(earnedBadges.length),
                  ),

                  const SizedBox(height: 8),

                  // Tabs
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                ],
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(earnedBadges),
              _buildBadgesTab(earnedBadges, inProgressBadges),
              _buildBuddiesTab(),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------
  // Sub-widgets
  // ------------------------------

  Widget _buildProfileHeader(int level, int xp, int nextXP, double progress, int streak) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: const Color(0xFFE8D9B5),
                  child: const Text('JD', style: TextStyle(color: Color(0xFF003B2E), fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Jane Doe', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 4),
                      const Text('Vancouver, BC', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        children: [
                          Chip(label: Text('Level $level'), backgroundColor: const Color(0xFFE66A00), labelStyle: const TextStyle(color: Colors.white)),
                          Chip(label: Text('$streak Day Streak'), backgroundColor: const Color(0xFFD72638), labelStyle: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress / 100,
              color: const Color(0xFF003B2E),
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 4),
            Text('$xp / $nextXP XP', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards(int badgesCount) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.1,
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
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 20)),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(List<Badge> earned) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildBioSection(),
          const SizedBox(height: 16),
          _buildAchievementsSection(earned),
        ],
      ),
    );
  }

  Widget _buildBioSection() => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('About Me', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'Adventure photographer and hiking enthusiast. Love exploring mountain trails and capturing nature’s beauty.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    ),
  );

  Widget _buildAchievementsSection(List<Badge> earned) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Achievements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Column(
            children: earned.take(3).map((b) => _buildAchievementItem(b)).toList(),
          ),
        ],
      ),
    ),
  );

  Widget _buildAchievementItem(Badge badge) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: _getRarityColor(badge.rarity),
          child: Icon(badge.icon, color: _getRarityTextColor(badge.rarity), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(badge.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(badge.description, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildBadgesTab(List<Badge> earned, List<Badge> progress) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildBadgeGrid(earned),
          const SizedBox(height: 16),
          Column(children: progress.map((b) => _buildProgressBadgeItem(b)).toList()),
        ],
      ),
    );
  }

  Widget _buildBadgeGrid(List<Badge> badges) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: badges.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
      itemBuilder: (context, i) => _buildBadgeCard(badges[i]),
    );
  }

  Widget _buildBadgeCard(Badge badge) => Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: _getRarityColor(badge.rarity),
            radius: 28,
            child: Icon(badge.icon, color: _getRarityTextColor(badge.rarity), size: 24),
          ),
          const SizedBox(height: 8),
          Text(badge.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(badge.rarity, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    ),
  );

  Widget _buildProgressBadgeItem(Badge badge) {
    final percent = (badge.progress ?? 0) / (badge.maxProgress ?? 1);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(badge.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(badge.description, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percent,
              color: _getRarityColor(badge.rarity),
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 4),
            Text('${badge.progress}/${badge.maxProgress}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildBuddiesTab() => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: _mockTrustedBuddies.map((b) => _buildBuddyItem(b)).toList(),
    ),
  );

  Widget _buildBuddyItem(TrustedBuddy b) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFE8D9B5),
            child: Text(b.name.split(' ').map((n) => n[0]).join(''),
                style: const TextStyle(color: Color(0xFF003B2E), fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(b.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('${b.trips} adventures together', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                Text(b.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 4),
            Chip(label: const Text('Trusted', style: TextStyle(fontSize: 12)), backgroundColor: Colors.transparent),
          ]),
        ],
      ),
    ),
  );
}