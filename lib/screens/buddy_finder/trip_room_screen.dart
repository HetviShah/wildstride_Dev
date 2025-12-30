import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Mock data models
class TripRoom {
  final int id;
  final String title;
  final String location;
  final String dates;
  final List<Participant> participants;
  final List<ChecklistItem> checklist;
  final List<ScheduleItem> schedule;
  final List<Expense> expenses;
  final double totalBudget;
  final double currentSpent;

  TripRoom({
    required this.id,
    required this.title,
    required this.location,
    required this.dates,
    required this.participants,
    required this.checklist,
    required this.schedule,
    required this.expenses,
    required this.totalBudget,
    required this.currentSpent,
  });
}

class Participant {
  final int id;
  final String name;
  final String avatar;
  final bool isLive;

  Participant({
    required this.id,
    required this.name,
    required this.avatar,
    this.isLive = false,
  });
}

class ChecklistItem {
  final int id;
  final String item;
  bool completed;
  final String? assignee;

  ChecklistItem({
    required this.id,
    required this.item,
    required this.completed,
    this.assignee,
  });
}

class ScheduleItem {
  final int id;
  final String time;
  final String activity;
  final String location;

  ScheduleItem({
    required this.id,
    required this.time,
    required this.activity,
    required this.location,
  });
}

class Expense {
  final int id;
  final String item;
  final double amount;
  final String paidBy;
  final List<String> splitWith;

  Expense({
    required this.id,
    required this.item,
    required this.amount,
    required this.paidBy,
    required this.splitWith,
  });
}

class Message {
  final int id;
  final String sender;
  final String avatar;
  final String content;
  final String timestamp;
  final bool isCurrentUser;
  final String type;

  Message({
    required this.id,
    required this.sender,
    required this.avatar,
    required this.content,
    required this.timestamp,
    required this.isCurrentUser,
    required this.type,
  });
}

class TripRoomScreen extends StatefulWidget {
  const TripRoomScreen({super.key});

  @override
  State<TripRoomScreen> createState() => _TripRoomScreenState();
}

class _TripRoomScreenState extends State<TripRoomScreen> with SingleTickerProviderStateMixin {
  final List<TripRoom> mockTripRooms = [
    TripRoom(
      id: 1,
      title: 'Banff Hiking & Photography Tour',
      location: 'Banff National Park, Canada',
      dates: 'Jul 15-20, 2024',
      participants: [
        Participant(id: 1, name: 'Alex Chen', avatar: '', isLive: true),
        Participant(id: 2, name: 'Sarah Kim', avatar: '', isLive: true),
        Participant(id: 3, name: 'Mike Johnson', avatar: ''),
        Participant(id: 4, name: 'Emma Wilson', avatar: ''),
        Participant(id: 5, name: 'You', avatar: '', isLive: true),
      ],
      checklist: [
        ChecklistItem(id: 1, item: 'Book accommodation at Lake Louise', completed: true, assignee: 'Alex'),
        ChecklistItem(id: 2, item: 'Pack camera equipment', completed: true, assignee: 'You'),
        ChecklistItem(id: 3, item: 'Purchase hiking permits', completed: false, assignee: 'Sarah'),
        ChecklistItem(id: 4, item: 'Plan meals and groceries', completed: false, assignee: 'Mike'),
        ChecklistItem(id: 5, item: 'Check weather forecast', completed: false, assignee: 'Emma'),
      ],
      schedule: [
        ScheduleItem(id: 1, time: '7:00 AM', activity: 'Departure from Calgary', location: 'Calgary'),
        ScheduleItem(id: 2, time: '9:30 AM', activity: 'Lake Louise Sunrise Shoot', location: 'Lake Louise'),
        ScheduleItem(id: 3, time: '12:00 PM', activity: 'Lunch at Chateau Lake Louise', location: 'Lake Louise'),
        ScheduleItem(id: 4, time: '2:00 PM', activity: 'Hiking to Plain of Six Glaciers', location: 'Lake Louise Trail'),
        ScheduleItem(id: 5, time: '6:00 PM', activity: 'Dinner and rest', location: 'Accommodation'),
      ],
      expenses: [
        Expense(id: 1, item: 'Accommodation (3 nights)', amount: 1200, paidBy: 'Alex', splitWith: ['All']),
        Expense(id: 2, item: 'Rental car', amount: 300, paidBy: 'Sarah', splitWith: ['All']),
        Expense(id: 3, item: 'Hiking permits', amount: 150, paidBy: 'You', splitWith: ['All']),
        Expense(id: 4, item: 'Groceries', amount: 180, paidBy: 'Mike', splitWith: ['All']),
      ],
      totalBudget: 2000,
      currentSpent: 1830,
    ),
    TripRoom(
      id: 2,
      title: 'Wilderness Camping Adventure',
      location: 'Algonquin Provincial Park',
      dates: 'Aug 10-14, 2024',
      participants: [
        Participant(id: 1, name: 'Maria Rodriguez', avatar: ''),
        Participant(id: 2, name: 'John Smith', avatar: '', isLive: true),
        Participant(id: 3, name: 'You', avatar: '', isLive: true),
      ],
      checklist: [
        ChecklistItem(id: 1, item: 'Reserve campsites', completed: true, assignee: 'Maria'),
        ChecklistItem(id: 2, item: 'Pack camping gear', completed: false, assignee: 'You'),
        ChecklistItem(id: 3, item: 'Plan canoe route', completed: false, assignee: 'John'),
      ],
      schedule: [
        ScheduleItem(id: 1, time: '8:00 AM', activity: 'Meet at park entrance', location: 'Algonquin Park'),
        ScheduleItem(id: 2, time: '10:00 AM', activity: 'Canoe launch', location: 'Canoe Lake'),
        ScheduleItem(id: 3, time: '12:00 PM', activity: 'First portage', location: 'Portage Trail'),
      ],
      expenses: [
        Expense(id: 1, item: 'Park permits', amount: 90, paidBy: 'Maria', splitWith: ['All']),
        Expense(id: 2, item: 'Canoe rental', amount: 180, paidBy: 'John', splitWith: ['All']),
      ],
      totalBudget: 500,
      currentSpent: 270,
    ),
  ];

  late List<TripRoom> tripRooms;
  TripRoom? selectedRoom;
  bool showCreateForm = false;
  String searchQuery = '';
  late TabController tabController;
  List<ChecklistItem> checklist = [];
  String currentMessage = '';
  bool showEmojiPicker = false;
  bool showCameraMenu = false;
  bool showAttachMenu = false;

  final List<Message> messages = [
    Message(
      id: 1,
      sender: 'Alex Chen',
      avatar: '',
      content: 'Just confirmed our accommodation! We\'re all set for an amazing trip 🏔️',
      timestamp: '10:30 AM',
      isCurrentUser: false,
      type: 'text',
    ),
    Message(
      id: 2,
      sender: 'Sarah Kim',
      avatar: '',
      content: 'Perfect! I\'ll handle the permits today. Weather looks great for the weekend!',
      timestamp: '10:35 AM',
      isCurrentUser: false,
      type: 'text',
    )
  ];

  final Map<String, dynamic> newRoomForm = {
    'title': '',
    'location': '',
    'startDate': '',
    'endDate': '',
    'participants': '',
    'description': '',
  };

  @override
  void initState() {
    super.initState();
    tripRooms = List.from(mockTripRooms);
    selectedRoom = tripRooms.isNotEmpty ? tripRooms[0] : null;
    checklist = selectedRoom?.checklist ?? [];
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void toggleChecklistItem(int id) {
    setState(() {
      checklist = checklist.map((item) {
        if (item.id == id) {
          return ChecklistItem(
            id: item.id,
            item: item.item,
            completed: !item.completed,
            assignee: item.assignee,
          );
        }
        return item;
      }).toList();
    });
  }

  void selectRoom(TripRoom room) {
    setState(() {
      selectedRoom = room;
      checklist = List.from(room.checklist);
      tabController.animateTo(0);
    });
  }

  void handleCreateRoom() {
    if (newRoomForm['title'].isEmpty ||
        newRoomForm['location'].isEmpty ||
        newRoomForm['startDate'].isEmpty ||
        newRoomForm['endDate'].isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final newRoom = TripRoom(
      id: DateTime.now().millisecondsSinceEpoch,
      title: newRoomForm['title'],
      location: newRoomForm['location'],
      dates: '${DateFormat('MMM d').format(DateTime.parse(newRoomForm['startDate']))}-${DateFormat('MMM d, yyyy').format(DateTime.parse(newRoomForm['endDate']))}',
      participants: [
        Participant(id: 999, name: 'You', avatar: '', isLive: true),
      ],
      checklist: [
        ChecklistItem(id: 1, item: 'Plan itinerary', completed: false, assignee: 'You'),
        ChecklistItem(id: 2, item: 'Pack essentials', completed: false, assignee: 'You'),
      ],
      schedule: [
        ScheduleItem(id: 1, time: '9:00 AM', activity: 'Trip begins', location: newRoomForm['location']),
      ],
      expenses: [],
      totalBudget: 1000,
      currentSpent: 0,
    );

    setState(() {
      tripRooms = [newRoom, ...tripRooms];
      newRoomForm.updateAll((key, value) => '');
      showCreateForm = false;
      selectedRoom = newRoom;
      checklist = List.from(newRoom.checklist);
    });
  }

  void resetCreateForm() {
    setState(() {
      newRoomForm.updateAll((key, value) => '');
      showCreateForm = false;
    });
  }

  void handleSendMessage({String type = 'text', String? content}) {
    final messageContent = content ?? currentMessage;
    if (messageContent.trim().isEmpty && type == 'text') return;

    final newMessage = Message(
      id: messages.length + 1,
      sender: 'You',
      avatar: '',
      content: messageContent,
      timestamp: DateFormat('h:mm a').format(DateTime.now()),
      isCurrentUser: true,
      type: type,
    );

    setState(() {
      messages.add(newMessage);
      currentMessage = '';
      showEmojiPicker = false;
      showCameraMenu = false;
      showAttachMenu = false;
    });
  }

  Widget _buildIcon(IconData icon, {double size = 16}) {
    return Icon(icon, size: size);
  }

  Widget _buildAvatar(String name, {String? avatarUrl, bool isLive = false, double size = 32}) {
    return Stack(
      children: [
        CircleAvatar(
          radius: size / 2,
          backgroundColor: const Color(0xFFE8D9B5),
          child: avatarUrl != null && avatarUrl.isNotEmpty
              ? Image.network(avatarUrl)
              : Text(
            name.split(' ').map((n) => n[0]).join(''),
            style: TextStyle(fontSize: size * 0.4, color: const Color(0xFF003B2E)),
          ),
        ),
        if (isLive)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: const BoxDecoration(
                color: Colors.green,
                border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 1)),
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTripRoomList() {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Trip Rooms',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF003B2E)),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() => showCreateForm = true),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003B2E)),
                    child: const Row(
                      children: [
                        Icon(Icons.add, size: 16),
                        SizedBox(width: 4),
                        Text('Create Room'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Search
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search your trip rooms...',
                  prefixIcon: Icon(Icons.search, size: 16),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)), // Fixed this line
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) => setState(() => searchQuery = value),
              ),
            ],
          ),
        ),
        // Trip Rooms List
        Expanded(
          child: tripRooms.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tripRooms.length,
            itemBuilder: (context, index) {
              final room = tripRooms[index];
              return _buildTripRoomCard(room);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFE8D9B5),
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Icon(Icons.chat, size: 32, color: Color(0xFF003B2E)),
          ),
          const SizedBox(height: 16),
          const Text(
            'No trip rooms yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first trip room to start coordinating with your travel companions.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF6B6B6B)),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(() => showCreateForm = true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE66A00)),
            child: const Text('Create Your First Room'),
          ),
        ],
      ),
    );
  }

  Widget _buildTripRoomCard(TripRoom room) {
    return Card(
      child: InkWell(
        onTap: () => selectRoom(room),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildIcon(Icons.location_on, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              room.location,
                              style: const TextStyle(fontSize: 12, color: Color(0xFF6B6B6B)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Active',
                      style: TextStyle(color: Colors.green[800], fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildIcon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    room.dates,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6B6B6B)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildIcon(Icons.people, size: 16),
                      const SizedBox(width: 4),
                      Row(
                        children: [
                          for (int i = 0; i < room.participants.length && i < 4; i++)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: _buildAvatar(
                                room.participants[i].name,
                                isLive: room.participants[i].isLive,
                                size: 24,
                              ),
                            ),
                          if (room.participants.length > 4)
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Color(0xFF6B6B6B),
                                shape: BoxShape.circle,
                                border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 2)),
                              ),
                              child: Center(
                                child: Text(
                                  '+${room.participants.length - 4}',
                                  style: const TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                          Text(
                            '${room.participants.where((p) => p.isLive).length} online',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF6B6B6B)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => selectRoom(room),
                    child: const Text('Open →'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateRoomDialog() {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create Trip Room',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF003B2E),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Set up a coordination hub for your upcoming adventure.',
                                  style: TextStyle(
                                    color: Color(0xFF6B6B6B),
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() => showCreateForm = false),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Room Name and Location
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Room Name *',
                                    style: TextStyle(fontWeight: FontWeight.w500)),
                                TextField(
                                  decoration: const InputDecoration(
                                    hintText: 'Amazing Mountain Adventure Room',
                                  ),
                                  onChanged: (value) => newRoomForm['title'] = value,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Trip Location *',
                                    style: TextStyle(fontWeight: FontWeight.w500)),
                                TextField(
                                  decoration: const InputDecoration(
                                    hintText: 'National Park, City, Country',
                                  ),
                                  onChanged: (value) => newRoomForm['location'] = value,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Dates Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Start Date *',
                                    style: TextStyle(fontWeight: FontWeight.w500)),
                                TextField(
                                  readOnly: true,
                                  decoration: const InputDecoration(hintText: 'Start Date'),
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 365)),
                                    );
                                    if (date != null) {
                                      setState(() {
                                        newRoomForm['startDate'] =
                                        date.toIso8601String().split('T')[0];
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('End Date *',
                                    style: TextStyle(fontWeight: FontWeight.w500)),
                                TextField(
                                  readOnly: true,
                                  decoration: const InputDecoration(hintText: 'End Date'),
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 365)),
                                    );
                                    if (date != null) {
                                      setState(() {
                                        newRoomForm['endDate'] =
                                        date.toIso8601String().split('T')[0];
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Participants
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Invite Participants',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          TextField(
                            decoration: const InputDecoration(
                              hintText: 'Enter email addresses or usernames...',
                            ),
                            onChanged: (value) => newRoomForm['participants'] = value,
                          ),
                          const Text(
                            'You can add more participants later',
                            style: TextStyle(fontSize: 12, color: Color(0xFF6B6B6B)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Description
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Description (Optional)',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          TextField(
                            decoration: const InputDecoration(
                              hintText:
                              'Brief description of the trip and what you\'ll be coordinating...',
                            ),
                            maxLines: 4,
                            onChanged: (value) =>
                            newRoomForm['description'] = value,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => setState(() {
                                newRoomForm.updateAll((key, value) => '');
                                showCreateForm = false;
                              }),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: handleCreateRoom,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE66A00),
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text('Create Room'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSelectedRoomView() {
    if (selectedRoom == null) return Container();

    final completedItems = checklist.where((item) => item.completed).length;
    final double progressPercentage = checklist.isNotEmpty ? (completedItems / checklist.length) * 100 : 0;
    final double totalExpenses = selectedRoom!.expenses.fold(0.0, (sum, expense) => sum + expense.amount);
    final double perPersonShare = selectedRoom!.participants.isNotEmpty ? totalExpenses / selectedRoom!.participants.length : 0;

    return Column(
      children: [
        // Trip Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF003B2E), Color(0xFFE66A00)],
            ),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side: Back + Title (takes remaining width)
                  Expanded(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => setState(() => selectedRoom = null),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        Flexible(
                          child: Text(
                            selectedRoom!.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right side: Right-aligned button + chip
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => setState(() => showCreateForm = true),
                        icon: const Icon(Icons.add, size: 16, color: Colors.white),
                        label: const Text(
                          'New Room',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'In Progress',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildIcon(Icons.location_on, size: 16),
                  const SizedBox(width: 4),
                  Text(selectedRoom!.location, style: const TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildIcon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 4),
                  Text(selectedRoom!.dates, style: const TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildIcon(Icons.people, size: 16),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      for (final participant in selectedRoom!.participants)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildAvatar(
                            participant.name,
                            isLive: participant.isLive,
                            size: 32,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${selectedRoom!.participants.where((p) => p.isLive).length} online',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Tabs and Content
        Expanded(
          child: Column(
            children: [
              // Tab Bar
              Container(
                color: Colors.white,
                child: TabBar(
                  controller: tabController,
                  tabs: const [
                    Tab(icon: Icon(Icons.chat), text: 'Chat'),
                    Tab(icon: Icon(Icons.checklist), text: 'Checklist'),
                    Tab(icon: Icon(Icons.schedule), text: 'Schedule'),
                    Tab(icon: Icon(Icons.attach_money), text: 'Expenses'),
                  ],
                ),
              ),

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    _buildChatTab(),
                    _buildChecklistTab(progressPercentage, completedItems),
                    _buildScheduleTab(),
                    _buildExpensesTab(totalExpenses, perPersonShare),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                // Messages Area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                      children: [
                        // Messages
                        ...messages.map((message) => _buildMessageBubble(message)),

                        // Live Location Sharing Notice
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8D9B5).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(text: '📍 ', style: TextStyle(fontSize: 16)),
                                const TextSpan(
                                  text: 'Live Location Sharing Active\n',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: '${selectedRoom!.participants.where((p) => p.isLive).length} members are sharing their location for safety',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            style: const TextStyle(color: Color(0xFF003B2E)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Message Input Area
                _buildMessageInputArea(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: message.isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isCurrentUser) ...[
            _buildAvatar(message.sender, size: 32),
            const SizedBox(width: 12),
          ],

          Expanded(
            child: Column(
              crossAxisAlignment: message.isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Sender name and timestamp
                Row(
                  mainAxisAlignment: message.isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Text(
                      message.sender,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      message.timestamp,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF6B6B6B)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Message content
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message.isCurrentUser ? const Color(0xFFE66A00) : Colors.grey.shade100,
                    borderRadius: BorderRadius.only(
                      topLeft: message.isCurrentUser ? const Radius.circular(12) : const Radius.circular(4),
                      topRight: message.isCurrentUser ? const Radius.circular(4) : const Radius.circular(12),
                      bottomLeft: const Radius.circular(12),
                      bottomRight: const Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: _buildMessageContent(message),
                ),
              ],
            ),
          ),

          if (message.isCurrentUser) ...[
            const SizedBox(width: 12),
            _buildAvatar(message.sender, size: 32),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageContent(Message message) {
    switch (message.type) {
      case 'location':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on, size: 16, color: Color(0xFF4A90E2)),
            const SizedBox(width: 8),
            Text(
              message.content,
              style: TextStyle(
                color: message.isCurrentUser ? Colors.white : const Color(0xFF003B2E),
                fontSize: 14,
              ),
            ),
          ],
        );
      case 'image':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.image, size: 16),
            const SizedBox(width: 8),
            Text(
              message.content,
              style: TextStyle(
                color: message.isCurrentUser ? Colors.white : const Color(0xFF003B2E),
                fontSize: 14,
              ),
            ),
          ],
        );
      case 'gif':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.movie, size: 16),
            const SizedBox(width: 8),
            Text(
              message.content,
              style: TextStyle(
                color: message.isCurrentUser ? Colors.white : const Color(0xFF003B2E),
                fontSize: 14,
              ),
            ),
          ],
        );
      default:
        return Text(
          message.content,
          style: TextStyle(
            color: message.isCurrentUser ? Colors.white : const Color(0xFF003B2E),
            fontSize: 14,
          ),
        );
    }
  }

  Widget _buildMessageInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          // Camera Options Menu
          if (showCameraMenu) _buildCameraOptionsMenu(),

          // Attachment Options Menu
          if (showAttachMenu) _buildAttachmentOptionsMenu(),

          // Emoji Picker Menu
          if (showEmojiPicker) _buildEmojiPickerMenu(),

          // Input Row
          Row(
            children: [
              // Camera Button
              IconButton(
                onPressed: () {
                  setState(() {
                    showCameraMenu = !showCameraMenu;
                    showAttachMenu = false;
                    showEmojiPicker = false;
                  });
                },
                icon: Icon(
                  Icons.camera_alt,
                  color: showCameraMenu ? const Color(0xFFE66A00) : const Color(0xFF6B6B6B),
                ),
              ),

              // Attachment Button
              IconButton(
                onPressed: () {
                  setState(() {
                    showAttachMenu = !showAttachMenu;
                    showCameraMenu = false;
                    showEmojiPicker = false;
                  });
                },
                icon: Icon(
                  Icons.attach_file,
                  color: showAttachMenu ? const Color(0xFFE66A00) : const Color(0xFF6B6B6B),
                ),
              ),

              // Message Input
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: Color(0xFFE66A00), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showEmojiPicker = !showEmojiPicker;
                          showCameraMenu = false;
                          showAttachMenu = false;
                        });
                      },
                      icon: Icon(
                        Icons.emoji_emotions,
                        color: showEmojiPicker ? const Color(0xFFE66A00) : const Color(0xFF6B6B6B),
                      ),
                    ),
                  ),
                  maxLines: null,
                  controller: TextEditingController(text: currentMessage),
                  onChanged: (value) => setState(() => currentMessage = value),
                  onSubmitted: (value) {
                    handleSendMessage();
                    setState(() {
                      showCameraMenu = false;
                      showAttachMenu = false;
                      showEmojiPicker = false;
                    });
                  },
                ),
              ),

              // Send Button
              IconButton(
                onPressed: currentMessage.trim().isEmpty
                    ? null
                    : () {
                  handleSendMessage();
                  setState(() {
                    showCameraMenu = false;
                    showAttachMenu = false;
                    showEmojiPicker = false;
                  });
                },
                icon: Icon(
                  Icons.send,
                  color: currentMessage.trim().isEmpty
                      ? Colors.grey.shade400
                      : const Color(0xFFE66A00),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCameraOptionsMenu() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Camera Options',
            style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF003B2E)),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    handleSendMessage(type: 'image', content: '📸 Shared a trail photo from camera');
                    setState(() => showCameraMenu = false);
                  },
                  icon: const Text('📷'),
                  label: const Text('Take Photo'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    handleSendMessage(type: 'image', content: '🎥 Shared a video from adventure');
                    setState(() => showCameraMenu = false);
                  },
                  icon: const Text('🎥'),
                  label: const Text('Record Video'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    handleSendMessage(type: 'image', content: '🖼️ Shared photos from gallery');
                    setState(() => showCameraMenu = false);
                  },
                  icon: const Text('🖼️'),
                  label: const Text('From Gallery'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentOptionsMenu() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Attach File',
            style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF003B2E)),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  handleSendMessage(type: 'location', content: '📍 Shared current location: ${selectedRoom!.location}');
                  setState(() => showAttachMenu = false);
                },
                icon: const Text('📍'),
                label: const Text('Location'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  handleSendMessage(type: 'text', content: '📄 Shared trip-itinerary.pdf');
                  setState(() => showAttachMenu = false);
                },
                icon: const Text('📄'),
                label: const Text('Document'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  handleSendMessage(type: 'text', content: '🎵 Shared adventure-playlist.mp3');
                  setState(() => showAttachMenu = false);
                },
                icon: const Text('🎵'),
                label: const Text('Audio'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  handleSendMessage(type: 'text', content: '☎️ Shared contact: Mountain Rescue (403-762-1111)');
                  setState(() => showAttachMenu = false);
                },
                icon: const Text('☎️'),
                label: const Text('Contact'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiPickerMenu() {
    final travelEmojis = [
      '😊', '👍', '❤️', '😂', '🎉', '🏔️', '🥾', '📍',
      '🌲', '🏕️', '🎒', '🧗', '🚶', '🌄', '⛰️', '🗺️',
      '📸', '🔥', '⭐', '✅', '🙌', '💪', '🌟', '🎯'
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Travel Emojis',
            style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF003B2E)),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: travelEmojis.length,
            itemBuilder: (context, index) {
              return IconButton(
                onPressed: () {
                  setState(() {
                    currentMessage += travelEmojis[index];
                    showEmojiPicker = false;
                  });
                },
                icon: Text(
                  travelEmojis[index],
                  style: const TextStyle(fontSize: 20),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFE66A00).withOpacity(0.1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistTab(double progressPercentage, int completedItems) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Trip Checklist',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  '$completedItems of ${checklist.length} completed',
                  style: const TextStyle(color: Color(0xFF6B6B6B)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Progress Bar
            LinearProgressIndicator(
              value: progressPercentage / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF003B2E)),
              minHeight: 8,
            ),
            const SizedBox(height: 24),

            // Checklist Items
            Column(
              children: checklist.map((item) => CheckboxListTile(
                title: Text(
                  item.item,
                  style: TextStyle(
                    decoration: item.completed ? TextDecoration.lineThrough : TextDecoration.none,
                    color: item.completed ? const Color(0xFF6B6B6B) : Colors.black,
                  ),
                ),
                subtitle: item.assignee != null
                    ? Text('Assigned to: ${item.assignee}')
                    : null,
                value: item.completed,
                onChanged: (value) => toggleChecklistItem(item.id),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              )).toList(),
            ),

            // Add New Item Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement add new item functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE66A00),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 16),
                    SizedBox(width: 8),
                    Text('Add New Item'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Trip Schedule',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement add event functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE66A00),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add, size: 16),
                      SizedBox(width: 4),
                      Text('Add Event'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Schedule Items
            Column(
              children: selectedRoom!.schedule.map((event) => Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8D9B5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        event.time,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF003B2E),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.activity,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: Color(0xFF6B6B6B)),
                              const SizedBox(width: 4),
                              Text(
                                event.location,
                                style: const TextStyle(color: Color(0xFF6B6B6B), fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesTab(double totalExpenses, double perPersonShare) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Trip Expenses',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement add expense functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE66A00),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add, size: 16),
                      SizedBox(width: 4),
                      Text('Add Expense'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Budget Overview
            Row(
              children: [
                Expanded(
                  child: _buildBudgetCard(
                    'Total Budget',
                    '\$${selectedRoom!.totalBudget.toStringAsFixed(0)}',
                    const Color(0xFFE8D9B5).withOpacity(0.3),
                    const Color(0xFF003B2E),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildBudgetCard(
                    'Total Spent',
                    '\$${totalExpenses.toStringAsFixed(0)}',
                    Colors.red.shade50,
                    Colors.red.shade600,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildBudgetCard(
                    'Remaining',
                    '\$${(selectedRoom!.totalBudget - totalExpenses).toStringAsFixed(0)}',
                    Colors.green.shade50,
                    Colors.green.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Progress Bar
            LinearProgressIndicator(
              value: totalExpenses / selectedRoom!.totalBudget,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF003B2E)),
              minHeight: 8,
            ),
            const SizedBox(height: 24),

            // Expenses List
            Column(
              children: selectedRoom!.expenses.map((expense) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expense.item,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Paid by ${expense.paidBy} • Split with ${expense.splitWith.join(', ')}',
                            style: const TextStyle(color: Color(0xFF6B6B6B), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${expense.amount.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '\$${(expense.amount / selectedRoom!.participants.length).toStringAsFixed(2)} per person',
                          style: const TextStyle(color: Color(0xFF6B6B6B), fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              )).toList(),
            ),

            // Your Share
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8D9B5).withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your share:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '\$${perPersonShare.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003B2E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetCard(String title, String amount, Color backgroundColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            amount,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B6B6B),
            ),
          ),
        ],
      ),
    );
  } // ← Add this closing brace if it's missing

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: selectedRoom == null ? _buildTripRoomList() : _buildSelectedRoomView(),
      bottomSheet: showCreateForm ? _buildCreateRoomDialog() : null,
    );
  }
}