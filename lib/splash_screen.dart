import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: colLogo()),
    );
  }

  Widget colLogo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'img/Logo TCGD (nền trắng).png',
          width: 250,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 20),
        const CircularProgressIndicator(color: AppTheme.primaryColor),
      ],
    );
  }
}
