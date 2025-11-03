import 'package:wildstride_app/models/buddy_finder/trip_model.dart';

class TripService {
  // Mock data
  final List<Trip> _mockTrips = [
    Trip(
      id: 1,
      title: 'Banff Hiking & Photography Tour',
      organizer: 'Alex Chen',
      location: 'Banff National Park, Canada',
      dates: 'Jul 15-20, 2024',
      duration: '6 days',
      maxParticipants: 8,
      currentParticipants: 5,
      difficulty: 'Moderate',
      price: 850,
      image: 'https://images.unsplash.com/photo-1623622863859-2931a6c3bc80?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtb3VudGFpbiUyMGhpa2luZyUyMHRyYWlsfGVufDF8fHx8MTc1NjI3NjEzN3ww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
      description: 'Explore the stunning landscapes of Banff with fellow photography enthusiasts.',
      activities: ['Hiking', 'Photography', 'Wildlife Viewing'],
      rating: 4.8,
      isOpen: true,
    ),
    // Add more mock trips as needed
  ];

  Future<List<Trip>> fetchTrips({
    String? searchQuery,
    List<String>? difficulties,
    List<String>? activities,
    double? minPrice,
    double? maxPrice,
    String? duration,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    List<Trip> filteredTrips = List.from(_mockTrips);
    
    // Apply search filter
    if (searchQuery != null && searchQuery.isNotEmpty) {
      filteredTrips = filteredTrips.where((trip) =>
          trip.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          trip.location.toLowerCase().contains(searchQuery.toLowerCase()) ||
          trip.organizer.toLowerCase().contains(searchQuery.toLowerCase()) ||
          trip.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
          trip.activities.any((activity) => activity.toLowerCase().contains(searchQuery.toLowerCase()))
      ).toList();
    }
    
    // Apply difficulty filter
    if (difficulties != null && difficulties.isNotEmpty) {
      filteredTrips = filteredTrips.where((trip) => difficulties.contains(trip.difficulty)).toList();
    }
    
    // Apply activities filter
    if (activities != null && activities.isNotEmpty) {
      filteredTrips = filteredTrips.where((trip) =>
          activities.any((activity) => trip.activities.contains(activity))
      ).toList();
    }
    
    // Apply price filter
    if (minPrice != null) {
      filteredTrips = filteredTrips.where((trip) => trip.price >= minPrice).toList();
    }
    if (maxPrice != null) {
      filteredTrips = filteredTrips.where((trip) => trip.price <= maxPrice).toList();
    }
    
    return filteredTrips;
  }

  Future<List<Trip>> fetchMyTrips() async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Filter trips where organizer is current user
    return _mockTrips.where((trip) => trip.organizer == 'You').toList();
  }

  Future<List<Trip>> fetchJoinedTrips() async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    // In a real app, this would filter trips joined by current user
    return _mockTrips.where((trip) => trip.organizer != 'You').take(2).toList();
  }

  Future<Trip?> fetchTripById(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    try {
      return _mockTrips.firstWhere((trip) => trip.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<Trip> createTrip(CreateTripForm formData) async {
    await Future.delayed(const Duration(seconds: 2));
    
    final newTrip = Trip(
      id: _mockTrips.length + 1,
      title: formData.title,
      organizer: 'You', // Current user
      location: formData.location,
      dates: TripHelpers.formatDateRange(formData.startDate, formData.endDate),
      duration: TripHelpers.calculateDuration(formData.startDate, formData.endDate),
      maxParticipants: int.parse(formData.maxParticipants),
      currentParticipants: 1,
      difficulty: formData.difficulty,
      price: double.parse(formData.price),
      image: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxvdXRkb29yJTIwYWR2ZW50dXJlfGVufDF8fHx8MTc1NjM0NzA3OXww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
      description: formData.description,
      activities: formData.activities,
      rating: 5.0,
      isOpen: true,
    );
    
    // In a real app, this would add to backend
    _mockTrips.insert(0, newTrip);
    
    return newTrip;
  }

  Future<bool> joinTrip(int tripId) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final tripIndex = _mockTrips.indexWhere((trip) => trip.id == tripId);
    if (tripIndex != -1 && _mockTrips[tripIndex].currentParticipants < _mockTrips[tripIndex].maxParticipants) {
      // Update participants count
      final updatedTrip = _mockTrips[tripIndex].copyWith(
        currentParticipants: _mockTrips[tripIndex].currentParticipants + 1,
      );
      _mockTrips[tripIndex] = updatedTrip;
      return true;
    }
    
    return false;
  }

  Future<bool> leaveTrip(int tripId) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final tripIndex = _mockTrips.indexWhere((trip) => trip.id == tripId);
    if (tripIndex != -1 && _mockTrips[tripIndex].currentParticipants > 0) {
      final updatedTrip = _mockTrips[tripIndex].copyWith(
        currentParticipants: _mockTrips[tripIndex].currentParticipants - 1,
      );
      _mockTrips[tripIndex] = updatedTrip;
      return true;
    }
    
    return false;
  }

  Future<bool> updateTrip(int tripId, CreateTripForm formData) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final tripIndex = _mockTrips.indexWhere((trip) => trip.id == tripId);
    if (tripIndex != -1) {
      final updatedTrip = _mockTrips[tripIndex].copyWith(
        title: formData.title,
        location: formData.location,
        dates: TripHelpers.formatDateRange(formData.startDate, formData.endDate),
        duration: TripHelpers.calculateDuration(formData.startDate, formData.endDate),
        maxParticipants: int.parse(formData.maxParticipants),
        difficulty: formData.difficulty,
        price: double.parse(formData.price),
        description: formData.description,
        activities: formData.activities,
      );
      _mockTrips[tripIndex] = updatedTrip;
      return true;
    }
    
    return false;
  }

  Future<bool> deleteTrip(int tripId) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final initialLength = _mockTrips.length;
    _mockTrips.removeWhere((trip) => trip.id == tripId);
    
    return _mockTrips.length < initialLength;
  }
}