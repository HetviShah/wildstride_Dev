import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Enums
enum AdventureStatus { completed, cancelled, ongoing }
enum AdventureCategory { hiking, camping, climbing, photography, cycling }
enum Difficulty { easy, moderate, hard }

// Models
class Participant {
  final int id;
  final String name;
  final String avatar;
  Participant({required this.id, required this.name, required this.avatar});
}

class Adventure {
  final int id;
  final String title;
  final String location;
  final String date;
  final String duration;
  final double rating;
  final int photos;
  final List<Participant> participants;
  final AdventureStatus status;
  final AdventureCategory category;
  final Difficulty difficulty;
  final String coverImage;
  final List<String> highlights;
  final String? distance;
  final String? elevation;

  Adventure({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.duration,
    required this.rating,
    required this.photos,
    required this.participants,
    required this.status,
    required this.category,
    required this.difficulty,
    required this.coverImage,
    required this.highlights,
    this.distance,
    this.elevation,
  });
}

// Mock data
final List<Adventure> mockAdventures = [
  Adventure(
    id: 1,
    title: 'Banff National Park Hiking',
    location: 'Banff, Alberta',
    date: '2024-08-15',
    duration: '3 days',
    rating: 5,
    photos: 47,
    participants: [
      Participant(id: 1, name: 'Alex Chen', avatar: ''),
      Participant(id: 2, name: 'Sarah Kim', avatar: ''),
    ],
    status: AdventureStatus.completed,
    category: AdventureCategory.hiking,
    difficulty: Difficulty.moderate,
    coverImage: '',
    highlights: ['Lake Louise', 'Moraine Lake', 'Plain of Six Glaciers'],
    distance: '24.5 km',
    elevation: '850m gain',
  ),
  Adventure(
    id: 2,
    title: 'Vancouver Island Cycling',
    location: 'Victoria, BC',
    date: '2024-08-30',
    duration: '1 day',
    rating: 0,
    photos: 0,
    participants: [Participant(id: 3, name: 'Tom Wilson', avatar: '')],
    status: AdventureStatus.cancelled,
    category: AdventureCategory.cycling,
    difficulty: Difficulty.easy,
    coverImage: '',
    highlights: [],
    distance: '25 km planned',
    elevation: '200m gain',
  ),
];

// Helpers
IconData getCategoryIcon(AdventureCategory category) {
  switch (category) {
    case AdventureCategory.hiking:
    case AdventureCategory.climbing:
      return Icons.terrain;
    case AdventureCategory.camping:
    case AdventureCategory.cycling:
      return Icons.navigation;
    case AdventureCategory.photography:
      return Icons.camera_alt;
  }
}

Color getCategoryColor(AdventureCategory category) {
  switch (category) {
    case AdventureCategory.hiking:
      return const Color(0xFF228B22);
    case AdventureCategory.camping:
      return const Color(0xFFFF8C00);
    case AdventureCategory.climbing:
      return const Color(0xFFD22B2B);
    case AdventureCategory.photography:
      return const Color(0xFF87CEEB);
    case AdventureCategory.cycling:
      return const Color(0xFFFFD700);
  }
}

Color getDifficultyColor(Difficulty difficulty) {
  switch (difficulty) {
    case Difficulty.easy:
      return Colors.green;
    case Difficulty.moderate:
      return const Color(0xFFFF8C00);
    case Difficulty.hard:
      return const Color(0xFFD22B2B);
  }
}

Color getStatusColor(AdventureStatus status) {
  switch (status) {
    case AdventureStatus.completed:
      return Colors.green;
    case AdventureStatus.cancelled:
      return const Color(0xFFD22B2B);
    case AdventureStatus.ongoing:
      return const Color(0xFF87CEEB);
  }
}

String getDifficultyText(Difficulty difficulty) {
  switch (difficulty) {
    case Difficulty.easy:
      return 'easy';
    case Difficulty.moderate:
      return 'moderate';
    case Difficulty.hard:
      return 'hard';
  }
}

String getStatusText(AdventureStatus status) {
  switch (status) {
    case AdventureStatus.completed:
      return 'completed';
    case AdventureStatus.cancelled:
      return 'cancelled';
    case AdventureStatus.ongoing:
      return 'ongoing';
  }
}

String getCategoryText(AdventureCategory category) {
  switch (category) {
    case AdventureCategory.hiking:
      return 'hiking';
    case AdventureCategory.camping:
      return 'camping';
    case AdventureCategory.climbing:
      return 'climbing';
    case AdventureCategory.photography:
      return 'photography';
    case AdventureCategory.cycling:
      return 'cycling';
  }
}

// Main Screen
class HistoryScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const HistoryScreen({Key? key, this.onBack}) : super(key: key);
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'all';
  String _selectedYear = '2024';

  @override
  Widget build(BuildContext context) {
    final filteredAdventures = mockAdventures.where((adventure) {
      final matchesSearch = adventure.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          adventure.location.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'all' || getCategoryText(adventure.category) == _selectedCategory;
      final matchesYear = adventure.date.startsWith(_selectedYear);
      return matchesSearch && matchesCategory && matchesYear;
    }).toList();

    final completedAdventures = filteredAdventures.where((a) => a.status == AdventureStatus.completed).toList();

    final stats = {
      'totalAdventures': completedAdventures.length,
      'totalDistance': completedAdventures.fold<double>(0.0, (sum, adv) {
        final numericDistance =
            double.tryParse(adv.distance?.replaceAll(RegExp(r'[^\d.]'), '') ?? '0') ?? 0.0;
        return sum + numericDistance;
      }),
      'totalPhotos': completedAdventures.fold<int>(0, (sum, adv) => sum + (adv.photos)),
      'averageRating': completedAdventures.isNotEmpty
          ? completedAdventures.fold<double>(0.0, (sum, adv) => sum + adv.rating) /
          completedAdventures.length
          : 0.0,
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
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
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF228B22)),
                        onPressed: widget.onBack,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Adventure History',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF228B22),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search adventures or locations...',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF808080)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: const Color(0xFF808080).withOpacity(0.3)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildStatCard(Icons.terrain, '${stats['totalAdventures']}', 'Adventures',
                          const Color(0xFF228B22)),
                      _buildStatCard(Icons.navigation,
                          '${(stats['totalDistance'] ?? 0.0).toStringAsFixed(1)} km', 'Distance',
                          const Color(0xFFFF8C00)),
                      _buildStatCard(Icons.camera_alt, '${stats['totalPhotos']}', 'Photos',
                          const Color(0xFF87CEEB)),
                      _buildStatCard(Icons.star, (stats['averageRating'] ?? 0.0).toStringAsFixed(1),
                          'Avg Rating', const Color(0xFFFFD700)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Adventures list
                  if (filteredAdventures.isNotEmpty)
                    ...filteredAdventures.map((adv) => _buildAdventureCard(adv)).toList()
                  else
                    Column(
                      children: const [
                        Icon(Icons.terrain, size: 48, color: Color(0xFF808080)),
                        SizedBox(height: 12),
                        Text('No adventures found',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF228B22))),
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

  Widget _buildStatCard(IconData icon, String value, String label, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: const Color(0xFF808080).withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(fontSize: 12, color: Color(0xFF808080))),
          ],
        ),
      ),
    );
  }

  Widget _buildAdventureCard(Adventure adventure) {
    final categoryColor = getCategoryColor(adventure.category);
    final categoryIcon = getCategoryIcon(adventure.category);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFFE0E0E0),
                  ),
                  child: const Icon(Icons.image, color: Color(0xFF808080)),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration:
                    BoxDecoration(color: categoryColor, shape: BoxShape.circle),
                    child: Icon(categoryIcon, size: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(adventure.title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF228B22))),
                  const SizedBox(height: 4),
                  Text(adventure.location,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF808080))),
                  const SizedBox(height: 4),
                  Text(
                    adventure.date.isNotEmpty
                        ? DateFormat('MMM d, yyyy')
                        .format(DateTime.tryParse(adventure.date) ?? DateTime.now())
                        : 'Unknown date',
                    style:
                    const TextStyle(fontSize: 12, color: Color(0xFF808080)),
                  ),
                  if (adventure.distance != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(adventure.distance!,
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFF808080))),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}