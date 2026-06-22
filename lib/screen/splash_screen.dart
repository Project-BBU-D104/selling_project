import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              const Text(
                'Inventory\nManagement',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003B6D),
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              const Text(
                'HARDWAREPRO ENTERPRISE',
                style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 2,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 80),

              // Loading
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: Color(0xFF003B6D),
                ),
              ),

              const SizedBox(height: 40),

              // Status Text
              const Text(
                'Verifying credentials...',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
