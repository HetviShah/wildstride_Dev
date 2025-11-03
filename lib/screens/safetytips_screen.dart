import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

// ---------- Color Constants ----------
const Color skyBlue = Color(0xFF1E90FF);
const Color forestGreen = Color(0xFF003B2E);
const Color mountainGray = Color(0xFF666666);
const Color foxOrange = Color(0xFFFF8C00);
const Color luckyRed = Color(0xFFD22B2B);
const Color earthSand = Color(0xFFE8D9B5);
const Color borderColor = Color(0xFFE5E7EB);

class SafetyTipsScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback? onComplete;

  const SafetyTipsScreen({
    super.key,
    required this.onBack,
    this.onComplete,
  });

  @override
  State<SafetyTipsScreen> createState() => _SafetyTipsScreenState();
}

class _SafetyTipsScreenState extends State<SafetyTipsScreen> {
  final PageController _pageController = PageController();
  int _currentSlide = 0;
  bool _agreedToTerms = false;
  List<Widget>? _slides;

  // ---------------- Safety Tips Data ----------------
  static final List<Map<String, dynamic>> _safetyDos = [
    {
      'icon': LucideIcons.users,
      'title': 'Meet in Public Places',
      'description':
      'Always choose well-populated, public locations for first meetings.',
      'color': skyBlue,
      'bgColor': skyBlue.withOpacity(0.1)
    },
    {
      'icon': LucideIcons.messageSquare,
      'title': 'Tell a Friend',
      'description':
      'Share your trip details and location with a trusted contact.',
      'color': skyBlue,
      'bgColor': skyBlue.withOpacity(0.1)
    },
    {
      'icon': LucideIcons.video,
      'title': 'Use Video Call First',
      'description':
      'Video chat before meeting to verify identity and build trust.',
      'color': skyBlue,
      'bgColor': skyBlue.withOpacity(0.1)
    },
    {
      'icon': LucideIcons.alertTriangle,
      'title': 'Use SOS Feature',
      'description': 'Know where the SOS button is for emergency situations.',
      'color': skyBlue,
      'bgColor': skyBlue.withOpacity(0.1)
    },
  ];

  static final List<Map<String, dynamic>> _safetyDonts = [
    {
      'icon': LucideIcons.eye,
      'title': "Don't Overshare Personal Info",
      'description':
      'Avoid sharing your home address, workplace, or financial details.',
      'color': foxOrange,
      'bgColor': foxOrange.withOpacity(0.1)
    },
    {
      'icon': LucideIcons.alertTriangle,
      'title': "Don't Ignore Red Flags",
      'description': 'Trust your instincts — cancel if something feels off.',
      'color': foxOrange,
      'bgColor': foxOrange.withOpacity(0.1)
    },
    {
      'icon': LucideIcons.mapPin,
      'title': "Don't Meet in Isolated Areas",
      'description': 'Avoid remote locations for first meetings.',
      'color': foxOrange,
      'bgColor': foxOrange.withOpacity(0.1)
    },
  ];

  // ---------------- Lifecycle ----------------
  @override
  void initState() {
    super.initState();

    // Only non-context-dependent logic here
    _pageController.addListener(() {
      if (!mounted) return;
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentSlide) {
        setState(() => _currentSlide = newPage);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Context-safe widget creation here
    _slides ??= [
      _buildInfoSlide(
        title: "Safety Tips: Do's ✅",
        subtitle: 'Follow these best practices for safe travel experiences.',
        icon: LucideIcons.checkCircle2,
        iconColor: skyBlue,
        items: _safetyDos,
        itemCheckIcon: LucideIcons.checkCircle2,
        itemCheckIconColor: skyBlue,
      ),
      _buildInfoSlide(
        title: "Safety Tips: Don'ts ❌",
        subtitle: 'Avoid these common safety mistakes.',
        icon: LucideIcons.xCircle,
        iconColor: foxOrange,
        items: _safetyDonts,
        itemCheckIcon: LucideIcons.xCircle,
        itemCheckIconColor: foxOrange,
      ),
      _buildReportingSlide(),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ---------------- Build UI ----------------
  @override
  Widget build(BuildContext context) {
    final slides = _slides ?? [];

    return Scaffold(
      backgroundColor: skyBlue.withOpacity(0.05),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: forestGreen),
          onPressed: widget.onBack,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Safety Guidelines",
              style: TextStyle(
                color: forestGreen,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Slide ${_currentSlide + 1} of ${slides.length}",
              style: const TextStyle(color: mountainGray, fontSize: 12),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: borderColor, height: 1),
        ),
      ),
      body: slides.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : PageView(
        controller: _pageController,
        children: slides,
      ),
      bottomNavigationBar: slides.isEmpty
          ? const SizedBox.shrink()
          : _buildBottomNavigation(),
    );
  }

  // ---------------- Slides ----------------
  Widget _buildProgressDots() {
    final slideCount = _slides?.length ?? 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(slideCount, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentSlide == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentSlide == index ? skyBlue : borderColor,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }

  Widget _buildInfoSlide({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required List<Map<String, dynamic>> items,
    required IconData itemCheckIcon,
    required Color itemCheckIconColor,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProgressDots(),
          const SizedBox(height: 24),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const SizedBox(height: 12),
          Text(title,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: forestGreen)),
          const SizedBox(height: 4),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: mountainGray)),
          const SizedBox(height: 24),
          ...items.map((tip) => _buildTipCard(
            icon: tip['icon'],
            title: tip['title'],
            description: tip['description'],
            color: tip['color'],
            bgColor: tip['bgColor'],
            checkIcon: itemCheckIcon,
            checkIconColor: itemCheckIconColor,
          )),
        ],
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required Color bgColor,
    required IconData checkIcon,
    required Color checkIconColor,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: forestGreen,
                          fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(description,
                      style: const TextStyle(fontSize: 13, color: mountainGray)),
                ],
              ),
            ),
            Icon(checkIcon, color: checkIconColor, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildReportingSlide() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProgressDots(),
          const SizedBox(height: 24),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: skyBlue.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.shield, color: skyBlue, size: 32),
          ),
          const SizedBox(height: 12),
          const Text("Reporting & Safety",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: forestGreen)),
          const SizedBox(height: 4),
          const Text("Your safety is our top priority",
              style: TextStyle(color: mountainGray, fontSize: 14)),
          const SizedBox(height: 24),
          _buildReportingInfoCard(),
          const SizedBox(height: 16),
          _buildAgreementCard(),
        ],
      ),
    );
  }

  Widget _buildReportingInfoCard() {
    return Card(
      elevation: 0,
      color: skyBlue.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: skyBlue.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(
              icon: LucideIcons.alertTriangle,
              iconColor: skyBlue,
              title: 'Report Unsafe Behavior',
              description:
              'Use the in-app reporting feature if you experience unsafe behavior. All reports are reviewed within 24–48 hours.',
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: LucideIcons.shield,
              iconColor: luckyRed,
              title: 'False Reports Are Not Tolerated',
              description:
              'Filing false reports wastes resources and harms innocent users. May result in trust score penalties.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration:
          BoxDecoration(color: iconColor.withOpacity(0.2), shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style:
                  const TextStyle(fontWeight: FontWeight.w600, color: forestGreen)),
              const SizedBox(height: 4),
              Text(description,
                  style: const TextStyle(color: mountainGray, fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- Checkbox Card ----------------
  Widget _buildAgreementCard() {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        setState(() => _agreedToTerms = !_agreedToTerms);
      },
      child: Card(
        elevation: 0,
        color: earthSand.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: earthSand),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              CheckboxListTile(
                value: _agreedToTerms,
                onChanged: (val) {
                  setState(() => _agreedToTerms = val ?? false);
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: skyBlue,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                title: const Text(
                  "I understand and agree to follow these safety guidelines when using Wildstride Buddy Finder.",
                  style: TextStyle(color: mountainGray, fontSize: 13),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Opening Safety Policy..."),
                    ),
                  );
                },
                icon: const Icon(LucideIcons.fileText, color: skyBlue, size: 16),
                label: const Text(
                  'View Full Legal Safety Policy',
                  style: TextStyle(color: skyBlue, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Bottom Navigation ----------------
  Widget _buildBottomNavigation() {
    final slideCount = _slides?.length ?? 0;

    return Container(
      padding: const EdgeInsets.all(16).copyWith(bottom: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_currentSlide == slideCount - 1)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _agreedToTerms
                    ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Thank you! You agreed to the Safety Guidelines."),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  if (widget.onComplete != null) {
                    widget.onComplete!();
                  } else {
                    Navigator.pop(context);
                  }
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  _agreedToTerms ? skyBlue : Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  "I Understand & Agree",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color:
                    _agreedToTerms ? Colors.white : Colors.grey.shade600,
                  ),
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _currentSlide == 0
                        ? null
                        : () => _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: mountainGray),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Previous"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: skyBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child:
                    const Text("Next", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          if (_currentSlide < slideCount - 1)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TextButton(
                onPressed: () => _pageController.jumpToPage(slideCount - 1),
                child: const Text(
                  'Skip to Agreement',
                  style: TextStyle(color: mountainGray, fontSize: 13),
                ),
              ),
            ),
        ],
      ),
    );
  }
}