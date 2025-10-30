import 'package:flutter/material.dart';
import 'signup_step_layout.dart';
import 'sign_up_data.dart';

class Step3Page extends StatefulWidget {
  final SignupData signupData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step3Page({
    super.key,
    required this.signupData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step3Page> createState() => _Step3PageState();
}

class _Step3PageState extends State<Step3Page> {
  String? _selectedLevel;
  final List<String> _selectedActivities = [];

  bool _showErrors = false;

  final List<Map<String, String>> _levels = [
    {"title": "Beginner", "subtitle": "New to outdoor adventures"},
    {"title": "Intermediate", "subtitle": "Some outdoor experience"},
    {"title": "Advanced", "subtitle": "Experienced adventurer"},
    {"title": "Expert", "subtitle": "Professional level"},
  ];

  final List<Map<String, dynamic>> _activities = [
    {"title": "Hiking", "icon": Icons.terrain, "color": Colors.green},
    {"title": "Camping", "icon": Icons.park, "color": Colors.orange},
    {"title": "Rock Climbing", "icon": Icons.fitness_center, "color": Colors.red},
    {"title": "Mountaineering", "icon": Icons.landscape, "color": Colors.purple},
    {"title": "Backpacking", "icon": Icons.hiking, "color": Colors.blue},
    {"title": "Photography", "icon": Icons.photo_camera, "color": Colors.pink},
    {"title": "Wildlife Watching", "icon": Icons.favorite, "color": Colors.teal},
    {"title": "Cycling", "icon": Icons.pedal_bike, "color": Colors.amber},
    {"title": "Kayaking", "icon": Icons.water, "color": Colors.cyan},
    {"title": "Skiing", "icon": Icons.ac_unit, "color": Colors.indigo},
  ];

  void _toggleActivity(String activity) {
    setState(() {
      if (_selectedActivities.contains(activity)) {
        _selectedActivities.remove(activity);
      } else {
        if (_selectedActivities.length < 10) {
          _selectedActivities.add(activity);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You can select up to 10 activities")),
          );
        }
      }
    });
  }

  void _saveAndNext() {
    setState(() {
      _showErrors = true; // show validation errors after pressing Continue
    });

    // Require minimum 3 activities
    if (_selectedLevel != null && _selectedActivities.length >= 3) {
      widget.signupData
        ..experienceLevel = _selectedLevel
        ..activities = List.from(_selectedActivities);

      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double boxWidth =
        (MediaQuery.of(context).size.width - 50) / 2; // 2-column layout

    return SignupStepLayout(
      title: "Step 3 of 6",
      onBack: widget.onBack,
      onNext: _saveAndNext,
      isNextEnabled: _selectedLevel != null, // ✅ Enabled as soon as Level chosen
      nextLabel: "Continue",
      backLabel: "Back",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: 3 / 6,
            backgroundColor: Colors.grey[800],
            color: Colors.green,
            minHeight: 6,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(height: 30),

          // Icon
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.amber[600],
            child: const Icon(Icons.terrain, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 20),

          // Subtitle
          const Text(
            "Tell us about your outdoor experience",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 30),

          // Levels (2x2 grid using Wrap)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _levels.map((level) {
              final isSelected = _selectedLevel == level["title"];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedLevel = level["title"];
                  });
                },
                child: Container(
                  width: boxWidth,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green[700] : Colors.black,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.green : Colors.grey[700]!,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(level["title"]!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 4),
                      Text(level["subtitle"]!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          )),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Activity selection header
          Text(
            "Select at least 3 activities (${_selectedActivities.length}/10)",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 15),

          // Activities (2-column grid using Wrap)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _activities.map((activity) {
              final isSelected = _selectedActivities.contains(activity["title"]);
              return GestureDetector(
                onTap: () => _toggleActivity(activity["title"]),
                child: Container(
                  width: boxWidth,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? activity["color"].withOpacity(0.2)
                        : Colors.black,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? activity["color"] : Colors.grey[700]!,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(activity["icon"], color: activity["color"]),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          activity["title"],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          // Error if < 3 activities when pressing Continue
          if (_showErrors && _selectedActivities.length < 3)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                "Please select at least 3 activities",
                style: TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}