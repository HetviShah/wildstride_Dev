import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BadgesScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const BadgesScreen({super.key, this.onBack});


  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> {
  String _selectedCategory = 'all';
  BadgeData? _selectedBadge;

  final UserStats _mockUserStats = UserStats(
    totalBadges: 8,
    rank: 'Mountain Explorer',
    streakDays: 15,
    completedTrips: 23,
    countriesVisited: 8,
    safetyScore: 98,
  );

  final List<BadgeData> _mockBadges = [
    BadgeData(
      id: 'first-trip',
      name: 'First Adventure',
      description: 'Complete your very first trip on Wildstride',
      category: 'achievement',
      rarity: 'common',
      icon: Icons.location_on,
      isEarned: true,
      earnedDate: 'Mar 15, 2024',
      requirements: ['Complete 1 trip'],
      rewards: ['Explorer title'],
      nextLevel: NextLevel(
        name: 'Adventure Seeker',
        requirement: 'Complete 5 trips',
      ),
    ),
    BadgeData(
      id: 'mountain-explorer',
      name: 'Mountain Explorer',
      description: 'Complete 5 mountain hiking trips',
      category: 'exploration',
      rarity: 'uncommon',
      icon: Icons.landscape,
      isEarned: true,
      earnedDate: 'May 20, 2024',
      requirements: ['Complete 5 mountain trips', 'Reach elevation above 2000m'],
      rewards: ['Mountain gear discount', 'Explorer rank'],
      nextLevel: NextLevel(
        name: 'Peak Conqueror',
        requirement: 'Complete 15 mountain trips',
      ),
    ),
    BadgeData(
      id: 'safety-champion',
      name: 'Safety Champion',
      description: 'Maintain perfect safety check-ins for 30 days',
      category: 'safety',
      rarity: 'rare',
      icon: Icons.security,
      isEarned: true,
      earnedDate: 'Jun 10, 2024',
      requirements: ['30 consecutive safety check-ins', 'Zero missed check-ins'],
      rewards: ['Priority support', 'Safety mentor status'],
      nextLevel: NextLevel(
        name: 'Safety Legend',
        requirement: 'Maintain 90-day perfect record',
      ),
    ),
    BadgeData(
      id: 'global-explorer',
      name: 'Global Explorer',
      description: 'Visit and complete trips in 10 different countries',
      category: 'exploration',
      rarity: 'epic',
      icon: Icons.public,
      isEarned: false,
      progress: 8,
      maxProgress: 10,
      requirements: ['Visit 10 different countries', 'Complete at least 1 trip per country'],
      rewards: ['VIP traveler status', 'Exclusive destinations'],
      nextLevel: NextLevel(
        name: 'World Wanderer',
        requirement: 'Visit 25 countries',
      ),
    ),
    BadgeData(
      id: 'streak-master',
      name: 'Streak Master',
      description: 'Maintain a 30-day activity streak',
      category: 'achievement',
      rarity: 'rare',
      icon: Icons.trending_up,
      isEarned: false,
      progress: 15,
      maxProgress: 30,
      requirements: ['Log in for 30 consecutive days', 'Complete daily challenges'],
      rewards: ['Activity streak bonus features'],
      nextLevel: NextLevel(
        name: 'Dedication Master',
        requirement: 'Maintain 100-day streak',
      ),
    ),
    BadgeData(
      id: 'navigation-expert',
      name: 'Navigation Expert',
      description: 'Successfully navigate 20 trips using offline maps',
      category: 'achievement',
      rarity: 'rare',
      icon: Icons.explore,
      isEarned: false,
      progress: 12,
      maxProgress: 20,
      requirements: ['Use offline navigation 20 times', 'Zero navigation failures'],
      rewards: ['Advanced GPS features'],
      nextLevel: NextLevel(
        name: 'Pathfinder',
        requirement: 'Navigate 50 trips',
      ),
    ),
    BadgeData(
      id: 'wilderness-survival',
      name: 'Wilderness Survival',
      description: 'Complete 10 wilderness survival training modules',
      category: 'safety',
      rarity: 'uncommon',
      icon: Icons.security,
      isEarned: true,
      earnedDate: 'Apr 18, 2024',
      requirements: ['Complete survival training', 'Pass wilderness quiz'],
      rewards: ['Emergency kit discount', 'Survival mentor badge'],
      nextLevel: NextLevel(
        name: 'Survival Expert',
        requirement: 'Lead survival training sessions',
      ),
    ),
    BadgeData(
      id: 'legend-status',
      name: 'Wildstride Legend',
      description: 'Achieve the highest rank in the Wildstride community',
      category: 'special',
      rarity: 'legendary',
      icon: Icons.emoji_events,
      isEarned: false,
      progress: 23,
      maxProgress: 50,
      requirements: ['Complete 50+ trips', 'Maintain 95%+ safety score', 'Help 10+ fellow travelers'],
      rewards: ['Legendary status', 'Exclusive features', 'Annual summit invite'],
      nextLevel: NextLevel(
        name: 'Hall of Fame',
        requirement: 'Maintain legend status for 1 year',
      ),
    ),
  ];

  List<BadgeData> get _filteredBadges {
    switch (_selectedCategory) {
      case 'all':
        return _mockBadges;
      case 'earned':
        return _mockBadges.where((badge) => badge.isEarned).toList();
      case 'available':
        return _mockBadges.where((badge) => !badge.isEarned).toList();
      default:
        return _mockBadges.where((badge) => badge.category == _selectedCategory).toList();
    }
  }

  List<BadgeData> get _earnedBadges => _mockBadges.where((b) => b.isEarned).toList();
  List<BadgeData> get _availableBadges => _mockBadges.where((b) => !b.isEarned).toList();

  Color _getRarityColor(String rarity) {
    switch (rarity) {
      case 'common':
        return const Color(0xFF8B8B8B);
      case 'uncommon':
        return const Color(0xFF2E8B57);
      case 'rare':
        return const Color(0xFF1E90FF);
      case 'epic':
        return const Color(0xFFFF8C00);
      case 'legendary':
        return const Color(0xFFFFD700);
      default:
        return const Color(0xFF8B8B8B);
    }
  }

  Color _getRarityBgColor(String rarity) {
    switch (rarity) {
      case 'common':
        return const Color(0xFFE8D9B5).withOpacity(0.3);
      case 'uncommon':
        return const Color(0xFF2E8B57).withOpacity(0.1);
      case 'rare':
        return const Color(0xFF1E90FF).withOpacity(0.1);
      case 'epic':
        return const Color(0xFFFF8C00).withOpacity(0.1);
      case 'legendary':
        return const Color(0xFFFFD700).withOpacity(0.2);
      default:
        return const Color(0xFFE8D9B5).withOpacity(0.3);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'exploration':
        return Icons.location_on;
      case 'safety':
        return Icons.security;
      case 'achievement':
        return Icons.emoji_events;
      case 'special':
        return Icons.star;
      default:
        return Icons.workspace_premium;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedBadge != null) {
      return _buildBadgeDetailScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE8D9B5).withOpacity(0.1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    children: [
                      if (widget.onBack != null)
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(LucideIcons.arrowLeft),
                              onPressed: widget.onBack,
                              color: const Color(0xFF003B2E),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Achievement Center',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E8B57),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 60,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildStatItem(_earnedBadges.length.toString(), 'Earned'),
                            _buildStatItem(_availableBadges.length.toString(), 'Available'),
                            _buildStatItem(
                              '${((_earnedBadges.length / _mockBadges.length) * 100).round()}%',
                              'Complete',
                            ),
                            _buildStatItem(_mockUserStats.completedTrips.toString(), 'Trips'),
                            _buildStatItem(_mockUserStats.countriesVisited.toString(), 'Countries'),
                            _buildStatItem(_mockUserStats.streakDays.toString(), 'Streak'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E8B57).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _mockUserStats.rank,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2E8B57),
                                  ),
                                ),
                                Text(
                                  '${_mockUserStats.safetyScore}% Safety Score',
                                  style: const TextStyle(color: Color(0xFF2E8B57)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: _mockUserStats.safetyScore / 100,
                              backgroundColor: const Color(0xFF2E8B57).withOpacity(0.2),
                              color: const Color(0xFF2E8B57),
                              minHeight: 4,
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Excellent safety record maintained',
                              style: TextStyle(fontSize: 12, color: Color(0xFF2E8B57)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Category Tabs
                Container(
                  height: 48,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryTab('all', 'All'),
                      _buildCategoryTab('earned', 'Earned'),
                      _buildCategoryTab('available', 'Available'),
                      _buildCategoryTab('exploration', 'Exploration'),
                      _buildCategoryTab('safety', 'Safety'),
                      _buildCategoryTab('achievement', 'Achievement'),
                    ],
                  ),
                ),

                // Badges Grid (non-scrollable inside main scroll)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _filteredBadges.isEmpty
                      ? _buildEmptyState()
                      : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredBadges.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      return _buildBadgeCard(_filteredBadges[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E8B57),
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF2E8B57),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String value, String label) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: () => setState(() => _selectedCategory = value),
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedCategory == value 
              ? const Color(0xFF2E8B57)
              : Colors.white,
          foregroundColor: _selectedCategory == value ? Colors.white : const Color(0xFF2E8B57),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2,
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildBadgeCard(BadgeData badge) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _getRarityColor(badge.rarity),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => setState(() => _selectedBadge = badge),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and badges
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getRarityBgColor(badge.rarity),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      badge.icon,
                      color: _getRarityColor(badge.rarity),
                      size: 24,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          badge.rarity.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _getRarityColor(badge.rarity),
                          ),
                        ),
                      ),
                      if (badge.isEarned) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, size: 12, color: Colors.green[800]),
                              const SizedBox(width: 4),
                              Text(
                                'Earned',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.green[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Category and Name
              Row(
                children: [
                  Icon(
                    _getCategoryIcon(badge.category),
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      badge.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              
              // Description
              Text(
                badge.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              
              // Earned date or progress
              if (badge.earnedDate != null)
                Text(
                  'Earned ${badge.earnedDate}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.green,
                  ),
                ),
              
              if (badge.progress != null && badge.maxProgress != null && !badge.isEarned) ...[
                const SizedBox(height: 8),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Progress',
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          '${badge.progress}/${badge.maxProgress}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: badge.progress! / badge.maxProgress!,
                      backgroundColor: Colors.grey[300],
                      color: _getRarityColor(badge.rarity),
                      minHeight: 2,
                    ),
                  ],
                ),
              ],
              
              const Spacer(),
              
              // Footer with rewards and view details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.emoji_events, size: 12, color: Colors.orange[700]),
                      const SizedBox(width: 4),
                      Text(
                        '${badge.rewards.length} reward${badge.rewards.length != 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'View Details →',
                    style: TextStyle(
                      fontSize: 10,
                      color: _getRarityColor(badge.rarity),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
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
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.workspace_premium,
              size: 32,
              color: const Color(0xFF2E8B57),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No badges found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different category or start earning badges!',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeDetailScreen() {
    final badge = _selectedBadge!;
    
    return Scaffold(
      backgroundColor: const Color(0xFFE8D9B5).withOpacity(0.1),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
            decoration: BoxDecoration(
              color: const Color(0xFF2E8B57),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Back button
                Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() => _selectedBadge = null),
                      icon: const Icon(Icons.arrow_back, color: Color(0xFFFF8C00)),
                    ),
                  ],
                ),
                
                // Badge info
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: _getRarityBgColor(badge.rarity),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _getRarityColor(badge.rarity),
                          width: 4,
                        ),
                      ),
                      child: Icon(
                        badge.icon,
                        color: _getRarityColor(badge.rarity),
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                badge.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF8C00),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  badge.rarity.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _getRarityColor(badge.rarity),
                                  ),
                                ),
                              ),
                              if (badge.isEarned) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.check_circle, size: 12, color: Colors.green[800]),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Earned',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green[800],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            badge.description,
                            style: const TextStyle(
                              color: Color(0xFFFF8C00),
                              fontSize: 14,
                            ),
                          ),
                          if (badge.earnedDate != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Earned on ${badge.earnedDate}',
                              style: const TextStyle(
                                color: Color(0xFFFF8C00),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Details
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Progress
                if (badge.progress != null && badge.maxProgress != null)
                  _buildDetailCard(
                    icon: Icons.track_changes, // Changed from Icons.target to Icons.track_changes
                    title: 'Progress',
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Current Progress'),
                            Text(
                              '${badge.progress} / ${badge.maxProgress}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: badge.progress! / badge.maxProgress!,
                          backgroundColor: Colors.grey[300],
                          color: _getRarityColor(badge.rarity),
                          minHeight: 8,
                        ),
                        if (!badge.isEarned) ...[
                          const SizedBox(height: 8),
                          Text(
                            '${badge.maxProgress! - badge.progress!} more to go!',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                
                // Requirements
                _buildDetailCard(
                  icon: Icons.check_circle,
                  title: 'Requirements',
                  child: Column(
                    children: badge.requirements.map((requirement) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: badge.isEarned ? Colors.green : Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: badge.isEarned 
                                ? const Icon(Icons.check, size: 14, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              requirement,
                              style: TextStyle(
                                color: badge.isEarned ? Colors.green[700] : Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ),
                ),
                
                // Rewards
                _buildDetailCard(
                  icon: Icons.workspace_premium,
                  title: 'Rewards',
                  child: Column(
                    children: badge.rewards.map((reward) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8D9B5).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.emoji_events, size: 16, color: Colors.orange[700]),
                          const SizedBox(width: 8),
                          Expanded(child: Text(reward)),
                        ],
                      ),
                    )).toList(),
                  ),
                ),
                
                // Next Level
                if (badge.nextLevel != null)
                  _buildDetailCard(
                    icon: Icons.trending_up,
                    title: 'Next Level',
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF2E8B57).withOpacity(0.1),
                            const Color(0xFFFF8C00).withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  badge.nextLevel!.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  badge.nextLevel!.requirement,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.lock, color: Colors.grey[600]),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({required IconData icon, required String title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
}

class BadgeData {
  final String id;
  final String name;
  final String description;
  final String category;
  final String rarity;
  final IconData icon;
  final bool isEarned;
  final String? earnedDate;
  final int? progress;
  final int? maxProgress;
  final List<String> requirements;
  final List<String> rewards;
  final NextLevel? nextLevel;

  const BadgeData({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.rarity,
    required this.icon,
    required this.isEarned,
    this.earnedDate,
    this.progress,
    this.maxProgress,
    required this.requirements,
    required this.rewards,
    this.nextLevel,
  });
}

class NextLevel {
  final String name;
  final String requirement;

  const NextLevel({
    required this.name,
    required this.requirement,
  });
}

class UserStats {
  final int totalBadges;
  final String rank;
  final int streakDays;
  final int completedTrips;
  final int countriesVisited;
  final int safetyScore;

  const UserStats({
    required this.totalBadges,
    required this.rank,
    required this.streakDays,
    required this.completedTrips,
    required this.countriesVisited,
    required this.safetyScore,
  });
}