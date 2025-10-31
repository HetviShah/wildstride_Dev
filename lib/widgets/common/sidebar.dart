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
    MenuItem(icon: LucideIcons.history, label: 'Safety & Trust', screen: 'safetyandtrust'),
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
      // Clear any stored user data, tokens, etc.
      // You would implement your actual sign-out logic here
      
      // Show success message (you can use a snackbar or toast)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Signed out successfully',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: _getColor('#2D5A3D'), // forest-green
          duration: const Duration(seconds: 3),
        ),
      );
      
      // Close sidebar
      widget.onClose();
      
      // Call the parent sign out handler
      if (widget.onSignOut != null) {
        Future.delayed(const Duration(milliseconds: 100), () {
          widget.onSignOut!();
        });
      }
      
      print('User signed out successfully');
    } catch (error) {
      print('Error during sign out: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sign out failed. Please try again.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: _getColor('#DC2626'), // lucky-red
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
    return Drawer(
      width: 320, // Equivalent to w-80 (80 * 4 = 320px)
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: _getColor('#E8D7C9'), // earth-sand
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo on the left
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _getColor('#2D5A3D'), // forest-green
                            _getColor('#D97B29'), // fox-orange
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
                            fontSize: 14,
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
                        color: _getColor('#2D5A3D'), // forest-green
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),

                // ❌ Close (X) button on right
                InkWell(
                  onTap: widget.onClose,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Profile Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  _getColor('#2D5A3D'), // forest-green
                  _getColor('#D97B29'), // fox-orange
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
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://images.unsplash.com/photo-1575396565842-2fe193abbb56?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwcm9mZXNzaW9uYWwlMjBoZWFkc2hvdCUyMHdvbWFuJTIwb3V0ZG9vciUyMGFkdmVudHVyZXxlbnwxfHx8fDE3NTYzNjMwNDZ8MA&ixlib=rb-4.1.0&q=80&w=1080',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              'JD',
                              style: TextStyle(
                                color: _getColor('#2D5A3D'), // forest-green
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
                      Text(
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
                              color: _getColor('#B59F3B'), // gold
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Verified',
                              style: TextStyle(
                                color: _getColor('#2D5A3D'), // forest-green
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
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
                            child: Text(
                              '15 Streak',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
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

          // Menu Items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.history, color: Color(0xFF2D5A3D)),
                          title: const Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter',
                              color: Color(0xFF2D5A3D),
                            ),
                          ),
                          onTap: () {
                          _handleMenuItemClick('profile_screen');
                          },
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          minLeadingWidth: 24,
                        ),

                        ListTile(
                          leading: const Icon(Icons.safety_check, color: Color(0xFF2D5A3D)),
                          title: const Text(
                            'Safety & Trust',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter',
                              color: Color(0xFF2D5A3D),
                            ),
                          ),
                          onTap: () {
                            widget.onNavigate('safetyandtrust_screen');
                            widget.onClose();
                          },
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          minLeadingWidth: 24,
                        ),

                        ListTile(
                          leading: const Icon(Icons.history, color: Color(0xFF2D5A3D)),
                          title: const Text(
                            'History',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter',
                              color: Color(0xFF2D5A3D),
                            ),
                          ),
                          onTap: () {
                            _handleMenuItemClick('history_screen');
                          },
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          minLeadingWidth: 24,
                        ),
                        ListTile(
                          leading: const Icon(Icons.badge, color: Color(0xFF2D5A3D)),
                          title: const Text(
                            'Badges',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter',
                              color: Color(0xFF2D5A3D),
                            ),
                          ),
                          onTap: () {
                            _handleMenuItemClick('badges_screen');
                          },
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          minLeadingWidth: 24,
                        ),
                        ListTile(
                          leading: const Icon(Icons.help_outline, color: Color(0xFF2D5A3D)),
                          title: const Text(
                            'Help & Support',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter',
                              color: Color(0xFF2D5A3D),
                            ),
                          ),
                          onTap: () {
                            widget.onNavigate('support_screen');
                            widget.onClose();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.settings_outlined, color: Color(0xFF2D5A3D)),
                          title: const Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter',
                              color: Color(0xFF2D5A3D),
                            ),
                          ),
                          onTap: () {
                            widget.onNavigate('settings_screen');
                            widget.onClose();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.info_outline, color: Color(0xFF2D5A3D)),
                          title: const Text(
                            'About Us',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter',
                              color: Color(0xFF2D5A3D),
                            ),
                          ),
                          onTap: () {
                            widget.onNavigate('aboutus_screen');
                            widget.onClose();
                          },
                        ),
                      ],
                    ),
                  ),
                  // Sign Out Button - Separated at bottom
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: _getColor('#E8D7C9'), // earth-sand
                          width: 1,
                        ),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        LucideIcons.logOut,
                        size: 20,
                        color: _getColor('#DC2626'), // lucky-red
                      ),
                      title: Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter',
                          color: _getColor('#DC2626'), // lucky-red
                        ),
                      ),
                      onTap: _showSignOutConfirmation,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      minLeadingWidth: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: _getColor('#E8D7C9'), // earth-sand
                  width: 1,
                ),
              ),
            ),
            child: Text(
              'Wildstride v1.0.0',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Inter',
                color: _getColor('#6B7280'), // mountain-gray
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Sign Out Confirmation Dialog
  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Sign Out',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            color: _getColor('#2D5A3D'), // forest-green
            fontSize: 18,
          ),
        ),
        content: Text(
          'Are you sure you want to sign out of Wildstride? You\'ll need to sign back in to access your account.',
          style: TextStyle(
            fontFamily: 'Inter',
            color: _getColor('#6B7280'), // mountain-gray
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Inter',
                color: _getColor('#6B7280'), // mountain-gray
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleSignOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _getColor('#DC2626'), // lucky-red
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Sign Out',
              style: TextStyle(
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to convert hex color to Color
  Color _getColor(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}

class MenuItem {
  final IconData icon;
  final String label;
  final String screen;

  const MenuItem({
    required this.icon,
    required this.label,
    required this.screen,
  });
}