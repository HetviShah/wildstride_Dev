import 'package:flutter/material.dart';
import 'dart:async';

class VideoCallScreen extends StatefulWidget {
  final VoidCallback? onEndCall;
  final VoidCallback? onBackToMessages;
  final VoidCallback? onSwitchToAudio;

  const VideoCallScreen({
    super.key,
    this.onEndCall,
    this.onBackToMessages,
    this.onSwitchToAudio,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isMuted = false;
  bool _isVideoOn = true;
  int _callDuration = 0;
  CallStatus _callStatus = CallStatus.connecting;
  bool _isFullscreen = false;
  Timer? _durationTimer;

  @override
  void initState() {
    super.initState();
    // Simulate call connection after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _callStatus = CallStatus.connected;
      });
      _startDurationTimer();
    });
  }

  @override
  void dispose() {
    _durationTimer?.cancel();
    super.dispose();
  }

  void _startDurationTimer() {
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _callDuration++;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Main Video Area
            Expanded(
              child: Stack(
                children: [
                  // Remote Video (Main)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF228B22).withOpacity(0.8),
                          const Color(0xFF228B22),
                        ],
                      ),
                    ),
                    child: _callStatus == CallStatus.connecting
                        ? _buildConnectingView()
                        : _buildConnectedVideoView(),
                  ),

                  // Call Info Overlay
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFD700),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _callStatus == CallStatus.connecting
                                    ? 'Connecting...'
                                    : _formatDuration(_callDuration),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isFullscreen = !_isFullscreen;
                            });
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.7),
                            shape: const CircleBorder(),
                          ),
                          icon: const Icon(
                            Icons.fullscreen,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Local Video (Picture-in-Picture)
                  Positioned(
                    top: 80,
                    right: 16,
                    child: Container(
                      width: 96,
                      height: 128,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.2), width: 2),
                      ),
                      child: _isVideoOn
                          ? Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFFD2B48C),
                                    // Fixed: Use .withValues() instead of .withOpacity()
                                    Color.fromRGBO(255, 127, 80, 0.2),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Your Video',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : Container(
                              color: const Color(0xFF808080),
                              child: Icon(
                                Icons.videocam_off,
                                color: Colors.white.withOpacity(0.6),
                                size: 24,
                              ),
                            ),
                    ),
                  ),

                  // Caller Info Overlay (when video is off)
                  if (!_isVideoOn && _callStatus == CallStatus.connected)
                    Container(
                      // Fixed: Use Color.fromRGBO instead of .withOpacity()
                      color: const Color(0xFF228B22).withOpacity(0.9),
                      child: _buildCallerInfoView(),
                    ),

                  // Connection Quality Indicator
                  if (_callStatus == CallStatus.connected)
                    Positioned(
                      bottom: 96,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            _buildConnectionBar(0.8),
                            _buildConnectionBar(0.8),
                            _buildConnectionBar(0.8),
                            _buildConnectionBar(0.3),
                            const SizedBox(width: 8),
                            Text(
                              'Good',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Call Controls
            Container(
              color: Colors.black.withOpacity(0.95),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildControlButton(
                        icon: _isMuted ? Icons.mic_off : Icons.mic,
                        label: _isMuted ? 'Muted' : 'Mic',
                        isActive: !_isMuted,
                        isDanger: _isMuted,
                        onPressed: () {
                          setState(() {
                            _isMuted = !_isMuted;
                          });
                        },
                        isEnabled: _callStatus == CallStatus.connected,
                      ),
                      _buildControlButton(
                        icon: _isVideoOn ? Icons.videocam : Icons.videocam_off,
                        label: _isVideoOn ? 'Video' : 'Off',
                        isActive: _isVideoOn,
                        isDanger: !_isVideoOn,
                        onPressed: () {
                          setState(() {
                            _isVideoOn = !_isVideoOn;
                          });
                        },
                        isEnabled: _callStatus == CallStatus.connected,
                      ),
                      _buildControlButton(
                        icon: Icons.phone,
                        label: 'Audio',
                        onPressed: widget.onSwitchToAudio,
                        isEnabled: _callStatus == CallStatus.connected,
                      ),
                      _buildEndCallButton(),
                      _buildControlButton(
                        icon: Icons.flip_camera_ios,
                        label: 'Flip',
                        onPressed: () {
                          print('Camera flip clicked');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Camera flip feature clicked!'),
                            ),
                          );
                        },
                        isEnabled: _callStatus == CallStatus.connected && _isVideoOn,
                      ),
                      _buildControlButton(
                        icon: Icons.chat_bubble_outline,
                        label: 'Chat',
                        onPressed: widget.onBackToMessages,
                      ),
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

  Widget _buildConnectingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 4),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.network(
                'https://images.unsplash.com/photo-1669986480140-2c90b8edb443?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx0cmF2ZWwlMjBhZHZlbnR1cmUlMjBtYW58ZW58MXx8fHwxNzU2MzY1NTkwfDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFFF7F50),
                    child: const Center(
                      child: Text(
                        'MJ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Marcus Johnson',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 4),
              shape: BoxShape.circle,
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.3)),
              strokeWidth: 4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Connecting video call...',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectedVideoView() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            // Fixed: Use Color.fromRGBO instead of .withOpacity() in constant expressions
            Color.fromRGBO(135, 206, 235, 0.2),
            Color.fromRGBO(34, 139, 34, 0.4),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              "Marcus Johnson's Video",
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallerInfoView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 4),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.network(
                'https://images.unsplash.com/photo-1669986480140-2c90b8edb443?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx0cmF2ZWwlMjBhZHZlbnR1cmUlMjBtYW58ZW58MXx8fHwxNzU2MzY1NTkwfDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFFF7F50),
                    child: const Center(
                      child: Text(
                        'MJ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Marcus Johnson',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Verified Explorer',
              style: TextStyle(
                color: Color(0xFF228B22),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Camera is off',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionBar(double heightFactor) {
    return Container(
      width: 2,
      height: 12 * heightFactor,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: heightFactor > 0.5 ? const Color(0xFFFFD700) : Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    VoidCallback? onPressed,
    bool isEnabled = true,
    bool isActive = true,
    bool isDanger = false,
  }) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          margin: const EdgeInsets.all(4),
          child: IconButton(
            onPressed: isEnabled ? onPressed : null,
            style: IconButton.styleFrom(
              backgroundColor: isDanger
                  ? const Color(0xFFDC3545)
                  : Colors.black.withOpacity(0.6),
              shape: const CircleBorder(),
              side: BorderSide(
                color: isDanger
                    ? const Color(0xFFDC3545)
                    : Colors.white.withOpacity(0.6),
                width: 2,
              ),
            ),
            icon: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEndCallButton() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          margin: const EdgeInsets.all(4),
          child: IconButton(
            onPressed: _handleEndCall,
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFDC3545),
              shape: const CircleBorder(),
            ),
            icon: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
        Text(
          'End Call',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

enum CallStatus {
  connecting,
  connected,
  ended,
}