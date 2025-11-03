import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wildstride_app/screens/badges_screen.dart';
// Import your existing screens
import 'screens/buddy_finder/buddies_screen.dart';

import 'screens/buddy_finder/trips_screen.dart';
import 'screens/buddy_finder/discover_screen.dart';
import 'screens/buddy_finder/trip_room_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/new_chat_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/options_screen.dart';
import 'screens/call_screen.dart';
import 'screens/chat_options_screen.dart';
import 'screens/video_call_screen.dart';
import 'widgets/common/bottom_navigation.dart';
import 'widgets/common/header.dart';
import 'widgets/common/sidebar.dart';
import 'widgets/common/sos_modal.dart';
import 'widgets/common/toaster.dart';
import 'screens/support_screen.dart';
import 'screens/safetyandtrust_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/aboutus_screen.dart';

class LandingHomePage extends StatefulWidget {
  const LandingHomePage({super.key});

  @override
  State<LandingHomePage> createState() => _LandingHomePageState();
}

class _LandingHomePageState extends State<LandingHomePage> {
  String _activeTab = 'discover';
  bool _isSidebarOpen = false;
  bool _showSOSModal = false;
  bool _isAuthenticated = true;
  bool _isCheckingAuth = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final authStatus = prefs.getBool('wildstride_auth') ?? true;
    setState(() {
      _isAuthenticated = authStatus;
      _isCheckingAuth = false;
    });
  }

  void _handleSignOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('wildstride_auth', false);
      setState(() {
        _isAuthenticated = false;
        _activeTab = 'discover';
        _isSidebarOpen = false;
      });
      if (mounted && Navigator.canPop(context)) Navigator.pop(context);
    } catch (e) {
      debugPrint("Error during sign out: $e");
    }
  }

  void _handleTabChange(String tab) {
    print('🧭 Navigating to tab: $tab'); // Debug helper
    setState(() => _activeTab = tab);
  }

  void _handleMenuClick() => setState(() => _isSidebarOpen = true);
  void _handleSOSClick() => setState(() => _showSOSModal = true);
  void _closeSidebar() => setState(() => _isSidebarOpen = false);
  void _closeSOSModal() => setState(() => _showSOSModal = false);

  // 🧭 Page switcher
  Widget _renderActiveScreen() {
    Widget safeReturn(Widget? screen, String name) {
      if (screen != null) return screen;
      return Container(
        color: const Color(0xFFF5F5F5),
        alignment: Alignment.center,
        child: Text(
          '$name coming soon...',
          style: const TextStyle(color: Colors.black54, fontSize: 18),
        ),
      );
    }

    switch (_activeTab) {
      case 'discover':
        return safeReturn(const DiscoverScreen(), 'Discover');

      case 'trips':
        return safeReturn(const TripsScreen(), 'Trips');

      case 'trip-room':
        return safeReturn(const TripRoomScreen(), 'Trip Room');

      case 'messages':
        return safeReturn(MessagesScreen(onNavigate: _handleTabChange), 'Messages');

      case 'notifications':
        return safeReturn(const NotificationsScreen(), 'Notifications');

      case 'buddies':
        return safeReturn(const BuddiesScreen(), 'Buddies');



      case 'call':
        return safeReturn(
          CallScreen(
            onEndCall: () => _handleTabChange('messages'),
            onBackToMessages: () => _handleTabChange('messages'),
            onVideoCall: () => _handleTabChange('video-call'),
          ),
          'Call',
        );

      case 'video-call':
        return safeReturn(
          VideoCallScreen(
            onEndCall: () => _handleTabChange('messages'),
            onBackToMessages: () => _handleTabChange('messages'),
            onSwitchToAudio: () => _handleTabChange('call'),
          ),
          'Video Call',
        );

      case 'options':
        return safeReturn(OptionsScreen(onBack: () => _handleTabChange('discover')), 'Options');

      case 'chat-options':
        return safeReturn(ChatOptionsScreen(onBack: () => _handleTabChange('messages')), 'Chat Options');

      case 'new-chat':
        return safeReturn(
          NewChatScreen(
            onBack: () => _handleTabChange('messages'),
            onStartChat: (dynamic userId, {Map<String, dynamic>? groupData}) {
              _handleTabChange('messages');
            },
          ),
          'New Chat',
        );

    // ✅ Navigation targets (aliases included)
      case 'profile':
      case 'profile_screen':
        return safeReturn(ProfileScreen(onBack: () => _handleTabChange('discover')), 'Profile_screen');

      case 'safetyandtrust':
      case 'safetyandtrust_screen':
        return safeReturn(SafetyTrustScreen(onBack: () => _handleTabChange('discover')), 'Safetyandtrust_screen');

      case 'history':
      case 'history_screen':
        return safeReturn(HistoryScreen(onBack: () => _handleTabChange('discover')), 'History');

      case 'badges':
      case 'badges_screen':
        return safeReturn(BadgesScreen(onBack: () => _handleTabChange('discover')), 'Badges');

      case 'support':
      case 'support_screen':
        return safeReturn(SupportScreen(onBack: () => _handleTabChange('discover')), 'Support');

      case 'settings':
      case 'settings_screen':
        return safeReturn(SettingsScreen(onBack: () => _handleTabChange('discover')), 'Settings');

      case 'about-us':
      case 'aboutus_screen':
        return safeReturn(AboutUsScreen(onBack: () => _handleTabChange('discover')), 'About Us');

      default:
        return const Center(
          child: Text(
            'Welcome to Wildstride!',
            style: TextStyle(color: Colors.black54, fontSize: 18),
          ),
        );
    }
  }

  Widget _safeScreenWrapper(Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              maxHeight: constraints.maxHeight, // ✅ Fix layout overflow
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewPadding.bottom;

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        resizeToAvoidBottomInset: false,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            // ✅ 1. Background
            Positioned.fill(
              child: Container(color: const Color(0xFFF5F5F5)),
            ),

            // ✅ 2. Main Content BELOW header
            Positioned.fill(
              top: kToolbarHeight + MediaQuery.of(context).padding.top + 8,
              bottom: 68 + MediaQuery.of(context).padding.bottom,
              child: _safeScreenWrapper(_renderActiveScreen()),
            ),

            // ✅ 3. Header ABOVE content
            SafeArea(
              top: true,
              bottom: false,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Header(
                  onMenuClick: _handleMenuClick,
                  onSOSClick: _handleSOSClick,
                  onNavigate: _handleTabChange,
                ),
              ),
            ),

            // ✅ 4. Bottom Navigation
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                top: false,
                child: Container(
                  color: Colors.white,
                  height: 68,
                  child: BottomNavigation(
                    activeTab: _activeTab,
                    onTabChange: _handleTabChange,
                  ),
                ),
              ),
            ),

            // ✅ 5. Sidebar
            if (_isSidebarOpen)
              Sidebar(
                isOpen: _isSidebarOpen,
                onClose: _closeSidebar,
                onNavigate: _handleTabChange,
                onSignOut: _handleSignOut,
              ),

            // ✅ 6. SOS Modal
            if (_showSOSModal)
              SOSModal(
                isOpen: _showSOSModal,
                onClose: _closeSOSModal,
              ),

            // ✅ 7. Toaster
            const Toaster(),
          ],
        ),
      ),
    );
  }
}

