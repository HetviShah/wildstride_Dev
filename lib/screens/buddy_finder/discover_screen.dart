import 'package:flutter/material.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class Buddy {
  final int id;
  final String name;
  final int age;
  final String location;
  final String bio;
  final String image;
  final int compatibility;
  final List<String> interests;
  final List<String> upcomingTrips;
  final String verificationLevel;

  Buddy({
    required this.id,
    required this.name,
    required this.age,
    required this.location,
    required this.bio,
    required this.image,
    required this.compatibility,
    required this.interests,
    required this.upcomingTrips,
    required this.verificationLevel,
  });
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  int _currentBuddy = 0;
  bool _showFilters = false;
  
  // Filter states
  RangeValues _ageRange = const RangeValues(18, 65);
  double _maxDistance = 100;
  String _verificationFilter = 'any';
  List<String> _selectedInterests = [];
  double _minCompatibility = 70;

  final List<Buddy> _mockBuddies = [
    Buddy(
      id: 1,
      name: 'Alex Chen',
      age: 28,
      location: 'Vancouver, BC',
      bio: 'Adventure photographer seeking hiking companions for mountain trails. Love sunrise hikes and wildlife photography.',
      image: 'https://images.unsplash.com/photo-1633210155517-df87bd0883d3?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxoaWtpbmclMjBhZHZlbnR1cmUlMjBwb3J0cmFpdHxlbnwxfHx8fDE3NTYzNDcwMjF8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
      compatibility: 94,
      interests: ['Photography', 'Hiking', 'Wildlife'],
      upcomingTrips: ['Banff National Park', 'Whistler'],
      verificationLevel: 'Verified'
    ),
    Buddy(
      id: 2,
      name: 'Maria Rodriguez',
      age: 25,
      location: 'Denver, CO',
      bio: 'Rock climbing enthusiast and mountaineer. Looking for partners for multi-day adventures and peak bagging.',
      image: 'https://images.unsplash.com/photo-1606175063459-796dce40e3aa?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxiYWNrcGFja2VyJTIwbW91bnRhaW4lMjB0cmF2ZWx8ZW58MXx8fHwxNzU2MzQ3MDI1fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
      compatibility: 87,
      interests: ['Rock Climbing', 'Mountaineering', 'Camping'],
      upcomingTrips: ['Rocky Mountain NP', '14ers Challenge'],
      verificationLevel: 'Premium'
    ),
    Buddy(
      id: 3,
      name: 'Sophie Turner',
      age: 31,
      location: 'Portland, OR',
      bio: 'Trail runner and outdoor educator. Always up for exploring new trails and sharing outdoor skills.',
      image: 'https://images.unsplash.com/photo-1640951333227-f9e3ee38eb43?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxvdXRkb29yJTIwYWR2ZW50dXJlJTIwd29tYW58ZW58MXx8fHwxNzU2MzQ3MDI5fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
      compatibility: 92,
      interests: ['Trail Running', 'Education', 'Nature'],
      upcomingTrips: ['Mt. Hood', 'Columbia Gorge'],
      verificationLevel: 'Verified'
    ),
  ];

  final List<String> _allInterests = [
    'Photography', 'Hiking', 'Wildlife', 'Rock Climbing', 'Mountaineering', 
    'Camping', 'Trail Running', 'Education', 'Nature', 'Skiing', 
    'Snowboarding', 'Kayaking', 'Surfing', 'Backpacking'
  ];

  void _handleSwipe(String direction) {
    print('$direction ${_mockBuddies[_currentBuddy].name}');
    setState(() {
      _currentBuddy = (_currentBuddy + 1) % _mockBuddies.length;
    });
  }

  void _handleInterestToggle(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  void _applyFilters() {
    print('Applying filters: ${{
      'ageRange': _ageRange,
      'maxDistance': _maxDistance,
      'verificationFilter': _verificationFilter,
      'selectedInterests': _selectedInterests,
      'minCompatibility': _minCompatibility
    }}');
    setState(() {
      _showFilters = false;
    });
  }

  void _clearFilters() {
    setState(() {
      _ageRange = const RangeValues(18, 65);
      _maxDistance = 100;
      _verificationFilter = 'any';
      _selectedInterests = [];
      _minCompatibility = 70;
    });
  }

  Color _getVerificationColor(String level) {
    switch (level) {
      case 'Premium': return const Color(0xFFFFD700);
      case 'Verified': return const Color(0xFF4A90E2);
      default: return const Color(0xFF6B6B6B);
    }
  }

  Color _getVerificationTextColor(String level) {
    switch (level) {
      case 'Premium': return Colors.black;
      case 'Verified': return Colors.white;
      default: return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buddy = _mockBuddies[_currentBuddy];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 24),

            // Filter Panel
            if (_showFilters) ...[
              _buildFilterPanel(theme),
              const SizedBox(height: 16),
            ],

            // Main Card
            Expanded(
              child: Column(
                children: [
                  // Buddy card takes most of the height
                  Expanded(
                    child: _buildBuddyCard(buddy, theme),
                  ),

                  const SizedBox(height: 16),

                  // Action buttons at bottom
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildActionButtons(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Discover Buddies',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF003B2E),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _showFilters = !_showFilters;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _showFilters ? const Color(0xFF003B2E) : Colors.transparent,
            foregroundColor: _showFilters ? Colors.white : const Color(0xFF003B2E),
            side: BorderSide(color: const Color(0xFF003B2E)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Row(
            children: [
              Icon(Icons.filter_list, size: 16),
              SizedBox(width: 4),
              Text('Filter'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterPanel(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: const Color(0xFF003B2E).withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Buddies',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF003B2E),
                  ),
                ),
                TextButton(
                  onPressed: _clearFilters,
                  child: Text(
                    'Clear All',
                    style: TextStyle(color: const Color(0xFF6B6B6B)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Age Range
            _buildAgeRangeSlider(),
            const SizedBox(height: 16),

            // Max Distance
            _buildDistanceSlider(),
            const SizedBox(height: 16),

            // Verification Level
            _buildVerificationDropdown(),
            const SizedBox(height: 16),

            // Minimum Compatibility
            _buildCompatibilitySlider(),
            const SizedBox(height: 16),

            // Interests
            _buildInterestsFilterSection(),
            const SizedBox(height: 16),

            // Apply Filters Button
            _buildFilterButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeRangeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Age Range: ${_ageRange.start.round()} - ${_ageRange.end.round()} years',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF003B2E),
          ),
        ),
        RangeSlider(
          values: _ageRange,
          onChanged: (values) {
            setState(() {
              _ageRange = values;
            });
          },
          min: 18,
          max: 65,
          divisions: 47,
          labels: RangeLabels(
            _ageRange.start.round().toString(),
            _ageRange.end.round().toString(),
          ),
        ),
      ],
    );
  }

  Widget _buildDistanceSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Max Distance: ${_maxDistance.round()} km',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF003B2E),
          ),
        ),
        Slider(
          value: _maxDistance,
          onChanged: (value) {
            setState(() {
              _maxDistance = value;
            });
          },
          min: 5,
          max: 500,
          divisions: 99,
        ),
      ],
    );
  }

  Widget _buildVerificationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verification Level',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF003B2E),
          ),
        ),
        DropdownButtonFormField<String>(
          value: _verificationFilter,
          onChanged: (value) {
            setState(() {
              _verificationFilter = value!;
            });
          },
          items: const [
            DropdownMenuItem(value: 'any', child: Text('Any Level')),
            DropdownMenuItem(value: 'basic', child: Text('Basic & Above')),
            DropdownMenuItem(value: 'verified', child: Text('Verified & Above')),
            DropdownMenuItem(value: 'premium', child: Text('Premium Only')),
          ],
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompatibilitySlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Minimum Compatibility: ${_minCompatibility.round()}%',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF003B2E),
          ),
        ),
        Slider(
          value: _minCompatibility,
          onChanged: (value) {
            setState(() {
              _minCompatibility = value;
            });
          },
          min: 50,
          max: 100,
          divisions: 10,
        ),
      ],
    );
  }

  Widget _buildInterestsFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interests',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF003B2E),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 128,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 4,
            ),
            itemCount: _allInterests.length,
            itemBuilder: (context, index) {
              final interest = _allInterests[index];
              return Row(
                children: [
                  Checkbox(
                    value: _selectedInterests.contains(interest),
                    onChanged: (value) => _handleInterestToggle(interest),
                  ),
                  Text(
                    interest,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF6B6B6B),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _applyFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE66A00),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Apply Filters'),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _showFilters = false;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFF003B2E),
            side: BorderSide(color: const Color(0xFF003B2E)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildBuddyCard(Buddy buddy, ThemeData theme) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Image Section
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45, // responsive image height
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  buddy.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 80, color: Colors.grey),
                  ),
                ),

                // Compatibility Badge
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${buddy.compatibility}%',
                      style: const TextStyle(
                        color: Color(0xFFE66A00),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Verification Badge
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getVerificationColor(buddy.verificationLevel),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      buddy.verificationLevel,
                      style: TextStyle(
                        color: _getVerificationTextColor(buddy.verificationLevel),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Info Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(), // prevent scroll inside
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${buddy.name}, ${buddy.age}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF003B2E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Color(0xFF6B6B6B)),
                        const SizedBox(width: 4),
                        Text(
                          buddy.location,
                          style: const TextStyle(color: Color(0xFF6B6B6B)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      buddy.bio,
                      style: const TextStyle(color: Color(0xFF6B6B6B)),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    _buildBuddyInterestsSection(buddy),
                    const SizedBox(height: 12),
                    _buildUpcomingTrips(buddy),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuddyInterestsSection(Buddy buddy) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interests',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF003B2E),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: buddy.interests.map((interest) {
            return Chip(
              label: Text(interest),
              backgroundColor: Colors.grey[200],
              labelStyle: const TextStyle(fontSize: 12),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildUpcomingTrips(Buddy buddy) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Adventures',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF003B2E),
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: buddy.upcomingTrips.map((trip) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: const Color(0xFF6B6B6B)),
                  const SizedBox(width: 8),
                  Text(
                    trip,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF6B6B6B),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Pass Button
        ElevatedButton(
          onPressed: () => _handleSwipe('pass'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFF6B6B6B),
            shape: const CircleBorder(),
            side: BorderSide(color: const Color(0xFF6B6B6B)),
            padding: const EdgeInsets.all(16),
          ),
          child: const Icon(Icons.close, size: 24),
        ),
        const SizedBox(width: 24),
        
        // Like Button
        ElevatedButton(
          onPressed: () => _handleSwipe('like'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE66A00),
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
          ),
          child: const Icon(Icons.favorite, size: 24),
        ),
      ],
    );
  }
}