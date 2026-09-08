import 'dart:async';
import 'package:flutter/material.dart';
import 'models/queue_service.dart';

class ClubEvent {
  final String name;
  final String club;
  final String date;
  final String status;

  const ClubEvent(this.name, this.club, this.date, this.status);
}

class ClubOfficePage extends StatefulWidget {
  const ClubOfficePage({super.key});

  @override
  State<ClubOfficePage> createState() => _ClubOfficePageState();
}

class _ClubOfficePageState extends State<ClubOfficePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  late final QueueService _queueService;
  Map<String, dynamic>? _token;

  int _queueLength = 4;
  int _nowServingNumber = 10;
  Timer? _simulationTimer;

  final List<ClubEvent> _events = const [
    ClubEvent('Robotics Workshop 2026', 'Robotics Club', 'Tomorrow, 3:00 PM', 'Open'),
    ClubEvent('Annual Hackathon Registration', 'Computer Club', 'Oct 15, 10:00 AM', 'Open'),
    ClubEvent('Inter-University Debate Championship', 'Debating Society', 'Oct 20, 2:00 PM', 'Open'),
    ClubEvent('Photography Walk & Exhibition', 'Photography Club', 'Oct 25, 9:00 AM', 'Closed'),
    ClubEvent('Cultural Fest Auditions', 'Cultural Club', 'Nov 02, 4:00 PM', 'Open'),
    ClubEvent('Badminton Tournament Sign-up', 'Sports Club', 'Nov 05, 11:00 AM', 'Open'),
  ];

  @override
  void initState() {
    super.initState();
    _queueService = QueueService.defaultServices().firstWhere((s) => s.id == 'club_office');
    _token = _buildToken(12, 'Robotics Workshop 2026', aheadCount: 2);
    _startSimulationTimer();
  }

  String _formatToken(int number) {
    final prefix = _queueService.codePrefix.split(' ').last;
    return '$prefix-${number.toString().padLeft(3, '0')}';
  }

  void _startSimulationTimer() {
    _simulationTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (!mounted) return;
      setState(() {
        _nowServingNumber++;
        if (_queueLength > 1) {
          _queueLength--;
        } else {
          _queueLength = 3;
        }

        if (_token != null) {
          final tokenNum = _token!['tokenNum'] as int;
          int newAhead = tokenNum - _nowServingNumber;
          if (newAhead < 0) newAhead = 0;
          final newPosition = newAhead > 0 ? newAhead + 1 : 1;
          final wait = newAhead == 0 ? 'Ready now' : '${newAhead * _queueService.avgWaitPerPerson} mins';

          if (_queueLength < newAhead + 1) {
            _queueLength = newAhead + 1;
          }

          _token!['serving'] = _formatToken(_nowServingNumber);
          _token!['ahead'] = newAhead;
          _token!['position'] = newPosition;
          _token!['wait'] = wait;
        }
      });
    });
  }

  Map<String, dynamic> _buildToken(int number, String eventName, {int? aheadCount}) {
    final ahead = aheadCount ?? (_queueLength > 0 ? _queueLength : 1);
    final position = ahead + 1;
    final wait = ahead == 0 ? 'Ready now' : '${ahead * _queueService.avgWaitPerPerson} mins';
    return {
      'tokenNum': number,
      'number': _formatToken(number),
      'event': eventName,
      'serving': _formatToken(_nowServingNumber),
      'position': position,
      'ahead': ahead,
      'wait': wait,
    };
  }

  List<ClubEvent> get _filteredEvents {
    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return _events;
    return _events.where((event) =>
        event.name.toLowerCase().contains(q) ||
        event.club.toLowerCase().contains(q)).toList();
  }

  void _registerToken(ClubEvent event) {
    if (event.status == 'Closed') {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration for ${event.name} is currently closed!'),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    if (_token != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You already have an active registration (${_token!['number']}). Please cancel it first.'),
          backgroundColor: Colors.orange.shade800,
        ),
      );
      return;
    }

    final issuedTokenNum = _nowServingNumber + _queueLength + 1;
    final ahead = _queueLength;
    _queueLength++;

    setState(() {
      _token = _buildToken(issuedTokenNum, event.name, aheadCount: ahead);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Token ${_token!['number']} issued for ${event.name}!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _cancelToken() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel Token'),
        content: const Text('Are you sure you want to cancel your queue token?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _token = null;
                if (_queueLength > 0) {
                  _queueLength--;
                }
              });
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Token cancelled successfully.')),
              );
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Club Office Services', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.green.shade50,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.green.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 26,
                      child: Icon(Icons.groups, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Student Club Office',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Open Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Hours: 9:00 AM - 5:00 PM',
                            style: TextStyle(fontSize: 13, color: Colors.black54),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Student activity & event registration',
                            style: TextStyle(fontSize: 12, color: Colors.black45),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.green.shade50,
                                child: Icon(Icons.notifications_active_outlined, color: Colors.green.shade700, size: 17),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Live',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _formatToken(_nowServingNumber),
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Now Serving',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    elevation: 2,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.teal.shade50,
                                child: Icon(Icons.people_alt_outlined, color: Colors.teal.shade700, size: 17),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '~${_queueLength * _queueService.avgWaitPerPerson}m',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.teal.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '$_queueLength Waiting',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'People in Queue',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (_token != null)
              Card(
                elevation: 3,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.green.shade300, width: 1.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.green.shade100,
                                child: Icon(Icons.confirmation_number_outlined, color: Colors.green.shade800, size: 20),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Your Active Token',
                                    style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    _token!['number'],
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TextButton.icon(
                            onPressed: _cancelToken,
                            icon: const Icon(Icons.cancel_outlined, size: 16, color: Colors.red),
                            label: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.event_note, size: 18, color: Colors.green.shade800),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _token!['event'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                children: [
                                  const Text('Position', style: TextStyle(fontSize: 11, color: Colors.black54)),
                                  const SizedBox(height: 2),
                                  Text(
                                    '#${_token!['position']}',
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                children: [
                                  const Text('Ahead', style: TextStyle(fontSize: 11, color: Colors.black54)),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${_token!['ahead']}',
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                children: [
                                  const Text('Est. Wait', style: TextStyle(fontSize: 11, color: Colors.black54)),
                                  const SizedBox(height: 2),
                                  Text(
                                    _token!['wait'],
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.teal.shade800),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if ((_token!['ahead'] as int) == 1) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber.shade400),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time_filled, color: Colors.amber.shade900, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Your turn is coming soon! Please stay nearby.',
                                  style: TextStyle(
                                    color: Colors.amber.shade900,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else if ((_token!['ahead'] as int) == 0) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.green.shade600,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white, size: 20),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "It's your turn! Please proceed to the office desk.",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              )
            else
              Card(
                elevation: 2,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green.shade50,
                        child: const Icon(Icons.info_outline, color: Colors.green),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'No Active Registration',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Tap "Register" on any open event below to join queue.',
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'Club Events & Activities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search event, activity, or club...',
                prefixIcon: const Icon(Icons.search, color: Colors.green),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.green, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 14),
            if (_filteredEvents.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No events found for "$_searchQuery"',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              )
            else
              ..._filteredEvents.map((event) {
                final isOpen = event.status != 'Closed';
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    leading: CircleAvatar(
                      backgroundColor: Colors.lightGreenAccent.shade100,
                      child: Icon(Icons.event, color: Colors.green.shade800),
                    ),
                    title: Text(event.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${event.club} • ${event.date}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                          const SizedBox(height: 2),
                          Text(
                            event.status,
                            style: TextStyle(
                              color: isOpen ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isOpen ? Colors.green : Colors.grey.shade400,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      onPressed: () => _registerToken(event),
                      child: Text(isOpen ? 'Register' : 'Closed', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
