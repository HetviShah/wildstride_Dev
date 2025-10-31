import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FAQ {
  final int id;
  final String question;
  final String answer;
  final String category;
  final int helpful;

  FAQ({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    required this.helpful,
  });
}

class SupportChannel {
  final int id;
  final String title;
  final String description;
  final IconData icon;
  final String availability;
  final String responseTime;
  final String action;
  final Color color;

  SupportChannel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.availability,
    required this.responseTime,
    required this.action,
    required this.color,
  });
}

class Guide {
  final int id;
  final String title;
  final String description;
  final IconData icon;
  final String duration;
  final String type;

  Guide({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.duration,
    required this.type,
  });
}

class SupportScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const SupportScreen({Key? key, this.onBack}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> with SingleTickerProviderStateMixin {
  final List<FAQ> mockFAQs = [
    FAQ(
      id: 1,
      question: 'How do I find travel buddies for my trips?',
      answer: 'You can find travel buddies by browsing the Discover tab, creating trip posts, or using our matching algorithm. Make sure to complete your profile with interests and travel preferences for better matches.',
      category: 'buddies',
      helpful: 142,
    ),
    FAQ(
      id: 2,
      question: 'What safety features does Wildstride offer?',
      answer: 'Wildstride includes real-time location sharing, SOS alerts, buddy verification, check-in reminders, emergency contacts, and 24/7 safety monitoring during trips.',
      category: 'safety',
      helpful: 98,
    ),
    FAQ(
      id: 3,
      question: 'How does the buddy verification system work?',
      answer: 'Our verification process includes ID verification, social media linking, reference checks from previous trip buddies, and safety ratings from the community.',
      category: 'safety',
      helpful: 87,
    ),
    FAQ(
      id: 4,
      question: 'Can I create private trips?',
      answer: 'Yes! When creating a trip, you can set it as private and invite only specific buddies. Private trips won\'t appear in public discovery feeds.',
      category: 'trips',
      helpful: 76,
    ),
    FAQ(
      id: 5,
      question: 'What should I do if I feel unsafe during a trip?',
      answer: 'Immediately use the SOS feature in the app, which will alert emergency services and your emergency contacts. You can also report safety concerns through the app.',
      category: 'safety',
      helpful: 156,
    ),
    FAQ(
      id: 6,
      question: 'How do I report inappropriate behavior?',
      answer: 'Use the report feature in user profiles or trip chats. Our safety team reviews all reports within 24 hours and takes appropriate action.',
      category: 'general',
      helpful: 64,
    ),
    FAQ(
      id: 7,
      question: 'Why isn\'t my app syncing properly?',
      answer: 'Check your internet connection and app permissions. Try closing and reopening the app. If issues persist, contact support with your device details.',
      category: 'technical',
      helpful: 45,
    ),
    FAQ(
      id: 8,
      question: 'How do I cancel or modify a trip?',
      answer: 'Go to your trip details and select "Edit Trip" or "Cancel Trip". Note that cancelling within 24 hours of departure may affect your reliability rating.',
      category: 'trips',
      helpful: 89,
    ),
  ];

  final List<SupportChannel> supportChannels = [
    SupportChannel(
      id: 1,
      title: 'Live Chat',
      description: 'Get instant help from our support team',
      icon: LucideIcons.messageCircle,
      availability: 'Available 24/7',
      responseTime: 'Usually responds in 2-5 minutes',
      action: 'Start Chat',
      color: const Color(0xFF228B22), // forest-green
    ),
    SupportChannel(
      id: 2,
      title: 'Email Support',
      description: 'Send us a detailed message',
      icon: LucideIcons.mail,
      availability: 'Response within 24 hours',
      responseTime: 'Usually responds in 2-4 hours',
      action: 'Send Email',
      color: const Color(0xFF87CEEB), // sky-blue
    ),
    SupportChannel(
      id: 3,
      title: 'Safety Hotline',
      description: 'Emergency safety support',
      icon: LucideIcons.phone,
      availability: 'Available 24/7',
      responseTime: 'Immediate response',
      action: 'Call Now',
      color: const Color(0xFFD22B2B), // lucky-red
    ),
  ];

  final List<Guide> guides = [
    Guide(
      id: 1,
      title: 'Getting Started Guide',
      description: 'Complete setup and find your first adventure buddy',
      icon: LucideIcons.bookOpen,
      duration: '5 min read',
      type: 'guide',
    ),
    Guide(
      id: 2,
      title: 'Safety Best Practices',
      description: 'Essential safety tips for outdoor adventures',
      icon: LucideIcons.shield,
      duration: '8 min read',
      type: 'guide',
    ),
    Guide(
      id: 3,
      title: 'Trip Planning Walkthrough',
      description: 'Step-by-step video guide for creating trips',
      icon: LucideIcons.video,
      duration: '12 min watch',
      type: 'video',
    ),
    Guide(
      id: 4,
      title: 'Community Guidelines',
      description: 'Rules and expectations for Wildstride community',
      icon: LucideIcons.fileText,
      duration: '3 min read',
      type: 'guide',
    ),
  ];

  late TabController _tabController;
  String _searchQuery = '';
  String _selectedCategory = 'all';
  int? _expandedFAQ;
  final Map<String, String> _contactForm = {
    'subject': '',
    'category': '',
    'message': '',
    'email': '',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<FAQ> get filteredFAQs {
    return mockFAQs.where((faq) {
      final matchesSearch = faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          faq.answer.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'all' || faq.category == _selectedCategory;
      
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _handleContactSubmit() {
    print('Contact form submitted: $_contactForm');
    // Reset form
    setState(() {
      _contactForm.updateAll((key, value) => '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC).withOpacity(0.1), // earth-sand/10
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(LucideIcons.arrowLeft),
                      onPressed: widget.onBack,
                      color: const Color(0xFF228B22), // forest-green
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Help & Support',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF228B22), // forest-green
                            ),
                          ),
                          Text(
                            'We\'re here to help you on your adventure journey',
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFF666666), // mountain-gray
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Emergency Notice
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: const Color(0xFFD22B2B).withOpacity(0.05), // lucky-red/5
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: const Color(0xFFD22B2B).withOpacity(0.3)), // lucky-red
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(LucideIcons.alertTriangle, color: const Color(0xFFD22B2B)), // lucky-red
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency Support',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFD22B2B), // lucky-red
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'If you\'re in immediate danger, call local emergency services or use our SOS feature.',
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFF666666), // mountain-gray
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD22B2B), // lucky-red
                      ),
                      child: const Text('SOS Help'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF228B22), // forest-green
              unselectedLabelColor: const Color(0xFF666666), // mountain-gray
              indicatorColor: const Color(0xFF228B22), // forest-green
              tabs: const [
                Tab(text: 'Help Center'),
                Tab(text: 'Contact Us'),
                Tab(text: 'Guides'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Help Center Tab
                _buildHelpCenterTab(),
                
                // Contact Us Tab
                _buildContactUsTab(),
                
                // Guides Tab
                _buildGuidesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCenterTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search
          TextField(
            decoration: InputDecoration(
              hintText: 'Search help articles...',
              prefixIcon: const Icon(LucideIcons.search, size: 20),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          const SizedBox(height: 16),

          // Category Filter
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All Categories')),
              DropdownMenuItem(value: 'general', child: Text('General')),
              DropdownMenuItem(value: 'safety', child: Text('Safety')),
              DropdownMenuItem(value: 'trips', child: Text('Trips')),
              DropdownMenuItem(value: 'buddies', child: Text('Buddies')),
              DropdownMenuItem(value: 'technical', child: Text('Technical')),
            ],
            onChanged: (value) => setState(() => _selectedCategory = value ?? 'all'),
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          // FAQs
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.helpCircle, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Frequently Asked Questions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF228B22), // forest-green
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (filteredFAQs.isEmpty)
                    _buildEmptyState()
                  else
                    ...filteredFAQs.map((faq) => _buildFAQItem(faq)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(FAQ faq) {
    final isExpanded = _expandedFAQ == faq.id;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD2B48C).withOpacity(0.3)), // earth-sand/30
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              faq.question,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF228B22), // forest-green
              ),
            ),
            trailing: Icon(
              isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
              size: 16,
              color: const Color(0xFF666666), // mountain-gray
            ),
            onTap: () => setState(() {
              _expandedFAQ = isExpanded ? null : faq.id;
            }),
          ),
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    faq.answer,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF666666), // mountain-gray
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Chip(
                        label: Text(faq.category),
                        backgroundColor: const Color(0xFFD2B48C).withOpacity(0.5), // earth-sand/50
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${faq.helpful} found this helpful',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF666666), // mountain-gray
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text('👍 Helpful'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('👎 Not helpful'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Icon(LucideIcons.helpCircle, size: 48, color: const Color(0xFF666666)),
        const SizedBox(height: 12),
        Text(
          'No articles found',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF228B22), // forest-green
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Try searching with different keywords or browse all categories.',
          style: TextStyle(
            fontSize: 12,
            color: const Color(0xFF666666), // mountain-gray
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContactUsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Support Channels
          Column(
            children: supportChannels.map((channel) => _buildSupportChannel(channel)).toList(),
          ),
          const SizedBox(height: 24),

          // Contact Form
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Send us a message',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF228B22), // forest-green
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Subject and Category
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Subject',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF228B22), // forest-green
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              decoration: const InputDecoration(
                                hintText: 'Brief description of your issue',
                              ),
                              onChanged: (value) => setState(() => _contactForm['subject'] = value),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Category',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF228B22), // forest-green
                              ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              items: const [
                                DropdownMenuItem(value: 'technical', child: Text('Technical Issue')),
                                DropdownMenuItem(value: 'safety', child: Text('Safety Concern')),
                                DropdownMenuItem(value: 'account', child: Text('Account Help')),
                                DropdownMenuItem(value: 'trip', child: Text('Trip Support')),
                                DropdownMenuItem(value: 'buddy', child: Text('Buddy Issues')),
                                DropdownMenuItem(value: 'billing', child: Text('Billing Question')),
                                DropdownMenuItem(value: 'feedback', child: Text('Feedback')),
                                DropdownMenuItem(value: 'other', child: Text('Other')),
                              ],
                              onChanged: (value) => setState(() => _contactForm['category'] = value ?? ''),
                              decoration: const InputDecoration(
                                hintText: 'Select category',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Email
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF228B22), // forest-green
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'your.email@example.com',
                        ),
                        onChanged: (value) => setState(() => _contactForm['email'] = value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Message
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Message',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF228B22), // forest-green
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Please describe your issue in detail...',
                        ),
                        onChanged: (value) => setState(() => _contactForm['message'] = value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _handleContactSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF228B22), // forest-green
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Send Message'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We typically respond within 2-4 hours during business hours.',
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF666666), // mountain-gray
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportChannel(SupportChannel channel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: channel.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(channel.icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    channel.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF228B22), // forest-green
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    channel.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF666666), // mountain-gray
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          channel.availability,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        channel.responseTime,
                        style: TextStyle(
                          fontSize: 10,
                          color: const Color(0xFF666666), // mountain-gray
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD2691E), // fox-orange
              ),
              child: Text(channel.action),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Guides
          Column(
            children: guides.map((guide) => _buildGuideItem(guide)).toList(),
          ),
          const SizedBox(height: 24),

          // Additional Resources
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Additional Resources',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF228B22), // forest-green
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildResourceButton('Visit our Website', LucideIcons.externalLink),
                  _buildResourceButton('Video Tutorials', LucideIcons.video),
                  _buildResourceButton('Community Forum', LucideIcons.messageCircle),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideItem(Guide guide) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF87CEEB), // sky-blue
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(guide.icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    guide.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF228B22), // forest-green
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    guide.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF666666), // mountain-gray
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD2B48C).withOpacity(0.5), // earth-sand/50
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          guide.type,
                          style: TextStyle(
                            fontSize: 10,
                            color: const Color(0xFF666666), // mountain-gray
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(LucideIcons.clock, size: 12, color: const Color(0xFF666666)),
                      const SizedBox(width: 4),
                      Text(
                        guide.duration,
                        style: TextStyle(
                          fontSize: 10,
                          color: const Color(0xFF666666), // mountain-gray
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, size: 16, color: const Color(0xFF666666)),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceButton(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          side: BorderSide(color: const Color(0xFFD2B48C).withOpacity(0.5)), // earth-sand/50
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: const Color(0xFFD2691E)), // fox-orange
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            Icon(LucideIcons.chevronRight, size: 16, color: const Color(0xFF666666)),
          ],
        ),
      ),
    );
  }
}