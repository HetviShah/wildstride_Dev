import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class Adventure {
  final int id;
  final String title;
  final String location;
  final String date;
  final String duration;
  final int rating;
  final int photos;
  final List<Map<String, String>> participants;
  final String status;
  final String category;
  final String difficulty;
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

class HistoryScreen extends StatefulWidget {
  final VoidCallback? onBack; // ✅ optional onBack callback

  const HistoryScreen({super.key, this.onBack});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = 'all';
  String selectedYear = '2024';

  final List<Adventure> _mockAdventures = [
    Adventure(
      id: 1,
      title: 'Banff National Park Hiking',
      location: 'Banff, Alberta',
      date: '2024-08-15',
      duration: '3 days',
      rating: 5,
      photos: 47,
      participants: [
        {'name': 'Alex Chen', 'avatar': ''},
        {'name': 'Sarah Kim', 'avatar': ''},
        {'name': 'Mike Johnson', 'avatar': ''},
      ],
      status: 'completed',
      category: 'hiking',
      difficulty: 'moderate',
      coverImage: 'https://picsum.photos/400/200',
      highlights: ['Lake Louise', 'Moraine Lake', 'Plain of Six Glaciers'],
      distance: '24.5 km',
      elevation: '850m gain',
    ),
    Adventure(
      id: 2,
      title: 'Pacific Coast Trail Photography',
      location: 'Tofino, BC',
      date: '2024-07-28',
      duration: '2 days',
      rating: 4,
      photos: 63,
      participants: [
        {'name': 'Emma Wilson', 'avatar': ''},
        {'name': 'Jordan Liu', 'avatar': ''},
      ],
      status: 'completed',
      category: 'photography',
      difficulty: 'easy',
      coverImage: 'https://picsum.photos/401/200',
      highlights: ['Chesterman Beach', 'Wild Pacific Trail', 'Sunset Photography'],
      distance: '8.2 km',
      elevation: '120m gain',
    ),
  ];

  List<Adventure> get filteredAdventures {
    return _mockAdventures.where((adv) {
      final query = _searchController.text.toLowerCase();
      final matchesSearch = adv.title.toLowerCase().contains(query) ||
          adv.location.toLowerCase().contains(query);
      final matchesCategory =
          selectedCategory == 'all' || adv.category == selectedCategory;
      final matchesYear = adv.date.startsWith(selectedYear);
      return matchesSearch && matchesCategory && matchesYear;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final completed = filteredAdventures.where((a) => a.status == 'completed').toList();
    final totalDistance = completed.fold<double>(
        0, (sum, a) => sum + double.tryParse(a.distance?.replaceAll(RegExp(r'[^\d.]'), '') ?? '0')!);
    final avgRating = completed.isEmpty
        ? 0
        : completed.fold<int>(0, (sum, a) => sum + a.rating) / completed.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),
      appBar: AppBar(
        title: const Text(
          'Adventure History',
          style: TextStyle(color: Color(0xFF003B2E)),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF003B2E)),
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!(); // ✅ trigger custom callback if provided
            } else {
              Navigator.pop(context); // ✅ fallback: pop current route
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchFilters(),
            const SizedBox(height: 12),
            _buildStatsRow(completed.length, totalDistance, avgRating.toDouble()),
            const SizedBox(height: 12),
            Expanded(
              child: filteredAdventures.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                itemCount: filteredAdventures.length,
                itemBuilder: (context, index) {
                  final adv = filteredAdventures[index];
                  return _buildAdventureCard(adv);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchFilters() {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: Color(0xFF6B6B6B)),
            hintText: "Search adventures or locations...",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All Categories')),
                  DropdownMenuItem(value: 'hiking', child: Text('Hiking')),
                  DropdownMenuItem(value: 'camping', child: Text('Camping')),
                  DropdownMenuItem(value: 'climbing', child: Text('Climbing')),
                  DropdownMenuItem(value: 'photography', child: Text('Photography')),
                  DropdownMenuItem(value: 'cycling', child: Text('Cycling')),
                ],
                onChanged: (value) => setState(() => selectedCategory = value!),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedYear,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: '2024', child: Text('2024')),
                  DropdownMenuItem(value: '2023', child: Text('2023')),
                  DropdownMenuItem(value: '2022', child: Text('2022')),
                ],
                onChanged: (value) => setState(() => selectedYear = value!),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow(int total, double distance, double avgRating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard(Icons.terrain, "$total", "Adventures", const Color(0xFF003B2E)),
        _buildStatCard(Icons.route, "${distance.toStringAsFixed(1)} km", "Distance", const Color(0xFFE66A00)),
        _buildStatCard(Icons.camera_alt, "${_mockAdventures.fold(0, (sum, a) => sum + a.photos)}", "Photos", const Color(0xFF4A90E2)),
        _buildStatCard(Icons.star, avgRating.toStringAsFixed(1), "Avg Rating", const Color(0xFFFFD700)),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Icon(icon, color: color),
              Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
              Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B6B6B))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdventureCard(Adventure adv) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              adv.coverImage,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  adv.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF003B2E),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Color(0xFF6B6B6B)),
                    const SizedBox(width: 4),
                    Text(adv.location, style: const TextStyle(color: Color(0xFF6B6B6B))),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${adv.duration} • ${adv.difficulty}",
                        style: const TextStyle(fontSize: 12, color: Color(0xFF6B6B6B))),
                    Row(
                      children: List.generate(
                        adv.rating,
                            (index) => const Icon(Icons.star, size: 14, color: Color(0xFFFFD700)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: adv.highlights.map((h) {
                    return Chip(
                      label: Text(h, style: const TextStyle(fontSize: 12)),
                      backgroundColor: Colors.grey.shade100,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.terrain, size: 64, color: Colors.grey),
          SizedBox(height: 8),
          Text('No adventures found', style: TextStyle(color: Color(0xFF003B2E))),
          Text('Start your first adventure to see it here!',
              style: TextStyle(color: Color(0xFF6B6B6B))),
        ],
      ),
    );
  }
}