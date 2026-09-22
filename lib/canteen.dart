import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class CanteenPage extends StatefulWidget {
  const CanteenPage({super.key});
  @override
  State<CanteenPage> createState() => _CanteenPageState();
}

class _CanteenPageState extends State<CanteenPage> {
  final items = const ['Chicken Biryani', 'Vegetable Fried Rice',
      'Chicken Sandwich', 'Beef Burger', 'Cold Coffee'];
  final prices = const ['120 Tk', '100 Tk', '80 Tk', '90 Tk', '60 Tk'];
  final db = FirebaseFirestore.instance;
  Map<String, bool> stock = {};
  String? tokenId;
  String tokenFood = '';

  String get email => FirebaseAuth.instance.currentUser?.email ??
      AuthService().currentUserEmail ?? 'guest';

  @override
  void initState() {
    super.initState();
    db.collection('foods').get().then((s) {
      if (s.docs.isEmpty) {
        for (final i in items) db.collection('foods').doc(i).set({'isAvailable': true});
      }
    });
    db.collection('foods').snapshots().listen((s) {
      final m = {for (var d in s.docs) d.id: (d['isAvailable'] ?? true) as bool};
      if (mounted) setState(() => stock = m);
    });
    db.collection('canteen_tokens').snapshots().listen((s) {
      String? id; String food = '';
      for (final d in s.docs) {
        if (d['userEmail'] == email && d['status'] == 'active') { id = d.id; food = d['foodName']; }
      }
      if (mounted) setState(() { tokenId = id; tokenFood = food; });
    });
  }

  void getToken(String item) => db.collection('canteen_tokens').add(
      {'userEmail': email, 'foodName': item, 'status': 'active', 'timestamp': FieldValue.serverTimestamp()});

  void cancelToken() => db.collection('canteen_tokens').doc(tokenId).update({'status': 'cancelled'});

  void setStock(String item, bool v) => db.collection('foods').doc(item).update({'isAvailable': v});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Canteen'), backgroundColor: Colors.green, foregroundColor: Colors.white),
      body: Column(children: [
        if (tokenId != null)
          Container(
            width: double.infinity, padding: const EdgeInsets.all(16), color: Colors.green.shade50,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Your Token: $tokenFood', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              TextButton(onPressed: cancelToken, child: const Text('Cancel')),
            ]),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) {
              final ok = stock[items[i]] ?? true;
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: Icon(Icons.restaurant, color: ok ? Colors.green : Colors.red),
                  title: Text(items[i]),
                  subtitle: Text(prices[i]),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    Switch(value: ok, activeColor: Colors.green, onChanged: (v) => setStock(items[i], v)),
                    ok
                        ? ElevatedButton(onPressed: () => getToken(items[i]), child: const Text('Get'))
                        : const Text('N/A', style: TextStyle(color: Colors.red)),
                  ]),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}