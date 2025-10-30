import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OptionsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const OptionsScreen({super.key, this.onBack});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  final Map<String, bool> _callSettings = {
    'autoAnswer': false,
    'vibrationEnabled': true,
    'soundEnabled': true,
    'videoAutoStart': true,
    'hdVideoEnabled': false,
    'dataSaverMode': false,
  };

  final Map<String, bool> _notificationSettings = {
    'incomingCalls': true,
    'missedCalls': true,
    'messageNotifications': true,
    'buddyRequests': true,
    'tripUpdates': true,
    'emergencyAlerts': true,
  };

  final Map<String, bool> _privacySettings = {
    'showOnlineStatus': true,
    'allowCallsFromAnyone': false,
    'shareLocationDuringCall': true,
    'recordCallHistory': true,
  };

  String _callQuality = 'standard';

  void _updateCallSetting(String key, bool value) {
    setState(() {
      _callSettings[key] = value;
    });
  }

  void _updateNotificationSetting(String key, bool value) {
    setState(() {
      _notificationSettings[key] = value;
    });
  }

  void _updatePrivacySetting(String key, bool value) {
    setState(() {
      _privacySettings[key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6).withOpacity(0.1),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  onPressed: widget.onBack,
                  icon: const Icon(LucideIcons.arrowLeft),
                  color: const Color(0xFF003B2E),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Communication Options',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF003B2E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Manage your call and messaging preferences',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Call Settings
                  _buildSettingsCard(
                    icon: LucideIcons.phone,
                    title: 'Call Settings',
                    children: [
                      _buildSettingSwitch(
                        title: 'Auto-answer calls',
                        subtitle: 'Automatically answer calls from verified buddies',
                        value: _callSettings['autoAnswer']!,
                        onChanged: (value) => _updateCallSetting('autoAnswer', value),
                      ),
                      const Divider(height: 24),
                      _buildSettingSwitch(
                        title: 'Vibration',
                        subtitle: 'Vibrate on incoming calls',
                        value: _callSettings['vibrationEnabled']!,
                        onChanged: (value) => _updateCallSetting('vibrationEnabled', value),
                      ),
                      const Divider(height: 24),
                      _buildSettingSwitch(
                        title: 'Call sounds',
                        subtitle: 'Play sounds for calls and notifications',
                        value: _callSettings['soundEnabled']!,
                        onChanged: (value) => _updateCallSetting('soundEnabled', value),
                      ),
                      const Divider(height: 24),
                      _buildCallQualitySelector(),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Video Call Settings
                  _buildSettingsCard(
                    icon: LucideIcons.video,
                    title: 'Video Call Settings',
                    children: [
                      _buildSettingSwitch(
                        title: 'Start video automatically',
                        subtitle: 'Turn on camera when starting video calls',
                        value: _callSettings['videoAutoStart']!,
                        onChanged: (value) => _updateCallSetting('videoAutoStart', value),
                      ),
                      const Divider(height: 24),
                      _buildSettingSwitchWithBadge(
                        title: 'HD Video',
                        subtitle: 'Enable high-definition video calls',
                        value: _callSettings['hdVideoEnabled']!,
                        onChanged: (value) => _updateCallSetting('hdVideoEnabled', value),
                        badgeText: 'Premium',
                        badgeColor: const Color(0xFFE66A00),
                      ),
                      const Divider(height: 24),
                      _buildSettingSwitch(
                        title: 'Data saver mode',
                        subtitle: 'Reduce video quality to save data',
                        value: _callSettings['dataSaverMode']!,
                        onChanged: (value) => _updateCallSetting('dataSaverMode', value),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Notification Settings
                  _buildSettingsCard(
                    icon: LucideIcons.bell,
                    title: 'Notifications',
                    children: [
                      _buildSettingSwitch(
                        title: 'Incoming calls',
                        subtitle: 'Show notifications for incoming calls',
                        value: _notificationSettings['incomingCalls']!,
                        onChanged: (value) => _updateNotificationSetting('incomingCalls', value),
                      ),
                      const Divider(height: 24),
                      _buildSettingSwitch(
                        title: 'Missed calls',
                        subtitle: 'Notify about missed calls',
                        value: _notificationSettings['missedCalls']!,
                        onChanged: (value) => _updateNotificationSetting('missedCalls', value),
                      ),
                      const Divider(height: 24),
                      _buildAlwaysOnSetting(
                        title: 'Emergency alerts',
                        subtitle: 'Critical SOS and safety notifications',
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Privacy & Security
                  _buildSettingsCard(
                    icon: LucideIcons.shield,
                    title: 'Privacy & Security',
                    children: [
                      _buildSettingSwitch(
                        title: 'Show online status',
                        subtitle: 'Let buddies see when you\'re online',
                        value: _privacySettings['showOnlineStatus']!,
                        onChanged: (value) => _updatePrivacySetting('showOnlineStatus', value),
                      ),
                      const Divider(height: 24),
                      _buildSettingSwitch(
                        title: 'Allow calls from anyone',
                        subtitle: 'Accept calls from non-buddies',
                        value: _privacySettings['allowCallsFromAnyone']!,
                        onChanged: (value) => _updatePrivacySetting('allowCallsFromAnyone', value),
                      ),
                      const Divider(height: 24),
                      _buildSettingSwitch(
                        title: 'Share location during calls',
                        subtitle: 'Share your location for safety',
                        value: _privacySettings['shareLocationDuringCall']!,
                        onChanged: (value) => _updatePrivacySetting('shareLocationDuringCall', value),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Device Permissions
                  _buildSettingsCard(
                    icon: LucideIcons.camera,
                    title: 'Device Permissions',
                    children: [
                      _buildPermissionItem(
                        icon: LucideIcons.camera,
                        title: 'Camera',
                        subtitle: 'Required for video calls',
                        status: 'Granted',
                      ),
                      const SizedBox(height: 12),
                      _buildPermissionItem(
                        icon: LucideIcons.mic,
                        title: 'Microphone',
                        subtitle: 'Required for voice calls',
                        status: 'Granted',
                      ),
                      const SizedBox(height: 12),
                      _buildPermissionItem(
                        icon: LucideIcons.bell,
                        title: 'Notifications',
                        subtitle: 'For call alerts',
                        status: 'Granted',
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // About
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: const Color(0xFFD9C7A7).withOpacity(0.3)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            'Wildstride Communication v2.1.0',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Encrypted calls • Global connectivity • Adventure-ready',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildFeatureIndicator(
                                color: const Color(0xFFFFD700),
                                text: 'Encrypted',
                              ),
                              const SizedBox(width: 16),
                              _buildFeatureIndicator(
                                color: const Color(0xFF87CEEB),
                                text: 'HD Ready',
                              ),
                              const SizedBox(width: 16),
                              _buildFeatureIndicator(
                                color: const Color(0xFFE66A00),
                                text: 'Global',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: const Color(0xFFD9C7A7).withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: const Color(0xFF003B2E)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF003B2E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF003B2E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSettingSwitchWithBadge({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required String badgeText,
    required Color badgeColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF003B2E),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: badgeColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildAlwaysOnSetting({
    required String title,
    required String subtitle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF003B2E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFD72638).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Always On',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFD72638),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(LucideIcons.check, size: 16, color: const Color(0xFFD72638)),
          ],
        ),
      ],
    );
  }

  Widget _buildCallQualitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Call quality',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF003B2E),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFD9C7A7)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _callQuality,
              isExpanded: true,
              items: [
                DropdownMenuItem(
                  value: 'low',
                  child: Text('Low (Data saver)'),
                ),
                DropdownMenuItem(
                  value: 'standard',
                  child: Text('Standard'),
                ),
                DropdownMenuItem(
                  value: 'high',
                  child: Text('High quality'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _callQuality = value!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0E6).withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF003B2E)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003B2E),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700).withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFFFD700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureIndicator({
    required Color color,
    required String text,
  }) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}