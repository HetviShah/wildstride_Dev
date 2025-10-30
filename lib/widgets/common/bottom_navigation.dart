import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BottomNavigation extends StatelessWidget {
  final String activeTab;
  final Function(String) onTabChange;

  const BottomNavigation({
    super.key,
    required this.activeTab,
    required this.onTabChange,
  });

  final List<NavigationTab> tabs = const [
    NavigationTab(id: 'trips', icon: LucideIcons.mapPin, label: 'Trips'),
    NavigationTab(id: 'discover', icon: LucideIcons.compass, label: 'Discover'),
    NavigationTab(id: 'trip-room', icon: LucideIcons.calendar, label: 'Trip Room'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: _getColor('#E8D7C9'), // earth-sand color
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: tabs.map((tab) {
              final isActive = activeTab == tab.id;
              
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTabChange(tab.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    decoration: BoxDecoration(
                      color: isActive 
                          ? _getColor('#E8D7C9').withOpacity(0.3) // earth-sand/30
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          tab.icon,
                          size: 20,
                          color: isActive 
                              ? _getColor('#2D5A3D') // forest-green
                              : _getColor('#6B7280'), // mountain-gray
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tab.label,
                          style: TextStyle(
                            fontFamily: 'Inter', // Assuming Inter font for body
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isActive 
                                ? _getColor('#2D5A3D') // forest-green
                                : _getColor('#6B7280'), // mountain-gray
                          ),
                        ),
                        if (isActive) ...[
                          const SizedBox(height: 2),
                          Container(
                            width: 24,
                            height: 2,
                            decoration: BoxDecoration(
                              color: _getColor('#D97B29'), // fox-orange
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
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

class NavigationTab {
  final String id;
  final IconData icon;
  final String label;

  const NavigationTab({
    required this.id,
    required this.icon,
    required this.label,
  });
}