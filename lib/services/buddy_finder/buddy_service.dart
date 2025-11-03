import 'package:wildstride_app/models/buddy_finder/buddy_model.dart';


class BuddyService {
  // Mock data
  final List<Buddy> _mockBuddies = [
    Buddy(
      id: 1,
      name: 'Alex Chen',
      avatar: '/api/placeholder/60/60',
      location: 'Vancouver, Canada',
      isOnline: true,
      isVerified: true,
      trustScore: 98,
      mutualConnections: 12,
      completedTrips: 23,
      lastSeen: 'Online now',
      bio: 'Passionate mountain climber and photographer. Love exploring remote trails and capturing nature\'s beauty.',
      interests: ['Mountain Climbing', 'Photography', 'Hiking', 'Camping'],
      languages: ['English', 'Mandarin', 'French'],
      nextTrip: NextTrip(destination: 'Patagonia', dates: 'Aug 15-30'),
      badges: ['Mountain Explorer', 'Safety Champion', 'Photo Master'],
      safetyStatus: 'safe',
      connectionStatus: 'connected',
    ),
    // Add more mock buddies as needed
  ];

  Future<List<Buddy>> fetchBuddies({String? searchQuery, List<String>? filters}) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    List<Buddy> filteredBuddies = List.from(_mockBuddies);
    
    // Apply search filter
    if (searchQuery != null && searchQuery.isNotEmpty) {
      filteredBuddies = filteredBuddies.where((buddy) =>
          buddy.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          buddy.location.toLowerCase().contains(searchQuery.toLowerCase()) ||
          buddy.interests.any((interest) => interest.toLowerCase().contains(searchQuery.toLowerCase()))
      ).toList();
    }
    
    // Apply additional filters here if needed
    
    return filteredBuddies;
  }

  Future<List<Buddy>> fetchBuddiesByConnectionStatus(String status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _mockBuddies.where((buddy) => buddy.connectionStatus == status).toList();
  }

  Future<Buddy?> fetchBuddyById(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    try {
      return _mockBuddies.firstWhere((buddy) => buddy.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<bool> sendConnectionRequest(int buddyId) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // In a real app, this would call an API
    final buddyIndex = _mockBuddies.indexWhere((buddy) => buddy.id == buddyId);
    if (buddyIndex != -1) {
      // This would update the backend in a real app
      return true;
    }
    
    return false;
  }

  Future<bool> acceptConnectionRequest(int buddyId) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final buddyIndex = _mockBuddies.indexWhere((buddy) => buddy.id == buddyId);
    if (buddyIndex != -1) {
      // Update connection status
      return true;
    }
    
    return false;
  }

  Future<bool> declineConnectionRequest(int buddyId) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final buddyIndex = _mockBuddies.indexWhere((buddy) => buddy.id == buddyId);
    if (buddyIndex != -1) {
      // Update connection status
      return true;
    }
    
    return false;
  }

  Future<bool> sendMessage(int buddyId, String message) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Simulate sending message
    return true;
  }

  // Get counts for different connection statuses
  Future<Map<String, int>> getBuddyCounts() async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    return {
      'connected': _mockBuddies.where((b) => b.connectionStatus == 'connected').length,
      'pendingIncoming': _mockBuddies.where((b) => b.connectionStatus == 'pending-incoming').length,
      'pendingOutgoing': _mockBuddies.where((b) => b.connectionStatus == 'pending-outgoing').length,
      'suggested': _mockBuddies.where((b) => b.connectionStatus == 'suggested').length,
    };
  }
}