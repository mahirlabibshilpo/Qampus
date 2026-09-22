import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Administrative Office er main screen
class AdministrativeOffice extends StatefulWidget {
  const AdministrativeOffice({super.key});

  @override
  State<AdministrativeOffice> createState() => _AdministrativeOfficeState();
}

// Ei class er moddhe screen er data ebong functions gula thakbe
class _AdministrativeOfficeState extends State<AdministrativeOffice> {
  // User je je service request koreche
  // shei service gula ekhane store hobe
  Set<String> requestedServices = {};

  // Screen open howar shomoy ei function automatically call hobe
  @override
  void initState() {
    super.initState();

    // Firestore theke already requested service gula load korbe
    loadRequestedServices();
  }

  // Firestore theke user er requested service gula load korbe
  Future<void> loadRequestedServices() async {
    // Currently login kora user ke ber korbe
    User? user = FirebaseAuth.instance.currentUser;

    // User login kora na thakle kichu korbe na
    if (user == null) {
      return;
    }

    // Student ID Card request kora ache kina check korbe
    if (await isServiceRequested(user.uid, 'Student ID Card')) {
      requestedServices.add('Student ID Card');
    }

    // Fee Management request kora ache kina check korbe
    if (await isServiceRequested(user.uid, 'Fee Management')) {
      requestedServices.add('Fee Management');
    }

    // Official Documents request kora ache kina check korbe
    if (await isServiceRequested(user.uid, 'Official Documents')) {
      requestedServices.add('Official Documents');
    }

    // Data load howar por screen update korbe
    setState(() {});
  }

  // Kono service age request kora hoyeche kina check korbe
  Future<bool> isServiceRequested(String uid, String serviceName) async {
    // Firestore e users collection e jabe
    var data = await FirebaseFirestore.instance
        // users collection
        .collection('users')
        // Current user er UID diye user select korbe
        .doc(uid)
        // Administrative service gula ekhane thakbe
        .collection('administrativeServices')
        // Service er naam ke document ID hisebe use korbe
        .doc(serviceName)
        // Firestore theke data nibe
        .get();

    // Document thakle true return korbe
    // Document na thakle false return korbe
    return data.exists;
  }

  // User kono administrative service request korle
  // ei function Firestore e data save korbe
  Future<void> requestService(String serviceName) async {
    // Currently login kora user ke nibe
    User? user = FirebaseAuth.instance.currentUser;

    // User login kora na thakle function sesh
    if (user == null) {
      return;
    }

    // Firestore e service request save korbe
    await FirebaseFirestore.instance
        // users collection e jabe
        .collection('users')
        // Current user er document
        .doc(user.uid)
        // Administrative service er collection
        .collection('administrativeServices')
        // Service er naam document ID hobe
        .doc(serviceName)
        // Service er information save korbe
        .set({'service': serviceName, 'status': 'Requested'});

    // Request korar por local list eo service add korbe
    setState(() {
      requestedServices.add(serviceName);
    });

    // User ke choto message dekhabe
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$serviceName requested')));
  }

  // Screen er main UI ekhane create hobe
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Screen er halka background color
      backgroundColor: Colors.grey.shade50,

      // Upore je AppBar thakbe
      appBar: AppBar(
        // AppBar er background green
        backgroundColor: Colors.green,

        // AppBar er text/icon white
        foregroundColor: Colors.white,

        // AppBar er title
        title: const Text(
          'Administrative Office',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Main screen er content
      body: Padding(
        // Screen er charpashe 16 pixel gap
        padding: const EdgeInsets.all(16),

        child: Column(
          // Shob content left side theke start hobe
          crossAxisAlignment: CrossAxisAlignment.start,

          // Ekhane screen er shob box thakbe
          children: [
            // Administrative Office Header

            // Header er main box
            Container(
              width: double.infinity,

              // Box er vitore gap
              padding: const EdgeInsets.all(16),

              // Box er design
              decoration: BoxDecoration(
                // Halka green background
                color: Colors.green.shade50,

                // Corner gula round korbe
                borderRadius: BorderRadius.circular(15),
              ),

              child: Row(
                children: [
                  // Administrative Office er icon
                  const Icon(
                    Icons.account_balance,
                    color: Colors.green,
                    size: 40,
                  ),

                  // Icon ar text er moddhe gap
                  const SizedBox(width: 12),

                  // Header er title ar subtitle
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // Main title
                      Text(
                        'Administrative Office',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),

                      // Title ar subtitle er moddhe gap
                      SizedBox(height: 5),

                      // Subtitle
                      Text(
                        'Student administrative services',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Header ar Student Services er moddhe gap
            const SizedBox(height: 20),

            // Student Services heading
            const Text(
              'Student Services',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),

            // Heading ar first box er moddhe gap
            const SizedBox(height: 12),

            // Student ID Card

            // Ei box e click korle service request hobe
            GestureDetector(
              onTap: () {
                // Student ID Card request korbe
                requestService('Student ID Card');
              },

              // Student ID Card er main box
              child: Container(
                width: double.infinity,

                // Box er vitore gap
                padding: const EdgeInsets.all(15),

                // Box er design
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Row(
                  children: [
                    // ID card er icon
                    const Icon(Icons.badge, color: Colors.green, size: 30),

                    // Icon ar text er moddhe gap
                    const SizedBox(width: 12),

                    // ID card er information
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // Service er naam
                          Text(
                            'Student ID Card',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Title ar description er moddhe gap
                          SizedBox(height: 4),

                          // Service er description
                          Text(
                            'Apply for or replace your student ID card',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    // Box er right side e arrow
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),

            // First box ar second box er moddhe gap
            const SizedBox(height: 10),

            // Fee Management

            // Fee Management box e click korle request hobe
            GestureDetector(
              onTap: () {
                // Fee Management request korbe
                requestService('Fee Management');
              },

              // Fee Management er main box
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),

                // Box er design
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Row(
                  children: [
                    // Fee er icon
                    const Icon(Icons.payments, color: Colors.green, size: 30),

                    // Icon ar text er moddhe gap
                    const SizedBox(width: 12),

                    // Fee related information
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // Service er naam
                          Text(
                            'Fee Management',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Title ar description er moddhe gap
                          SizedBox(height: 4),

                          // Service er description
                          Text(
                            'Check fees and payment information',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    // Box er right side e arrow
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),

            // Second box ar third box er moddhe gap
            const SizedBox(height: 10),

            // Official Documents

            // Official Documents box e click korle request hobe
            GestureDetector(
              onTap: () {
                // Official Documents request korbe
                requestService('Official Documents');
              },

              // Official Documents er main box
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),

                // Box er design
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Row(
                  children: [
                    // Documents er icon
                    const Icon(
                      Icons.description,
                      color: Colors.green,
                      size: 30,
                    ),

                    // Icon ar text er moddhe gap
                    const SizedBox(width: 12),

                    // Documents er information
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // Service er naam
                          Text(
                            'Official Documents',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Title ar description er moddhe gap
                          SizedBox(height: 4),

                          // Service er description
                          Text(
                            'Request certificates and official documents',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    // Box er right side e arrow
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),

            // Services ar Office Information er moddhe gap
            const SizedBox(height: 20),

            // Office information er main box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),

              // Box er design
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(15),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // Information box er heading
                  const Text(
                    'Office Information',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),

                  // Heading ar location er moddhe gap
                  const SizedBox(height: 10),

                  // Office location
                  const Row(
                    children: [
                      // Location icon
                      Icon(Icons.location_on, color: Colors.green, size: 20),

                      // Icon ar text er moddhe gap
                      SizedBox(width: 8),

                      // Office address
                      Text(
                        'Main Administration Building',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),

                  // Location ar email er moddhe gap
                  const SizedBox(height: 8),

                  // Office email
                  const Row(
                    children: [
                      // Email icon
                      Icon(Icons.email, color: Colors.green, size: 20),

                      // Icon ar email er moddhe gap
                      SizedBox(width: 8),

                      // Office email address
                      Text('admin@qampus.edu', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),

            // Office information ar Back button er moddhe gap
            const SizedBox(height: 20),

            // Back to Home Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Previous screen e fire jabe
                  Navigator.pop(context);
                },

                // Button er text
                child: const Text(
                  'Back to Home',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
