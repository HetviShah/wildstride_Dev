import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:logger/logger.dart';
import 'package:wildstride_app/models/buddy_finder/trip_model.dart';
import 'package:wildstride_app/services/buddy_finder/trip_service.dart';
import 'package:wildstride_app/widgets/buddy_finder/trip_card.dart' as trip_card;
import 'package:wildstride_app/widgets/buddy_finder/filter_panel.dart' as filter_panel;

// Add logger instance
final Logger _logger = Logger();

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  _TripsScreenState createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> with SingleTickerProviderStateMixin {
  final TripService _tripService = TripService();
  
  late TabController _tabController;
  String _activeTab = 'browse';
  String _searchQuery = '';
  bool _showCreateForm = false;
  bool _showFilters = false;
  
  // Filter state
  List<String> _selectedDifficulties = [];
  List<String> _selectedActivities = [];
  RangeValues _priceRange = const RangeValues(0, 1000);
  String _selectedDuration = 'any';
  String _selectedAvailability = 'any';
  
  List<Trip> _trips = [];
  List<Trip> _myTrips = [];
  final List<int> _joinedTripIds = [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _showSuccessMessage = false;
  bool _showJoinSuccessMessage = false;
  int? _isJoining;
  
  // Form state
  CreateTripForm _formData = CreateTripForm();
  Map<String, String> _formErrors = {};

  final List<String> _activityOptions = [
    'Hiking', 'Photography', 'Wildlife Viewing', 'Camping', 
    'Canoeing', 'Fishing', 'Rock Climbing', 'Instruction', 'Desert Hiking'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTrips();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTrips() async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _tripService.fetchTrips(
          searchQuery: _searchQuery,
          difficulties: _selectedDifficulties,
          activities: _selectedActivities,
          minPrice: _priceRange.start,
          maxPrice: _priceRange.end,
          duration: _selectedDuration != 'any' ? _selectedDuration : null,
        ),
        _tripService.fetchMyTrips(),
      ]);
      
      if (mounted) {
        setState(() {
          _trips = results[0];
          _myTrips = results[1];
        });
      }
    } catch (e) {
      _logger.e('Error loading trips: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading trips')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (!_validateForm()) return;
    
    setState(() => _isSubmitting = true);
    
    try {
      final newTrip = await _tripService.createTrip(_formData);
      if (mounted) {
        setState(() {
          _trips.insert(0, newTrip);
          _myTrips.insert(0, newTrip);
          _isSubmitting = false;
          _showCreateForm = false;
          _showSuccessMessage = true;
          _activeTab = 'my-trips';
          _formData = CreateTripForm();
          _formErrors = {};
        });
        
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) setState(() => _showSuccessMessage = false);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create trip: $e')),
        );
      }
    }
  }

  Future<void> _handleJoinTrip(int tripId) async {
    final tripIndex = _trips.indexWhere((t) => t.id == tripId);
    if (tripIndex == -1) return;
    
    final trip = _trips[tripIndex];
    
    if (trip.organizer == 'You' || _joinedTripIds.contains(tripId) || trip.currentParticipants >= trip.maxParticipants) {
      return;
    }

    setState(() => _isJoining = tripId);

    try {
      final success = await _tripService.joinTrip(tripId);
      if (success && mounted) {
        setState(() {
          _joinedTripIds.add(tripId);
          _isJoining = null;
          _showJoinSuccessMessage = true;
        });
        
        // Reload trips to get updated participant counts
        _loadTrips();
        
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) setState(() => _showJoinSuccessMessage = false);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isJoining = null);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to join trip')),
        );
      }
    }
  }

  void _handleCloseForm() {
    setState(() {
      _showCreateForm = false;
      _formData = CreateTripForm();
      _formErrors = {};
    });
  }

  void _toggleActivity(String activity) {
    setState(() {
      if (_formData.activities.contains(activity)) {
        _formData.activities.remove(activity);
      } else {
        _formData.activities.add(activity);
      }
    });
  }

  bool _validateForm() {
    final errors = <String, String>{};
    
    if (_formData.title.trim().isEmpty) errors['title'] = 'Trip title is required';
    if (_formData.location.trim().isEmpty) errors['location'] = 'Location is required';
    if (_formData.startDate.isEmpty) errors['startDate'] = 'Start date is required';
    if (_formData.endDate.isEmpty) errors['endDate'] = 'End date is required';
    
    final maxParticipants = int.tryParse(_formData.maxParticipants);
    if (maxParticipants == null || maxParticipants < 1) {
      errors['maxParticipants'] = 'Valid number of participants is required';
    }
    
    final price = double.tryParse(_formData.price);
    if (price == null || price < 0) {
      errors['price'] = 'Valid price is required';
    }
    
    if (_formData.description.trim().isEmpty) errors['description'] = 'Description is required';
    if (_formData.activities.isEmpty) errors['activities'] = 'At least one activity is required';
    
    if (_formData.startDate.isNotEmpty && _formData.endDate.isNotEmpty) {
      final start = DateTime.parse(_formData.startDate);
      final end = DateTime.parse(_formData.endDate);
      if (end.isBefore(start) || end.isAtSameMomentAs(start)) {
        errors['endDate'] = 'End date must be after start date';
      }
    }
    
    setState(() => _formErrors = errors);
    return errors.isEmpty;
  }

  void _clearFilters() {
    setState(() {
      _selectedDifficulties = [];
      _selectedActivities = [];
      _priceRange = const RangeValues(0, 1000);
      _selectedDuration = 'any';
      _selectedAvailability = 'any';
    });
    _loadTrips();
  }

  bool get _hasActiveFilters {
    return _selectedDifficulties.isNotEmpty || 
        _selectedActivities.isNotEmpty || 
        _priceRange.start > 0 || 
        _priceRange.end < 1000 ||
        _selectedDuration != 'any' ||
        _selectedAvailability != 'any';
  }

  int get _activeFilterCount {
    return _selectedDifficulties.length +
        _selectedActivities.length +
        (_priceRange.start > 0 || _priceRange.end < 1000 ? 1 : 0) +
        (_selectedDuration != 'any' ? 1 : 0) +
        (_selectedAvailability != 'any' ? 1 : 0);
  }

  List<Trip> get _filteredTrips {
    return _trips.where((trip) {
      // Availability filter
      final matchesAvailability = _selectedAvailability == 'any' || _selectedAvailability == 'All trips' ||
          (_selectedAvailability == 'Open slots' && trip.currentParticipants < trip.maxParticipants - 2) ||
          (_selectedAvailability == 'Almost full' && trip.currentParticipants >= trip.maxParticipants - 2);

      return matchesAvailability;
    }).toList();
  }

  List<filter_panel.FilterSection> get _filterSections {
    return [
      filter_panel.FilterConfigs.createDifficultyFilter(
        selectedDifficulties: _selectedDifficulties,
        onDifficultySelected: (difficulty, selected) {
          setState(() {
            if (selected) {
              _selectedDifficulties.add(difficulty);
            } else {
              _selectedDifficulties.remove(difficulty);
            }
          });
          _loadTrips();
        },
      ),
      filter_panel.FilterConfigs.createActivitiesFilter(
        selectedActivities: _selectedActivities,
        onActivitySelected: (activity, selected) {
          setState(() {
            if (selected) {
              _selectedActivities.add(activity);
            } else {
              _selectedActivities.remove(activity);
            }
          });
          _loadTrips();
        },
        availableActivities: _activityOptions,
      ),
      filter_panel.FilterConfigs.createPriceFilter(
        priceRange: _priceRange,
        onPriceRangeChanged: (range) {
          setState(() => _priceRange = range);
          _loadTrips();
        },
      ),
      filter_panel.FilterConfigs.createDurationFilter(
        selectedDuration: _selectedDuration,
        onDurationSelected: (duration, selected) {
          setState(() => _selectedDuration = selected ? duration : 'any');
          _loadTrips();
        },
      ),
      filter_panel.FilterConfigs.createAvailabilityFilter(
        selectedAvailability: _selectedAvailability,
        onAvailabilitySelected: (availability, selected) {
          setState(() => _selectedAvailability = selected ? availability : 'any');
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 2,
              title: TabBar(
                controller: _tabController,
                onTap: (index) {
                  setState(() {
                    _activeTab = index == 0 ? 'browse' : 'my-trips';
                  });
                },
                tabs: const [
                  Tab(text: 'Discover Trips'),
                  Tab(text: 'My Trips'),
                ],
                labelColor: Colors.green,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.green,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
              actions: [
                if (_activeTab == 'my-trips')
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: ElevatedButton.icon(
                      onPressed: () => setState(() => _showCreateForm = true),
                      icon: const Icon(LucideIcons.plus, size: 16),
                      label: const Text('Create Trip'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
              ],
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildBrowseTab(),
            _buildMyTripsTab(),
          ],
        ),
      ),
      
      // Success Messages
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showSuccessMessage) 
            _buildSuccessMessage(
              'Trip Published Successfully!', 
              'Your adventure is now live and ready for fellow explorers to join.'
            ),
          if (_showJoinSuccessMessage) 
            _buildSuccessMessage(
              'Successfully Joined Trip!', 
              'You\'re now part of this amazing adventure. Check your joined trips!'
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,

      // Create Trip Modal
      bottomSheet: _showCreateForm ? _buildCreateTripForm() : null,
    );
  }

  Widget _buildSuccessMessage(String title, String message) {
    return Card(
      elevation: 4,
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.checkCircle, color: Colors.green[600]),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                Text(message, style: TextStyle(color: Colors.green[600], fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowseTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search and Filters
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search destinations, activities...',
                    prefixIcon: const Icon(LucideIcons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                    _loadTrips();
                  },
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => setState(() => _showFilters = !_showFilters),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _hasActiveFilters ? Colors.orange : Colors.grey[700],
                  side: BorderSide(
                    color: _hasActiveFilters ? Colors.orange : Colors.grey[300]!,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
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

          const SizedBox(height: 16),

          // Filter Panel
          if (_showFilters) 
            filter_panel.FilterPanel(
              sections: _filterSections,
              onClearAll: _clearFilters,
              onClose: () => setState(() => _showFilters = false),
              hasActiveFilters: _hasActiveFilters,
              activeFilterCount: _activeFilterCount,
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),

          const SizedBox(height: 16),

          // Results count
          Row(
            children: [
              Text(
                '${_filteredTrips.length} trip${_filteredTrips.length != 1 ? 's' : ''} found${_searchQuery.isNotEmpty ? ' for "$_searchQuery"' : ''}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const Spacer(),
              if (_hasActiveFilters) TextButton(
                onPressed: _clearFilters,
                child: const Text('Clear filters', style: TextStyle(color: Colors.orange)),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Trip Cards
          _isLoading 
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: CircularProgressIndicator(), // FIXED: Removed duplicate const
                  ),
                )
              : _filteredTrips.isNotEmpty
                  ? Column(
                      children: _filteredTrips.map((trip) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: trip_card.TripCard(
                          trip: trip,
                          onTap: () => _showTripDetails(trip),
                          onJoin: () => _handleJoinTrip(trip.id),
                          onViewDetails: () => _showTripDetails(trip),
                          canJoin: trip.organizer != 'You' && 
                                  !_joinedTripIds.contains(trip.id) && 
                                  trip.currentParticipants < trip.maxParticipants,
                          isJoining: _isJoining == trip.id,
                          isJoined: _joinedTripIds.contains(trip.id),
                          isOwnTrip: trip.organizer == 'You',
                        ),
                      )).toList(),
                    )
                  : _buildNoResults(),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.brown[200],
              shape: BoxShape.circle,
            ),
            child: Icon(LucideIcons.search, size: 32, color: Colors.green[900]),
          ),
          const SizedBox(height: 16),
          const Text(
            'No trips found', 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search or filter criteria to find more adventures.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _clearFilters();
              });
            },
            child: const Text('Clear search and filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildMyTripsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (_myTrips.isNotEmpty) ...[
            Row(
              children: [
                const Text(
                  'My Created Adventures', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => setState(() => _showCreateForm = true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.plus, size: 16),
                      SizedBox(width: 4),
                      Text('Create Trip'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: _myTrips.map((trip) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: trip_card.TripCard(
                  trip: trip,
                  onTap: () => _showTripDetails(trip),
                  onViewDetails: () => _showTripDetails(trip),
                  canJoin: false,
                  isOwnTrip: true,
                ),
              )).toList(),
            ),
          ] else
            _buildNoTripsYet(),
        ],
      ),
    );
  }

  Widget _buildNoTripsYet() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFE8D9B5),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.mapPin, size: 32, color: Color(0xFF003B2E)),
          ),
          const SizedBox(height: 16),
          const Text('No trips yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'Start by creating your first adventure or joining an open trip.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(() => _showCreateForm = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Create Your First Trip'),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateTripForm() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Create New Adventure',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(LucideIcons.x),
                onPressed: _handleCloseForm,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Form Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildFormField(
                    label: 'Trip Title',
                    hintText: 'Amazing Mountain Adventure...',
                    value: _formData.title,
                    onChanged: (value) => setState(() => _formData.title = value),
                    errorText: _formErrors['title'],
                  ),
                  const SizedBox(height: 16),
                  
                  _buildFormField(
                    label: 'Location',
                    hintText: 'National Park, City, Country',
                    value: _formData.location,
                    onChanged: (value) => setState(() => _formData.location = value),
                    errorText: _formErrors['location'],
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildFormField(
                          label: 'Start Date',
                          hintText: 'YYYY-MM-DD',
                          value: _formData.startDate,
                          onChanged: (value) => setState(() => _formData.startDate = value),
                          errorText: _formErrors['startDate'],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFormField(
                          label: 'End Date',
                          hintText: 'YYYY-MM-DD',
                          value: _formData.endDate,
                          onChanged: (value) => setState(() => _formData.endDate = value),
                          errorText: _formErrors['endDate'],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildFormField(
                          label: 'Max Participants',
                          hintText: '8',
                          value: _formData.maxParticipants,
                          onChanged: (value) => setState(() => _formData.maxParticipants = value),
                          errorText: _formErrors['maxParticipants'],
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFormField(
                          label: 'Price per Person',
                          hintText: '250',
                          value: _formData.price,
                          onChanged: (value) => setState(() => _formData.price = value),
                          errorText: _formErrors['price'],
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  _buildActivitiesSection(),
                  const SizedBox(height: 16),
                  
                  _buildFormField(
                    label: 'Description',
                    hintText: 'Describe your adventure...',
                    value: _formData.description,
                    onChanged: (value) => setState(() => _formData.description = value),
                    errorText: _formErrors['description'],
                    maxLines: 4,
                  ),
                  const SizedBox(height: 24),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _handleCloseForm,
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                          child: _isSubmitting 
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : const Text('Publish Trip'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String hintText,
    required String value,
    required Function(String) onChanged,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700]),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: TextEditingController(text: value),
          onChanged: onChanged,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildActivitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activities',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _activityOptions.map((activity) {
            final isSelected = _formData.activities.contains(activity);
            return FilterChip(
              label: Text(activity),
              selected: isSelected,
              onSelected: (selected) => _toggleActivity(activity),
              backgroundColor: isSelected ? Colors.orange : Colors.grey[100],
              selectedColor: Colors.orange,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            );
          }).toList(),
        ),
        if (_formErrors.containsKey('activities'))
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _formErrors['activities']!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  void _showTripDetails(Trip trip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(trip.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('by ${trip.organizer}', style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 12),
              Text(trip.description),
              const SizedBox(height: 16),
              const Text('Activities:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: trip.activities.map((activity) => Chip(
                  label: Text(activity),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                )).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Details:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('📍 ${trip.location}'),
              Text('📅 ${trip.dates} • ${trip.duration}'),
              Text('👥 ${trip.currentParticipants}/${trip.maxParticipants} participants'),
              Text('💲 \$${trip.price} per person'),
              Text('⭐ ${trip.rating} rating'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (trip.organizer != 'You' && !_joinedTripIds.contains(trip.id) && trip.currentParticipants < trip.maxParticipants)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _handleJoinTrip(trip.id);
              },
              child: const Text('Join Trip'),
            ),
        ],
      ),
    );
  }
}