import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "Email Address",
        prefixIcon: const Icon(Icons.alternate_email),
        hintText: "Enter your work email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
