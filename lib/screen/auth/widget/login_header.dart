import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF003B6D),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.factory,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "HardwarePro Enterprise",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color(0xFF003B6D),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "SECURE MANAGEMENT PORTAL",
          style: TextStyle(
            letterSpacing: 2,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
