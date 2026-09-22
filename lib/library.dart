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
  // Library er boi er data store korar list
  List<String> bookTitles = [];
  List<String> bookAuthors = [];
  List<bool> bookAvailable = [];

  // Active ticket ebong queue status er state
  bool hasTicket = false;
  String ticketBookName = '';
  String ticketId = '';
  int serialNumber = 0;

  @override
  void initState() {
    super.initState();
    loadBooks();
    loadMyTicket();
  }

  // Firebase Firestore theke real-time e boi er list load kora
  void loadBooks() {
    FirebaseFirestore.instance
        .collection('books')
        .snapshots()
        .listen((snapshot) {
      final List<String> loadedTitles = [];
      final List<String> loadedAuthors = [];
      final List<bool> loadedAvailability = [];

      for (int i = 0; i < snapshot.docs.length; i++) {
        var doc = snapshot.docs[i];
        String title = doc['title'];
        String author = doc['author'];
        bool isAvailable = doc['isAvailable'];

        if (loadedTitles.contains(title)) continue;

        loadedTitles.add(title);
        loadedAuthors.add(author);
        loadedAvailability.add(isAvailable);
      }


        setState(() {
          bookTitles = loadedTitles;
          bookAuthors = loadedAuthors;
          bookAvailable = loadedAvailability;
        });

    });
  }

  // Current user er active ticket check kora ebong serial number count kora
  void loadMyTicket() {
    final String myEmail = FirebaseAuth.instance.currentUser?.email ??
        AuthService().currentUserEmail ??
        '';

    FirebaseFirestore.instance
        .collection('tickets')
        .snapshots()
        .listen((snapshot) {
      bool found = false;
      String book = '';
      String id = '';
      int serial = 0;

      for (int i = 0; i < snapshot.docs.length; i++) {
        var doc = snapshot.docs[i];
        if (doc['userId'] == myEmail && doc['status'] == 'active') {
          found = true;
          book = doc['bookTitle'];
          id = doc.id;
        }
      }

      // Same boi er queue te active user koyjon ache tar serial count kora
      if (found) {
        for (int i = 0; i < snapshot.docs.length; i++) {
          var doc = snapshot.docs[i];
          if (doc['bookTitle'] == book && doc['status'] == 'active') {
            serial++;
          }
        }
      }

        setState(() {
          hasTicket = found;
          ticketBookName = book;
          ticketId = id;
          serialNumber = serial;
        });

    });
  }

  // Boi collect korar jonno Firestore e notun ticket book kora
  void getTicket(String bookTitle) {
    final String myEmail = FirebaseAuth.instance.currentUser?.email ??
        AuthService().currentUserEmail ??
        '';

    FirebaseFirestore.instance.collection('tickets').add({
      'userId': myEmail,
      'bookTitle': bookTitle,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'active',
    });
  }

  // Current active ticket cancel kora
  void cancelTicket() {
    if (ticketId.isEmpty) return;

    FirebaseFirestore.instance.collection('tickets').doc(ticketId).update({
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
            // Library status card: Opening hours ebong current status
            Card(
              color: Colors.green.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              elevation: 10,
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
                          'Hours: 10:00 AM - 6:00 PM',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
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

            // User er jodi kono active ticket thake taile ticket card show korbe
            if (hasTicket)
              Card(
                color: Colors.green.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                  side: const BorderSide(color: Colors.brown),
                ),
                elevation: 10,
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
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          TextButton(
                            onPressed: cancelTicket,
                            child: const Text(
                              'Cancel Ticket',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Book: $ticketBookName',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('People in queue: $serialNumber'),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 22),

            Text(
              'Book Availability >>',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade900,
              ),
            ),
            const SizedBox(height: 10),

            if (bookTitles.isEmpty) const Text('Loading books...'),

            // Available boi gular list render kora
            for (int i = 0; i < bookTitles.length; i++)
              Card(
                child: ListTile(
                  leading: Icon(
                    Icons.menu_book,
                    color: bookAvailable[i] == true
                        ? Colors.green
                        : Colors.red,
                  ),
                  title: Text(bookTitles[i]),
                  subtitle: Text(bookAuthors[i]),
                  trailing: bookAvailable[i] == true
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => getTicket(bookTitles[i]),
                          child: const Text('Get Ticket'),
                        )
                      : const Text(
                          'Unavailable',
                          style: TextStyle(color: Colors.red),
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
