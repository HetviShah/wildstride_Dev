import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wildstride_app/models/buddy_finder/trip_model.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback? onTap;
  final VoidCallback? onJoin;
  final VoidCallback? onViewDetails;
  final bool canJoin;
  final bool isJoining;
  final bool isJoined;
  final bool isOwnTrip;
  final bool compact;

  const TripCard({
    Key? key,
    required this.trip,
    this.onTap,
    this.onJoin,
    this.onViewDetails,
    this.canJoin = false,
    this.isJoining = false,
    this.isJoined = false,
    this.isOwnTrip = false,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and organizer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      trip.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (trip.organizer == 'You')
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Your Trip',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Location and dates
              Row(
                children: [
                  Icon(LucideIcons.mapPin, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    trip.location,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(width: 16),
                  Icon(LucideIcons.calendar, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    trip.dates,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Activities chips
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: trip.activities.take(3).map((activity) => Chip(
                  label: Text(activity),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  labelStyle: const TextStyle(fontSize: 12),
                )).toList(),
              ),
              
              const SizedBox(height: 12),
              
              // Footer with participants, price, and actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Participants and price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${trip.currentParticipants}/${trip.maxParticipants} participants',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      Text(
                        '\$${trip.price} per person',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  
                  // Action buttons
                  if (!compact)
                    Row(
                      children: [
                        if (canJoin && !isJoined && !isJoining)
                          ElevatedButton(
                            onPressed: onJoin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            child: const Text('Join'),
                          ),
                        
                        if (isJoining)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        
                        if (isJoined)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(LucideIcons.check, size: 14, color: Colors.green[600]),
                                const SizedBox(width: 4),
                                Text(
                                  'Joined',
                                  style: TextStyle(
                                    color: Colors.green[600],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        
                        if (isOwnTrip)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(LucideIcons.users, size: 14, color: Colors.blue[600]),
                                const SizedBox(width: 4),
                                Text(
                                  'Managing',
                                  style: TextStyle(
                                    color: Colors.blue[600],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        
                        if (onViewDetails != null)
                          TextButton(
                            onPressed: onViewDetails,
                            child: const Text('Details'),
                          ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}