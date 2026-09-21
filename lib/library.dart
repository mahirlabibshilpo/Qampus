import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  // Current user's email
  String get userEmail {
    return FirebaseAuth.instance.currentUser?.email ?? 
           AuthService().currentUserEmail ?? 
           'student@qampus.com';
  }

  // Get a ticket for a book
  Future<void> bookTicket(String bookTitle) async {
    await FirebaseFirestore.instance.collection('tickets').add({
      'userId': userEmail,
      'bookTitle': bookTitle,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'active',
    });
  }

  // Cancel current ticket
  Future<void> cancelTicket(String docId) async {
    await FirebaseFirestore.instance.collection('tickets').doc(docId).update({
      'status': 'cancelled',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Library Services',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Library status card
            Card(
              color: Colors.green.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CENTRAL LIBRARY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Hours: 8:00 AM - 8:00 PM',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                    Text(
                      'Open Now',
                      style: TextStyle(
                        color: Colors.lightGreenAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Active Ticket Section (Real-time)
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tickets')
                  .where('userId', isEqualTo: userEmail)
                  .where('status', isEqualTo: 'active')
                  .snapshots(),
              builder: (context, ticketSnapshot) {
                if (!ticketSnapshot.hasData || ticketSnapshot.data!.docs.isEmpty) {
                  return const SizedBox.shrink();
                }

                var myTicketDoc = ticketSnapshot.data!.docs.first;
                var myTicketData = myTicketDoc.data() as Map<String, dynamic>;
                String bookedBook = myTicketData['bookTitle'];
                Timestamp? myTime = myTicketData['timestamp'] as Timestamp?;

                // Queue check (Count tickets before mine)
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('tickets')
                      .where('bookTitle', isEqualTo: bookedBook)
                      .where('status', isEqualTo: 'active')
                      .snapshots(),
                  builder: (context, queueSnapshot) {
                    int peopleAhead = 0;
                    if (queueSnapshot.hasData && myTime != null) {
                      for (var doc in queueSnapshot.data!.docs) {
                        var data = doc.data() as Map<String, dynamic>;
                        Timestamp? theirTime = data['timestamp'] as Timestamp?;
                        if (theirTime != null && theirTime.toDate().isBefore(myTime.toDate())) {
                          peopleAhead++;
                        }
                      }
                    }

                    return Card(
                      color: Colors.green.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: Colors.green),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'YOUR TICKET',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Cancel Ticket?'),
                                        content: const Text('Do you want to cancel this ticket?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('No'),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                            onPressed: () {
                                              cancelTicket(myTicketDoc.id);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Yes', style: TextStyle(color: Colors.white)),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Cancel Ticket',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                            Text('Book: $bookedBook', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 8),
                            Text('People ahead of you: $peopleAhead', style: const TextStyle(color: Colors.black87)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 16),

            // Book List Section (Real-time)
            const Text('Book Availability', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('books').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('No books available in database.');
                }

                var books = snapshot.data!.docs;

                return Column(
                  children: books.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    String title = data['title'] ?? 'Unknown';
                    String author = data['author'] ?? 'Unknown';
                    bool isAvailable = data['isAvailable'] ?? false;

                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.menu_book, color: isAvailable ? Colors.green : Colors.red),
                        title: Text(title),
                        subtitle: Text(author),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isAvailable ? Colors.green : Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: isAvailable ? () => bookTicket(title) : null,
                          child: Text(isAvailable ? 'Get Ticket' : 'Unavailable'),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
