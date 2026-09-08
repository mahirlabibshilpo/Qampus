import 'package:flutter/material.dart';

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

  String searchQuery = '';

 
  bool hasToken = true;
  String tokenNumber = 'C-042';
  String activeItem = 'Chicken Biryani Platter';

  
  final List<CanteenItem> menuItems = const [
    CanteenItem('Chicken Biryani Platter', 'Lunch & Dinner', '\$4.50', 'Available'),
    CanteenItem('Vegetable Fried Rice', 'Lunch & Dinner', '\$3.00', 'Available'),
    CanteenItem('Grilled Chicken Sandwich', 'Snacks', '\$2.50', 'Available'),
    CanteenItem('Beef Cheeseburger', 'Fast Food', '\$3.80', 'Unavailable'),
    CanteenItem('Cold Coffee & Muffin', 'Beverages & Bakery', '\$2.00', 'Available'),
    CanteenItem('Samosa & Chai Combo', 'Snacks', '\$1.50', 'Available'),
  ];

  // token cancel korar jonno popup
  void showCancelTokenDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel Token?'),
        content: const Text('Do you want to cancel this token?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                hasToken = false;
              });
              Navigator.pop(context);
            },
            child: const Text('Yes', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final filteredItems = menuItems.where((item) {    

      final query = searchQuery.toLowerCase();
      return item.name.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Canteen Services', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // canteen status card
            Card(
              color: Colors.green.shade800,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CAMPUS CANTEEN', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Hours: 7:30 AM - 9:00 PM', style: TextStyle(color: Colors.white, fontSize: 13)),
                      ],
                    ),
                    Text('-> Open Now', style: TextStyle(color: Colors.lightGreenAccent, fontSize: 25, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Now Serving', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('C-040', style: TextStyle(color: Colors.black38, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 0.4,
                        minHeight: 11,
                        backgroundColor: Colors.teal.shade100,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // user er token thakle show korbe
            if (hasToken)
              Card(
                color: Colors.green.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.green),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('TOKEN #$tokenNumber', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green)),
                          TextButton(
                            onPressed: showCancelTokenDialog,
                            child: const Text('Cancel Token', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                      Text('Item: $activeItem', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 4),
                      const Text('Queue: #5', style: TextStyle(fontSize: 13, color: Colors.black54)),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // search box
            const Text('Menu>>>', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search food >>>',
                prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white70),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // menu item cards
            for (var item in filteredItems)
              Card(
                margin: const EdgeInsets.only(bottom: 5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.lightGreenAccent.shade200,
                    child: const Icon(Icons.restaurant, color: Colors.green),
                  ),
                  title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${item.category} • ${item.price}', style: const TextStyle(fontSize: 12)),
                      Text(
                        item.status,
                        style: TextStyle(
                          color: item.status == 'Available' ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: item.status == 'Available' ? Colors.green : Colors.grey.shade200,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    onPressed: item.status == 'Available'
                        ? () {
                            setState(() {
                              hasToken = true;
                              activeItem = item.name;
                              tokenNumber = 'C-043';
                            });
                          }
                        : null,
                    child: Text(item.status == 'Available' ? 'Get Token' : 'Unavailable', style: const TextStyle(fontSize: 12)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
