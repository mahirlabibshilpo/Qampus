import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';
import 'canteen.dart';
import 'library.dart';
import 'login.dart';
import 'club_office.dart';
import 'administrative_office.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  String _getUserEmail() {
    try {
      return FirebaseAuth.instance.currentUser?.email ??
          AuthService().currentUserEmail ??
          'Student';
    } catch (_) {
      return AuthService().currentUserEmail ?? 'Student';
    }
  }

  @override
  Widget build(BuildContext context) {
    String userEmail = _getUserEmail();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text(
          'QAMPUS - Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.green.shade50,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
                side: BorderSide(color: Colors.green.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 30,
                      child: Icon(Icons.person, color: Colors.white, size: 35),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome to QAMPUS!',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            userEmail,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Smart Access, Better Campus',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Campus Services',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            _buildServiceCard(
              icon: Icons.menu_book,
              title: 'Library',
              subtitle: 'Books issue, return & study room access',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LibraryPage()),
                );
              },
            ),
            _buildServiceCard(
              icon: Icons.restaurant,
              title: 'Canteen',
              subtitle: 'Cafeteria tokens & meal schedule',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CanteenPage()),
                );
              },
            ),
            _buildServiceCard(
              icon: Icons.groups,
              title: 'Club Office',
              subtitle: 'Student activity & event registration',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ClubOffice()),
                );
              },
            ),
            _buildServiceCard(
              icon: Icons.campaign,
              title: 'Notice Board',
              subtitle: 'Important university notices & announcements',
              onTap: () => _showComingSoon(context, 'Notice Board'),
            ),
            _buildServiceCard(
              icon: Icons.account_balance,
              title: 'Administrative Office',
              subtitle: 'Student ID, fees & official documents',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdministrativeOffice(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.lightGreenAccent.shade200,
          child: Icon(icon, color: Colors.green.shade700),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showComingSoon(BuildContext context, String service) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$service service selected!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
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
              backgroundColor: Colors.deepOrange.shade900,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context);
              try {
                await FirebaseAuth.instance.signOut();
              } catch (_) {}
              AuthService().logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

// Alias for backwards compatibility if referenced elsewhere
class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}
