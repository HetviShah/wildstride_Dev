import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const SettingsScreen({Key? key, this.onBack}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic> _settings = {
    // Account settings
    'profileVisibility': 'public',
    'onlineStatus': true,
    
    // Privacy settings
    'locationSharing': true,
    'messageRequests': 'friends',
    'profileViewers': true,
    'activityStatus': true,
    
    // Notification settings
    'pushNotifications': true,
    'tripReminders': true,
    'messageNotifications': true,
    'safetyAlerts': true,
    'marketingEmails': false,
    
    // App settings
    'darkMode': false,
    'language': 'english',
    'units': 'metric',
    'autoDownload': true,
    'dataUsage': 'wifi-only',
    
    // Device permissions
    'camera': true,
    'microphone': true,
    'location': true,
    'contacts': false,
    'storage': true
  };

  void _updateSetting(String key, dynamic value) {
    setState(() {
      _settings[key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EB), // earth-sand/10
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFFA68A64).withOpacity(0.3), // earth-sand
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.arrow_back),
                  color: const Color(0xFF2D5016), // forest-green
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D5016), // forest-green
                        ),
                      ),
                      Text(
                        'Customize your Wildstride experience',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF6B7280), // mountain-gray
                        ),
                      ),
                    ],
                  ),
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
                  // Account Summary
                  _buildAccountSummary(),
                  const SizedBox(height: 24),

                  // Settings Sections
                  ..._buildSettingSections(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSummary() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: const Color(0xFFA68A64).withOpacity(0.3), // earth-sand
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: const Color(0xFFA68A64), // earth-sand
              child: Text(
                'JD',
                style: TextStyle(
                  color: const Color(0xFF2D5016), // forest-green
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jane Doe',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D5016), // forest-green
                    ),
                  ),
                  Text(
                    'jane.doe@example.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF6B7280), // mountain-gray
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7), // green-100
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified, size: 12, color: const Color(0xFF166534)), // green-700
                            const SizedBox(width: 4),
                            Text(
                              'Verified',
                              style: TextStyle(
                                fontSize: 12,
                                color: const Color(0xFF166534), // green-700
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7).withOpacity(0.8), // gold/20
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Level 7 Explorer',
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xFFB45309), // gold
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () => print('Edit profile'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: const Color(0xFFA68A64).withOpacity(0.5), // earth-sand
                ),
              ),
              child: const Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSettingSections() {
    final sections = [
      _buildAccountSettings(),
      _buildPrivacySettings(),
      _buildNotificationSettings(),
      _buildAppSettings(),
      _buildDevicePermissions(),
      _buildAdvancedSettings(),
      _buildAppInfo(),
    ];

    return sections
        .map((section) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: section,
            ))
        .toList();
  }

  Widget _buildAccountSettings() {
    return _buildSettingsCard(
      title: 'Account',
      icon: Icons.person,
      children: [
        _buildNavigationItem(
          title: 'Profile Information',
          description: 'Edit your name, bio, and interests',
          onTap: () => print('Edit profile'),
        ),
        _buildDivider(),
        _buildSelectItem(
          title: 'Profile Visibility',
          description: 'Who can see your profile',
          value: _settings['profileVisibility'],
          options: [
            {'value': 'public', 'label': 'Public'},
            {'value': 'friends', 'label': 'Friends Only'},
            {'value': 'private', 'label': 'Private'},
          ],
          onChanged: (value) => _updateSetting('profileVisibility', value),
        ),
        _buildDivider(),
        _buildSwitchItem(
          title: 'Show Online Status',
          description: 'Let others see when you\'re online',
          value: _settings['onlineStatus'],
          onChanged: (value) => _updateSetting('onlineStatus', value),
        ),
      ],
    );
  }

  Widget _buildPrivacySettings() {
    return _buildSettingsCard(
      title: 'Privacy & Safety',
      icon: Icons.security,
      children: [
        _buildSwitchItem(
          title: 'Location Sharing',
          description: 'Share your location with trip buddies',
          value: _settings['locationSharing'],
          onChanged: (value) => _updateSetting('locationSharing', value),
        ),
        _buildDivider(),
        _buildSelectItem(
          title: 'Message Requests',
          description: 'Who can send you messages',
          value: _settings['messageRequests'],
          options: [
            {'value': 'everyone', 'label': 'Everyone'},
            {'value': 'friends', 'label': 'Friends Only'},
            {'value': 'verified', 'label': 'Verified Users Only'},
          ],
          onChanged: (value) => _updateSetting('messageRequests', value),
        ),
        _buildDivider(),
        _buildSwitchItem(
          title: 'Profile Viewers',
          description: 'Show who viewed your profile',
          value: _settings['profileViewers'],
          onChanged: (value) => _updateSetting('profileViewers', value),
        ),
        _buildDivider(),
        _buildSwitchItem(
          title: 'Activity Status',
          description: 'Show your recent activity',
          value: _settings['activityStatus'],
          onChanged: (value) => _updateSetting('activityStatus', value),
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return _buildSettingsCard(
      title: 'Notifications',
      icon: Icons.notifications,
      children: [
        _buildSwitchItem(
          title: 'Push Notifications',
          description: 'Receive notifications on this device',
          value: _settings['pushNotifications'],
          onChanged: (value) => _updateSetting('pushNotifications', value),
        ),
        _buildDivider(),
        _buildSwitchItem(
          title: 'Trip Reminders',
          description: 'Reminders for upcoming trips',
          value: _settings['tripReminders'],
          onChanged: (value) => _updateSetting('tripReminders', value),
        ),
        _buildDivider(),
        _buildSwitchItem(
          title: 'Message Notifications',
          description: 'New message alerts',
          value: _settings['messageNotifications'],
          onChanged: (value) => _updateSetting('messageNotifications', value),
        ),
        _buildDivider(),
        _buildSwitchItem(
          title: 'Safety Alerts',
          description: 'Important safety notifications',
          value: _settings['safetyAlerts'],
          onChanged: (value) => _updateSetting('safetyAlerts', value),
          locked: true,
          lockReason: 'Required for safety',
        ),
        _buildDivider(),
        _buildSwitchItem(
          title: 'Marketing Emails',
          description: 'Promotional emails and updates',
          value: _settings['marketingEmails'],
          onChanged: (value) => _updateSetting('marketingEmails', value),
        ),
      ],
    );
  }

  Widget _buildAppSettings() {
    return _buildSettingsCard(
      title: 'App Preferences',
      icon: Icons.smartphone,
      children: [
        _buildSwitchItem(
          title: 'Dark Mode',
          description: 'Use dark theme for the app',
          value: _settings['darkMode'],
          onChanged: (value) => _updateSetting('darkMode', value),
        ),
        _buildDivider(),
        _buildSelectItem(
          title: 'Language',
          description: 'App display language',
          value: _settings['language'],
          options: [
            {'value': 'english', 'label': 'English'},
            {'value': 'french', 'label': 'Français'},
            {'value': 'spanish', 'label': 'Español'},
            {'value': 'mandarin', 'label': '中文'},
            {'value': 'german', 'label': 'Deutsch'},
          ],
          onChanged: (value) => _updateSetting('language', value),
        ),
        _buildDivider(),
        _buildSelectItem(
          title: 'Units',
          description: 'Distance and measurement units',
          value: _settings['units'],
          options: [
            {'value': 'metric', 'label': 'Metric (km, °C)'},
            {'value': 'imperial', 'label': 'Imperial (mi, °F)'},
          ],
          onChanged: (value) => _updateSetting('units', value),
        ),
        _buildDivider(),
        _buildSwitchItem(
          title: 'Auto-download Media',
          description: 'Automatically download photos and videos',
          value: _settings['autoDownload'],
          onChanged: (value) => _updateSetting('autoDownload', value),
        ),
        _buildDivider(),
        _buildSelectItem(
          title: 'Data Usage',
          description: 'Control when to download content',
          value: _settings['dataUsage'],
          options: [
            {'value': 'always', 'label': 'Always'},
            {'value': 'wifi-only', 'label': 'Wi-Fi Only'},
            {'value': 'never', 'label': 'Never'},
          ],
          onChanged: (value) => _updateSetting('dataUsage', value),
        ),
      ],
    );
  }

  Widget _buildDevicePermissions() {
    return _buildSettingsCard(
      title: 'Device Permissions',
      icon: Icons.lock,
      children: [
        _buildPermissionItem(
          icon: Icons.camera_alt,
          title: 'Camera',
          description: 'Take photos and videos',
          granted: _settings['camera'],
          color: const Color(0xFF0EA5E9), // sky-blue
        ),
        _buildDivider(),
        _buildPermissionItem(
          icon: Icons.navigation,
          title: 'Location',
          description: 'Safety features and trip tracking',
          granted: _settings['location'],
          color: const Color(0xFFEA580C), // fox-orange
        ),
        _buildDivider(),
        _buildPermissionItem(
          icon: Icons.mic,
          title: 'Microphone',
          description: 'Voice messages and calls',
          granted: _settings['microphone'],
          color: const Color(0xFF0EA5E9), // sky-blue
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0EA5E9).withOpacity(0.1), // sky-blue/10
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Permissions can be managed in your device settings. Some features may not work properly without required permissions.',
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFF6B7280), // mountain-gray
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedSettings() {
    return _buildSettingsCard(
      title: 'Advanced',
      children: [
        _buildNavigationItem(
          title: 'Download My Data',
          description: 'Get a copy of your data',
          icon: Icons.download,
          iconColor: const Color(0xFF0EA5E9), // sky-blue
          onTap: () => print('Download data'),
        ),
        _buildDivider(),
        _buildNavigationItem(
          title: 'Delete Account',
          description: 'Permanently delete your account',
          icon: Icons.delete,
          iconColor: const Color(0xFFDC2626), // lucky-red
          titleColor: const Color(0xFFDC2626), // lucky-red
          onTap: _showDeleteAccountDialog,
        ),
      ],
    );
  }

  Widget _buildAppInfo() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: const Color(0xFFA68A64).withOpacity(0.3), // earth-sand
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF2D5016), // forest-green
                    const Color(0xFFEA580C), // fox-orange
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  'W',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Wildstride',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D5016), // forest-green
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: const Color(0xFF6B7280), // mountain-gray
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => print('Privacy Policy'),
                  child: Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF6B7280), // mountain-gray
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => print('Terms of Service'),
                  child: Text(
                    'Terms of Service',
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF6B7280), // mountain-gray
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    IconData? icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: const Color(0xFFA68A64).withOpacity(0.3), // earth-sand
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null)
              Row(
                children: [
                  Icon(icon, size: 20, color: const Color(0xFF2D5016)),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D5016), // forest-green
                    ),
                  ),
                ],
              )
            else
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D5016), // forest-green
                ),
              ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required String title,
    required String description,
    required bool value,
    required Function(bool) onChanged,
    bool locked = false,
    String? lockReason,
  }) {
    return Row(
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
                      color: const Color(0xFF2D5016), // forest-green
                    ),
                  ),
                  if (locked) ...[
                    const SizedBox(width: 4),
                    Icon(Icons.lock, size: 12, color: const Color(0xFF6B7280)),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF6B7280), // mountain-gray
                ),
              ),
              if (locked && lockReason != null) ...[
                const SizedBox(height: 2),
                Text(
                  lockReason,
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFFEA580C), // fox-orange
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 16),
        Switch(
          value: value,
          onChanged: locked ? null : onChanged,
        ),
      ],
    );
  }

  Widget _buildSelectItem({
    required String title,
    required String description,
    required String value,
    required List<Map<String, String>> options,
    required Function(String) onChanged,
  }) {
    return Row(
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
                  color: const Color(0xFF2D5016), // forest-green
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF6B7280), // mountain-gray
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        DropdownButton<String>(
          value: value,
          onChanged: (newValue) => onChanged(newValue!),
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option['value'],
              child: Text(
                option['label']!,
                style: TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNavigationItem({
    required String title,
    required String description,
    IconData? icon,
    Color? iconColor,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: titleColor ?? const Color(0xFF2D5016), // forest-green
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF6B7280), // mountain-gray
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 16, color: const Color(0xFF6B7280)),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String description,
    required bool granted,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
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
                  color: const Color(0xFF2D5016), // forest-green
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF6B7280), // mountain-gray
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: granted
                ? const Color(0xFFDCFCE7) // green-100
                : const Color(0xFFFECACA), // red-100
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            granted ? 'Granted' : 'Denied',
            style: TextStyle(
              fontSize: 12,
              color: granted
                  ? const Color(0xFF166534) // green-700
                  : const Color(0xFFDC2626), // red-700
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(
        height: 1,
        color: const Color(0xFFA68A64).withOpacity(0.3), // earth-sand
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: const Color(0xFFDC2626)), // lucky-red
            const SizedBox(width: 8),
            Text(
              'Delete Account',
              style: TextStyle(
                color: const Color(0xFFDC2626), // lucky-red
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This action cannot be undone. This will permanently delete your account and remove all your data from our servers.'),
            const SizedBox(height: 16),
            Text('You will lose:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...[
              'All your trip history and photos',
              'Your buddy connections',
              'Achievement badges and progress',
              'All messages and conversations',
            ].map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text('• $item', style: TextStyle(fontSize: 12)),
            )).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              print('Delete account');
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626), // lucky-red
            ),
            child: Text(
              'Delete Account',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}