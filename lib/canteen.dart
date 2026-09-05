import 'package:flutter/material.dart';
import 'models/queue_service.dart';

// Library er moto pattern follow kore canteen er jonno banano hoyeche
class CanteenItem {
  final String name;
  final String category;
  final String price;
  final String status;

  const CanteenItem(this.name, this.category, this.price, this.status);
}

class CanteenPage extends StatefulWidget {
  const CanteenPage({super.key});

  @override
  State<CanteenPage> createState() => _CanteenPageState();
}

class _CanteenPageState extends State<CanteenPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  late final QueueService _queueService;
  Map<String, dynamic>? _token;

  final List<CanteenItem> _menuItems = const [
    CanteenItem('Chicken Biryani Platter', 'Lunch & Dinner', '\$4.50', 'Available'),
    CanteenItem('Vegetable Fried Rice', 'Lunch & Dinner', '\$3.00', 'Available'),
    CanteenItem('Grilled Chicken Sandwich', 'Snacks', '\$2.50', 'Available'),
    CanteenItem('Beef Cheeseburger', 'Fast Food', '\$3.80', 'Unavailable'),
    CanteenItem('Cold Coffee & Muffin', 'Beverages & Bakery', '\$2.00', 'Available'),
    CanteenItem('Samosa & Chai Combo', 'Snacks', '\$1.50', 'Available'),
  ];

  // canteen entry queue_service.dart theke asche
  @override
  void initState() {
    super.initState();
    _queueService = QueueService.defaultServices().firstWhere((s) => s.id == 'canteen');
    _token = _buildToken('042', 'Chicken Biryani Platter');
  }

  // token map ekbar e banano jate baar baar likhte na hoy
  Map<String, dynamic> _buildToken(String number, String itemName) {
    final prefix = _queueService.codePrefix.split(' ').last;
    final wait = _queueService.currentQueueLength * _queueService.avgWaitPerPerson;
    return {
      'number': '$prefix-$number',
      'item': itemName,
      'serving': '$prefix-035',
      'position': _queueService.currentQueueLength + 1,
      'ahead': _queueService.currentQueueLength,
      'wait': '$wait mins',
    };
  }

  List<CanteenItem> get _filteredMenuItems {
    final q = _searchQuery.toLowerCase();
    return _menuItems.where((item) =>
        item.name.toLowerCase().contains(q) || item.category.toLowerCase().contains(q)).toList();
  }

  void _getToken(CanteenItem item) {
    if (item.status == 'Unavailable') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${item.name} is currently unavailable!')),
      );
      return;
    }
    setState(() => _token = _buildToken('043', item.name));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Token ${_token!['number']} issued for ${item.name}!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _cancelToken() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Token'),
        content: const Text('Are you sure you want to cancel your queue token?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              setState(() => _token = null);
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
        title: const Text('Canteen Services', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.green.shade800,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CAMPUS CANTEEN', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Hours: 7:30 AM - 9:00 PM', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                    Text('● Open Now', style: TextStyle(color: Colors.lightGreenAccent, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Live Queue Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('${_queueService.currentQueueLength} in Queue', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: (_queueService.currentQueueLength / 15).clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: Colors.green.shade100,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Prefix: ${_queueService.codePrefix}  |  Avg Wait: ${_queueService.avgWaitPerPerson} mins/person  |  Est. Wait: ${_queueService.currentQueueLength * _queueService.avgWaitPerPerson} mins',
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (_token != null)
              Card(
                color: Colors.green.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.green)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('TOKEN #${_token!['number']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                          TextButton(onPressed: _cancelToken, child: const Text('Cancel Token', style: TextStyle(color: Colors.red))),
                        ],
                      ),
                      Text('Item: ${_token!['item']}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text('Now Serving: ${_token!['serving']}  |  Your Position: #${_token!['position']}'),
                      Text('People Ahead: ${_token!['ahead']}  |  Est. Wait: ${_token!['wait']}', style: const TextStyle(color: Colors.black54, fontSize: 13)),
                    ],
                  ),
                ),
              )
            else
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Text('No active token. Tap "Get Token" on any menu item below to join queue.', style: TextStyle(color: Colors.black54)),
                ),
              ),
            const SizedBox(height: 20),

            const Text('Menu Items & Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search menu item or category...',
                prefixIcon: const Icon(Icons.search, color: Colors.green),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),

            ..._filteredMenuItems.map((item) {
              final isAvailable = item.status != 'Unavailable';
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: Colors.green.shade50, child: const Icon(Icons.restaurant, color: Colors.green)),
                  title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${item.category} • ${item.price}', style: const TextStyle(fontSize: 12)),
                      Text(item.status, style: TextStyle(color: isAvailable ? Colors.green : Colors.red, fontWeight: FontWeight.w600, fontSize: 12)),
                    ],
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: isAvailable ? Colors.green : Colors.grey, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10)),
                    onPressed: () => _getToken(item),
                    child: Text(isAvailable ? 'Get Token' : 'Unavailable', style: const TextStyle(fontSize: 12)),
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