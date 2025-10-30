import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class TeamMember {
  final int id;
  final String name;
  final String role;
  final String bio;
  final String avatar;
  final List<String> expertise;
  final int adventures;

  TeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.bio,
    required this.avatar,
    required this.expertise,
    required this.adventures,
  });
}

class Feature {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  Feature({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

class Stat {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  Stat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

class Milestone {
  final String year;
  final String title;
  final String description;
  final IconData icon;

  Milestone({
    required this.year,
    required this.title,
    required this.description,
    required this.icon,
  });
}

class SocialLink {
  final IconData icon;
  final String label;
  final String url;
  final Color color;

  SocialLink({
    required this.icon,
    required this.label,
    required this.url,
    required this.color,
  });
}

class AboutUsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const AboutUsScreen({Key? key, this.onBack}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  // Remove unused _activeTab field since we're using DefaultTabController
  // final int _activeTab = 0; // This line is commented out as it's not used

  final List<TeamMember> teamMembers = [
    TeamMember(
      id: 1,
      name: 'Alex Rivera',
      role: 'Founder & CEO',
      bio: 'Former mountain guide turned tech entrepreneur. Passionate about making outdoor adventures safer and more accessible.',
      avatar: '/api/placeholder/80/80',
      expertise: ['Leadership', 'Product Strategy', 'Mountain Safety'],
      adventures: 150,
    ),
    TeamMember(
      id: 2,
      name: 'Sarah Chen',
      role: 'Head of Safety',
      bio: 'Emergency response specialist with 10+ years in wilderness safety. Designs our safety protocols and emergency systems.',
      avatar: '/api/placeholder/80/80',
      expertise: ['Emergency Response', 'Risk Management', 'Training'],
      adventures: 89,
    ),
    TeamMember(
      id: 3,
      name: 'Marcus Johnson',
      role: 'Lead Developer',
      bio: 'Full-stack developer and weekend rock climber. Builds the technology that keeps adventurers connected and safe.',
      avatar: '/api/placeholder/80/80',
      expertise: ['Mobile Development', 'Backend Systems', 'Rock Climbing'],
      adventures: 67,
    ),
    TeamMember(
      id: 4,
      name: 'Emma Thompson',
      role: 'Community Manager',
      bio: 'Travel photographer and community builder. Helps create the welcoming culture that makes Wildstride special.',
      avatar: '/api/placeholder/80/80',
      expertise: ['Community Building', 'Photography', 'Content Strategy'],
      adventures: 124,
    ),
  ];

  final List<Feature> features = [
    Feature(
      icon: LucideIcons.shield,
      title: 'Safety First',
      description: 'Real-time location tracking, SOS alerts, and 24/7 emergency monitoring keep you safe on every adventure.',
      color: Colors.red,
    ),
    Feature(
      icon: LucideIcons.users,
      title: 'Trusted Community',
      description: 'Meet verified adventure buddies through our community of outdoor enthusiasts who share your passion.',
      color: Colors.green,
    ),
    Feature(
      icon: LucideIcons.compass,
      title: 'Smart Matching',
      description: 'Our algorithm connects you with compatible travel partners based on interests, experience, and trip preferences.',
      color: Colors.orange,
    ),
    Feature(
      icon: LucideIcons.mountain,
      title: 'Adventure Planning',
      description: 'Plan, organize, and coordinate trips with built-in tools for itinerary planning and group coordination.',
      color: Colors.blue,
    ),
    Feature(
      icon: LucideIcons.award,
      title: 'Gamification',
      description: 'Earn badges, build streaks, and level up as you explore new places and complete amazing adventures.',
      color: Colors.yellow,
    ),
    Feature(
      icon: LucideIcons.globe,
      title: 'Global Reach',
      description: 'Connect with adventurers worldwide with multi-language support and location-based matching.',
      color: Colors.green,
    ),
  ];

  final List<Stat> stats = [
    Stat(
      icon: LucideIcons.users,
      label: 'Active Users',
      value: '50K+',
      color: Colors.green,
    ),
    Stat(
      icon: LucideIcons.mountain,
      label: 'Adventures Completed',
      value: '125K+',
      color: Colors.orange,
    ),
    Stat(
      icon: LucideIcons.globe,
      label: 'Countries',
      value: '45+',
      color: Colors.blue,
    ),
    Stat(
      icon: LucideIcons.shield,
      label: 'Safety Rating',
      value: '99.9%',
      color: Colors.red,
    ),
  ];

  final List<Milestone> milestones = [
    Milestone(
      year: '2023',
      title: 'Wildstride Founded',
      description: 'Started with a simple mission: make outdoor adventures safer and more social.',
      icon: LucideIcons.target,
    ),
    Milestone(
      year: '2023',
      title: 'Beta Launch',
      description: 'Launched beta version with 1,000 passionate outdoor enthusiasts.',
      icon: LucideIcons.zap,
    ),
    Milestone(
      year: '2024',
      title: 'Safety Certification',
      description: 'Achieved international safety standards certification for emergency response.',
      icon: LucideIcons.shield,
    ),
    Milestone(
      year: '2024',
      title: 'Global Expansion',
      description: 'Expanded to 45+ countries with multi-language support and local partnerships.',
      icon: LucideIcons.globe,
    ),
    Milestone(
      year: '2024',
      title: '50K Adventurers',
      description: 'Reached 50,000 active users creating amazing adventure stories.',
      icon: LucideIcons.users,
    ),
  ];

  final List<SocialLink> socialLinks = [
    SocialLink(
      icon: LucideIcons.twitter,
      label: '@wildstride',
      url: 'https://twitter.com/wildstride',
      color: Colors.blue,
    ),
    SocialLink(
      icon: LucideIcons.instagram,
      label: '@wildstride_adventures',
      url: 'https://instagram.com/wildstride',
      color: Colors.orange,
    ),
    SocialLink(
      icon: LucideIcons.facebook,
      label: 'Wildstride Adventures',
      url: 'https://facebook.com/wildstride',
      color: Colors.blue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(LucideIcons.arrowLeft, color: Colors.green[700]),
                  onPressed: widget.onBack,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About Wildstride',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      Text(
                        'Connecting adventurers, creating memories',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Hero Section
                  Stack(
                    children: [
                      Container(
                        height: 192,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.green[700]!,
                              Colors.orange,
                              Colors.blue,
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 192,
                        color: Colors.black.withOpacity(0.2),
                      ),
                      Container(
                        height: 192,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Icon(
                                  LucideIcons.mountain,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Wildstride',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Adventure. Safety. Community.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Stats Bar
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: stats.map((stat) => _buildStatItem(stat)).toList(),
                    ),
                  ),

                  // Tabs
                  Container(
                    color: Colors.white,
                    margin: const EdgeInsets.all(16),
                    child: DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          TabBar(
                            tabs: const [
                              Tab(text: 'Our Story'),
                              Tab(text: 'Team'),
                              Tab(text: 'Features'),
                            ],
                            labelColor: Colors.green[700],
                            unselectedLabelColor: Colors.grey[600],
                            indicatorColor: Colors.green[700],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height - 300,
                            child: TabBarView(
                              children: [
                                _buildStoryTab(),
                                _buildTeamTab(),
                                _buildFeaturesTab(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Contact & Social
                  _buildContactSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(Stat stat) {
    return Column(
      children: [
        Icon(stat.icon, size: 24, color: stat.color),
        const SizedBox(height: 4),
        Text(
          stat.value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        ),
        Text(
          stat.label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Mission Statement
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(LucideIcons.heart, size: 32, color: Colors.orange),
                  const SizedBox(height: 16),
                  Text(
                    'Our Mission',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'To make outdoor adventures safer, more accessible, and infinitely more enjoyable by connecting like-minded explorers and providing the tools they need to create unforgettable experiences together.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center, // Fixed: textAlign is valid for Text widget
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Story
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The Wildstride Story',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._buildStoryParagraphs(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Timeline
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Journey',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._buildTimeline(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Values
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Values',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._buildValues(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStoryParagraphs() {
    return [
      _buildParagraph(
        'Wildstride was born from a simple realization: some of life\'s most incredible moments happen when we step outside our comfort zones and explore the world around us. But too often, people hold back from adventures because they don\'t have someone to share the experience with, or they\'re concerned about safety when venturing into the unknown.',
      ),
      const SizedBox(height: 12),
      _buildParagraph(
        'Our founder, Alex Rivera, experienced this firsthand during a solo hiking trip in the Canadian Rockies. While the views were breathtaking, something was missing – the joy of shared discovery, the safety of having trusted companions, and the confidence that comes from knowing help is always available.',
      ),
      const SizedBox(height: 12),
      _buildParagraph(
        'That\'s when the idea for Wildstride was born. We envisioned a platform that wouldn\'t just connect adventurers, but would actively prioritize their safety, foster genuine community connections, and gamify the exploration experience to make every journey more rewarding.',
      ),
      const SizedBox(height: 12),
      _buildParagraph(
        'Today, Wildstride has grown into a global community of outdoor enthusiasts who believe that adventure is better when shared, safer when planned, and more meaningful when it connects us to both nature and each other.',
      ),
    ];
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
        height: 1.5,
      ),
    );
  }

  List<Widget> _buildTimeline() {
    List<Widget> timeline = [];
    for (int i = 0; i < milestones.length; i++) {
      timeline.add(_buildTimelineItem(milestones[i], i));
      if (i < milestones.length - 1) {
        timeline.add(const SizedBox(height: 16));
      }
    }
    return timeline;
  }

  Widget _buildTimelineItem(Milestone milestone, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(milestone.icon, size: 20, color: Colors.white),
            ),
            if (index < milestones.length - 1)
              Container(
                width: 1,
                height: 48,
                color: Colors.brown[300],
                margin: const EdgeInsets.only(top: 8),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green[700]!.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        milestone.year,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      milestone.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  milestone.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildValues() {
    return [
      _buildValueItem(
        LucideIcons.shield,
        'Safety First',
        'Every feature we build prioritizes user safety and emergency preparedness.',
        Colors.red,
      ),
      const SizedBox(height: 16),
      _buildValueItem(
        LucideIcons.users,
        'Community',
        'We foster genuine connections and inclusive experiences for all adventurers.',
        Colors.green,
      ),
      const SizedBox(height: 16),
      _buildValueItem(
        LucideIcons.mountain,
        'Adventure',
        'We inspire people to explore, discover, and create unforgettable memories.',
        Colors.orange,
      ),
    ];
  }

  Widget _buildValueItem(IconData icon, String title, String description, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Column(
            children: [
              Text(
                'Meet Our Team',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Adventure enthusiasts building the future of outdoor exploration',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...teamMembers.map((member) => _buildTeamMemberCard(member)).toList(),
          const SizedBox(height: 16),
          // Join Team CTA
          Card(
            color: Colors.orange.withOpacity(0.05),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.orange),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(LucideIcons.users, size: 32, color: Colors.orange),
                  const SizedBox(height: 16),
                  Text(
                    'Join Our Team',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We\'re always looking for passionate adventurers to join our mission. Check out our open positions and become part of the Wildstride story.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center, // Fixed: textAlign is valid for Text widget
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text('View Careers'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMemberCard(TeamMember member) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.brown[100],
              child: Text(
                member.name.split(' ').map((n) => n[0]).join(''),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  Text(
                    member.role,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    member.bio,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: member.expertise
                        .map((skill) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.brown[300]!),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                skill,
                                style: const TextStyle(fontSize: 10),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(LucideIcons.mountain, size: 12, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${member.adventures} adventures completed',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
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
    );
  }

  Widget _buildFeaturesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Column(
            children: [
              Text(
                'What Makes Us Different',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Innovation meets adventure in every feature we build',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            itemBuilder: (context, index) => _buildFeatureCard(features[index]),
          ),
          const SizedBox(height: 16),
          // Technology
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Technology & Innovation',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Wildstride is built on cutting-edge technology designed for reliability, security, and scalability. Our platform combines real-time location services, AI-powered matching algorithms, and robust safety protocols to create a seamless adventure experience.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildTechFeature(
                        LucideIcons.checkCircle,
                        '99.9% Uptime',
                        'Reliable service when you need it most',
                        Colors.green,
                      ),
                      _buildTechFeature(
                        LucideIcons.shield,
                        'End-to-End Encryption',
                        'Your data and conversations are secure',
                        Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(Feature feature) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: feature.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(feature.icon, size: 24, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              feature.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              feature.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechFeature(IconData icon, String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.brown[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
            textAlign: TextAlign.center, // Fixed: textAlign is valid for Text widget
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center, // Fixed: textAlign is valid for Text widget
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Connect With Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: socialLinks
                  .map((social) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: Icon(social.icon, size: 16, color: social.color),
                          label: const Text('Follow'),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.brown[300]!),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.brown[300]!), // Fixed: Proper Border syntax
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.mail, size: 16, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'hello@wildstride.app',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We\'d love to hear from you! Questions, feedback, or just want to share your adventure stories.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center, // Fixed: textAlign is valid for Text widget
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}