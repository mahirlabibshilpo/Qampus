import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  // Ekbar navigate hoyeche kina track korar variable
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    // App start holei delay diye login page-e jabe
    _navigateToLogin();
  }

  // Login page e auto jaoar delay ebong navigation function
  Future<void> _navigateToLogin() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    if (_navigated || !mounted) return;
    _navigated = true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        // Screen e jekono jaygay tap korle shathe shathe login-e jabe
        onTap: () {
          if (_navigated) return;
          _navigated = true;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Campus logo ebong animation
                    Image.asset(
                      'assets/green_environment_logo.png',
                      width: 220,
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .scale(duration: 600.ms),
                    const SizedBox(height: 15),
                    // App-er name ebong slogan
                    Column(
                      children: [
                        Text(
                          'QAMPUS',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                          ),
                        ),
                        Text(
                          'Smart Access, Better Campus',
                          style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            color: Colors.lightGreen.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Loading ghurar indicator
            const CircularProgressIndicator(
              color: Colors.green,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
