import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Club Office er main screen
class ClubOffice extends StatefulWidget {
  const ClubOffice({super.key});

  @override
  State<ClubOffice> createState() => _ClubOfficeState();
}

// Club Office er state class
class _ClubOfficeState extends State<ClubOffice> {
  // User kon kon club e join koreche shei club gula ekhane rakha hobe
  Set<String> joinedClubs = {};

  // Screen open howar shomoy ei function automatically cholbe
  @override
  void initState() {
    super.initState();

    // Firestore theke user er joined club gula load korbe
    loadJoinedClubs();
  }

  // Firestore theke user kon kon club e already join koreche ta ber korbe
  Future<void> loadJoinedClubs() async {
    // Firebase theke currently logged in user ke nibe
    User? user = FirebaseAuth.instance.currentUser;

    // User login kora na thakle ekhanei function sesh hobe
    if (user == null) {
      return;
    }

    // Computer Club already join kora ache kina check korbe
    if (await isClubJoined(user.uid, 'Computer Club')) {
      joinedClubs.add('Computer Club');
    }

    // Sports Club already join kora ache kina check korbe
    if (await isClubJoined(user.uid, 'Sports Club')) {
      joinedClubs.add('Sports Club');
    }

    // Cultural Club already join kora ache kina check korbe
    if (await isClubJoined(user.uid, 'Cultural Club')) {
      joinedClubs.add('Cultural Club');
    }

    // Photography Club already join kora ache kina check korbe
    if (await isClubJoined(user.uid, 'Photography Club')) {
      joinedClubs.add('Photography Club');
    }

    // Data pawar por screen abar update korbe
    setState(() {});
  }

  // User kono specific club e join koreche kina check korbe
  Future<bool> isClubJoined(String uid, String clubName) async {
    // Firestore theke user er joinedClubs collection e jabe
    var data = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('joinedClubs')
        .doc(clubName)
        .get();

    // Document thakle true, na thakle false return korbe
    return data.exists;
  }

  // User jokhon kono club e Join button press korbe
  // tokhon ei function Firestore e data save korbe
  Future<void> joinClub(String clubName) async {
    // Currently login kora user ke nibe
    User? user = FirebaseAuth.instance.currentUser;

    // User login kora na thakle kichu korbe na
    if (user == null) {
      return;
    }

    // Firestore e user er joined club save korbe
    await FirebaseFirestore.instance
        .collection('users')
        // Current user er unique ID diye user ke identify korbe
        .doc(user.uid)
        // Ei collection er moddhe joinedClubs name e data rakhbe
        .collection('joinedClubs')
        // Club er name ke document ID hisebe use korbe
        .doc(clubName)
        // Club er information save korbe
        .set({'club': clubName, 'status': 'Joined'});

    // Join korar por user ke message dekhabe
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Joined $clubName')));
  }

  // Screen er UI ekhane create hobe
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Upore Club Office er AppBar
      appBar: AppBar(
        title: const Text(
          'Club Office',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),

        // AppBar er background green
        backgroundColor: Colors.green,

        // AppBar er text/icon white
        foregroundColor: Colors.white,
      ),

      // Main screen er content
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Student Clubs er heading
            const Text(
              'Student Clubs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // Computer Club er box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),

              // Box er design
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // Computer Club er icon
                  const Icon(Icons.code, color: Colors.green, size: 28),

                  const SizedBox(height: 8),

                  // Club er naam
                  const Text(
                    'Computer Club',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  // Club er short description
                  const Text(
                    'Programming and technology activities',
                    style: TextStyle(fontSize: 12),
                  ),

                  const SizedBox(height: 8),

                  // Join button ke right side e rakhar jonno Row use kora hoyeche
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,

                    children: [
                      // Join button
                      ElevatedButton(
                        onPressed: () {
                          // Computer Club e join korar function call
                          joinClub('Computer Club');
                        },

                        // User already join korle "Joined"
                        // na hole "Join" dekhabe
                        child: Text(
                          joinedClubs.contains('Computer Club')
                              ? 'Joined'
                              : 'Join',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Sports Club er box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // Sports Club er icon
                  const Icon(
                    Icons.sports_soccer,
                    color: Colors.green,
                    size: 28,
                  ),

                  const SizedBox(height: 8),

                  // Club er naam
                  const Text(
                    'Sports Club',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  // Club er description
                  const Text(
                    'Sports events and student activities',
                    style: TextStyle(fontSize: 12),
                  ),

                  const SizedBox(height: 8),

                  // Join button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,

                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Sports Club e join korbe
                          joinClub('Sports Club');
                        },

                        // Already joined hole Joined dekhabe
                        child: Text(
                          joinedClubs.contains('Sports Club')
                              ? 'Joined'
                              : 'Join',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Cultural Club er box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // Cultural Club er icon
                  const Icon(Icons.music_note, color: Colors.green, size: 28),

                  const SizedBox(height: 8),

                  // Club er naam
                  const Text(
                    'Cultural Club',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  // Club er description
                  const Text(
                    'Music, art and cultural programs',
                    style: TextStyle(fontSize: 12),
                  ),

                  const SizedBox(height: 8),

                  // Join button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,

                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Cultural Club e join korbe
                          joinClub('Cultural Club');
                        },

                        // Already joined hole Joined dekhabe
                        child: Text(
                          joinedClubs.contains('Cultural Club')
                              ? 'Joined'
                              : 'Join',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Photography Club er box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // Photography Club er icon
                  const Icon(Icons.camera_alt, color: Colors.green, size: 28),

                  const SizedBox(height: 8),

                  // Club er naam
                  const Text(
                    'Photography Club',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  // Club er description
                  const Text(
                    'Photography and creative activities',
                    style: TextStyle(fontSize: 12),
                  ),

                  const SizedBox(height: 8),

                  // Join button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,

                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Photography Club e join korbe
                          joinClub('Photography Club');
                        },

                        // Already joined hole Joined dekhabe
                        child: Text(
                          joinedClubs.contains('Photography Club')
                              ? 'Joined'
                              : 'Join',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
