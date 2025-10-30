import 'package:flutter/material.dart';
import 'dart:async';

class CallScreen extends StatefulWidget {
  final VoidCallback? onEndCall;
  final VoidCallback? onBackToMessages;
  final VoidCallback? onVideoCall;

  const CallScreen({
    super.key,
    this.onEndCall,
    this.onBackToMessages,
    this.onVideoCall,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  bool _isOnHold = false;
  bool _showMoreOptions = false;
  int _callDuration = 0;
  CallStatus _callStatus = CallStatus.connecting;
  Timer? _durationTimer;

  @override
  void initState() {
    super.initState();
    
    // Simulate call connection after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _callStatus = CallStatus.connected;
        });
        _startDurationTimer();
      }
    });
  }

  @override
  void dispose() {
    _durationTimer?.cancel();
    super.dispose();
  }

  void _startDurationTimer() {
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _callDuration++;
        });
      }
    });
  }

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _handleEndCall() {
    _durationTimer?.cancel();
    setState(() {
      _callStatus = CallStatus.ended;
    });
    widget.onEndCall?.call();
  }

  void _handleAddCaller() {
    // In a real app, this would open a contact picker or dial screen
    print('Add caller functionality');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Caller feature clicked!')),
    );
  }

  void _handleVideoCall() {
    print('Video call feature clicked!');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Switching to Video Call!')),
    );
    widget.onVideoCall?.call();
  }

  void _handleHold() {
    setState(() {
      _isOnHold = !_isOnHold;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E8B57), // forest-green
      body: Stack(
        children: [
          // Background Pattern
          _buildBackgroundPattern(),
          
          // Main Content
          Column(
            children: [
              // Header
              _buildHeader(),
              
              // Caller Info
              Expanded(
                child: _buildCallerInfo(),
              ),
              
              // Call Controls
              _buildCallControls(),
            ],
          ),
          
          // Call Status Indicator
          if (_callStatus == CallStatus.connected)
            _buildConnectedStatusIndicator(),
        ],
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.1,
        child: Stack(
          children: [
            Positioned(
              top: 80,
              left: 40,
              child: Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
              ),
            ),
            Positioned(
              top: 160,
              right: 32,
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
              ),
            ),
            Positioned(
              bottom: 160,
              left: 24,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Column(
        children: [
          Text(
            _getCallStatusText(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (_callStatus == CallStatus.connected)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _formatDuration(_callDuration),
                style: const TextStyle(
                  color: Color(0xE6FFFFFF), // Equivalent to white90
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getCallStatusText() {
    switch (_callStatus) {
      case CallStatus.connecting:
        return 'Connecting...';
      case CallStatus.connected:
        return _isOnHold ? 'Call On Hold' : 'Voice Call';
      case CallStatus.ended:
        return 'Call Ended';
    }
  }

  Widget _buildCallerInfo() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Avatar
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 4),
              boxShadow: [
                BoxShadow(
                  blurRadius: 16,
                  color: Colors.black.withOpacity(0.3),
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundImage: const NetworkImage(
                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx0cmF2ZWwlMjBhZHZlbnR1cmUlMjBtYW58ZW58MXx8fHwxNzU2MzYzMTY5fDA&ixlib=rb-4.1.0&q=80&w=1080',
              ),
              child: const Text('MJ'), // Fallback
            ),
          ),
          const SizedBox(height: 24),
          
          // Name and Info
          const Text(
            'Marcus Johnson',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Adventure Buddy',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          
          // Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700), // gold
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Verified Explorer',
                  style: TextStyle(
                    color: Color(0xFF2E8B57), // forest-green
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Level 9',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          // Connecting Indicator
          if (_callStatus == CallStatus.connecting)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 4,
                      ),
                    ),
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Calling...',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCallControls() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.4),
            Colors.black.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          // Primary Controls Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(
                icon: _isMuted ? Icons.mic_off : Icons.mic,
                isActive: _isMuted,
                activeColor: const Color(0xFFDC143C), // lucky-red
                onPressed: () => setState(() => _isMuted = !_isMuted),
              ),
              const SizedBox(width: 16),
              _buildControlButton(
                icon: _isOnHold ? Icons.play_arrow : Icons.pause,
                isActive: _isOnHold,
                activeColor: const Color(0xFFFFD700), // gold
                onPressed: _handleHold,
              ),
              const SizedBox(width: 16),
              _buildEndCallButton(),
              const SizedBox(width: 16),
              _buildControlButton(
                icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                isActive: _isSpeakerOn,
                activeColor: const Color(0xFFFF8C00), // fox-orange
                onPressed: () => setState(() => _isSpeakerOn = !_isSpeakerOn),
              ),
              const SizedBox(width: 16),
              _buildControlButton(
                icon: Icons.videocam,
                isActive: false,
                onPressed: _handleVideoCall,
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Secondary Controls Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextButton(
                icon: Icons.person_add,
                text: 'Add Caller',
                onPressed: _handleAddCaller,
              ),
              const SizedBox(width: 16),
              _buildTextButton(
                icon: Icons.message,
                text: 'Message',
                onPressed: widget.onBackToMessages,
              ),
              const SizedBox(width: 16),
              _buildMoreOptionsButton(),
            ],
          ),
          const SizedBox(height: 16),
          
          // Call Status Indicators
          _buildStatusIndicators(),
          const SizedBox(height: 16),
          
          // More Options Panel
          if (_showMoreOptions) _buildMoreOptionsPanel(),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    Color? activeColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: isActive 
            ? activeColor ?? Colors.white
            : Colors.black.withOpacity(0.5),
        border: Border.all(
          color: isActive 
              ? activeColor ?? Colors.white
              : Colors.white.withOpacity(0.5),
          width: 2,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            blurRadius: isActive ? 8 : 4,
            color: Colors.black.withOpacity(0.3),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 24),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildEndCallButton() {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        color: Color(0xFFDC143C), // lucky-red
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            color: Colors.black45,
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.call_end, color: Colors.white, size: 28),
        onPressed: _handleEndCall,
      ),
    );
  }

  Widget _buildTextButton({
    required IconData icon,
    required String text,
    required VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        border: Border.all(color: Colors.white.withOpacity(0.6)),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(blurRadius: 8, color: Colors.black26),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 8),
            Text(text),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreOptionsButton() {
    return Container(
      decoration: BoxDecoration(
        color: _showMoreOptions 
            ? const Color(0xFFFF8C00) // fox-orange
            : Colors.black.withOpacity(0.6),
        border: Border.all(
          color: _showMoreOptions 
              ? const Color(0xFFFF8C00)
              : Colors.white.withOpacity(0.6),
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            blurRadius: _showMoreOptions ? 16 : 8,
            color: Colors.black.withOpacity(0.3),
          ),
        ],
      ),
      child: TextButton(
        onPressed: () => setState(() => _showMoreOptions = !_showMoreOptions),
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: const Row(
          children: [
            Icon(Icons.more_horiz, size: 16),
            SizedBox(width: 8),
            Text('More'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicators() {
    final indicators = <Widget>[];
    
    if (_isMuted) {
      indicators.add(_buildStatusIndicatorItem(Icons.mic_off, 'Muted'));
    }
    if (_isSpeakerOn) {
      indicators.add(_buildStatusIndicatorItem(Icons.volume_up, 'Speaker'));
    }
    if (_isOnHold) {
      indicators.add(_buildStatusIndicatorItem(Icons.pause, 'On Hold'));
    }
    
    if (indicators.isEmpty) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: indicators.expand((widget) => [widget, const SizedBox(width: 16)]).toList()
          ..removeLast(), // Remove last spacer
      ),
    );
  }

  Widget _buildStatusIndicatorItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.white70),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMoreOptionsPanel() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
        boxShadow: const [
          BoxShadow(blurRadius: 16, color: Colors.black45),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildOptionButton(Icons.dialpad, 'Keypad', () {
            print('Open keypad');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Keypad feature clicked!')),
            );
          }),
          _buildOptionButton(Icons.person, 'Contact', () {
            print('View contact');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('View Contact feature clicked!')),
            );
          }),
          _buildOptionButton(Icons.fiber_manual_record, 'Record', () {
            print('Record call');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Record Call feature clicked!')),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOptionButton(IconData icon, String text, VoidCallback onPressed) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildConnectedStatusIndicator() {
    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFFFD700), // gold
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Connected',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum CallStatus {
  connecting,
  connected,
  ended,
}