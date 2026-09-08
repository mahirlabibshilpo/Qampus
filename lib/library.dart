import 'package:flutter/material.dart';
import 'models/book.dart';



class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}



class _LibraryPageState extends State<LibraryPage> {

  String searchQuery = '';




  // active ticket er info
  bool hasTicket = true;
  String ticketNumber = 'A-045';
  String activeBook = 'Introduction to FLUTTER';




  // sob boi er list
  final List<Book> books = const [
    Book('Introduction to EEE', 'Thomas H. Cormen', 'Available',00),
    Book('Database System Data Structure', 'Abraham Silberschatz', 'Available', 2),
    Book('Introduction to DLD', 'Abraham Silberschatz', 'Unavailable', 10),
    Book('Introduction to MATH', 'Andrew S. Tanenbaum', 'Available', 1),
    Book('Introduction to HUM', 'Stuart Russell', 'Available', 25),
  ];




  // ticket cancel korar jonno popup
  void showCancelTicketDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
        title: const Text('Cancel Ticket?'),
        content: const Text('Do you want to cancel this ticket?'),
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
                hasTicket = false;
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

    final filteredBooks = books.where((b) {    // search filter logic

      final query = searchQuery.toLowerCase();
      return b.title.toLowerCase().contains(query) ||
          b.author.toLowerCase().contains(query);
    }).toList();




    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: const Text('Library Services', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // library status card
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
                        Text('CENTRAL LIBRARY', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Hours: 8:00 AM - 8:00 PM', style: TextStyle(color: Colors.white, fontSize: 13)),
                      ],
                    ),
                    Text('-> Open Now', style: TextStyle(color: Colors.lightGreenAccent,fontSize: 25, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),




            const SizedBox(height: 14),

            // seat count
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
                        Text('Available Seats', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('42 / 100', style: TextStyle(color: Colors.black38, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 0.42,
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

            // user er ticket thakle show korbe
            if (hasTicket)
              Card(
                color: Colors.green.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.green),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical:10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('TICKET #$ticketNumber', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green)),
                          TextButton(
                            onPressed: showCancelTicketDialog,
                            child: const Text('Cancel Ticket', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                      Text('Book: $activeBook', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 4),
                      const Text('Queue: #12', style: TextStyle(fontSize: 13, color: Colors.black54)),
                    ],
                  ),
                ),
              ),




            const SizedBox(height: 16),

            // search box
            const Text('Books>>>', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search books >>>',
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

            // book list cards
            for (var book in filteredBooks)
              Card(
                margin: const EdgeInsets.only(bottom: 5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.lightGreenAccent.shade200,
                    child: const Icon(Icons.menu_book, color: Colors.green),
                  ),
                  title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(book.author, style: const TextStyle(fontSize: 12)),
                      Text(
                        book.status,
                        style: TextStyle(
                          color: book.status == 'Available' ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: book.status == 'Available' ? Colors.green : Colors.grey.shade200,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    onPressed: book.status == 'Available'
                        ? () {
                            setState(() {
                              hasTicket = true;
                              activeBook = book.title;
                              ticketNumber = 'A-028';
                            });
                          }
                        : null,
                    child: Text(book.status == 'Available' ? 'Get Ticket' : 'Unavailable', style: const TextStyle(fontSize: 12)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
