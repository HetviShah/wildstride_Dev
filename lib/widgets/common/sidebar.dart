import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wildstride_app/landinghomepage.dart';

class Sidebar extends StatefulWidget {
  final bool isOpen;
  final VoidCallback onClose;
  final Function(String) onNavigate;
  final VoidCallback? onSignOut;

  const Sidebar({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.onNavigate,
    this.onSignOut,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final List<MenuItem> _menuItems = [
    MenuItem(icon: LucideIcons.user, label: 'Profile', screen: 'profile'),
    MenuItem(icon: LucideIcons.shield, label: 'Safety & Trust', screen: 'safetyandtrust'),
    MenuItem(icon: LucideIcons.history, label: 'History', screen: 'history'),
    MenuItem(icon: LucideIcons.badge, label: 'Badges', screen: 'badges'),
    MenuItem(icon: LucideIcons.helpCircle, label: 'Support', screen: 'support'),
    MenuItem(icon: LucideIcons.settings, label: 'Settings', screen: 'settings'),
    MenuItem(icon: LucideIcons.info, label: 'About Us', screen: 'about-us'),
  ];

  void _handleMenuItemClick(String screen) {
    widget.onNavigate(screen);
    widget.onClose();
  }

  void _handleSignOut() {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Signed out successfully',
            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500),
          ),
          backgroundColor: _getColor('#2D5A3D'),
          duration: const Duration(seconds: 3),
        ),
      );

      widget.onClose();

      if (widget.onSignOut != null) {
        Future.delayed(const Duration(milliseconds: 100), () {
          widget.onSignOut!();
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Sign out failed. Please try again.',
            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500),
          ),
          backgroundColor: _getColor('#DC2626'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showSignOutConfirmation() {
    _showSignOutDialog();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea( // ✅ Fixes the overlap on Android/iOS
      child: Drawer(
        width: 320,
        backgroundColor: Colors.white,
        child: Column(
          children: [
            // ✅ Header section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: _getColor('#E8D7C9'),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo and text
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              _getColor('#2D5A3D'),
                              _getColor('#D97B29'),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'W',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Wildstride',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          color: _getColor('#2D5A3D'),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  // ❌ Close Button
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black87, size: 22),
                    onPressed: widget.onClose,
                    splashRadius: 24,
                  ),
                ],
              ),
            ),

            // ✅ Gradient Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    _getColor('#2D5A3D'),
                    _getColor('#D97B29'),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1575396565842-2fe193abbb56?auto=format&fit=crop&w=1080&q=80',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.white,
                            child: Center(
                              child: Text(
                                'JD',
                                style: TextStyle(
                                  color: _getColor('#2D5A3D'),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Jane Doe',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Explorer Level 7',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getColor('#B59F3B'),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Verified',
                                style: TextStyle(
                                  color: _getColor('#2D5A3D'),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '15 Streak',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  _buildMenuItem(LucideIcons.user, 'Profile', 'profile_screen'),
                  _buildMenuItem(LucideIcons.shield, 'Safety & Trust', 'safetyandtrust_screen'),
                  _buildMenuItem(LucideIcons.history, 'History', 'history_screen'),
                  _buildMenuItem(LucideIcons.badge, 'Badges', 'badges_screen'),
                  _buildMenuItem(LucideIcons.helpCircle, 'Help & Support', 'support_screen'),
                  _buildMenuItem(LucideIcons.settings, 'Settings', 'settings_screen'),
                  _buildMenuItem(LucideIcons.info, 'About Us', 'aboutus_screen'),
                  const Divider(height: 24),
                  ListTile(
                    leading: Icon(LucideIcons.logOut, color: _getColor('#DC2626')),
                    title: Text(
                      'Sign Out',
                      style: TextStyle(
                        color: _getColor('#DC2626'),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                    onTap: _showSignOutConfirmation,
                  ),
                ],
              ),
            ),

            // ✅ Footer Version
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Wildstride v1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Inter',
                  color: _getColor('#6B7280'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String screen) {
    return ListTile(
      leading: Icon(icon, color: _getColor('#2D5A3D')),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Inter',
          color: _getColor('#2D5A3D'),
        ),
      ),
      onTap: () => _handleMenuItemClick(screen),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    );
  }

  // Sign-out dialog
  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Sign Out',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            color: _getColor('#2D5A3D'),
            fontSize: 18,
          ),
        ),
        content: Text(
          'Are you sure you want to sign out of Wildstride?',
          style: TextStyle(
            fontFamily: 'Inter',
            color: _getColor('#6B7280'),
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: _getColor('#6B7280')),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleSignOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _getColor('#DC2626'),
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  Color _getColor(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) hexColor = "FF$hexColor";
    return Color(int.parse(hexColor, radix: 16));
  }
}

class MenuItem {
  final IconData icon;
  final String label;
  final String screen;
  const MenuItem({required this.icon, required this.label, required this.screen});
}