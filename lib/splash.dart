import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'login.dart';



class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}



class _SplashState extends State<Splash> {

  bool _navigated = false;




  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }




  // login page e jaoar delay
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
                    Image.asset(
                      'assets/green_environment_logo.png',
                      width: 220,
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .scale(duration: 600.ms),
                    const SizedBox(height: 15),
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
