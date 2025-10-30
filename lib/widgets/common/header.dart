import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Header extends StatelessWidget {
  final VoidCallback onMenuClick;
  final VoidCallback onSOSClick;
  final Function(String)? onNavigate;

  const Header({
    super.key,
    required this.onMenuClick,
    required this.onSOSClick,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Container(
        height: 68,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: _getColor('#E8D7C9'), // earth-sand
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // ✅ fixes alignment
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ Left: Profile Avatar
            GestureDetector(
              onTap: onMenuClick,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getColor('#2D5A3D').withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://images.unsplash.com/photo-1575396565842-2fe193abbb56?auto=format&fit=crop&w=150&q=80',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: _getColor('#E8D7C9'),
                        child: Center(
                          child: Text(
                            'W',
                            style: TextStyle(
                              color: _getColor('#2D5A3D'),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // ✅ Center: Wildstride logo (flexible for web)
            Flexible(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getColor('#2D5A3D'),
                          _getColor('#D97B29'),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
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
                      fontWeight: FontWeight.bold,
                      color: _getColor('#2D5A3D'),
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Right: Icons + SOS Button (always pinned right)
            Flexible(
              flex: 3,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    _buildIconButton(
                      icon: LucideIcons.messageCircle,
                      badgeCount: 3,
                      badgeColor: _getColor('#DC2626'),
                      tooltip: 'Messages',
                      onTap: () => onNavigate?.call('messages'),
                    ),
                    _buildIconButton(
                      icon: LucideIcons.bell,
                      badgeCount: 2,
                      badgeColor: _getColor('#D97B29'),
                      tooltip: 'Notifications',
                      onTap: () => onNavigate?.call('notifications'),
                    ),
                    _buildIconButton(
                      icon: LucideIcons.users,
                      tooltip: 'Buddies',
                      onTap: () => onNavigate?.call('buddies'),
                    ),

                    // Divider line
                    Container(
                      width: 1,
                      height: 24,
                      color: _getColor('#E8D7C9'),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),

                    // ✅ SOS Button - scaled for all devices
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: ElevatedButton.icon(
                        onPressed: onSOSClick,
                        icon: const Icon(
                          LucideIcons.alertCircle,
                          size: 16,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'SOS',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getColor('#DC2626'),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    int? badgeCount,
    Color? badgeColor,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(icon, size: 20, color: _getColor('#6B7280')),
          tooltip: tooltip,
          onPressed: onTap,
        ),
        if (badgeCount != null && badgeCount > 0)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: badgeColor ?? _getColor('#DC2626'),
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
              child: Center(
                child: Text(
                  badgeCount > 9 ? '9+' : badgeCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  static Color _getColor(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) hexColor = "FF$hexColor";
    return Color(int.parse(hexColor, radix: 16));
  }
}