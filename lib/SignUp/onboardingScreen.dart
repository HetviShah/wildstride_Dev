import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      "icon": Icons.terrain,
      "color": Colors.green,
      "title": "Discover Adventures",
      "subtitle":
      "Find breathtaking trails, hidden gems, and outdoor experiences curated by our community of adventurers.",
      "button": "Continue",
    },
    {
      "icon": Icons.group,
      "color": Colors.orange,
      "title": "Connect with Explorers",
      "subtitle":
      "Meet like-minded travelers, share your journeys, and find the perfect adventure buddy for your next expedition.",
      "button": "Continue",
    },
    {
      "icon": Icons.explore,
      "color": Colors.amber,
      "title": "Track Your Journey",
      "subtitle":
      "Record your trails, document memories, and build your outdoor legacy while exploring the world’s most beautiful places.",
      "button": "Get Started",
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // ✅ Navigate to your Home/Dashboard
      Navigator.pushReplacementNamed(context, "/landing");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: page["color"],
                            child: Icon(page["icon"],
                                size: 50, color: Colors.white),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            page["title"],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            page["subtitle"],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // 🔹 Dots indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                      (index) => Container(
                    margin: const EdgeInsets.all(4),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.green
                          : Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🔹 Continue / Get Started button
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: ElevatedButton.icon(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  icon: Icon(
                    _currentPage == _pages.length - 1
                        ? Icons.arrow_forward_ios
                        : Icons.arrow_forward,
                  ),
                  label: Text(_pages[_currentPage]["button"]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}