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
  // বইয়ের তথ্য
  List bookTitles = [];
  List bookAuthors = [];
  List bookAvailable = [];

  // টিকিটের তথ্য
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

  // ফায়ারবেস থেকে বই আনা
  void loadBooks() {
    FirebaseFirestore.instance.collection('books').snapshots().listen((data) {
      List t = [];
      List a = [];
      List av = [];
      for (int i = 0; i < data.docs.length; i++) {
        if (t.contains(data.docs[i]['title'])) continue;
        t.add(data.docs[i]['title']);
        a.add(data.docs[i]['author']);
        av.add(data.docs[i]['isAvailable']);
      }
      setState(() {
        bookTitles = t;
        bookAuthors = a;
        bookAvailable = av;
      });
    });
  }

  // নিজের টিকিট আনা
  void loadMyTicket() {
    String myEmail = FirebaseAuth.instance.currentUser?.email ??
        AuthService().currentUserEmail ?? '';

    FirebaseFirestore.instance.collection('tickets').snapshots().listen((data) {
      bool found = false;
      String book = '';
      String id = '';
      int serial = 0;

      for (int i = 0; i < data.docs.length; i++) {
        if (data.docs[i]['userId'] == myEmail && data.docs[i]['status'] == 'active') {
          found = true;
          book = data.docs[i]['bookTitle'];
          id = data.docs[i].id;
        }
      }

      // সিরিয়াল গোনা
      if (found) {
        for (int i = 0; i < data.docs.length; i++) {
          if (data.docs[i]['bookTitle'] == book && data.docs[i]['status'] == 'active') {
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

  // টিকিট কাটা
  void getTicket(String bookTitle) {
    String myEmail = FirebaseAuth.instance.currentUser?.email ??
        AuthService().currentUserEmail ?? '';
    FirebaseFirestore.instance.collection('tickets').add({
      'userId': myEmail,
      'bookTitle': bookTitle,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'active',
    });
  }

  // টিকিট ক্যানসেল
  void cancelTicket() {
    FirebaseFirestore.instance.collection('tickets').doc(ticketId).update({
      'status': 'cancelled',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Library Services',
            style: TextStyle(fontWeight: FontWeight.bold)),
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
                  borderRadius: BorderRadius.circular(22)),elevation: 10,
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CENTRAL LIBRARY',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Hours: 10:00 AM - 6:00 PM',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 15)),
                      ],
                    ),
                    Text('Open Now',
                        style: TextStyle(
                            color: Colors.lightGreenAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Active Ticket card
            if (hasTicket)
              Card(
                color: Colors.green.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                  side: const BorderSide(color: Colors.brown),
                ),elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('YOUR TICKET',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,  )),
                          TextButton(
                            onPressed: cancelTicket,
                            child: const Text('Cancel Ticket',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                      Text('Book: $ticketBookName',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black,fontSize: 20)),
                      const SizedBox(height: 4),
                      Text('People in queue: $serialNumber'),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 22),

             Text('Book Availability >>',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.green.shade900  ,),),
            const SizedBox(height: 10),

            if (bookTitles.isEmpty) const Text('Loading books...'),

            // বইয়ের লিস্ট
            for (int i = 0; i < bookTitles.length; i++)
              Card(
                child: ListTile(
                  leading: Icon(Icons.menu_book,
                      color: bookAvailable[i] == true
                          ? Colors.green
                          : Colors.red),
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
                      : const Text('Unavailable',
                          style: TextStyle(color: Colors.red)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
