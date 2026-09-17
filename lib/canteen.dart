import 'package:flutter/material.dart';

class CanteenPage extends StatefulWidget {
  const CanteenPage({super.key});
  @override
  State<CanteenPage> createState() => _CanteenPageState();
}
class _CanteenPageState extends State<CanteenPage> {
  // Canteen er food list
  final List<String> foods = [
    'Chicken Biryani',
    'Vegetable Fried Rice',
    'Chicken Sandwich',
    'Beef Burger',
    'Cold Coffee',
  ];
  final List<String> prices = ['120 Tk', '100 Tk', '80 Tk', '90 Tk', '60 Tk'];
  String myToken = '';
  void getToken(int index) {
    setState(() {
      myToken = 'C-0${index + 1}';
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canteen'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.green.shade50,
            child: Text(
              myToken == '' ? 'No token taken' : 'Your Token: $myToken',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: foods.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: const Icon(Icons.restaurant, color: Colors.green),
                    title: Text(foods[index]),
                    subtitle: Text(prices[index]),
                    trailing: ElevatedButton(
                      onPressed: () => getToken(index),
                      child: const Text('Get Token'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
