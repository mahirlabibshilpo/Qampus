import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'administrative_office.dart';
import 'auth_service.dart';
import 'canteen.dart';
import 'club_office.dart';
import 'library.dart';
import 'login.dart';
import 'notice_board.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  String getEmail() {
    // Firebase theke email pele seta use korbo
    String? firebaseEmail = FirebaseAuth.instance.currentUser?.email;
    if (firebaseEmail != null) {
      return firebaseEmail;
    }

    // Na pele local AuthService theke email nabo
    String? localEmail = AuthService().currentUserEmail;
    if (localEmail != null) {
      return localEmail;
    }

    // Kichui na paile default
    return 'Student';
  }

  @override
  Widget build(BuildContext context) {
    String userEmail = getEmail();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title:  Text(
          'QAMPUS.Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon:  Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => showLogoutDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ // User profile card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),    elevation: 10,

              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.face_unlock_rounded, color: Colors.lightGreenAccent, size:50),
                    ),
                    const SizedBox(width: 18),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome to QAMPUS!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          userEmail,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Hear you go! Find the',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        const Text(
                          'Smart Access, Better Campus',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Section title
            const Text(
              'Campus Services>>',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 18),

            // Service cards
            serviceCard(
              context: context,
              icon: Icons.menu_book,
              title: 'Library',
              subtitle: 'Books issue, return & study room access',
              page: const LibraryPage(),
            ),
            serviceCard(
              context: context,
              icon: Icons.restaurant,
              title: 'Canteen',
              subtitle: 'Cafeteria tokens & meal schedule',
              page: const CanteenPage(),
            ),
            serviceCard(
              context: context,
              icon: Icons.groups,
              title: 'Club Office',
              subtitle: 'Student activity & event registration',
              page: const ClubOffice(),
            ),
            serviceCard(
              context: context,
              icon: Icons.campaign,
              title: 'Notice Board',
              subtitle: 'Important university notices & announcements',
              page: const NoticeBoard(),
            ),
            serviceCard(
              context: context,
              icon: Icons.account_balance,
              title: 'Administrative Office',
              subtitle: 'Student ID, fees & official documents',
              page: const AdministrativeOffice(),
            ),
          ],
        ),
      ),
    );
  }

  // Each service card - reusable widget aita diyei sob card call debo
  Widget serviceCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget page,
  }) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green.shade100,
              child: Icon(icon, color: Colors.green.shade700, size: 25),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_circle_right_outlined, size: 26),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => page),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Logout confirm dialog
  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
              AuthService().logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}
