import 'package:flutter/material.dart';

class Trip {
  final int id;
  final String title;
  final String organizer;
  final String location;
  final String dates;
  final String duration;
  final int maxParticipants;
  final int currentParticipants;
  final String difficulty;
  final double price;
  final String image;
  final String description;
  final List<String> activities;
  final double rating;
  final bool isOpen;

  Trip({
    required this.id,
    required this.title,
    required this.organizer,
    required this.location,
    required this.dates,
    required this.duration,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.difficulty,
    required this.price,
    required this.image,
    required this.description,
    required this.activities,
    required this.rating,
    required this.isOpen,
  });

  Trip copyWith({
    int? id,
    String? title,
    String? organizer,
    String? location,
    String? dates,
    String? duration,
    int? maxParticipants,
    int? currentParticipants,
    String? difficulty,
    double? price,
    String? image,
    String? description,
    List<String>? activities,
    double? rating,
    bool? isOpen,
  }) {
    return Trip(
      id: id ?? this.id,
      title: title ?? this.title,
      organizer: organizer ?? this.organizer,
      location: location ?? this.location,
      dates: dates ?? this.dates,
      duration: duration ?? this.duration,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      currentParticipants: currentParticipants ?? this.currentParticipants,
      difficulty: difficulty ?? this.difficulty,
      price: price ?? this.price,
      image: image ?? this.image,
      description: description ?? this.description,
      activities: activities ?? this.activities,
      rating: rating ?? this.rating,
      isOpen: isOpen ?? this.isOpen,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'organizer': organizer,
      'location': location,
      'dates': dates,
      'duration': duration,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'difficulty': difficulty,
      'price': price,
      'image': image,
      'description': description,
      'activities': activities,
      'rating': rating,
      'isOpen': isOpen,
    };
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      title: json['title'],
      organizer: json['organizer'],
      location: json['location'],
      dates: json['dates'],
      duration: json['duration'],
      maxParticipants: json['maxParticipants'],
      currentParticipants: json['currentParticipants'],
      difficulty: json['difficulty'],
      price: json['price'].toDouble(),
      image: json['image'],
      description: json['description'],
      activities: List<String>.from(json['activities']),
      rating: json['rating'].toDouble(),
      isOpen: json['isOpen'],
    );
  }
}

class CreateTripForm {
  String title;
  String location;
  String startDate;
  String endDate;
  String maxParticipants;
  String difficulty;
  String price;
  String description;
  List<String> activities;

  CreateTripForm({
    this.title = '',
    this.location = '',
    this.startDate = '',
    this.endDate = '',
    this.maxParticipants = '',
    this.difficulty = 'Moderate',
    this.price = '',
    this.description = '',
    this.activities = const [],
  });

  CreateTripForm copyWith({
    String? title,
    String? location,
    String? startDate,
    String? endDate,
    String? maxParticipants,
    String? difficulty,
    String? price,
    String? description,
    List<String>? activities,
  }) {
    return CreateTripForm(
      title: title ?? this.title,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      difficulty: difficulty ?? this.difficulty,
      price: price ?? this.price,
      description: description ?? this.description,
      activities: activities ?? this.activities,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'location': location,
      'startDate': startDate,
      'endDate': endDate,
      'maxParticipants': maxParticipants,
      'difficulty': difficulty,
      'price': price,
      'description': description,
      'activities': activities,
    };
  }
}

// Helper methods
class TripHelpers {
  static String calculateDuration(String startDate, String endDate) {
    if (startDate.isEmpty || endDate.isEmpty) return '1 day';
    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);
    final diffDays = end.difference(start).inDays + 1;
    return diffDays == 1 ? '1 day' : '$diffDays days';
  }

  static String formatDateRange(String startDate, String endDate) {
    if (startDate.isEmpty || endDate.isEmpty) return 'TBD';
    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);
    
    final startMonth = _getMonthAbbreviation(start.month);
    final endMonth = _getMonthAbbreviation(end.month);
    
    if (startMonth == endMonth) {
      return '$startMonth ${start.day}-${end.day}, ${start.year}';
    } else {
      return '$startMonth ${start.day} - $endMonth ${end.day}, ${start.year}';
    }
  }

  static String _getMonthAbbreviation(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  static Color getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy': return Colors.green;
      case 'Moderate': return Colors.orange;
      case 'Hard': return Colors.red;
      default: return Colors.grey;
    }
  }
}