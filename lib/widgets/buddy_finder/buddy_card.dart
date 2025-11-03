import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wildstride_app/models/buddy_finder/buddy_model.dart';

class BuddyCard extends StatelessWidget {
  final Buddy? buddy; // Made nullable
  final VoidCallback? onTap;
  final VoidCallback? onConnect;
  final VoidCallback? onMessage;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final bool showActions;
  final bool compact;

  const BuddyCard({
    super.key,
    required this.buddy, // Still required but can be null
    this.onTap,
    this.onConnect,
    this.onMessage,
    this.onAccept,
    this.onDecline,
    this.showActions = true,
    this.compact = false,
  });

  // Add a loading state or empty state
  Widget _buildLoadingState() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(radius: 30, child: Icon(LucideIcons.user)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 16,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 80,
                    height: 12,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSafetyStatusColor(String status) {
    switch (status) {
      case 'safe': return Colors.green;
      case 'active': return Colors.blue;
      case 'checking-in': return Colors.yellow;
      default: return Colors.grey;
    }
  }

  Color _getTrustScoreColor(int score) {
    if (score >= 95) return Colors.green;
    if (score >= 85) return Colors.blue;
    if (score >= 70) return Colors.yellow;
    return Colors.red;
  }

  String _getConnectionButtonText(String status) {
    switch (status) {
      case 'connected': return 'Message';
      case 'suggested': return 'Connect';
      case 'pending-outgoing': return 'Request Sent';
      case 'pending-incoming': return 'Respond';
      default: return 'Connect';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Handle null buddy
    if (buddy == null) {
      return _buildLoadingState();
    }

    if (compact) {
      return _buildCompactCard(context);
    }
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildDetails(),
              if (showActions) ...[
                const SizedBox(height: 12),
                _buildActions(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildAvatar(40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNameAndVerification(),
                    const SizedBox(height: 4),
                    _buildLocation(),
                  ],
                ),
              ),
              if (showActions) _buildCompactActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _buildAvatar(60),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNameAndVerification(),
              const SizedBox(height: 4),
              _buildLocation(),
              const SizedBox(height: 4),
              _buildStats(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(double size) {
    return Stack(
      children: [
        CircleAvatar(
          radius: size / 2,
          backgroundImage: buddy!.avatar.isNotEmpty 
              ? NetworkImage(buddy!.avatar) 
              : null,
          child: buddy!.avatar.isEmpty 
              ? Icon(LucideIcons.user, size: size * 0.6) 
              : null,
        ),
        if (buddy!.isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: size * 0.25,
            height: size * 0.25,
            decoration: BoxDecoration(
              color: _getSafetyStatusColor(buddy!.safetyStatus),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameAndVerification() {
    return Row(
      children: [
        Text(
          buddy!.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green[900],
          ),
        ),
        if (buddy!.isVerified) ...[
          const SizedBox(width: 4),
          Icon(LucideIcons.shield, size: 14, color: Colors.blue),
        ],
      ],
    );
  }

  Widget _buildLocation() {
    return Row(
      children: [
        Icon(LucideIcons.mapPin, size: 12, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          buddy!.location,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Text(
          '${buddy!.completedTrips} trips',
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        const Text(' • ', style: TextStyle(fontSize: 11, color: Colors.grey)),
        Text(
          '${buddy!.trustScore}% trust',
          style: TextStyle(
            fontSize: 11,
            color: _getTrustScoreColor(buddy!.trustScore),
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(' • ', style: TextStyle(fontSize: 11, color: Colors.grey)),
        Text(
          buddy!.lastSeen,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (buddy!.interests.isNotEmpty) ...[
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: buddy!.interests.take(3).map((interest) => Chip(
              label: Text(interest, style: const TextStyle(fontSize: 10)),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            )).toList(),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _buildActions() {
    if (buddy!.connectionStatus == 'pending-incoming') {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onAccept,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.check, size: 14),
                  SizedBox(width: 4),
                  Text('Accept'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: onDecline,
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.x, size: 14),
                  SizedBox(width: 4),
                  Text('Decline'),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onTap,
            child: const Text('View Profile'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: _getMainAction(),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getButtonColor(),
            ),
            child: Text(_getConnectionButtonText(buddy!.connectionStatus)),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactActions() {
    return SizedBox(
      width: 100,
      child: ElevatedButton(
        onPressed: _getMainAction(),
        style: ElevatedButton.styleFrom(
          backgroundColor: _getButtonColor(),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        child: Text(
          _getConnectionButtonText(buddy!.connectionStatus),
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  VoidCallback? _getMainAction() {
    switch (buddy!.connectionStatus) {
      case 'connected': return onMessage;
      case 'suggested': return onConnect;
      case 'pending-outgoing': return null;
      case 'pending-incoming': return null;
      default: return onConnect;
    }
  }

  Color _getButtonColor() {
    switch (buddy!.connectionStatus) {
      case 'connected': return Colors.green;
      case 'suggested': return Colors.orange;
      case 'pending-outgoing': return Colors.grey;
      case 'pending-incoming': return Colors.grey;
      default: return Colors.orange;
    }
  }
}