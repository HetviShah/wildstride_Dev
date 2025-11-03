class Buddy {
  final int id;
  final String name;
  final String avatar;
  final String location;
  final bool isOnline;
  final bool isVerified;
  final int trustScore;
  final int mutualConnections;
  final int completedTrips;
  final String lastSeen;
  final String bio;
  final List<String> interests;
  final List<String> languages;
  final NextTrip? nextTrip;
  final List<String> badges;
  final String safetyStatus;
  final String connectionStatus;

  Buddy({
    required this.id,
    required this.name,
    required this.avatar,
    required this.location,
    required this.isOnline,
    required this.isVerified,
    required this.trustScore,
    required this.mutualConnections,
    required this.completedTrips,
    required this.lastSeen,
    required this.bio,
    required this.interests,
    required this.languages,
    this.nextTrip,
    required this.badges,
    required this.safetyStatus,
    required this.connectionStatus,
  });

  Buddy copyWith({
    int? id,
    String? name,
    String? avatar,
    String? location,
    bool? isOnline,
    bool? isVerified,
    int? trustScore,
    int? mutualConnections,
    int? completedTrips,
    String? lastSeen,
    String? bio,
    List<String>? interests,
    List<String>? languages,
    NextTrip? nextTrip,
    List<String>? badges,
    String? safetyStatus,
    String? connectionStatus,
  }) {
    return Buddy(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      location: location ?? this.location,
      isOnline: isOnline ?? this.isOnline,
      isVerified: isVerified ?? this.isVerified,
      trustScore: trustScore ?? this.trustScore,
      mutualConnections: mutualConnections ?? this.mutualConnections,
      completedTrips: completedTrips ?? this.completedTrips,
      lastSeen: lastSeen ?? this.lastSeen,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      languages: languages ?? this.languages,
      nextTrip: nextTrip ?? this.nextTrip,
      badges: badges ?? this.badges,
      safetyStatus: safetyStatus ?? this.safetyStatus,
      connectionStatus: connectionStatus ?? this.connectionStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'location': location,
      'isOnline': isOnline,
      'isVerified': isVerified,
      'trustScore': trustScore,
      'mutualConnections': mutualConnections,
      'completedTrips': completedTrips,
      'lastSeen': lastSeen,
      'bio': bio,
      'interests': interests,
      'languages': languages,
      'nextTrip': nextTrip?.toJson(),
      'badges': badges,
      'safetyStatus': safetyStatus,
      'connectionStatus': connectionStatus,
    };
  }

  factory Buddy.fromJson(Map<String, dynamic> json) {
    return Buddy(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      location: json['location'],
      isOnline: json['isOnline'],
      isVerified: json['isVerified'],
      trustScore: json['trustScore'],
      mutualConnections: json['mutualConnections'],
      completedTrips: json['completedTrips'],
      lastSeen: json['lastSeen'],
      bio: json['bio'],
      interests: List<String>.from(json['interests']),
      languages: List<String>.from(json['languages']),
      nextTrip: json['nextTrip'] != null ? NextTrip.fromJson(json['nextTrip']) : null,
      badges: List<String>.from(json['badges']),
      safetyStatus: json['safetyStatus'],
      connectionStatus: json['connectionStatus'],
    );
  }
}

class NextTrip {
  final String destination;
  final String dates;

  NextTrip({required this.destination, required this.dates});

  NextTrip copyWith({
    String? destination,
    String? dates,
  }) {
    return NextTrip(
      destination: destination ?? this.destination,
      dates: dates ?? this.dates,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'destination': destination,
      'dates': dates,
    };
  }

  factory NextTrip.fromJson(Map<String, dynamic> json) {
    return NextTrip(
      destination: json['destination'],
      dates: json['dates'],
    );
  }
}