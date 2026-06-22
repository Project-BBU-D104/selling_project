import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;

  const PasswordField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Password",
        prefixIcon: const Icon(Icons.lock_outline),
        hintText: "Enter your password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
